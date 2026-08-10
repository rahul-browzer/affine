#!/usr/bin/env python3
"""Patch mining_src vllm_client HTTP timeout for 65536-ctx crown sims.

Idempotent. Does not touch the validator tree — only /root/mining_src.
"""
from __future__ import annotations

from pathlib import Path

TARGET = Path("/root/mining_src/affine_pkg/evalsrv/vllm_client.py")

OLD = """        # Keep per-request timeout well under vLLM hang windows. 180s covers
        # echo+logprobs on 32k ctx with prompt_logprobs; retries absorb
        # transient engine stalls without wedging the whole asyncio gather.
        timeout = httpx.Timeout(180.0, connect=10.0)
        async with self.sem:
            for attempt in range(3):"""

NEW = """        # Crown sim @ max_model_len=65536: teacher sample+force can exceed 180s
        # under 80-way gather. 600s + 5 attempts absorbs slow GLM rollouts.
        timeout = httpx.Timeout(600.0, connect=30.0)
        async with self.sem:
            for attempt in range(5):"""


def main() -> None:
    text = TARGET.read_text()
    if "Timeout(600.0" in text and "range(5)" in text:
        print(f"already patched {TARGET}")
        return
    if OLD not in text:
        raise SystemExit(f"patch site not found in {TARGET}")
    TARGET.write_text(text.replace(OLD, NEW, 1))
    print(f"patched {TARGET}")


if __name__ == "__main__":
    main()
