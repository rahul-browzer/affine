#!/usr/bin/env python3
"""CPU-only check: every row has a bash fence cut; report thought/action sizes.

Does not load model weights. Safe to run on the validator host.
"""
from __future__ import annotations

import argparse
import json
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
from thought_mask import thought_cut_char


def main() -> None:
    ap = argparse.ArgumentParser()
    ap.add_argument("--data", type=Path, required=True)
    ap.add_argument("--out", type=Path, default=None)
    args = ap.parse_args()

    n = 0
    ok = 0
    missing = 0
    thought_chars: list[int] = []
    action_chars: list[int] = []
    samples = []
    for line in args.data.open():
        if not line.strip():
            continue
        r = json.loads(line)
        n += 1
        c = r["completion"]
        cut = thought_cut_char(c)
        if cut is None:
            missing += 1
            print(f"NO_FENCE turn_id={r.get('turn_id')}", flush=True)
            continue
        ok += 1
        th = c[:cut]
        thought_chars.append(len(th))
        action_chars.append(len(c) - cut)
        if ok <= 3:
            samples.append(
                {
                    "turn_id": r.get("turn_id"),
                    "cut": cut,
                    "thought_chars": len(th),
                    "action_chars": len(c) - cut,
                    "thought_tail": th[-80:],
                    "action_head": c[cut : cut + 40],
                }
            )

    summary = {
        "n": n,
        "thought_ok": ok,
        "no_fence": missing,
        "thought_chars_mean": (sum(thought_chars) / len(thought_chars))
        if thought_chars
        else None,
        "action_chars_mean": (sum(action_chars) / len(action_chars))
        if action_chars
        else None,
        "thought_chars_min": min(thought_chars) if thought_chars else None,
        "thought_chars_max": max(thought_chars) if thought_chars else None,
        "samples": samples,
        "pass": missing == 0 and ok >= 1,
    }
    print(json.dumps(summary, indent=2))
    if args.out:
        args.out.parent.mkdir(parents=True, exist_ok=True)
        args.out.write_text(json.dumps(summary, indent=2) + "\n")
    if not summary["pass"]:
        raise SystemExit(1)


if __name__ == "__main__":
    main()
