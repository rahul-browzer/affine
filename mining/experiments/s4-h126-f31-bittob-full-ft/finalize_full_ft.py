#!/usr/bin/env python3
"""Restore multimodal wrapper + visual weights after CausalLM full-FT save.

Reuses the same restore path as merge_lora.py (wrapper config, preprocessor,
model.visual.* extraction). Also refuses weight-identity to base/king.
"""
from __future__ import annotations

import argparse
import hashlib
import json
import shutil
import sys
import time
from collections import defaultdict
from pathlib import Path

import torch
from safetensors import safe_open
from safetensors.torch import save_file


def _shard_keyset(path: Path) -> set[str]:
    if not path.is_file():
        return set()
    with safe_open(str(path), framework="pt") as f:
        return set(f.keys())


def _window_sha(path: Path, offset: int, nbytes: int = 1 << 20) -> str:
    h = hashlib.sha256()
    size = path.stat().st_size
    off = max(0, min(offset, max(0, size - nbytes)))
    with open(path, "rb") as f:
        f.seek(off)
        h.update(f.read(nbytes))
    return h.hexdigest()


def _numbered(p: Path) -> list[Path]:
    shards = sorted(p.glob("model-*-of-*.safetensors"))
    if shards:
        return shards
    return sorted(x for x in p.glob("model-*.safetensors") if "visual" not in x.name)


def main() -> None:
    ap = argparse.ArgumentParser()
    ap.add_argument("--base", required=True, type=Path)
    ap.add_argument("--full-ft", required=True, type=Path)
    ap.add_argument("--out", required=True, type=Path)
    ap.add_argument("--king", type=Path, default=None)
    args = ap.parse_args()

    t0 = time.time()
    if not args.full_ft.is_dir():
        raise SystemExit(f"full-ft dir missing: {args.full_ft}")
    if args.out.exists():
        shutil.rmtree(args.out)
    shutil.copytree(args.full_ft, args.out)
    print(f"[finalize] copied {args.full_ft} → {args.out}", flush=True)

    for name in (
        "config.json",
        "preprocessor_config.json",
        "processor_config.json",
        "video_preprocessor_config.json",
    ):
        src = args.base / name
        if src.is_file():
            shutil.copy2(src, args.out / name)
            print(f"[finalize] restored {name}", flush=True)

    pre_out = args.out / "preprocessor_config.json"
    proc_src = args.base / "processor_config.json"
    if not pre_out.is_file() and proc_src.is_file():
        proc = json.loads(proc_src.read_text())
        img = proc.get("image_processor", proc)
        pre_out.write_text(json.dumps(img, indent=2) + "\n")
        print("[finalize] derived preprocessor_config.json", flush=True)

    out_idx_path = args.out / "model.safetensors.index.json"
    base_idx_path = args.base / "model.safetensors.index.json"
    out_idx = (
        json.loads(out_idx_path.read_text())
        if out_idx_path.is_file()
        else {"metadata": {}, "weight_map": {}}
    )
    base_idx = (
        json.loads(base_idx_path.read_text())
        if base_idx_path.is_file()
        else {"weight_map": {}}
    )

    added = 0
    for src in sorted(args.base.glob("model-visual*.safetensors")):
        shutil.copy2(src, args.out / src.name)
        print(f"[finalize] restored visual shard {src.name}", flush=True)
    for key, shard in (base_idx.get("weight_map") or {}).items():
        if key not in out_idx["weight_map"] and (args.out / shard).is_file():
            out_idx["weight_map"][key] = shard
            added += 1

    out_shard_keys: dict[str, set[str]] = {}
    phantom = {}
    for key, shard in list(out_idx["weight_map"].items()):
        if "visual" not in key:
            continue
        if shard not in out_shard_keys:
            out_shard_keys[shard] = _shard_keyset(args.out / shard)
        if key not in out_shard_keys[shard]:
            phantom[key] = shard
    if phantom:
        print(f"[finalize] phantom visual index entries: {len(phantom)}", flush=True)
        for key in phantom:
            out_idx["weight_map"].pop(key, None)

    missing = {
        k: sh
        for k, sh in (base_idx.get("weight_map") or {}).items()
        if k not in out_idx["weight_map"]
    }
    if missing:
        by_shard: dict[str, list[str]] = defaultdict(list)
        for key, shard in missing.items():
            by_shard[shard].append(key)
        restored: dict[str, torch.Tensor] = {}
        for shard, keys in by_shard.items():
            src = args.base / shard
            if not src.is_file():
                raise SystemExit(f"missing base shard for visual restore: {src}")
            with safe_open(str(src), framework="pt", device="cpu") as f:
                for key in keys:
                    t = f.get_tensor(key)
                    restored[key] = t.contiguous().clone() if hasattr(t, "contiguous") else t
            print(f"[finalize] extracted {len(keys)} keys from {shard}", flush=True)
        # Write visual shard under /tmp then copy (gocryptfs EFAULT).
        tmp_vis = Path("/tmp/h126_model-visual-restored.safetensors")
        save_file(restored, str(tmp_vis))
        out_vis = args.out / "model-visual-restored.safetensors"
        shutil.copy2(tmp_vis, out_vis)
        for key in restored:
            out_idx["weight_map"][key] = out_vis.name
            added += 1
        print(f"[finalize] wrote {out_vis.name} n={len(restored)}", flush=True)

    if added or missing or phantom or list(args.base.glob("model-visual*.safetensors")):
        total = sum(p.stat().st_size for p in args.out.glob("*.safetensors"))
        out_idx.setdefault("metadata", {})
        out_idx["metadata"]["total_size"] = total
        if "total_parameters" in (base_idx.get("metadata") or {}):
            out_idx["metadata"]["total_parameters"] = base_idx["metadata"][
                "total_parameters"
            ]
        out_idx_path.write_text(json.dumps(out_idx, indent=2) + "\n")
        out_shard_keys = {}
        vis_resolved = 0
        n_vis = 0
        for key, shard in out_idx["weight_map"].items():
            if "visual" not in key:
                continue
            n_vis += 1
            if shard not in out_shard_keys:
                out_shard_keys[shard] = _shard_keyset(args.out / shard)
            if key in out_shard_keys[shard]:
                vis_resolved += 1
        print(
            f"[finalize] visual_keys={n_vis} visual_resolved={vis_resolved}",
            flush=True,
        )
        base_has_vis = any("visual" in k for k in (base_idx.get("weight_map") or {}))
        if base_has_vis and vis_resolved == 0:
            raise SystemExit("REFUSE: no resolved visual tensors")
        if base_has_vis and vis_resolved < n_vis:
            raise SystemExit(
                f"REFUSE: phantom visual index — resolved {vis_resolved}/{n_vis}"
            )

    cfg_path = args.out / "config.json"
    cfg = json.loads(cfg_path.read_text())
    if "auto_map" in cfg:
        del cfg["auto_map"]
        cfg_path.write_text(json.dumps(cfg, indent=2) + "\n")
    for p in args.out.rglob("*.py"):
        p.unlink()

    def probe(ref: Path, label: str) -> dict:
        ms, rs = _numbered(args.out), _numbered(ref)
        if not ms or not rs:
            return {"label": label, "error": "missing shards", "identical": True}
        by_name = {r.name: r for r in rs}
        pairs = [(m, by_name[m.name]) for m in ms if m.name in by_name]
        if not pairs:
            n = min(len(ms), len(rs))
            pairs = list(zip(ms[:n], rs[:n]))
        any_diff = False
        for m, r in pairs:
            size = r.stat().st_size
            windows = [
                (_window_sha(r, 0), _window_sha(m, 0)),
                (_window_sha(r, size // 2), _window_sha(m, size // 2)),
                (
                    _window_sha(r, max(0, size - (1 << 20))),
                    _window_sha(m, max(0, m.stat().st_size - (1 << 20))),
                ),
            ]
            if any(a != b for a, b in windows):
                any_diff = True
                break
        return {
            "label": label,
            "n_pairs": len(pairs),
            "identical": not any_diff and len(pairs) > 0,
        }

    base_probe = probe(args.base, "tok_init_base")
    king_probe = (
        probe(args.king, "tok331102_king")
        if args.king and args.king.is_dir()
        else {"label": "tok331102_king", "identical": False, "error": "missing"}
    )
    meta = {
        "elapsed_s": time.time() - t0,
        "out": str(args.out),
        "vs_base": base_probe,
        "vs_king": king_probe,
        "weight_identical": bool(base_probe.get("identical")),
    }
    (args.out / "finalize_meta.json").write_text(json.dumps(meta, indent=2) + "\n")
    print(json.dumps(meta, indent=2), flush=True)
    if base_probe.get("identical"):
        sys.exit("REFUSE: full-FT weight-identical to Tok init base")
    if king_probe.get("identical"):
        sys.exit("REFUSE: full-FT weight-identical to Tok331102 king")
    print("[finalize] OK_NON_IDENTICAL", flush=True)


if __name__ == "__main__":
    main()
