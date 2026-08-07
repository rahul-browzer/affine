#!/usr/bin/env python3
"""H5c: TalentPigs crown vs near-miss autopsy (current knobs). No GPU."""
from __future__ import annotations

import gzip
import json
import math
import re
import statistics as st
import sys
from pathlib import Path

sys.path.insert(0, "/home/const/subnet120")
from affine.affine.score import (  # noqa: E402
    DEFAULT_BASELINE_BAND,
    DEFAULT_L1_CLIP,
    DEFAULT_L1_WEIGHT,
    DEFAULT_MIN_MARGIN,
    DEFAULT_MIN_SE,
    DEFAULT_R_HI,
    DEFAULT_R_LO,
    clipped_l1_lift,
    duel,
    gate_pass,
    l1_lift,
    lambda2,
    rank_term,
    score_miner,
)

CLIP = DEFAULT_L1_CLIP
W = DEFAULT_L1_WEIGHT
HERE = Path(__file__).resolve().parent
RES = HERE / "results"


def mean_bank(rows: list[dict]) -> float:
    vals = [r["bank_frac"] for r in rows if r.get("valid") and "bank_frac" in r]
    return st.mean(vals) if vals else 0.0


def pair_stats(rows: list[dict]) -> dict:
    pairs = [p for r in rows if r.get("valid") and "pairs" in r for p in r["pairs"]]
    if not pairs:
        return {}
    l2 = [lambda2(p) for p in pairs]
    raw = [l1_lift(p) for p in pairs]
    cl = [clipped_l1_lift(p, CLIP) for p in pairs]
    rt = [rank_term(p, W, CLIP) for p in pairs]
    za_len = [len(p.get("z_a") or "") for p in pairs]
    ya_len = [len(p.get("y_a") or "") for p in pairs]
    return {
        "n_pairs": len(pairs),
        "mean_lambda2": st.mean(l2),
        "mean_raw_l1": st.mean(raw),
        "mean_clip_l1": st.mean(cl),
        "mean_mix": st.mean(rt),
        "frac_l1_at_clip_hi": sum(1 for x in raw if x >= CLIP) / len(pairs),
        "frac_l1_at_clip_lo": sum(1 for x in raw if x <= -CLIP) / len(pairs),
        "mean_za_chars": st.mean(za_len),
        "median_za_chars": st.median(za_len),
        "p90_za_chars": sorted(za_len)[int(0.9 * (len(za_len) - 1))],
        "mean_ya_chars": st.mean(ya_len),
        "gate_pass_rate": st.mean(1.0 if gate_pass(p) else 0.0 for p in pairs),
    }


def thought_style(rows: list[dict]) -> dict:
    zs = []
    for r in rows:
        if not r.get("valid") or not r.get("pairs"):
            continue
        zs.append(r["pairs"][0].get("z_a") or "")
    if not zs:
        return {}
    n = len(zs)
    return {
        "n_turns_sampled": n,
        "frac_fence_in_z": sum(1 for z in zs if "```" in z) / n,
        "frac_bash_fence_in_z": sum(1 for z in zs if "```bash" in z or "```sh" in z) / n,
        "frac_za_lt_200": sum(1 for z in zs if len(z) < 200) / n,
        "frac_za_gt_1500": sum(1 for z in zs if len(z) > 1500) / n,
        "mean_newlines": st.mean(z.count("\n") for z in zs),
        "mean_list_markers": st.mean(
            len(re.findall(r"(?m)^\s*(\d+\.|- |\* )", z)) for z in zs
        ),
    }


def analyze(path: Path) -> dict:
    d = json.load(gzip.open(path, "rt"))
    req = d.get("request") or {}
    ver = d.get("verdict") or {}
    c_rows, k_rows = d["challenger_rows"], d["king_rows"]
    c_bank, k_bank = mean_bank(c_rows), mean_bank(k_rows)
    cs = score_miner(c_rows, bank_frac=c_bank, r_lo=DEFAULT_R_LO, r_hi=DEFAULT_R_HI)
    ks = score_miner(k_rows, bank_frac=k_bank, r_lo=DEFAULT_R_LO, r_hi=DEFAULT_R_HI)
    base_ratio = None
    if cs.baseline_abs and ks.baseline_abs and ks.baseline_abs > 0:
        base_ratio = cs.baseline_abs / ks.baseline_abs
        if base_ratio > DEFAULT_BASELINE_BAND:
            cs.valid = False
            cs.S = float("-inf")
    dr = duel(
        c_rows,
        k_rows,
        challenger_bank_frac=c_bank,
        king_bank_frac=k_bank,
        r_lo=DEFAULT_R_LO,
        r_hi=DEFAULT_R_HI,
        min_margin=DEFAULT_MIN_MARGIN,
        min_se=DEFAULT_MIN_SE,
        baseline_band=DEFAULT_BASELINE_BAND,
    )
    c_by = {r["turn_id"]: r for r in c_rows if r.get("valid") and "pairs" in r}
    k_by = {r["turn_id"]: r for r in k_rows if r.get("valid") and "pairs" in r}
    d_l2, d_cl1, d_mix = [], [], []
    for tid in sorted(set(c_by) & set(k_by)):

        def mterm(row, fn):
            return st.mean(fn(p) for p in row["pairs"])

        d_l2.append(mterm(c_by[tid], lambda2) - mterm(k_by[tid], lambda2))
        d_cl1.append(
            mterm(c_by[tid], lambda p: clipped_l1_lift(p, CLIP))
            - mterm(k_by[tid], lambda p: clipped_l1_lift(p, CLIP))
        )
        d_mix.append(
            mterm(c_by[tid], lambda p: rank_term(p, W, CLIP))
            - mterm(k_by[tid], lambda p: rank_term(p, W, CLIP))
        )
    refs = d.get("teacher_refs") or {}
    n_refs = len(refs) if isinstance(refs, dict) else 0
    n_samples = 0
    if isinstance(refs, dict):
        n_samples = sum(len(v) if isinstance(v, list) else 1 for v in refs.values())
    return {
        "challenge_id": path.name.replace(".json.gz", ""),
        "challenger_repo": req.get("challenger_repo"),
        "challenger_revision": req.get("challenger_revision"),
        "king_repo": req.get("king_repo"),
        "king_revision": req.get("king_revision"),
        "published": {
            "wins": ver.get("challenger_wins"),
            "margin": ver.get("margin"),
            "z": ver.get("z"),
        },
        "recompute": {
            "cs_valid": cs.valid,
            "ks_valid": ks.valid,
            "cs_S": cs.S if math.isfinite(cs.S) else None,
            "ks_S": ks.S if math.isfinite(ks.S) else None,
            "cs_r": cs.calib_ratio,
            "ks_r": ks.calib_ratio,
            "cs_bank": c_bank,
            "ks_bank": k_bank,
            "cs_gate_pass": cs.gate_pass_rate,
            "ks_gate_pass": ks.gate_pass_rate,
            "cs_baseline_abs": cs.baseline_abs,
            "ks_baseline_abs": ks.baseline_abs,
            "baseline_ratio": base_ratio,
            "margin": dr.margin,
            "se": dr.se if math.isfinite(dr.se) else None,
            "z": dr.z,
            "wins": dr.challenger_wins,
        },
        "challenger_decomp": pair_stats(c_rows),
        "king_decomp": pair_stats(k_rows),
        "challenger_style": thought_style(c_rows),
        "king_style": thought_style(k_rows),
        "paired_delta": {
            "n": len(d_mix),
            "mean_d_lambda2": st.mean(d_l2) if d_l2 else None,
            "mean_d_clip_l1": st.mean(d_cl1) if d_cl1 else None,
            "mean_d_mix": st.mean(d_mix) if d_mix else None,
            "clip_l1_share": (
                abs(st.mean(d_cl1))
                / (abs(st.mean(d_l2)) + abs(st.mean(d_cl1)) + 1e-12)
                if d_mix
                else None
            ),
        },
        "n_teacher_ref_keys": n_refs,
        "n_teacher_ref_samples": n_samples,
    }


def main() -> None:
    rows = [analyze(p) for p in sorted(RES.glob("chal-*.json.gz"))]
    (RES / "summary.json").write_text(json.dumps({"duels": rows}, indent=2) + "\n")

    lines = ["# TalentPigs lineage autopsy (current knobs)", ""]
    lines.append(
        f"{'id':12} {'m':>8} {'z':>6} {'cS':>8} {'kS':>8} {'cL2':>8} {'cL1c':>8} "
        f"{'dL2':>8} {'dL1c':>8} {'c_r':>6} {'base×':>6} {'zaμ':>6} repo"
    )
    for r in rows:
        rc, cd, kd, pd = (
            r["recompute"],
            r["challenger_decomp"],
            r["king_decomp"],
            r["paired_delta"],
        )
        lines.append(
            f"{r['challenge_id']:12} "
            f"{rc['margin']:+8.4f} {rc['z']:+6.2f} "
            f"{(cd.get('mean_mix') or float('nan')):+8.4f} "
            f"{(kd.get('mean_mix') or float('nan')):+8.4f} "
            f"{(cd.get('mean_lambda2') or float('nan')):+8.4f} "
            f"{(cd.get('mean_clip_l1') or float('nan')):+8.4f} "
            f"{(pd.get('mean_d_lambda2') or float('nan')):+8.4f} "
            f"{(pd.get('mean_d_clip_l1') or float('nan')):+8.4f} "
            f"{(rc['cs_r'] or float('nan')):6.3f} "
            f"{(rc['baseline_ratio'] or float('nan')):6.3f} "
            f"{(cd.get('mean_za_chars') or float('nan')):6.0f} "
            f"{(r['challenger_repo'] or '')[-28:]}"
        )
    (RES / "table.txt").write_text("\n".join(lines) + "\n")
    print("\n".join(lines))


if __name__ == "__main__":
    main()
