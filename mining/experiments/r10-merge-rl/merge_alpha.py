#!/usr/bin/env python3
"""CPU α-merge of N HF MoE snapshots → local dir for vLLM chall reload.

Blends tensors by name: out[k] = Σ w_i · parent_i[k]  (weights normalized).
Uses parent0 as the layout/config donor (live king Tok). Missing keys in a
non-primary parent fall back to the primary tensor for that key.

Refuse path: if every blended tensor equals primary within atol, exit 3
(weight-identical copies are rejected by the subnet).
"""
from __future__ import annotations

import argparse
import json
import shutil
import time
from collections import defaultdict
from pathlib import Path

import torch
from safetensors.torch import load_file, save_file

_COPY_NAMES = (
    "config.json",
    "preprocessor_config.json",
    "processor_config.json",
    "video_preprocessor_config.json",
    "chat_template.jinja",
    "chat_template.json",
    "generation_config.json",
    "configuration.json",
    "tokenizer.json",
    "tokenizer_config.json",
    "special_tokens_map.json",
    "vocab.json",
    "merges.txt",
)


def _load_index(p: Path) -> dict:
    idx_path = p / "model.safetensors.index.json"
    if not idx_path.is_file():
        raise SystemExit(f"missing index at {idx_path}")
    return json.loads(idx_path.read_text())


def _copy_sidecar(src: Path, dst: Path) -> list[str]:
    copied: list[str] = []
    for name in _COPY_NAMES:
        sp = src / name
        if not sp.is_file() and not sp.is_symlink():
            continue
        # Materialize (HF snapshots are often symlinks into blobs/).
        shutil.copyfile(sp, dst / name)
        copied.append(name)
    # Derive preprocessor_config.json from processor_config.json if absent
    # (Tok af10 landmine — vLLM wants preprocessor_config.json).
    if not (dst / "preprocessor_config.json").exists() and (
        dst / "processor_config.json"
    ).exists():
        shutil.copyfile(dst / "processor_config.json", dst / "preprocessor_config.json")
        copied.append("preprocessor_config.json(from_processor)")
    return copied


def main() -> None:
    ap = argparse.ArgumentParser()
    ap.add_argument(
        "--parent",
        action="append",
        required=True,
        help="PATH:WEIGHT (repeat). First parent is layout/config donor.",
    )
    ap.add_argument("--out", required=True, type=Path)
    ap.add_argument(
        "--device",
        default="cpu",
        help="torch device for blend math (default cpu; host has ~2TB RAM)",
    )
    ap.add_argument(
        "--atol",
        type=float,
        default=0.0,
        help="identical-to-primary check atol (0 = exact)",
    )
    args = ap.parse_args()

    parents: list[tuple[Path, float]] = []
    for spec in args.parent:
        if ":" not in spec:
            raise SystemExit(f"--parent needs PATH:WEIGHT, got {spec!r}")
        path_s, w_s = spec.rsplit(":", 1)
        parents.append((Path(path_s), float(w_s)))
    if len(parents) < 2:
        raise SystemExit("need ≥2 --parent PATH:WEIGHT")

    wsum = sum(w for _, w in parents)
    if wsum <= 0:
        raise SystemExit("weights must sum > 0")
    norms = [(p, w / wsum) for p, w in parents]
    primary = norms[0][0]
    for p, _ in norms:
        if not p.is_dir():
            raise SystemExit(f"missing parent dir {p}")

    t0 = time.time()
    args.out.mkdir(parents=True, exist_ok=True)
    meta = {
        "started_utc": time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime()),
        "parents": [{"path": str(p), "weight": w, "norm": nw} for (p, w), (_, nw) in zip(parents, norms)],
        "out": str(args.out),
        "device": args.device,
    }
    print(json.dumps(meta), flush=True)

    indexes = [_load_index(p) for p, _ in norms]
    primary_map: dict[str, str] = indexes[0]["weight_map"]
    parent_maps = [idx["weight_map"] for idx in indexes]

    # Group keys by primary output shard (keeps shard layout = Tok).
    shard_keys: dict[str, list[str]] = defaultdict(list)
    for k, shard in primary_map.items():
        shard_keys[shard].append(k)

    # Cache of loaded parent shards: (parent_i, shard_name) -> dict[str, Tensor]
    cache: dict[tuple[int, str], dict] = {}
    cache_order: list[tuple[int, str]] = []
    max_cached = 24  # ~ caps host pressure when secondaries are many-shard

    def get_shard(pi: int, shard: str) -> dict:
        key = (pi, shard)
        if key in cache:
            return cache[key]
        path = norms[pi][0] / shard
        if not path.exists():
            raise SystemExit(f"missing shard {path}")
        print(f"[merge-α] load parent{pi} {shard}", flush=True)
        blob = load_file(str(path), device=args.device)
        cache[key] = blob
        cache_order.append(key)
        while len(cache_order) > max_cached:
            old = cache_order.pop(0)
            if old in cache and old != key:
                del cache[old]
        return blob

    out_map: dict[str, str] = {}
    total_size = 0
    n_keys = 0
    n_exact_primary = 0
    n_missing_fallback = 0
    max_abs_delta = 0.0

    for shard, keys in sorted(shard_keys.items()):
        print(f"[merge-α] blend → {shard} ({len(keys)} keys)", flush=True)
        out_tensors: dict[str, torch.Tensor] = {}
        # Prefetch primary shard once.
        prim_blob = get_shard(0, shard)
        for k in keys:
            acc = None
            primary_t = None
            for pi, (_, nw) in enumerate(norms):
                pmap = parent_maps[pi]
                if k not in pmap:
                    if pi == 0:
                        raise SystemExit(f"primary missing key {k}")
                    n_missing_fallback += 1
                    t = prim_blob[k]
                else:
                    t = get_shard(pi, pmap[k])[k]
                if pi == 0:
                    primary_t = t
                piece = t.to(dtype=torch.float32) * nw
                acc = piece if acc is None else acc + piece
            assert acc is not None and primary_t is not None
            blended = acc.to(dtype=primary_t.dtype)
            # Exact-identity probe (sample max abs delta vs primary).
            if blended.shape == primary_t.shape:
                d = (blended.to(torch.float32) - primary_t.to(torch.float32)).abs().max().item()
                max_abs_delta = max(max_abs_delta, float(d))
                if d <= args.atol:
                    n_exact_primary += 1
            out_tensors[k] = blended.contiguous()
            out_map[k] = shard
            n_keys += 1
            total_size += int(blended.nbytes)
        save_file(out_tensors, str(args.out / shard))
        del out_tensors, prim_blob
        # Drop primary shard from cache after write.
        cache.pop((0, shard), None)
        print(f"[merge-α] wrote {shard}", flush=True)

    idx_out = {
        "metadata": {"total_size": total_size},
        "weight_map": out_map,
    }
    (args.out / "model.safetensors.index.json").write_text(
        json.dumps(idx_out, indent=2) + "\n"
    )
    copied = _copy_sidecar(primary, args.out)

    identical_frac = n_exact_primary / max(n_keys, 1)
    summary = {
        "finished_utc": time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime()),
        "seconds": round(time.time() - t0, 1),
        "n_keys": n_keys,
        "n_shards": len(shard_keys),
        "total_size_gb": round(total_size / 1e9, 3),
        "n_missing_fallback": n_missing_fallback,
        "n_exact_primary": n_exact_primary,
        "identical_frac": round(identical_frac, 6),
        "max_abs_delta": max_abs_delta,
        "sidecar_copied": copied,
    }
    (args.out / "merge_alpha_meta.json").write_text(json.dumps(summary, indent=2) + "\n")
    print(json.dumps(summary, indent=2), flush=True)

    # Hard refuse weight-identical (or near) copies — subnet rejects them.
    if max_abs_delta <= args.atol:
        raise SystemExit(3)
    if identical_frac > 0.999:
        raise SystemExit(3)
    print("[merge-α] OK distinct from primary", flush=True)


if __name__ == "__main__":
    main()
