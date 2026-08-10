#!/usr/bin/env python3
"""Probe thought-only supervised token counts under the R1 trainer mask."""
from __future__ import annotations

import argparse
import json
import statistics
import sys
from pathlib import Path

from transformers import AutoTokenizer

sys.path.insert(0, str(Path(__file__).resolve().parent))
from thought_mask import thought_cut_char  # noqa: E402

THINK_OPEN = "<think>"


def msg_chars(row: dict) -> int:
    return sum(len(m.get("content") or "") for m in row.get("messages") or [])


def main() -> None:
    ap = argparse.ArgumentParser()
    ap.add_argument("--base", required=True)
    ap.add_argument("--data", type=Path, required=True)
    ap.add_argument("--max-len", type=int, default=16384)
    ap.add_argument("--limit", type=int, default=0, help="0 = all kept rows")
    args = ap.parse_args()

    # Line-iterate (not str.splitlines): JSON strings may contain U+2028/U+2029.
    rows: list[dict] = []
    with args.data.open() as f:
        for line in f:
            if line.strip():
                rows.append(json.loads(line))
    budget = int(args.max_len * 2.5)
    kept = [r for r in rows if msg_chars(r) <= budget]
    kept.sort(key=msg_chars)
    if args.limit:
        kept = kept[: args.limit]
    print(
        f"kept={len(kept)}/{len(rows)} budget_chars={budget} "
        f"row0_msg={msg_chars(kept[0]) if kept else 'n/a'}",
        flush=True,
    )

    tok = AutoTokenizer.from_pretrained(args.base, trust_remote_code=True)
    sup: list[int] = []
    reasons: list[float] = []
    for i, r in enumerate(kept):
        prompt = tok.apply_chat_template(
            r["messages"], tokenize=False, add_generation_prompt=True
        )
        if not prompt.rstrip().endswith(THINK_OPEN):
            prompt = prompt + THINK_OPEN
        completion = r["completion"]
        full = prompt + completion
        enc = tok(
            full,
            add_special_tokens=False,
            truncation=True,
            max_length=args.max_len,
            return_offsets_mapping=True,
        )
        labels = list(enc["input_ids"])
        prompt_end = len(prompt)
        offsets = enc["offset_mapping"]
        for j, (a, b) in enumerate(offsets):
            if b <= prompt_end:
                labels[j] = -100
        cut = thought_cut_char(completion)
        if cut is None:
            nsup = 0
        else:
            action_start = prompt_end + cut
            for j, (a, b) in enumerate(offsets):
                if labels[j] == -100:
                    continue
                if a >= action_start:
                    labels[j] = -100
            nsup = sum(1 for x in labels if x != -100)
        sup.append(nsup)
        reasons.append(float(r.get("reason") or 0.0))
        if i < 8 or nsup < 20:
            print(
                f"i={i} msg={msg_chars(r)} comple={len(completion)} cut={cut} "
                f"n_tok={len(labels)} nsup={nsup} reason={r.get('reason')}",
                flush=True,
            )

    print(
        f"nsup med/mean/min/max = {statistics.median(sup)} / "
        f"{round(statistics.mean(sup), 1)} / {min(sup)} / {max(sup)}",
        flush=True,
    )
    print(
        f"nsup<20={sum(1 for x in sup if x < 20)} "
        f"nsup<50={sum(1 for x in sup if x < 50)} "
        f"nsup>=100={sum(1 for x in sup if x >= 100)} "
        f"nsup>=200={sum(1 for x in sup if x >= 200)} of {len(sup)}",
        flush=True,
    )
    top = sorted(zip(reasons, sup), key=lambda x: -x[0])[:10]
    print("top10_reason_nsup", top, flush=True)
    # rows with usable signal
    usable = [(rs, ns) for rs, ns in zip(reasons, sup) if ns >= 100]
    print(
        f"usable_nsup>=100={len(usable)} "
        f"reason_med={statistics.median([u[0] for u in usable]) if usable else None}",
        flush=True,
    )


if __name__ == "__main__":
    main()
