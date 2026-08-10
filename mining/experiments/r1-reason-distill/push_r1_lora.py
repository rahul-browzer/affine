#!/usr/bin/env python3
"""Upload R1 LoRA-merged challenger to HF while n80 sim runs.

Prefer --public: unconst private storage is ~65GiB and one merged king fills it.
Not a submission — Stage-5 still needs Reason headroom ≥ 1.5×(3·SE), fresh
hotkey, and submit.py --check. Runs on the crown pod.
"""
from __future__ import annotations

import argparse
import json
import os
import sys
from datetime import datetime, timezone
from pathlib import Path

DEFAULT_REPO = "unconst/Affine-5czsc2fc98-r1lora"
DEFAULT_BASE_HUB = "Tok331102/affine-5EqYW8McUc-af10"


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--merged", type=Path, required=True)
    ap.add_argument("--repo", default=DEFAULT_REPO)
    ap.add_argument("--public", action="store_true")
    ap.add_argument(
        "--out-meta",
        type=Path,
        default=Path("/root/affine_data/r1_lora_hf_push.json"),
    )
    ap.add_argument(
        "--commit-message",
        default="R1 LoRA-merged challenger (pre-submit; Reason v3)",
    )
    ap.add_argument("--base-hub", default=DEFAULT_BASE_HUB)
    args = ap.parse_args()

    token = os.environ.get("HF_TOKEN")
    if not token:
        print("[push-r1] FATAL: HF_TOKEN missing", file=sys.stderr)
        return 2
    if not args.merged.is_dir():
        print(f"[push-r1] FATAL: merged dir missing: {args.merged}", file=sys.stderr)
        return 2
    py = list(args.merged.rglob("*.py"))
    if py:
        print(f"[push-r1] FATAL: *.py present: {py[:5]}", file=sys.stderr)
        return 2
    cfg_path = args.merged / "config.json"
    if not cfg_path.is_file():
        print("[push-r1] FATAL: config.json missing", file=sys.stderr)
        return 2
    cfg = json.loads(cfg_path.read_text())
    if "auto_map" in cfg:
        print("[push-r1] FATAL: auto_map in config.json", file=sys.stderr)
        return 2
    arch = cfg.get("architectures") or []
    if "Qwen3_5MoeForConditionalGeneration" not in arch:
        print(f"[push-r1] FATAL: bad architectures {arch}", file=sys.stderr)
        return 2
    if not (args.merged / "model-visual.safetensors").is_file():
        print("[push-r1] FATAL: model-visual.safetensors missing", file=sys.stderr)
        return 2
    if not (args.merged / "preprocessor_config.json").is_file():
        print("[push-r1] FATAL: preprocessor_config.json missing", file=sys.stderr)
        return 2

    shards = list(args.merged.glob("*.safetensors"))
    if not shards:
        print("[push-r1] FATAL: no *.safetensors shards", file=sys.stderr)
        return 2
    total = sum(p.stat().st_size for p in shards)
    if total < 20 * (1 << 30):
        print(
            f"[push-r1] FATAL: merged too small ({total} bytes) — abort",
            file=sys.stderr,
        )
        return 2

    readme = args.merged / "README.md"
    if not readme.is_file():
        readme.write_text(
            "---\n"
            f"base_model: {args.base_hub}\n"
            "library_name: transformers\n"
            "pipeline_tag: text-generation\n"
            "tags:\n"
            "- affine-r1-lora\n"
            "- reason-v3\n"
            "---\n\n"
            "# R1 LoRA-merged challenger (Reason v3)\n\n"
            f"LoRA-merged from `{args.base_hub}` on high-Reason thought "
            "targets. Private pre-submit artifact; not crowned until a live "
            "duel verdict.\n"
        )

    from huggingface_hub import HfApi

    api = HfApi(token=token)
    private = not args.public
    api.create_repo(args.repo, private=private, exist_ok=True, repo_type="model")
    print(
        f"[push-r1] uploading {args.merged} ({total / (1 << 30):.1f} GiB) "
        f"→ {args.repo} private={private}",
        flush=True,
    )
    info = api.upload_folder(
        folder_path=str(args.merged),
        repo_id=args.repo,
        repo_type="model",
        commit_message=args.commit_message,
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
        ignore_patterns=[
            "*.py",
            "*.bin",
            "optimizer*",
            "rng*",
            "scheduler*",
            "config.json.bak*",
            "*_result.json",
        ],
    )
    meta = {
        "repo": args.repo,
        "private": private,
        "merged": str(args.merged),
        "bytes": total,
        "n_shards": len(shards),
        "base_hub": args.base_hub,
        "architectures": arch,
        "commit_sha": getattr(info, "commit_id", None) or str(info),
        "uploaded_utc": datetime.now(timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ"),
        "note": "pre-submit R1 LoRA push; NOT a submission until Stage-5 gate",
    }
    args.out_meta.parent.mkdir(parents=True, exist_ok=True)
    args.out_meta.write_text(json.dumps(meta, indent=2) + "\n")
    print(json.dumps(meta, indent=2), flush=True)
    print("[push-r1] DONE", flush=True)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
