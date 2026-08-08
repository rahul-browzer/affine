#!/usr/bin/env python3
"""Repair Tok-style phantom visual index after CausalLM merge.

CausalLM.save_pretrained drops model.visual.* tensors but can leave their
keys in model.safetensors.index.json pointing at language shards that do
not contain them. merge_lora.py previously treated those keys as present
and skipped TalentPigs-style extraction — chall then dies with
ValueError: weights were not initialized (visual.*).

Usage:
  python restore_visual_pass310.py --merged /root/h79/merged --base <tok-snap>
"""
from __future__ import annotations

import argparse
import json
from collections import defaultdict
from pathlib import Path

from safetensors import safe_open
from safetensors.torch import save_file


def shard_keys(path: Path) -> set[str]:
    with safe_open(str(path), framework="pt") as f:
        return set(f.keys())


def main() -> None:
    ap = argparse.ArgumentParser()
    ap.add_argument("--merged", type=Path, required=True)
    ap.add_argument("--base", type=Path, required=True)
    args = ap.parse_args()

    out = args.merged
    base = args.base
    out_idx_path = out / "model.safetensors.index.json"
    base_idx_path = base / "model.safetensors.index.json"
    out_idx = json.loads(out_idx_path.read_text())
    base_idx = json.loads(base_idx_path.read_text())
    wm = out_idx.setdefault("weight_map", {})

    # Keys claimed by the index but absent from the claimed shard file.
    phantom: dict[str, str] = {}
    checked: dict[str, set[str]] = {}
    for key, shard in list(wm.items()):
        if "visual" not in key:
            continue
        sp = out / shard
        if shard not in checked:
            checked[shard] = shard_keys(sp) if sp.is_file() else set()
        if key not in checked[shard]:
            phantom[key] = shard

    # Also any base visual key missing entirely from out index.
    for key, shard in (base_idx.get("weight_map") or {}).items():
        if "visual" in key and key not in wm:
            phantom[key] = shard

    if not phantom:
        n = sum(1 for k in wm if "visual" in k)
        print(f"[restore310] ok: no phantom visual keys; index visual={n}")
        return

    print(f"[restore310] phantom/missing visual keys: {len(phantom)}", flush=True)

    # Prefer base weight_map shard for extraction source.
    by_shard: dict[str, list[str]] = defaultdict(list)
    base_wm = base_idx.get("weight_map") or {}
    for key in phantom:
        src_shard = base_wm.get(key)
        if not src_shard:
            raise SystemExit(f"base index missing visual key {key}")
        by_shard[src_shard].append(key)

    restored: dict = {}
    for shard, keys in by_shard.items():
        src = base / shard
        if not src.is_file():
            raise SystemExit(f"missing base shard {src}")
        with safe_open(str(src), framework="pt", device="cpu") as f:
            for key in keys:
                restored[key] = f.get_tensor(key)
        print(
            f"[restore310] extracted {len(keys)} keys from {shard}",
            flush=True,
        )

    out_vis = out / "model-visual-restored.safetensors"
    save_file(restored, str(out_vis))
    for key in restored:
        wm[key] = out_vis.name

    total = sum(p.stat().st_size for p in out.glob("*.safetensors"))
    out_idx.setdefault("metadata", {})["total_size"] = total
    if "total_parameters" in (base_idx.get("metadata") or {}):
        out_idx["metadata"]["total_parameters"] = base_idx["metadata"][
            "total_parameters"
        ]
    out_idx_path.write_text(json.dumps(out_idx, indent=2) + "\n")

    # Verify every visual key resolves.
    with safe_open(str(out_vis), framework="pt") as f:
        have = set(f.keys())
    bad = [k for k in wm if "visual" in k and k not in have and k not in shard_keys(out / wm[k])]
    n_vis = sum(1 for k in wm if "visual" in k)
    print(
        f"[restore310] wrote {out_vis.name} tensors={len(restored)} "
        f"index_visual={n_vis} unresolved={len(bad)}",
        flush=True,
    )
    if bad:
        raise SystemExit(f"REFUSE: unresolved visual keys sample={bad[:5]}")


if __name__ == "__main__":
    main()
