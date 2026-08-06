#!/usr/bin/env python3
"""Linear weight merge: out = α·A + (1−α)·B for matching safetensor keys.

Parents may use different shard layouts; we merge by tensor name via each
side's index.json (or single-file fallback). Output uses A's shard map and
non-weight files (config/tokenizer) so the result serves like A under stock
vLLM. Skips keys missing on either side (logs them); aborts if too many miss.
"""
from __future__ import annotations

import argparse
import hashlib
import json
import os
import shutil
import sys
import time
from collections import defaultdict
from pathlib import Path

import torch
from safetensors import safe_open
from safetensors.torch import save_file


META_COPY = (
    "config.json",
    "generation_config.json",
    "tokenizer.json",
    "tokenizer_config.json",
    "chat_template.jinja",
    "preprocessor_config.json",
    "processor_config.json",
    "video_preprocessor_config.json",
)


def resolve_snapshot(repo: str, rev: str, hf_home: Path) -> Path:
    """Resolve HF cache snapshot dir for repo@rev (must already be downloaded).

    huggingface_hub default layout is ``$HF_HOME/hub/models--*``. Passing
    ``cache_dir=$HF_HOME`` to ``snapshot_download`` instead lands at
    ``$HF_HOME/models--*``. Accept both so merge works either way.
    """
    model = "models--" + repo.replace("/", "--")
    candidates = [hf_home / "hub" / model, hf_home / model]
    tried: list[str] = []
    for cache in candidates:
        tried.append(str(cache))
        refs = cache / "refs" / rev
        if refs.is_file():
            sha = refs.read_text().strip()
            snap = cache / "snapshots" / sha
            if snap.is_dir():
                return snap
        # rev may already be the commit sha
        snap = cache / "snapshots" / rev
        if snap.is_dir():
            return snap
    raise SystemExit(f"snapshot not found for {repo}@{rev}; tried {tried}")


def weight_map(snap: Path) -> dict[str, str]:
    idx = snap / "model.safetensors.index.json"
    if idx.is_file():
        return json.loads(idx.read_text())["weight_map"]
    singles = sorted(snap.glob("*.safetensors"))
    if not singles:
        raise SystemExit(f"no safetensors in {snap}")
    # Build map by scanning (handles model-visual-extra etc.)
    out: dict[str, str] = {}
    for f in singles:
        with safe_open(str(f), framework="pt") as sf:
            for k in sf.keys():
                out[k] = f.name
    return out


def file_sha256(path: Path, nbytes: int = 0) -> str:
    h = hashlib.sha256()
    with open(path, "rb") as f:
        if nbytes:
            h.update(f.read(nbytes))
        else:
            for chunk in iter(lambda: f.read(1 << 20), b""):
                h.update(chunk)
    return h.hexdigest()


def main() -> None:
    ap = argparse.ArgumentParser()
    ap.add_argument("--a-repo", required=True, help="base parent (kevin)")
    ap.add_argument("--a-rev", required=True)
    ap.add_argument("--b-repo", required=True, help="merge-in parent (pandora)")
    ap.add_argument("--b-rev", required=True)
    ap.add_argument("--alpha", type=float, default=0.5, help="weight on A")
    ap.add_argument("--out", required=True, type=Path)
    ap.add_argument("--hf-home", type=Path, default=Path(os.environ.get("HF_HOME", "/root/hf")))
    ap.add_argument("--dtype", default="bfloat16", choices=["bfloat16", "float16", "float32"])
    args = ap.parse_args()

    if not (0.0 < args.alpha < 1.0):
        raise SystemExit("alpha must be in (0,1) — exact 0/1 is a copy")

    dtype = {"bfloat16": torch.bfloat16, "float16": torch.float16, "float32": torch.float32}[
        args.dtype
    ]
    a_snap = resolve_snapshot(args.a_repo, args.a_rev, args.hf_home)
    b_snap = resolve_snapshot(args.b_repo, args.b_rev, args.hf_home)
    print(f"[merge] A={a_snap}", flush=True)
    print(f"[merge] B={b_snap}", flush=True)
    print(f"[merge] alpha={args.alpha} out={args.out}", flush=True)

    a_map = weight_map(a_snap)
    b_map = weight_map(b_snap)
    common = sorted(set(a_map) & set(b_map))
    only_a = sorted(set(a_map) - set(b_map))
    only_b = sorted(set(b_map) - set(a_map))
    print(
        f"[merge] keys common={len(common)} only_A={len(only_a)} only_B={len(only_b)}",
        flush=True,
    )
    if only_a[:5]:
        print(f"[merge] only_A sample: {only_a[:5]}", flush=True)
    if only_b[:5]:
        print(f"[merge] only_B sample: {only_b[:5]}", flush=True)
    if len(common) < 0.95 * max(len(a_map), len(b_map)):
        raise SystemExit(
            f"too few overlapping keys ({len(common)}/{max(len(a_map), len(b_map))}); abort"
        )

    args.out.mkdir(parents=True, exist_ok=True)
    for name in META_COPY:
        src = a_snap / name
        if src.is_file():
            shutil.copy2(src, args.out / name)

    # Group output tensors by A's shard filename.
    by_shard: dict[str, list[str]] = defaultdict(list)
    for k in common:
        by_shard[a_map[k]].append(k)
    # Keys only in A: copy through from A (keep serveable; logged above).
    for k in only_a:
        by_shard[a_map[k]].append(k)

    # Open handles lazily per shard pair.
    a_handles: dict[str, safe_open] = {}
    b_handles: dict[str, safe_open] = {}

    def a_get(key: str):
        fname = a_map[key]
        if fname not in a_handles:
            a_handles[fname] = safe_open(str(a_snap / fname), framework="pt")
        return a_handles[fname].get_tensor(key)

    def b_get(key: str):
        fname = b_map[key]
        if fname not in b_handles:
            b_handles[fname] = safe_open(str(b_snap / fname), framework="pt")
        return b_handles[fname].get_tensor(key)

    new_weight_map: dict[str, str] = {}
    t0 = time.time()
    n_merged = 0
    n_copied = 0
    max_abs_delta = 0.0

    for shard, keys in sorted(by_shard.items()):
        tensors: dict[str, torch.Tensor] = {}
        print(f"[merge] shard {shard} n_keys={len(keys)}", flush=True)
        for key in keys:
            ta = a_get(key)
            if key in b_map:
                tb = b_get(key)
                if ta.shape != tb.shape:
                    raise SystemExit(f"shape mismatch {key}: {ta.shape} vs {tb.shape}")
                # Promote for math, write as target dtype.
                out = (
                    args.alpha * ta.to(torch.float32) + (1.0 - args.alpha) * tb.to(torch.float32)
                ).to(dtype)
                # Track a cheap non-identity signal on first few params.
                if n_merged < 8:
                    max_abs_delta = max(
                        max_abs_delta, (out.float() - ta.float()).abs().max().item()
                    )
                tensors[key] = out.contiguous()
                n_merged += 1
            else:
                tensors[key] = ta.to(dtype).contiguous()
                n_copied += 1
            new_weight_map[key] = shard
        dest = args.out / shard
        save_file(tensors, str(dest))
        print(f"[merge] wrote {dest} bytes={dest.stat().st_size}", flush=True)
        del tensors

    for h in list(a_handles.values()) + list(b_handles.values()):
        # safe_open has no close in older versions; drop refs
        pass
    a_handles.clear()
    b_handles.clear()

    index = {
        "metadata": {
            "merge": {
                "a_repo": args.a_repo,
                "a_rev": args.a_rev,
                "b_repo": args.b_repo,
                "b_rev": args.b_rev,
                "alpha": args.alpha,
                "formula": "alpha*A + (1-alpha)*B",
                "n_merged": n_merged,
                "n_copied_from_A": n_copied,
                "max_abs_delta_sample": max_abs_delta,
            }
        },
        "weight_map": new_weight_map,
    }
    (args.out / "model.safetensors.index.json").write_text(json.dumps(index, indent=2))

    # Fingerprint first shard vs A's — must differ.
    first_shard = sorted(by_shard)[0]
    a_fp = file_sha256(a_snap / first_shard, nbytes=1 << 20)
    o_fp = file_sha256(args.out / first_shard, nbytes=1 << 20)
    identical_prefix = a_fp == o_fp
    meta = {
        "out": str(args.out),
        "alpha": args.alpha,
        "n_merged": n_merged,
        "n_copied_from_A": n_copied,
        "max_abs_delta_sample": max_abs_delta,
        "first_shard": first_shard,
        "a_first_1MiB_sha256": a_fp,
        "out_first_1MiB_sha256": o_fp,
        "first_1MiB_identical": identical_prefix,
        "elapsed_s": time.time() - t0,
    }
    (args.out / "merge_meta.json").write_text(json.dumps(meta, indent=2))
    print(json.dumps(meta, indent=2), flush=True)
    if identical_prefix and max_abs_delta == 0.0:
        raise SystemExit("merge looks weight-identical to A — refuse")
    if max_abs_delta < 1e-8:
        raise SystemExit(f"max_abs_delta_sample too small ({max_abs_delta}); refuse copy")
    print("[merge] OK_NON_IDENTICAL", flush=True)


if __name__ == "__main__":
    main()
