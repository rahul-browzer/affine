#!/usr/bin/env python3
"""Upload the H1 merged full checkpoint to HF (TTL / deadman insurance).

Runs on the pod after merge. Not a submission revision by itself — Stage-5
still requires sim margin > 0.04 + H4 + submit.py --check. Private by default.

Uploads from the pod only (never stage weights on the validator host).
"""
from __future__ import annotations

import argparse
import json
import os
import sys
from datetime import datetime, timezone
from pathlib import Path

DEFAULT_REPO = "unconst/Affine-5czsc2fc98-h1-merged"
DEFAULT_BASE_HUB = "kevin954/Affine-5dfqbbh8ev-sft"


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--merged", type=Path, required=True)
    ap.add_argument("--repo", default=DEFAULT_REPO)
    ap.add_argument("--public", action="store_true")
    ap.add_argument(
        "--out-meta",
        type=Path,
        default=Path("/root/affine_data/h1_merged_salvage.json"),
    )
    ap.add_argument(
        "--commit-message",
        default="H1 merged checkpoint salvage (TTL insurance; not a submission)",
    )
    ap.add_argument("--base-hub", default=DEFAULT_BASE_HUB)
    args = ap.parse_args()

    token = os.environ.get("HF_TOKEN")
    if not token:
        print("[push-merged] FATAL: HF_TOKEN missing", file=sys.stderr)
        return 2
    if not args.merged.is_dir():
        print(f"[push-merged] FATAL: merged dir missing: {args.merged}", file=sys.stderr)
        return 2
    # Serve hygiene: refuse if any .py slipped in.
    py = list(args.merged.rglob("*.py"))
    if py:
        print(f"[push-merged] FATAL: *.py present: {py[:5]}", file=sys.stderr)
        return 2
    cfg_path = args.merged / "config.json"
    if not cfg_path.is_file():
        print("[push-merged] FATAL: config.json missing", file=sys.stderr)
        return 2
    cfg = json.loads(cfg_path.read_text())
    if "auto_map" in cfg:
        print("[push-merged] FATAL: auto_map in config.json", file=sys.stderr)
        return 2
    # Rough size gate: must look like a full 35B, not an empty stub.
    shards = list(args.merged.glob("*.safetensors"))
    if not shards:
        print("[push-merged] FATAL: no *.safetensors shards", file=sys.stderr)
        return 2
    total = sum(p.stat().st_size for p in shards)
    if total < 20 * (1 << 30):
        print(
            f"[push-merged] FATAL: merged too small ({total} bytes) — abort",
            file=sys.stderr,
        )
        return 2

    # Ensure README names the base (HF card hygiene); do not invent a new one
    # if merge already wrote one.
    readme = args.merged / "README.md"
    if not readme.is_file():
        readme.write_text(
            "---\n"
            f"base_model: {args.base_hub}\n"
            "library_name: transformers\n"
            "pipeline_tag: text-generation\n"
            "tags:\n"
            "- affine-h1-merged-salvage\n"
            "---\n\n"
            "# H1 merged checkpoint salvage\n\n"
            f"LoRA-merged from `{args.base_hub}`. Private TTL insurance; "
            "not a submission until Stage-5 gate clears.\n"
        )

    from huggingface_hub import HfApi

    api = HfApi(token=token)
    private = not args.public
    api.create_repo(args.repo, private=private, exist_ok=True, repo_type="model")
    print(
        f"[push-merged] uploading {args.merged} ({total / (1 << 30):.1f} GiB) "
        f"→ {args.repo} private={private}",
        flush=True,
    )
    info = api.upload_folder(
        folder_path=str(args.merged),
        repo_id=args.repo,
        repo_type="model",
        commit_message=args.commit_message,
        # allow_patterns keeps optimizer junk out if any land later
        allow_patterns=[
            "*.safetensors",
            "*.json",
            "*.txt",
            "*.model",
            "tokenizer*",
            "vocab*",
            "merges.txt",
            "special_tokens_map.json",
            "chat_template*",
            "README.md",
            "*.jinja",
        ],
        ignore_patterns=["*.py", "*.bin", "optimizer*", "rng*", "scheduler*"],
    )
    meta = {
        "repo": args.repo,
        "private": private,
        "merged": str(args.merged),
        "bytes": total,
        "n_shards": len(shards),
        "base_hub": args.base_hub,
        "commit_sha": getattr(info, "commit_id", None) or str(info),
        "uploaded_utc": datetime.now(timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ"),
        "note": "full merged salvage; NOT a submission until Stage-5 gate",
    }
    args.out_meta.parent.mkdir(parents=True, exist_ok=True)
    args.out_meta.write_text(json.dumps(meta, indent=2) + "\n")
    # Best-effort host harvest mirror (H33: hard fail if /root/h1 missing after upload).
    try:
        mirror = Path("/root/h1/merged_salvage.json")
        mirror.parent.mkdir(parents=True, exist_ok=True)
        mirror.write_text(json.dumps(meta, indent=2) + "\n")
    except OSError as e:
        print(f"[push-merged] WARN mirror /root/h1 skipped: {e}", flush=True)
    print(json.dumps(meta, indent=2), flush=True)
    print("[push-merged] DONE", flush=True)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
