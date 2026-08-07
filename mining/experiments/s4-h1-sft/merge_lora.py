#!/usr/bin/env python3
"""Merge LoRA adapter into kevin base → full safetensors dir for vllm serve."""
from __future__ import annotations

import argparse
import json
import os
import shutil
import time
from pathlib import Path

import torch
from peft import PeftModel
from transformers import AutoModelForCausalLM, AutoTokenizer


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

    meta = {
        "base": args.base,
        "adapter": str(args.adapter),
        "out": str(args.out),
        "device_map": args.device_map,
        "cuda_visible": os.environ.get("CUDA_VISIBLE_DEVICES"),
        "elapsed_s": time.time() - t0,
        "finished_utc": time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime()),
    }
    (args.out / "merge_meta.json").write_text(json.dumps(meta, indent=2))
    print(json.dumps(meta, indent=2), flush=True)
    print("[merge] DONE", flush=True)


if __name__ == "__main__":
    main()
