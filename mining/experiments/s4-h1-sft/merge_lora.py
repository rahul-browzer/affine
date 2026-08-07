#!/usr/bin/env python3
"""Merge LoRA adapter into kevin base → full safetensors dir for vllm serve."""
from __future__ import annotations

import argparse
import hashlib
import json
import os
import shutil
import time
from pathlib import Path

import torch
from peft import PeftModel
from transformers import AutoModelForCausalLM, AutoTokenizer


def _file_sha256(path: Path, nbytes: int = 0) -> str:
    h = hashlib.sha256()
    with open(path, "rb") as f:
        if nbytes:
            h.update(f.read(nbytes))
        else:
            for chunk in iter(lambda: f.read(1 << 20), b""):
                h.update(chunk)
    return h.hexdigest()


def _first_shard(model_dir: Path) -> Path:
    idx = model_dir / "model.safetensors.index.json"
    if idx.is_file():
        weight_map = json.loads(idx.read_text()).get("weight_map") or {}
        shard = weight_map.get("model.embed_tokens.weight") or next(
            iter(weight_map.values()), None
        )
        if shard:
            return model_dir / shard
    single = model_dir / "model.safetensors"
    if single.is_file():
        return single
    raise FileNotFoundError(f"no safetensors shard under {model_dir}")


def main() -> None:
    ap = argparse.ArgumentParser()
    ap.add_argument("--base", required=True)
    ap.add_argument("--adapter", type=Path, required=True)
    ap.add_argument("--out", type=Path, required=True)
    ap.add_argument(
        "--device-map",
        default="cpu",
        help="transformers device_map; use 'auto' on free GPUs 6,7 after train "
        "(much faster than cpu for 35B merge under TTL pressure)",
    )
    args = ap.parse_args()

    t0 = time.time()
    if args.out.exists():
        shutil.rmtree(args.out)
    args.out.mkdir(parents=True)

    print(
        f"[merge] load base {args.base} device_map={args.device_map} "
        f"CUDA_VISIBLE_DEVICES={os.environ.get('CUDA_VISIBLE_DEVICES')}",
        flush=True,
    )
    tok = AutoTokenizer.from_pretrained(args.base, trust_remote_code=False)
    model = AutoModelForCausalLM.from_pretrained(
        args.base,
        torch_dtype=torch.bfloat16,
        device_map=args.device_map,
        trust_remote_code=False,
    )
    print(f"[merge] load adapter {args.adapter}", flush=True)
    model = PeftModel.from_pretrained(model, str(args.adapter))
    print("[merge] merge_and_unload", flush=True)
    model = model.merge_and_unload()
    print(f"[merge] save {args.out}", flush=True)
    model.save_pretrained(str(args.out), safe_serialization=True)
    tok.save_pretrained(str(args.out))

    # Hygiene: no *.py, strip auto_map if present.
    cfg_path = args.out / "config.json"
    cfg = json.loads(cfg_path.read_text())
    if "auto_map" in cfg:
        del cfg["auto_map"]
        cfg_path.write_text(json.dumps(cfg, indent=2))
    for p in args.out.rglob("*.py"):
        p.unlink()

    # Hard rule: weight-identical to king/base is rejected at submit. Refuse
    # here so we never burn ~66 min of n40+n80 sim on a no-op merge.
    base_path = Path(args.base)
    base_shard = _first_shard(base_path)
    out_shard = _first_shard(args.out)
    base_fp = _file_sha256(base_shard, nbytes=1 << 20)
    out_fp = _file_sha256(out_shard, nbytes=1 << 20)
    identical = base_fp == out_fp

    meta = {
        "base": args.base,
        "adapter": str(args.adapter),
        "out": str(args.out),
        "device_map": args.device_map,
        "cuda_visible": os.environ.get("CUDA_VISIBLE_DEVICES"),
        "base_first_shard": str(base_shard),
        "out_first_shard": str(out_shard),
        "base_first_1MiB_sha256": base_fp,
        "out_first_1MiB_sha256": out_fp,
        "first_1MiB_identical": identical,
        "elapsed_s": time.time() - t0,
        "finished_utc": time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime()),
    }
    (args.out / "merge_meta.json").write_text(json.dumps(meta, indent=2) + "\n")
    # Also stage where host harvest looks.
    Path("/root/affine_data").mkdir(parents=True, exist_ok=True)
    Path("/root/affine_data/h1_merge_meta.json").write_text(
        json.dumps(meta, indent=2) + "\n"
    )
    print(json.dumps(meta, indent=2), flush=True)
    if identical:
        raise SystemExit(
            "merge looks weight-identical to base (first_1MiB sha match) — refuse sim"
        )
    print("[merge] DONE", flush=True)


if __name__ == "__main__":
    main()
