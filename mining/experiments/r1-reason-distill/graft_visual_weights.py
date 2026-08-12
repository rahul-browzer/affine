#!/usr/bin/env python3
"""Copy model.visual.* tensors from multimodal base into a CausalLM-merged dir.

AutoModelForCausalLM.save_pretrained drops vision weights. vLLM with
Qwen3_5MoeForConditionalGeneration then fails weight init. Graft from base.
"""
from __future__ import annotations

import argparse
import json
import time
from pathlib import Path

from safetensors.torch import load_file, save_file


def main() -> None:
    ap = argparse.ArgumentParser()
    ap.add_argument("--base", required=True, type=Path)
    ap.add_argument("--merged", required=True, type=Path)
    ap.add_argument("--shard-name", default="model-visual.safetensors")
    args = ap.parse_args()

    t0 = time.time()
    b_idx_path = args.base / "model.safetensors.index.json"
    m_idx_path = args.merged / "model.safetensors.index.json"
    b_idx = json.loads(b_idx_path.read_text())
    m_idx = json.loads(m_idx_path.read_text())
    b_map = b_idx["weight_map"]
    m_map = m_idx["weight_map"]

    already = [k for k in m_map if "visual" in k]
    if already:
        print(json.dumps({"status": "skip", "visual_already": len(already)}), flush=True)
        return

    vis_keys = sorted(k for k in b_map if "visual" in k)
    if not vis_keys:
        raise SystemExit(f"no visual keys in base {args.base}")

    shard_to_keys: dict[str, list[str]] = {}
    for k in vis_keys:
        shard_to_keys.setdefault(b_map[k], []).append(k)

    # Clone off safetensors mmap before dropping the blob — otherwise
    # save_file can hit EFAULT / "Bad address" (os error 14) after del blob
    # (seen on crown R9 merge p2187).
    tensors = {}
    for shard, keys in shard_to_keys.items():
        path = args.base / shard
        print(f"[graft] loading {len(keys)} keys from {shard}", flush=True)
        blob = load_file(str(path), device="cpu")
        for k in keys:
            tensors[k] = blob[k].detach().contiguous().clone()
        del blob

    out_shard = args.merged / args.shard_name
    print(f"[graft] writing {len(tensors)} tensors → {out_shard}", flush=True)
    save_file(tensors, str(out_shard))

    nbytes = sum(t.nbytes for t in tensors.values())
    for k in vis_keys:
        m_map[k] = args.shard_name
    m_idx["weight_map"] = m_map
    m_idx["metadata"] = dict(m_idx.get("metadata") or {})
    m_idx["metadata"]["total_size"] = int(m_idx["metadata"].get("total_size", 0)) + int(
        nbytes
    )
    m_idx_path.write_text(json.dumps(m_idx, indent=2) + "\n")

    for name in ("video_preprocessor_config.json",):
        src, dst = args.base / name, args.merged / name
        if src.is_file() and not dst.is_file():
            dst.write_bytes(src.read_bytes())
            print(f"[graft] copied {name}", flush=True)

    meta = {
        "status": "ok",
        "visual_keys": len(vis_keys),
        "bytes": nbytes,
        "shard": args.shard_name,
        "elapsed_s": round(time.time() - t0, 1),
    }
    (args.merged / "graft_visual_result.json").write_text(json.dumps(meta, indent=2) + "\n")
    print(json.dumps(meta, indent=2), flush=True)


if __name__ == "__main__":
    main()
