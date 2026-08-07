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

    # AutoModelForCausalLM.save_pretrained writes the *text* config
    # (qwen3_5_moe_text / Qwen3_5MoeForCausalLM). Stock vLLM on the eval
    # stack expects the multimodal wrapper (qwen3_5_moe /
    # Qwen3_5MoeForConditionalGeneration) that the king ships. Observed
    # 2026-08-07: chall serve crashed with TypeError expecting
    # Qwen3_5MoeConfig, got Qwen3_5MoeTextConfig. Restore wrapper config
    # + vision preprocessor sidecars from the base snapshot (weights
    # already use model.language_model.* keys; sizes match).
    base_path = Path(args.base)
    for name in (
        "config.json",
        "preprocessor_config.json",
        "video_preprocessor_config.json",
    ):
        src = base_path / name
        if src.is_file():
            shutil.copy2(src, args.out / name)
            print(f"[merge] restored {name} from base", flush=True)

    # CausalLM save also drops the vision tower shard (model.visual.*).
    # With the wrapper config restored, vLLM requires those weights.
    # Copy untouched visual shard(s) + merge their weight_map entries.
    visual_shards = sorted(base_path.glob("model-visual*.safetensors"))
    if visual_shards:
        out_idx_path = args.out / "model.safetensors.index.json"
        base_idx_path = base_path / "model.safetensors.index.json"
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
        for src in visual_shards:
            shutil.copy2(src, args.out / src.name)
            print(f"[merge] restored visual shard {src.name}", flush=True)
        for key, shard in (base_idx.get("weight_map") or {}).items():
            if key not in out_idx["weight_map"]:
                out_idx["weight_map"][key] = shard
                added += 1
        total = sum(p.stat().st_size for p in args.out.glob("*.safetensors"))
        out_idx.setdefault("metadata", {})
        out_idx["metadata"]["total_size"] = total
        if "total_parameters" in (base_idx.get("metadata") or {}):
            out_idx["metadata"]["total_parameters"] = base_idx["metadata"][
                "total_parameters"
            ]
        out_idx_path.write_text(json.dumps(out_idx, indent=2) + "\n")
        print(f"[merge] merged {added} visual weight_map keys into index", flush=True)

    # Hygiene: no *.py, strip auto_map if present.
    cfg_path = args.out / "config.json"
    cfg = json.loads(cfg_path.read_text())
    if "auto_map" in cfg:
        del cfg["auto_map"]
        cfg_path.write_text(json.dumps(cfg, indent=2) + "\n")
    for p in args.out.rglob("*.py"):
        p.unlink()

    # Hard rule: weight-identical to king/base is rejected at submit. Refuse
    # here so we never burn ~66 min of n40+n80 sim on a no-op merge.
    #
    # Do NOT use only the first 1MiB of shard-1: that window is almost always
    # embed/lm_head (untouched by LoRA), so a real LoRA merge false-positives
    # as identical (observed 2026-08-07 H1: head equal, mid equal, tail ≠,
    # and q/k/v/o_proj tensors differ). Sample head/mid/tail on every
    # safetensors shard; refuse only if ALL sampled windows match.
    base_shard = _first_shard(base_path)
    out_shard = _first_shard(args.out)
    base_fp = _file_sha256(base_shard, nbytes=1 << 20)
    out_fp = _file_sha256(out_shard, nbytes=1 << 20)

    def _window_sha(path: Path, offset: int, nbytes: int = 1 << 20) -> str:
        h = hashlib.sha256()
        size = path.stat().st_size
        off = max(0, min(offset, max(0, size - nbytes)))
        with open(path, "rb") as f:
            f.seek(off)
            h.update(f.read(nbytes))
        return h.hexdigest()

    shard_windows: dict[str, dict] = {}
    any_diff = False
    # Only numbered language-model shards. Base may ship unused extras
    # (e.g. model-visual-extra.safetensors) that save_pretrained omits.
    shard_paths = sorted(base_path.glob("model-*-of-*.safetensors"))
    if not shard_paths:
        shard_paths = sorted(
            p for p in base_path.glob("*.safetensors") if p.name.startswith("model")
        )
    for shard_path in shard_paths:
        name = shard_path.name
        out_p = args.out / name
        if not out_p.is_file():
            any_diff = True
            shard_windows[name] = {"out_missing": True}
            continue
        size = shard_path.stat().st_size
        windows = {
            "head": (_window_sha(shard_path, 0), _window_sha(out_p, 0)),
            "mid": (
                _window_sha(shard_path, size // 2),
                _window_sha(out_p, size // 2),
            ),
            "tail": (
                _window_sha(shard_path, max(0, size - (1 << 20))),
                _window_sha(out_p, max(0, out_p.stat().st_size - (1 << 20))),
            ),
        }
        eqs = {k: a == b for k, (a, b) in windows.items()}
        if not all(eqs.values()):
            any_diff = True
        shard_windows[name] = {
            "size_base": size,
            "size_out": out_p.stat().st_size,
            "equal": eqs,
        }

    # Legacy field kept for harvest parsers; true identity uses window probe.
    first_1mib_identical = base_fp == out_fp
    identical = (not any_diff) and first_1mib_identical

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
        "first_1MiB_identical": first_1mib_identical,
        "shard_windows": shard_windows,
        "weight_identical": identical,
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
            "merge looks weight-identical to base (all shard head/mid/tail "
            "windows match) — refuse sim"
        )
    if first_1mib_identical and any_diff:
        print(
            "[merge] NOTE: first_1MiB of first shard matches base (expected "
            "for embed-leading shards); later windows differ — merge OK",
            flush=True,
        )
    print("[merge] DONE", flush=True)


if __name__ == "__main__":
    main()
