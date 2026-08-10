#!/usr/bin/env python3
"""Filter SFT rows by thought-only supervised token count (R1c prep).

R1/R1b train on fit-filter by message chars, but thought-loss nsup is tiny
for most rows (R1b probe @16384: med=54, only 176/1006 with nsup>=100).
Keep rows with enough thought tokens under the trainer mask.
"""
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


def nsup_thought(tok, row: dict, max_len: int) -> int:
    prompt = tok.apply_chat_template(
        row["messages"], tokenize=False, add_generation_prompt=True
    )
    if not prompt.rstrip().endswith(THINK_OPEN):
        prompt = prompt + THINK_OPEN
    completion = row["completion"]
    full = prompt + completion
    enc = tok(
        full,
        add_special_tokens=False,
        truncation=True,
        max_length=max_len,
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
        return 0
    action_start = prompt_end + cut
    for j, (a, b) in enumerate(offsets):
        if labels[j] == -100:
            continue
        if a >= action_start:
            labels[j] = -100
    return sum(1 for x in labels if x != -100)


def main() -> None:
    ap = argparse.ArgumentParser()
    ap.add_argument("--base", required=True)
    ap.add_argument("--data", type=Path, required=True)
    ap.add_argument("--out", type=Path, required=True)
    ap.add_argument("--max-len", type=int, default=16384)
    ap.add_argument("--min-nsup", type=int, default=100)
    ap.add_argument("--min-reason", type=float, default=0.0)
    ap.add_argument("--meta", type=Path, default=None)
    args = ap.parse_args()

    rows: list[dict] = []
    with args.data.open() as f:
        for line in f:
            if line.strip():
                rows.append(json.loads(line))

    # Same char budget as train_lora fit-filter so truncation does not empty labels.
    budget = int(args.max_len * 2.5)
    candidates = [r for r in rows if msg_chars(r) <= budget]
    print(
        f"[filter] in={len(rows)} budget_kept={len(candidates)} "
        f"max_len={args.max_len} min_nsup={args.min_nsup} min_reason={args.min_reason}",
        flush=True,
    )

    tok = AutoTokenizer.from_pretrained(args.base, trust_remote_code=True)
    kept: list[dict] = []
    nsups: list[int] = []
    for i, r in enumerate(candidates):
        reason = float(r.get("reason") or 0.0)
        if reason < args.min_reason:
            continue
        n = nsup_thought(tok, r, args.max_len)
        if n >= args.min_nsup:
            out = dict(r)
            out["nsup_thought"] = n
            kept.append(out)
            nsups.append(n)
        if (i + 1) % 100 == 0:
            print(f"[filter] scanned={i+1}/{len(candidates)} kept={len(kept)}", flush=True)

    kept.sort(key=lambda r: (-float(r.get("reason") or 0.0), -int(r["nsup_thought"])))
    args.out.parent.mkdir(parents=True, exist_ok=True)
    with args.out.open("w") as f:
        for r in kept:
            f.write(json.dumps(r, ensure_ascii=False) + "\n")

    meta = {
        "source": str(args.data),
        "out": str(args.out),
        "max_len": args.max_len,
        "min_nsup": args.min_nsup,
        "min_reason": args.min_reason,
        "in_rows": len(rows),
        "budget_candidates": len(candidates),
        "kept": len(kept),
        "nsup_med": statistics.median(nsups) if nsups else None,
        "nsup_mean": round(statistics.mean(nsups), 1) if nsups else None,
        "reason_med": (
            statistics.median([float(r.get("reason") or 0) for r in kept]) if kept else None
        ),
    }
    print(json.dumps(meta, indent=2), flush=True)
    if args.meta:
        args.meta.write_text(json.dumps(meta, indent=2) + "\n")
    print(f"[filter] wrote {args.out} n={len(kept)}", flush=True)


if __name__ == "__main__":
    main()
