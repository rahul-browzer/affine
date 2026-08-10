#!/usr/bin/env python3
"""Merge R1 LoRA adapter into Tok base → local HF dir for vLLM chall reload.

Keeps tokenizer + processor configs from the base snapshot so vLLM can load.
Runs on idle GPUs (default 6,7) after train frees them.
"""
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

# Always overwrite config.json: CausalLM save writes qwen3_5_moe_text /
# Qwen3_5MoeForCausalLM, which vLLM rejects (needs full multimodal MoE config).
_COPY_NAMES = (
    "config.json",
    "preprocessor_config.json",
    "processor_config.json",
    "video_preprocessor_config.json",
    "chat_template.jinja",
    "chat_template.json",
    "generation_config.json",
    "configuration.json",
)
_ALWAYS_OVERWRITE = frozenset({"config.json"})


def _graft_visual_weights(base: Path, out: Path) -> dict:
    """CausalLM save drops model.visual.*; vLLM multimodal needs them back."""
    from safetensors.torch import load_file, save_file

    b_idx = json.loads((base / "model.safetensors.index.json").read_text())
    m_idx_path = out / "model.safetensors.index.json"
    m_idx = json.loads(m_idx_path.read_text())
    b_map, m_map = b_idx["weight_map"], m_idx["weight_map"]
    if any("visual" in k for k in m_map):
        return {"status": "skip", "reason": "visual_already_present"}

    vis_keys = sorted(k for k in b_map if "visual" in k)
    if not vis_keys:
        return {"status": "warn", "reason": "no_visual_in_base"}

    shard_to_keys: dict[str, list[str]] = {}
    for k in vis_keys:
        shard_to_keys.setdefault(b_map[k], []).append(k)

    tensors = {}
    for shard, keys in shard_to_keys.items():
        blob = load_file(str(base / shard), device="cpu")
        for k in keys:
            tensors[k] = blob[k]
        del blob

    shard_name = "model-visual.safetensors"
    save_file(tensors, str(out / shard_name))
    nbytes = sum(t.nbytes for t in tensors.values())
    for k in vis_keys:
        m_map[k] = shard_name
    m_idx["weight_map"] = m_map
    m_idx["metadata"] = dict(m_idx.get("metadata") or {})
    m_idx["metadata"]["total_size"] = int(m_idx["metadata"].get("total_size", 0)) + int(
        nbytes
    )
    m_idx_path.write_text(json.dumps(m_idx, indent=2) + "\n")
    return {"status": "ok", "visual_keys": len(vis_keys), "bytes": nbytes, "shard": shard_name}


def main() -> None:
    ap = argparse.ArgumentParser()
    ap.add_argument("--base", required=True, type=Path)
    ap.add_argument("--adapter", required=True, type=Path)
    ap.add_argument("--out", required=True, type=Path)
    args = ap.parse_args()

    t0 = time.time()
    if not args.base.is_dir():
        raise SystemExit(f"missing base {args.base}")
    if not (args.adapter / "adapter_config.json").is_file() and not (
        args.adapter / "adapter_model.safetensors"
    ).is_file():
        # peft may write adapter_model.safetensors or .bin; config is required.
        if not (args.adapter / "adapter_config.json").is_file():
            raise SystemExit(f"missing adapter at {args.adapter}")

    args.out.mkdir(parents=True, exist_ok=True)
    print(
        json.dumps(
            {
                "base": str(args.base),
                "adapter": str(args.adapter),
                "out": str(args.out),
                "cuda_visible": os.environ.get("CUDA_VISIBLE_DEVICES"),
                "started_utc": time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime()),
            }
        ),
        flush=True,
    )

    tok = AutoTokenizer.from_pretrained(str(args.base), trust_remote_code=False)
    print(f"[merge] loading base {args.base}", flush=True)
    model = AutoModelForCausalLM.from_pretrained(
        str(args.base),
        torch_dtype=torch.bfloat16,
        device_map="auto",
        trust_remote_code=False,
        attn_implementation="sdpa",
    )
    print(f"[merge] loading adapter {args.adapter}", flush=True)
    model = PeftModel.from_pretrained(model, str(args.adapter))
    print("[merge] merge_and_unload…", flush=True)
    model = model.merge_and_unload()

    print(f"[merge] saving → {args.out}", flush=True)
    model.save_pretrained(str(args.out), safe_serialization=True)
    tok.save_pretrained(str(args.out))

    # Copy multimodal / chat configs. Use copyfile (follows HF blob symlinks
    # and writes a real file — copy2 of a symlink can leave a dangling link).
    for name in _COPY_NAMES:
        src = args.base / name
        dst = args.out / name
        if not src.is_file():
            continue
        if name not in _ALWAYS_OVERWRITE and dst.is_file() and not dst.is_symlink():
            continue
        if dst.is_symlink() or dst.exists():
            dst.unlink()
        shutil.copyfile(src, dst)
        print(f"[merge] copied {name}", flush=True)

    # Derive preprocessor if only processor_config exists (Tok pattern).
    pre, proc = args.out / "preprocessor_config.json", args.out / "processor_config.json"
    if not pre.is_file() and proc.is_file():
        data = json.loads(proc.read_text())
        img = data.get("image_processor", data)
        pre.write_text(json.dumps(img, indent=2) + "\n")
        print(f"[merge] derived {pre}", flush=True)

    graft = _graft_visual_weights(args.base, args.out)
    print(f"[merge] graft_visual={json.dumps(graft)}", flush=True)

    meta = {
        "base": str(args.base),
        "adapter": str(args.adapter),
        "out": str(args.out),
        "graft_visual": graft,
        "elapsed_s": time.time() - t0,
        "finished_utc": time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime()),
    }
    (args.out / "merge_result.json").write_text(json.dumps(meta, indent=2))
    print(json.dumps(meta, indent=2), flush=True)
    print("[merge] DONE", flush=True)


if __name__ == "__main__":
    main()
