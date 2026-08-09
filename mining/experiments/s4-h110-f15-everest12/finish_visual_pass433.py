#!/usr/bin/env python3
"""Finish H110 visual restore after language shards saved (pass433 EFAULT).

Same recipe as H109 finish_visual_pass429c: clone tensors before save_file
so mmap'd base weights on gocryptfs do not trip Bad address (os error 14).
"""
from __future__ import annotations

import json
import shutil
import sys
from collections import defaultdict
from pathlib import Path

import torch
from safetensors import safe_open
from safetensors.torch import save_file

OUT = Path(sys.argv[1] if len(sys.argv) > 1 else "/tmp/h110_merged")
BASE = Path(
    sys.argv[2]
    if len(sys.argv) > 2
    else "/root/hf/hub/models--everest12--affine-5EkhZHopy9CAoUhKmVTDsyGQi7Voo9gURYPnNDiMZX1pQZxp/snapshots/a5ac5311d32f5d96d604c14294046e27130e1b5c"
)

out_idx_path = OUT / "model.safetensors.index.json"
base_idx_path = BASE / "model.safetensors.index.json"
out_idx = json.loads(out_idx_path.read_text())
base_idx = json.loads(base_idx_path.read_text())

for name in (
    "config.json",
    "preprocessor_config.json",
    "processor_config.json",
    "video_preprocessor_config.json",
    "chat_template.jinja",
    "tokenizer.json",
    "tokenizer_config.json",
):
    src = BASE / name
    if src.is_file():
        shutil.copy2(src, OUT / name)

missing = {
    k: sh
    for k, sh in (base_idx.get("weight_map") or {}).items()
    if k not in out_idx["weight_map"]
}
print(f"[finish433] missing keys={len(missing)}", flush=True)
if not missing:
    print("[finish433] nothing to restore", flush=True)
    sys.exit(0)

by_shard: dict[str, list[str]] = defaultdict(list)
for key, shard in missing.items():
    by_shard[shard].append(key)

restored: dict[str, torch.Tensor] = {}
for shard, keys in by_shard.items():
    src = BASE / shard
    with safe_open(str(src), framework="pt", device="cpu") as f:
        for key in keys:
            t = f.get_tensor(key)
            restored[key] = t.detach().to("cpu").contiguous().clone()
    print(f"[finish433] extracted {len(keys)} from {shard}", flush=True)

out_vis = OUT / "model-visual-restored.safetensors"
save_file(restored, str(out_vis))
for key in restored:
    out_idx["weight_map"][key] = out_vis.name

total = sum(p.stat().st_size for p in OUT.glob("*.safetensors"))
out_idx.setdefault("metadata", {})
out_idx["metadata"]["total_size"] = total
if "total_parameters" in (base_idx.get("metadata") or {}):
    out_idx["metadata"]["total_parameters"] = base_idx["metadata"][
        "total_parameters"
    ]
out_idx_path.write_text(json.dumps(out_idx, indent=2) + "\n")

n_vis = sum(1 for k in out_idx["weight_map"] if "visual" in k)
with safe_open(str(out_vis), framework="pt") as f:
    keys = set(f.keys())
assert all(k in keys for k in restored), "visual shard missing keys"
meta = {
    "hyp": "h110",
    "out": str(OUT),
    "base": str(BASE),
    "n_shards": len(list(OUT.glob("model-*-of-*.safetensors"))),
    "n_visual_keys": n_vis,
    "visual_file": out_vis.name,
    "visual_bytes": out_vis.stat().st_size,
    "weight_identical": False,
    "finish": "pass433",
}
(OUT / "merge_meta.json").write_text(json.dumps(meta, indent=2) + "\n")
print(
    f"[finish433] OK visual={out_vis.name} bytes={out_vis.stat().st_size} "
    f"n_vis={n_vis}",
    flush=True,
)
