#!/usr/bin/env python3
"""Apply experiments/s4-h1-sft/plan.md decision rule to H1 sim result JSON.

Reads n80 (preferred) and/or n40 from results/, writes h1_decision.json.
Does not submit. Host harvest calls this when artifacts land.
"""
from __future__ import annotations

import argparse
import json
import sys
from datetime import datetime, timezone
from pathlib import Path

# plan.md / GOAL submit gate
SUBMIT_MARGIN = 0.04
# contract min_margin (noise floor) — iterate band sits between these
CONTRACT_MARGIN = 0.02
# H4 design envelope (stricter than contract r∈[0.3,4] / base×≤1.25)
H4_R_LO, H4_R_HI = 0.70, 0.85
H4_BASE_X_MAX = 1.15


def _load(path: Path) -> dict | None:
    if not path.is_file():
        return None
    return json.loads(path.read_text())


def _summarize(raw: dict, source: str) -> dict:
    v = raw.get("verdict") or {}
    h4 = raw.get("h4") or {}
    king = v.get("king") or {}
    chal = v.get("challenger") or {}
    margin = float(v.get("margin") or 0.0)
    r = h4.get("chall_r")
    if r is None:
        r = chal.get("calib_ratio")
    base_x = h4.get("base_x")
    if base_x is None:
        kb = king.get("baseline_abs") or 0.0
        cb = chal.get("baseline_abs") or 0.0
        base_x = (cb / kb) if kb else None
    both_valid = bool(king.get("valid")) and bool(chal.get("valid"))
    h4_ok = (
        r is not None
        and base_x is not None
        and H4_R_LO <= float(r) <= H4_R_HI
        and float(base_x) <= H4_BASE_X_MAX
    )
    if not both_valid:
        action = "reject_gates"
        reason = "one or both sides gate-invalid"
    elif margin > SUBMIT_MARGIN and h4_ok:
        action = "toward_submit"
        reason = (
            f"margin {margin:.5f} > {SUBMIT_MARGIN} and H4 envelope OK "
            "(still need submit.py --check + fresh hotkey; prefer n80)"
        )
    elif margin > SUBMIT_MARGIN and not h4_ok:
        action = "iterate_h4"
        reason = (
            f"margin {margin:.5f} clears submit gate but H4 envelope fail "
            f"(r={r}, base_x={base_x}); do not burn a slot"
        )
    elif margin >= CONTRACT_MARGIN:
        action = "iterate"
        reason = (
            f"margin {margin:.5f} in [{CONTRACT_MARGIN}, {SUBMIT_MARGIN}]; "
            "more refs/lr/steps; do not submit"
        )
    else:
        action = "revise_recipe"
        reason = (
            f"margin {margin:.5f} < {CONTRACT_MARGIN}; "
            "revise recipe or try H5 warm-start; do not burn a slot"
        )
    return {
        "source": source,
        "n_paired_turns": v.get("n_paired_turns"),
        "margin": margin,
        "se": v.get("se"),
        "z": v.get("z"),
        "challenger_wins": v.get("challenger_wins"),
        "king_S": king.get("S"),
        "chall_S": chal.get("S"),
        "king_valid": king.get("valid"),
        "chall_valid": chal.get("valid"),
        "chall_r": r,
        "base_x": base_x,
        "h4_ok": h4_ok,
        "action": action,
        "reason": reason,
        "chall_repo": raw.get("chall_repo"),
        "king_repo": raw.get("king_repo"),
    }


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument(
        "--results-dir",
        type=Path,
        default=Path(__file__).resolve().parent / "results",
    )
    ap.add_argument(
        "--out",
        type=Path,
        default=None,
        help="default: <results-dir>/h1_decision.json",
    )
    args = ap.parse_args()
    out = args.out or (args.results_dir / "h1_decision.json")

    n80 = _load(args.results_dir / "h1_sim_result.json")
    n40 = _load(args.results_dir / "h1_sim_result_n40.json")
    if n80 is None and n40 is None:
        print("[triage] no sim results yet", file=sys.stderr)
        return 1

    primary_src = "n80" if n80 is not None else "n40"
    primary_raw = n80 if n80 is not None else n40
    assert primary_raw is not None
    primary = _summarize(primary_raw, primary_src)

    # If only n40, never allow toward_submit — plan.md wants n80 confirm.
    if primary_src == "n40" and primary["action"] == "toward_submit":
        primary["action"] = "confirm_n80"
        primary["reason"] = (
            f"n40 margin {primary['margin']:.5f} looks crown-ward + H4 OK; "
            "confirm on n80 before any submit"
        )

    decision = {
        "utc": datetime.now(timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ"),
        "rule": {
            "submit_margin": SUBMIT_MARGIN,
            "contract_margin": CONTRACT_MARGIN,
            "h4_r": [H4_R_LO, H4_R_HI],
            "h4_base_x_max": H4_BASE_X_MAX,
            "prefer": "n80",
        },
        "primary": primary,
        "n40": _summarize(n40, "n40") if n40 is not None else None,
        "n80": _summarize(n80, "n80") if n80 is not None else None,
        "submit": primary["action"] == "toward_submit",
    }
    out.parent.mkdir(parents=True, exist_ok=True)
    out.write_text(json.dumps(decision, indent=2) + "\n")
    print(json.dumps(decision, indent=2))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
