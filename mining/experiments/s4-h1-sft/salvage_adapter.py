#!/usr/bin/env python3
"""Upload the H1 LoRA adapter (small) to HF so a TTL kill cannot erase train.

Not a submission candidate — adapter-only salvage. Full merged weights stay
on the pod until sim clears the Stage-5 gate.
"""
from __future__ import annotations

import argparse
import json
import os
import sys
from datetime import datetime, timezone
from pathlib import Path


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
    args = ap.parse_args()

    token = os.environ.get("HF_TOKEN")
    if not token:
        print("[salvage] FATAL: HF_TOKEN missing", file=sys.stderr)
        return 2
    if not args.adapter.is_dir():
        print(f"[salvage] FATAL: adapter missing: {args.adapter}", file=sys.stderr)
        return 2

    from huggingface_hub import HfApi

    api = HfApi(token=token)
    private = not args.public
    api.create_repo(args.repo, private=private, exist_ok=True, repo_type="model")
    info = api.upload_folder(
        folder_path=str(args.adapter),
        repo_id=args.repo,
        repo_type="model",
        commit_message="H1 LoRA adapter salvage (TTL insurance)",
    )
    meta = {
        "repo": args.repo,
        "private": private,
        "adapter": str(args.adapter),
        "commit_sha": getattr(info, "commit_id", None) or str(info),
        "uploaded_utc": datetime.now(timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ"),
        "note": "adapter-only salvage; not a submission revision",
    }
    args.out_meta.parent.mkdir(parents=True, exist_ok=True)
    args.out_meta.write_text(json.dumps(meta, indent=2) + "\n")
    print(json.dumps(meta, indent=2))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
