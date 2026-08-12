#!/usr/bin/env python3
"""Write decision.json from run_reason_sim.py output (Reason v3 rule).

Live contract (2026-08-11): k_sigma=2.0.
Crown: margin > k_sigma · SE.
Submit bar (pre-registered): margin ≥ 1.5 × (k_sigma · SE) on a fresh slice.
Legacy S* 0.04 gate is not used.

Note: field names still include `*_3se` for older readers; values follow live k_sigma
unless the sim stamped a different k. Always also emit `*_live_2se` aliases.
"""
from __future__ import annotations

import argparse
import json
from datetime import datetime, timezone
from pathlib import Path

# Live SN120 contract default (confirm via api/v1/contract every pass).
LIVE_K_SIGMA = 2.0

_FALSE_PROBE_MARKERS = (
    "unpromptable",
    "connecterror",
    "enginedead",
    "probe_sample_failed",
    "probe_force",
    "all connection attempts failed",
)


def extract(d: dict, *, k_sigma: float) -> dict:
    v = d.get("verdict") or {}
    r = d.get("reason") or {}
    chal = v.get("challenger") or {}
    king = v.get("king") or {}
    margin = r.get("margin", v.get("margin"))
    se = r.get("se", v.get("se"))
    # Prefer explicit CLI / live k; ignore stale sim stamps of 3.0 when live is 2.0.
    sim_k = r.get("k_sigma", v.get("k_sigma"))
    if sim_k is not None:
        try:
            sim_k_f = float(sim_k)
            # Trust sim only when it matches live or caller override.
            if abs(sim_k_f - k_sigma) < 1e-9:
                k_sigma = sim_k_f
        except (TypeError, ValueError):
            pass
    thresh = (k_sigma * se) if se is not None else None
    headroom = None
    if margin is not None and thresh and thresh > 0:
        headroom = margin / thresh
    # Legacy alias: "3se" name kept for readers; value is live thresh/headroom.
    clears = bool(
        (v.get("challenger_wins") is True)
        or (margin is not None and thresh is not None and margin > thresh)
    )
    return {
        "margin": margin,
        "se": se,
        "z": r.get("z", v.get("z")),
        "k_sigma": k_sigma,
        "threshold_3se": thresh,
        "headroom_vs_3se": headroom,
        "k_sigma_live": k_sigma,
        "threshold_live_2se": thresh,
        "headroom_vs_live_2se": headroom,
        "submit_bar_1p5x_2se": (1.5 * thresh) if thresh is not None else None,
        "reason_c": r.get("reason_c", chal.get("reason")),
        "reason_k": r.get("reason_k", king.get("reason")),
        "n_paired_turns": r.get("n_paired_turns", v.get("n_paired_turns")),
        "challenger_wins": clears,
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
        return "FALSE_PROBE"
    h = ex.get("headroom_vs_live_2se")
    if h is None:
        h = ex.get("headroom_vs_3se")
    if h is not None and h >= headroom_bar:
        return "ADVANCE_STAGE5_SUBMIT"
    if ex.get("challenger_wins"):
        return "SIGNAL_CLEARS_KSIGMA_NEED_HEADROOM"
    m = ex.get("margin")
    if m is not None and m > 0:
        return "SIGNAL_POS_BELOW_KSIGMA"
    return "REFUTE"


def main() -> None:
    ap = argparse.ArgumentParser()
    ap.add_argument("--sim-result", required=True)
    ap.add_argument("--out", required=True)
    ap.add_argument(
        "--headroom-bar",
        type=float,
        default=1.5,
        help="require margin >= bar × (k_sigma·SE); default 1.5",
    )
    ap.add_argument(
        "--k-sigma",
        type=float,
        default=LIVE_K_SIGMA,
        help=f"live crown k_sigma (default {LIVE_K_SIGMA})",
    )
    ap.add_argument(
        "--hyp",
        default="R1",
        help="hypothesis id stamped into decision JSON (default R1)",
    )
    args = ap.parse_args()
    d = json.loads(Path(args.sim_result).read_text())
    ex = extract(d, k_sigma=float(args.k_sigma))
    fp = false_probe(d)
    decision = decide(ex, headroom_bar=args.headroom_bar, fp=fp)
    # Keep hyp id in decision string for grep-friendly REFUTE_<hyp>.
    if decision == "REFUTE":
        decision = f"REFUTE_{args.hyp}"
    elif decision == "FALSE_PROBE":
        decision = f"FALSE_PROBE_{args.hyp}"
    out = {
        "utc": datetime.now(timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ"),
        "hyp": args.hyp,
        "contract": "Reason v3",
        "decision": decision,
        "decision_live_k2": decision,
        "headroom_bar": args.headroom_bar,
        "false_probe": fp,
        **ex,
        "sim_result": str(args.sim_result),
    }
    Path(args.out).write_text(json.dumps(out, indent=2) + "\n")
    print(json.dumps(out, indent=2))


if __name__ == "__main__":
    main()
