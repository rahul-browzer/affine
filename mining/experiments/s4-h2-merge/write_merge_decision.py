#!/usr/bin/env python3
"""Write h{N}_decision.json from run_sim_duel.py output.

run_sim_duel nests margin/z under verdict and valid/S under verdict.challenger;
flat d.get("margin") is always None and would false-REFUTE winners.
"""
from __future__ import annotations

import argparse
import json
from datetime import datetime, timezone
from pathlib import Path


def extract(d: dict) -> dict:
    v = d.get("verdict") or {}
    chal = v.get("challenger") or {}
    king = v.get("king") or {}
    h4 = d.get("h4") or {}
    margin = v.get("margin", d.get("margin"))
    z = v.get("z", d.get("z"))
    r = d.get("r_c")
    if r is None:
        r = h4.get("chall_r")
    if r is None:
        r = chal.get("calib_ratio")
    valid = d.get("valid_c")
    if valid is None:
        valid = chal.get("valid")
    return {
        "margin": margin,
        "z": z,
        "r_c": r,
        "valid_c": valid,
        "S_c": d.get("S_c") or chal.get("S"),
        "S_k": d.get("S_k") or king.get("S"),
        "se": v.get("se"),
        "base_x": h4.get("base_x"),
    }


def decide(hyp: str, margin, valid, *, signal_only: bool) -> str:
    tag = hyp.upper().replace("-", "_")
    if margin is not None and margin > 0.04 and valid:
        return "SIGNAL_STRONG" if signal_only else "ADVANCE_STAGE5"
    if margin is not None and margin >= 0.02:
        return "SIGNAL_WEAK" if signal_only else "TRY_ALPHA_085"
    return f"SIGNAL_NEG" if signal_only else f"REFUTE_{tag}"


def main() -> None:
    ap = argparse.ArgumentParser()
    ap.add_argument("--hyp", required=True, help="h6 / h6_mid50 / h7 / h8 / h9 / h10")
    ap.add_argument("--sim-result", required=True)
    ap.add_argument("--out", required=True)
    ap.add_argument(
        "--signal-only",
        action="store_true",
        help="mid-ckpt n40: emit SIGNAL_* (do not tear down pod)",
    )
    args = ap.parse_args()
    d = json.loads(Path(args.sim_result).read_text())
    fields = extract(d)
    signal_only = args.signal_only or args.hyp.endswith("mid50")
    dec = {
        "utc": datetime.now(timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ"),
        **fields,
        "decision": decide(
            args.hyp, fields["margin"], fields["valid_c"], signal_only=signal_only
        ),
        "parser": "write_merge_decision.py#nested_verdict",
        "signal_only": signal_only,
        "submit": False
        if signal_only
        else (
            fields["margin"] is not None
            and fields["margin"] > 0.04
            and bool(fields["valid_c"])
        ),
    }
    if signal_only:
        dec["note"] = "mid50 early signal only; final n80 is authoritative"
    out = Path(args.out)
    out.parent.mkdir(parents=True, exist_ok=True)
    out.write_text(json.dumps(dec, indent=2) + "\n")
    print(json.dumps(dec, indent=2))


if __name__ == "__main__":
    main()
