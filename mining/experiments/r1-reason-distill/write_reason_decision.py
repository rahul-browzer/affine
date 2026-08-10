#!/usr/bin/env python3
"""Write r1_decision.json from run_reason_sim.py output (Reason v3 rule).

Submit bar (pre-registered): paired margin > 1.5 × (3·SE) on a fresh slice.
Legacy S* 0.04 gate is not used.
"""
from __future__ import annotations

import argparse
import json
from datetime import datetime, timezone
from pathlib import Path

_FALSE_PROBE_MARKERS = (
    "unpromptable",
    "connecterror",
    "enginedead",
    "probe_sample_failed",
    "probe_force",
    "all connection attempts failed",
)


def extract(d: dict) -> dict:
    v = d.get("verdict") or {}
    r = d.get("reason") or {}
    chal = v.get("challenger") or {}
    king = v.get("king") or {}
    margin = r.get("margin", v.get("margin"))
    se = r.get("se", v.get("se"))
    k_sigma = float(r.get("k_sigma") or v.get("k_sigma") or 3.0)
    thresh = r.get("threshold_3se")
    if thresh is None and se is not None:
        thresh = k_sigma * se
    headroom = r.get("headroom_vs_3se")
    if headroom is None and margin is not None and thresh and thresh > 0:
        headroom = margin / thresh
    return {
        "margin": margin,
        "se": se,
        "z": r.get("z", v.get("z")),
        "k_sigma": k_sigma,
        "threshold_3se": thresh,
        "headroom_vs_3se": headroom,
        "reason_c": r.get("reason_c", chal.get("reason")),
        "reason_k": r.get("reason_k", king.get("reason")),
        "n_paired_turns": r.get("n_paired_turns", v.get("n_paired_turns")),
        "challenger_wins": v.get("challenger_wins"),
    }


def false_probe(d: dict) -> str | None:
    v = d.get("verdict") or {}
    rr = v.get("rejection_reason") or d.get("rejection_reason") or ""
    if not rr:
        return None
    low = str(rr).lower()
    if any(m in low for m in _FALSE_PROBE_MARKERS):
        return str(rr)
    return None


def decide(ex: dict, *, headroom_bar: float, fp: str | None) -> str:
    if fp:
        return "FALSE_PROBE_R1"
    h = ex.get("headroom_vs_3se")
    if h is not None and h >= headroom_bar:
        return "ADVANCE_STAGE5_SUBMIT"
    if ex.get("challenger_wins"):
        return "SIGNAL_CLEARS_3SE_NEED_HEADROOM"
    m = ex.get("margin")
    if m is not None and m > 0:
        return "SIGNAL_POS_BELOW_3SE"
    return "REFUTE_R1_H64_BASELINE"


def main() -> None:
    ap = argparse.ArgumentParser()
    ap.add_argument("--sim-result", required=True)
    ap.add_argument("--out", required=True)
    ap.add_argument(
        "--headroom-bar",
        type=float,
        default=1.5,
        help="require margin >= bar × (3·SE); default 1.5",
    )
    ap.add_argument(
        "--hyp",
        default="R1",
        help="hypothesis id stamped into decision JSON (default R1)",
    )
    args = ap.parse_args()
    d = json.loads(Path(args.sim_result).read_text())
    ex = extract(d)
    fp = false_probe(d)
    decision = decide(ex, headroom_bar=args.headroom_bar, fp=fp)
    out = {
        "utc": datetime.now(timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ"),
        "hyp": args.hyp,
        "contract": "Reason v3",
        "decision": decision,
        "headroom_bar": args.headroom_bar,
        "false_probe": fp,
        **ex,
        "sim_result": str(args.sim_result),
    }
    Path(args.out).write_text(json.dumps(out, indent=2))
    print(json.dumps(out, indent=2))


if __name__ == "__main__":
    main()
