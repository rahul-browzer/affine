#!/usr/bin/env python3
"""Upload the H1 LoRA adapter (small) to HF so a TTL kill cannot erase train.

Not a submission candidate — adapter-only salvage. Full merged weights stay
on the pod until sim clears the Stage-5 gate.

PEFT writes README.md / adapter_config with a local snapshot path as
base_model; HF rejects that YAML. We stage a clean copy with a Hub id.
"""
from __future__ import annotations

import argparse
import json
import os
import re
import shutil
import sys
import tempfile
from datetime import datetime, timezone
from pathlib import Path

DEFAULT_BASE_HUB = "kevin954/Affine-5dfqbbh8ev-sft"

# Adapter reload needs these; optimizer/rng are optional and bulky.
ADAPTER_KEEP = (
    "adapter_config.json",
    "adapter_model.safetensors",
    "adapter_model.bin",
)


def _hub_base_from_local(path: str, fallback: str) -> str:
    """Map a local HF hub cache path → repo id when possible."""
    # e.g. .../models--kevin954--Affine-5dfqbbh8ev-sft/snapshots/<sha>
    m = re.search(r"/models--([^/]+)--([^/]+)/", path + "/")
    if m:
        return f"{m.group(1)}/{m.group(2)}"
    if path.count("/") == 1 and not path.startswith("/"):
        return path
    return fallback


def _stage_adapter(src: Path, base_hub: str) -> Path:
    tmp = Path(tempfile.mkdtemp(prefix="h1_salvage_"))
    kept = []
    for name in ADAPTER_KEEP:
        p = src / name
        if p.is_file():
            shutil.copy2(p, tmp / name)
            kept.append(name)
    if "adapter_config.json" not in kept:
        raise FileNotFoundError(f"no adapter_config.json in {src}")
    if "adapter_model.safetensors" not in kept and "adapter_model.bin" not in kept:
        raise FileNotFoundError(f"no adapter weights in {src}")

    cfg_path = tmp / "adapter_config.json"
    cfg = json.loads(cfg_path.read_text())
    local = cfg.get("base_model_name_or_path") or ""
    hub = _hub_base_from_local(str(local), base_hub)
    cfg["base_model_name_or_path"] = hub
    cfg_path.write_text(json.dumps(cfg, indent=2) + "\n")

    readme = (
        "---\n"
        f"base_model: {hub}\n"
        "library_name: peft\n"
        "pipeline_tag: text-generation\n"
        "tags:\n"
        "- lora\n"
        "- peft\n"
        "- affine-h1-salvage\n"
        "---\n\n"
        "# H1 LoRA adapter salvage (not a submission)\n\n"
        f"Base: `{hub}`. Adapter-only TTL insurance for mining H1.\n"
    )
    (tmp / "README.md").write_text(readme)
    return tmp


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--adapter", required=True, type=Path)
    ap.add_argument(
        "--repo",
        default="unconst/Affine-5czsc2fc98-h1-lora",
        help="HF repo id for adapter salvage (private)",
    )
    ap.add_argument("--private", action="store_true", default=True)
    ap.add_argument("--public", action="store_true", help="create/update as public")
    ap.add_argument("--out-meta", type=Path, default=Path("/root/h1/adapter_salvage.json"))
    ap.add_argument(
        "--path-in-repo",
        default=None,
        help="optional HF path prefix (e.g. checkpoint-50/) so mid-ckpts "
        "do not overwrite the final adapter root",
    )
    ap.add_argument(
        "--commit-message",
        default="H1 LoRA adapter salvage (TTL insurance)",
    )
    ap.add_argument(
        "--base-hub",
        default=DEFAULT_BASE_HUB,
        help="Hub id written into adapter_config + README base_model",
    )
    args = ap.parse_args()

    token = os.environ.get("HF_TOKEN")
    if not token:
        print("[salvage] FATAL: HF_TOKEN missing", file=sys.stderr)
        return 2
    if not args.adapter.is_dir():
        print(f"[salvage] FATAL: adapter missing: {args.adapter}", file=sys.stderr)
        return 2

    from huggingface_hub import HfApi

    staged = None
    try:
        staged = _stage_adapter(args.adapter, args.base_hub)
        api = HfApi(token=token)
        private = not args.public
        api.create_repo(args.repo, private=private, exist_ok=True, repo_type="model")
        upload_kwargs = dict(
            folder_path=str(staged),
            repo_id=args.repo,
            repo_type="model",
            commit_message=args.commit_message,
        )
        if args.path_in_repo:
            upload_kwargs["path_in_repo"] = args.path_in_repo.rstrip("/")
        info = api.upload_folder(**upload_kwargs)
        meta = {
            "repo": args.repo,
            "private": private,
            "adapter": str(args.adapter),
            "staged_files": sorted(p.name for p in staged.iterdir()),
            "base_hub": args.base_hub,
            "path_in_repo": args.path_in_repo,
            "commit_sha": getattr(info, "commit_id", None) or str(info),
            "uploaded_utc": datetime.now(timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ"),
            "note": "adapter-only salvage; not a submission revision",
        }
        args.out_meta.parent.mkdir(parents=True, exist_ok=True)
        args.out_meta.write_text(json.dumps(meta, indent=2) + "\n")
        print(json.dumps(meta, indent=2))
        return 0
    finally:
        if staged is not None:
            shutil.rmtree(staged, ignore_errors=True)


if __name__ == "__main__":
    raise SystemExit(main())
