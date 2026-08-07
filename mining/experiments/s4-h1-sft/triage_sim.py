#!/usr/bin/env python3
"""Apply experiments/s4-h1-sft/plan.md decision rule to H1 sim result JSON.

Reads n80 (preferred) and/or n40 from results/, writes h1_decision.json.
Does not submit. Host harvest calls this when artifacts land.

Also fetches the live king from affine.io/api/v1/snapshot. A margin measured
against a deposed king must not become toward_submit (chal-00274 H6 and later
challengers can crown while our n40/n80 is still running).
"""
from __future__ import annotations

import argparse
import json
import sys
import urllib.error
import urllib.request
from datetime import datetime, timezone
from pathlib import Path

# plan.md / GOAL submit gate
SUBMIT_MARGIN = 0.04
# contract min_margin (noise floor) — iterate band sits between these
CONTRACT_MARGIN = 0.02
# H4 design envelope (stricter than contract r∈[0.3,4] / base×≤1.25)
H4_R_LO, H4_R_HI = 0.70, 0.85
H4_BASE_X_MAX = 1.15
SNAPSHOT_URL = "https://affine.io/api/v1/snapshot"
# Actions that would burn money / a slot if the sim king is stale.
CROWNWARD = frozenset({"toward_submit", "confirm_n80"})


def _load(path: Path) -> dict | None:
    if not path.is_file():
        return None
    return json.loads(path.read_text())


def _fetch_live_king(timeout: float = 10.0) -> dict | None:
    """Return {repo, revision, score, challenge_id?} or None on fetch failure."""
    try:
        req = urllib.request.Request(
            SNAPSHOT_URL,
            headers={"User-Agent": "affine-mining-h1-triage/1.0"},
        )
        with urllib.request.urlopen(req, timeout=timeout) as resp:
            d = json.loads(resp.read().decode())
    except (urllib.error.URLError, TimeoutError, json.JSONDecodeError, OSError) as e:
        return {"error": str(e)}
    king = d.get("king") or {}
    ce = d.get("current_eval") or {}
    return {
        "repo": king.get("repo"),
        "revision": king.get("revision"),
        "score": king.get("score"),
        "reign_number": king.get("reign_number"),
        "current_eval_id": ce.get("challenge_id"),
        "current_eval_repo": ce.get("repo"),
        "current_eval_stage": ce.get("stage"),
        "current_eval_progress": ce.get("progress"),
        "snapshot_generated_at": d.get("generated_at"),
    }


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
        "king_rev": raw.get("king_rev"),
    }


def _apply_live_king_guard(primary: dict, primary_raw: dict, live: dict | None) -> dict:
    """Downgrade crownward actions if the sim king is no longer live."""
    guard = {
        "checked": False,
        "match": None,
        "live": live,
        "sim_king_repo": primary_raw.get("king_repo"),
        "sim_king_rev": primary_raw.get("king_rev"),
    }
    if live is None or live.get("error") or not live.get("repo"):
        guard["note"] = "live king fetch failed or empty; human must re-check snapshot"
        # Fail closed on crownward: never set submit=true without a verified king.
        if primary["action"] in CROWNWARD:
            old = primary["action"]
            primary["action"] = "confirm_live_king"
            primary["reason"] = (
                f"{old} blocked: could not verify live king "
                f"({live.get('error') if live else 'no fetch'}). "
                f"Re-check https://affine.io/api/v1/snapshot before any submit "
                f"(margin was {primary['margin']:.5f})"
            )
            guard["downgraded_from"] = old
        return guard
    guard["checked"] = True
    sim_repo = (primary_raw.get("king_repo") or "").strip()
    sim_rev = (primary_raw.get("king_rev") or "").strip()
    live_repo = (live.get("repo") or "").strip()
    live_rev = (live.get("revision") or "").strip()
    repo_ok = bool(sim_repo) and sim_repo == live_repo
    # Rev: if sim recorded a rev, it must match. Missing sim rev → repo-only.
    rev_ok = (not sim_rev) or (sim_rev == live_rev)
    match = repo_ok and rev_ok
    guard["match"] = match
    if match:
        guard["note"] = "sim king matches live king"
        return guard
    guard["note"] = (
        f"sim king {sim_repo}@{sim_rev or '?'} != live {live_repo}@{live_rev or '?'}"
    )
    if primary["action"] in CROWNWARD:
        old = primary["action"]
        primary["action"] = "re_sim_new_king"
        primary["reason"] = (
            f"{old} blocked: {guard['note']}. Re-serve live king and re-run "
            f"n80; do not submit on a deposed-king margin "
            f"(margin was {primary['margin']:.5f})"
        )
        guard["downgraded_from"] = old
    return guard


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
    ap.add_argument(
        "--skip-live-king",
        action="store_true",
        help="do not fetch snapshot (offline / tests only)",
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

    live = None if args.skip_live_king else _fetch_live_king()
    king_guard = _apply_live_king_guard(primary, primary_raw, live)

    decision = {
        "utc": datetime.now(timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ"),
        "rule": {
            "submit_margin": SUBMIT_MARGIN,
            "contract_margin": CONTRACT_MARGIN,
            "h4_r": [H4_R_LO, H4_R_HI],
            "h4_base_x_max": H4_BASE_X_MAX,
            "prefer": "n80",
            "live_king_guard": True,
        },
        "primary": primary,
        "n40": _summarize(n40, "n40") if n40 is not None else None,
        "n80": _summarize(n80, "n80") if n80 is not None else None,
        "live_king_guard": king_guard,
        "submit": primary["action"] == "toward_submit",
    }
    out.parent.mkdir(parents=True, exist_ok=True)
    out.write_text(json.dumps(decision, indent=2) + "\n")
    print(json.dumps(decision, indent=2))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
