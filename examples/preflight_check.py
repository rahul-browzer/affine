"""Pre-flight a miner submission locally, before spending the one eval slot.

Replays the cheap intake checks against the LIVE contract from /api/v1/contract:
repo naming pattern, coldkey/hotkey identity characters, custom-code
prohibition, size caps, and the config.json constraints that make checkpoints
fail under the validator's vLLM setup (tensor-parallel-2, max-model-len 65536).

Each hotkey gets exactly one submission, ever — run this first.

Usage:
  python examples/preflight_check.py --repo you/Affine-abcde12345-mymodel \
      --hotkey 5F3sa2TJc... [--config path/to/config.json]
"""

import argparse
import json
import re
import sys

import requests

CONTRACT_URL = "https://www.affine.io/api/v1/contract"
TENSOR_PARALLEL = 2
MAX_MODEL_LEN = 65536


def check(label: str, ok: bool, detail: str = "") -> bool:
    print(f"  [{'ok' if ok else 'FAIL'}] {label}" + (f" — {detail}" if detail else ""))
    return ok


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--repo", required=True, help="HF repo, e.g. you/Affine-...")
    parser.add_argument("--hotkey", required=True, help="Hotkey ss58 address")
    parser.add_argument("--coldkey", default=None, help="Coldkey ss58 (optional)")
    parser.add_argument("--config", default=None, help="Path to config.json")
    args = parser.parse_args()

    sub = requests.get(CONTRACT_URL, timeout=30).json()["submission"]
    ok = True

    print("Naming:")
    ok &= check(
        f"repo matches {sub['repo_pattern']}",
        re.match(sub["repo_pattern"], args.repo) is not None,
        args.repo,
    )
    prefix_len, suffix_len = sub["coldkey_prefix_len"], sub["coldkey_suffix_len"]
    repo_lower = args.repo.lower()
    identity_ok = False
    for key in filter(None, (args.coldkey, args.hotkey)):
        head, tail = key[:prefix_len].lower(), key[-suffix_len:].lower()
        if head in repo_lower and tail in repo_lower:
            identity_ok = True
    ok &= check(
        f"repo embeds first {prefix_len} AND last {suffix_len} chars of a key",
        identity_ok,
    )

    if args.config:
        print("Config:")
        cfg = json.load(open(args.config))
        ok &= check(
            "no auto_map (custom code is prohibited)",
            "auto_map" not in cfg,
        )
        heads = cfg.get("num_key_value_heads", cfg.get("num_attention_heads", 0))
        ok &= check(
            f"head count divisible by tensor_parallel={TENSOR_PARALLEL}",
            heads % TENSOR_PARALLEL == 0,
            f"heads={heads}",
        )
        max_pos = cfg.get("max_position_embeddings", 0)
        ok &= check(
            f"context covers {MAX_MODEL_LEN}",
            max_pos >= MAX_MODEL_LEN or cfg.get("rope_scaling") is not None,
            f"max_position_embeddings={max_pos}",
        )

    print(
        "\nCaps enforced at intake: "
        f"weights <= {sub['max_model_size_gb']:g} GB, "
        f"repo <= {sub['max_total_repo_gb']:g} GB, "
        f"<= {sub['max_repo_files']} files, config <= {sub['max_config_bytes']} bytes, "
        f"python files allowed: {sub['allow_python_files']}"
    )
    print("Next: run the official client with --check, then vllm serve locally:")
    print("  python submit.py --repo ... --wallet ... --hotkey ... --check")
    print(
        f"  vllm serve {args.repo} --revision <40hex> "
        f"--max-model-len {MAX_MODEL_LEN} --tensor-parallel-size {TENSOR_PARALLEL}"
    )
    return 0 if ok else 1


if __name__ == "__main__":
    sys.exit(main())
