#!/usr/bin/env python3
"""In-place multimodal restore after CausalLM full-FT save (no copytree).

Copies wrapper config/preprocessor from --base into --out, extracts any
missing model.visual.* tensors into model-visual-restored.safetensors, and
rewrites the weight index. Fixes vLLM TypeError: Qwen3_5MoeTextConfig vs
Qwen3_5MoeConfig (LESSON: CausalLM save drops visual wrapper).
"""
from __future__ import annotations

import argparse
import json
import shutil
import sys
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


def main() -> None:
    ap = argparse.ArgumentParser()
    ap.add_argument("--base", required=True, type=Path)
    ap.add_argument("--out", required=True, type=Path)
    ap.add_argument("--tmp-vis", type=Path, default=None)
    args = ap.parse_args()

    if not args.out.is_dir():
        raise SystemExit(f"out missing: {args.out}")
    if not args.base.is_dir():
        raise SystemExit(f"base missing: {args.base}")

    for name in (
        "config.json",
        "preprocessor_config.json",
        "processor_config.json",
        "video_preprocessor_config.json",
    ):
        src = args.base / name
        if src.is_file():
            shutil.copy2(src, args.out / name)
            print(f"[restore] copied {name}", flush=True)

    pre_out = args.out / "preprocessor_config.json"
    proc_src = args.base / "processor_config.json"
    if not pre_out.is_file() and proc_src.is_file():
        proc = json.loads(proc_src.read_text())
        img = proc.get("image_processor", proc)
        pre_out.write_text(json.dumps(img, indent=2) + "\n")
        print("[restore] derived preprocessor_config.json", flush=True)

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

    for src in sorted(args.base.glob("model-visual*.safetensors")):
        shutil.copy2(src, args.out / src.name)
        print(f"[restore] copied visual shard {src.name}", flush=True)
    for key, shard in (base_idx.get("weight_map") or {}).items():
        if key not in out_idx["weight_map"] and (args.out / shard).is_file():
            out_idx["weight_map"][key] = shard

    out_shard_keys: dict[str, set[str]] = {}
    phantom = []
    for key, shard in list(out_idx["weight_map"].items()):
        if "visual" not in key:
            continue
        if shard not in out_shard_keys:
            out_shard_keys[shard] = _shard_keyset(args.out / shard)
        if key not in out_shard_keys[shard]:
            phantom.append(key)
            out_idx["weight_map"].pop(key, None)
    if phantom:
        print(f"[restore] dropped {len(phantom)} phantom visual index keys", flush=True)

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
                raise SystemExit(f"missing base shard: {src}")
            with safe_open(str(src), framework="pt", device="cpu") as f:
                for key in keys:
                    t = f.get_tensor(key)
                    restored[key] = (
                        t.contiguous().clone() if hasattr(t, "contiguous") else t
                    )
            print(f"[restore] extracted {len(keys)} keys from {shard}", flush=True)
        tmp_vis = args.tmp_vis or Path("/tmp/model-visual-restored.safetensors")
        if tmp_vis.exists():
            tmp_vis.unlink()
        save_file(restored, str(tmp_vis))
        out_vis = args.out / "model-visual-restored.safetensors"
        shutil.copy2(tmp_vis, out_vis)
        for key in restored:
            out_idx["weight_map"][key] = out_vis.name
        print(f"[restore] wrote {out_vis.name} n={len(restored)}", flush=True)

    total = sum(p.stat().st_size for p in args.out.glob("*.safetensors"))
    out_idx.setdefault("metadata", {})
    out_idx["metadata"]["total_size"] = total
    if "total_parameters" in (base_idx.get("metadata") or {}):
        out_idx["metadata"]["total_parameters"] = base_idx["metadata"][
            "total_parameters"
        ]
    out_idx_path.write_text(json.dumps(out_idx, indent=2) + "\n")

    n_vis = sum(1 for k in out_idx["weight_map"] if "visual" in k)
    resolved = 0
    keysets: dict[str, set[str]] = {}
    for key, shard in out_idx["weight_map"].items():
        if "visual" not in key:
            continue
        if shard not in keysets:
            keysets[shard] = _shard_keyset(args.out / shard)
        if key in keysets[shard]:
            resolved += 1
    cfg = json.loads((args.out / "config.json").read_text())
    if "auto_map" in cfg:
        del cfg["auto_map"]
        (args.out / "config.json").write_text(json.dumps(cfg, indent=2) + "\n")
    for p in args.out.rglob("*.py"):
        p.unlink()

    print(
        json.dumps(
            {
                "model_type": cfg.get("model_type"),
                "architectures": cfg.get("architectures"),
                "visual_keys": n_vis,
                "visual_resolved": resolved,
            }
        ),
        flush=True,
    )
    if n_vis == 0 or resolved < n_vis:
        raise SystemExit(f"REFUSE: visual_keys={n_vis} resolved={resolved}")
    if cfg.get("model_type") == "qwen3_5_moe_text":
        raise SystemExit("REFUSE: still text-only model_type")
    print("[restore] OK", flush=True)


if __name__ == "__main__":
    main()
