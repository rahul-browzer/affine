#!/usr/bin/env python3
"""Stage 2: decompose public duel records (Λ2 vs clip L1, gates, margins).

Read-only import of affine.affine.score. No GPU. Writes summary.json + table.txt.
"""
from __future__ import annotations

import gzip
import json
import math
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

HERE = Path(__file__).resolve().parent
CLIP = DEFAULT_L1_CLIP
W = DEFAULT_L1_WEIGHT


def _mean_bank(rows: list[dict]) -> float:
    vals = [r["bank_frac"] for r in rows if r.get("valid") and "bank_frac" in r]
    return st.mean(vals) if vals else 0.0


def _pair_stats(rows: list[dict]) -> dict:
    pairs = [p for r in rows if r.get("valid") and "pairs" in r for p in r["pairs"]]
    if not pairs:
        return {}
    l2 = [lambda2(p) for p in pairs]
    raw_l1 = [l1_lift(p) for p in pairs]
    cl1 = [clipped_l1_lift(p, CLIP) for p in pairs]
    rt = [rank_term(p, W, CLIP) for p in pairs]
    n_clip_hi = sum(1 for x in raw_l1 if x >= CLIP)
    n_clip_lo = sum(1 for x in raw_l1 if x <= -CLIP)
    return {
        "n_pairs": len(pairs),
        "mean_lambda2": st.mean(l2),
        "mean_raw_l1": st.mean(raw_l1),
        "mean_clip_l1": st.mean(cl1),
        "mean_mix": st.mean(rt),
        "frac_l1_at_clip_hi": n_clip_hi / len(pairs),
        "frac_l1_at_clip_lo": n_clip_lo / len(pairs),
        "share_mix_from_clip_l1": (
            abs(st.mean(cl1)) / (abs(st.mean(l2)) + abs(st.mean(cl1)) + 1e-12)
        ),
        "gate_pass_rate": st.mean(1.0 if gate_pass(p) else 0.0 for p in pairs),
    }


def analyze_one(path: Path) -> dict:
    with gzip.open(path, "rt") as f:
        d = json.load(f)
    req = d.get("request") or {}
    ver = d.get("verdict") or {}
    c_rows = d["challenger_rows"]
    k_rows = d["king_rows"]
    c_bank = _mean_bank(c_rows)
    k_bank = _mean_bank(k_rows)
    cs = score_miner(c_rows, bank_frac=c_bank, r_lo=DEFAULT_R_LO, r_hi=DEFAULT_R_HI)
    ks = score_miner(k_rows, bank_frac=k_bank, r_lo=DEFAULT_R_LO, r_hi=DEFAULT_R_HI)
    base_ratio = None
    band_fail = False
    if cs.baseline_abs and ks.baseline_abs and ks.baseline_abs > 0:
        base_ratio = cs.baseline_abs / ks.baseline_abs
        if base_ratio > DEFAULT_BASELINE_BAND:
            band_fail = True
            cs.valid = False
            cs.S = float("-inf")
    dr = duel(
        c_rows, k_rows,
        challenger_bank_frac=c_bank, king_bank_frac=k_bank,
        r_lo=DEFAULT_R_LO, r_hi=DEFAULT_R_HI,
        min_margin=DEFAULT_MIN_MARGIN, min_se=DEFAULT_MIN_SE,
        baseline_band=DEFAULT_BASELINE_BAND,
    )
    # paired per-turn ΔΛ2 / ΔclipL1 (same pairing as duel)
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
    c_stats = _pair_stats(c_rows)
    k_stats = _pair_stats(k_rows)
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
            "challenger_valid": (ver.get("challenger") or {}).get("valid"),
            "challenger_mean_mix": (ver.get("challenger") or {}).get("mean_mix"),
            "challenger_mean_lambda2": (ver.get("challenger") or {}).get("mean_lambda2"),
            "king_mean_mix": (ver.get("king") or {}).get("mean_mix"),
            "gates_min_margin": (ver.get("gates") or {}).get("min_margin"),
        },
        "recompute_current": {
            "cs_valid": cs.valid,
            "ks_valid": ks.valid,
            "band_fail": band_fail,
            "cs_S": cs.S if cs.valid else None,
            "ks_S": ks.S if ks.valid else None,
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
        "challenger_decomp": c_stats,
        "king_decomp": k_stats,
        "paired_delta": {
            "n": len(d_mix),
            "mean_d_lambda2": st.mean(d_l2) if d_l2 else None,
            "mean_d_clip_l1": st.mean(d_cl1) if d_cl1 else None,
            "mean_d_mix": st.mean(d_mix) if d_mix else None,
            # contribution of clip-L1 to the paired margin (absolute share)
            "clip_l1_share_of_abs_margin": (
                abs(st.mean(d_cl1)) / (abs(st.mean(d_l2)) + abs(st.mean(d_cl1)) + 1e-12)
                if d_mix else None
            ),
        },
        "n_teacher_refs": len(d.get("teacher_refs") or {}),
    }


def main() -> None:
    paths = sorted(HERE.glob("chal-*.json.gz"))
    rows = []
    for p in paths:
        try:
            rows.append(analyze_one(p))
        except Exception as e:
            rows.append({"challenge_id": p.name, "error": repr(e)})

    # H3 probe: among recomputed-valid near-king challengers (|margin|<0.03 or
    # mean_mix within 0.02 of king), correlate |ΔS| parts.
    valid_near = []
    for r in rows:
        if r.get("error"):
            continue
        rc = r["recompute_current"]
        if not (rc["cs_valid"] and rc["ks_valid"]):
            continue
        pd = r["paired_delta"]
        if pd["mean_d_mix"] is None:
            continue
        valid_near.append(r)

    # Spearman-ish via rank correlation of |d_clip_l1| vs |d_mix| and |d_l2| vs |d_mix|
    def spearman(xs, ys):
        n = len(xs)
        if n < 3:
            return None
        rx = {v: i for i, v in enumerate(sorted(xs))}
        ry = {v: i for i, v in enumerate(sorted(ys))}
        # tie-unaware ok for small n
        xi = [rx[x] for x in xs]
        yi = [ry[y] for y in ys]
        mx, my = st.mean(xi), st.mean(yi)
        num = sum((a - mx) * (b - my) for a, b in zip(xi, yi))
        denx = math.sqrt(sum((a - mx) ** 2 for a in xi))
        deny = math.sqrt(sum((b - my) ** 2 for b in yi))
        if denx == 0 or deny == 0:
            return None
        return num / (denx * deny)

    d_mix = [r["paired_delta"]["mean_d_mix"] for r in valid_near]
    d_l2 = [r["paired_delta"]["mean_d_lambda2"] for r in valid_near]
    d_cl = [r["paired_delta"]["mean_d_clip_l1"] for r in valid_near]
    h3 = {
        "n_valid_duels": len(valid_near),
        "spearman_d_mix_vs_d_lambda2": spearman(d_mix, d_l2),
        "spearman_d_mix_vs_d_clip_l1": spearman(d_mix, d_cl),
        "mean_abs_d_lambda2": st.mean(abs(x) for x in d_l2) if d_l2 else None,
        "mean_abs_d_clip_l1": st.mean(abs(x) for x in d_cl) if d_cl else None,
        "mean_clip_l1_share": st.mean(
            r["paired_delta"]["clip_l1_share_of_abs_margin"] for r in valid_near
        ) if valid_near else None,
    }

    out = {"duels": rows, "h3_probe": h3}
    (HERE / "summary.json").write_text(json.dumps(out, indent=2) + "\n")

    lines = []
    lines.append("s2-public-duel-mine — decomposition table (current knobs)")
    lines.append(
        f"{'id':12} {'pub_m':>8} {'rc_m':>8} {'rc_z':>7} {'win':>3} "
        f"{'cS':>8} {'cL2':>8} {'cL1c':>8} {'c_r':>6} {'base×':>6} "
        f"{'dL2':>8} {'dL1c':>8} {'L1shr':>5} repo"
    )
    for r in rows:
        if r.get("error"):
            lines.append(f"{r['challenge_id']:12} ERROR {r['error']}")
            continue
        pub = r["published"]
        rc = r["recompute_current"]
        cd = r["challenger_decomp"]
        pd = r["paired_delta"]
        repo = (r.get("challenger_repo") or "?")[:40]
        lines.append(
            f"{r['challenge_id']:12} "
            f"{(pub.get('margin') if pub.get('margin') is not None else float('nan')):+8.4f} "
            f"{(rc['margin'] if rc['margin'] is not None else float('nan')):+8.4f} "
            f"{(rc['z'] if rc['z'] is not None else float('nan')):+7.2f} "
            f"{'Y' if rc['wins'] else 'n':>3} "
            f"{(cd.get('mean_mix') if cd else float('nan')):+8.4f} "
            f"{(cd.get('mean_lambda2') if cd else float('nan')):+8.4f} "
            f"{(cd.get('mean_clip_l1') if cd else float('nan')):+8.4f} "
            f"{(rc['cs_r'] if rc['cs_r'] is not None else float('nan')):6.3f} "
            f"{(rc['baseline_ratio'] if rc['baseline_ratio'] is not None else float('nan')):6.3f} "
            f"{(pd['mean_d_lambda2'] if pd['mean_d_lambda2'] is not None else float('nan')):+8.4f} "
            f"{(pd['mean_d_clip_l1'] if pd['mean_d_clip_l1'] is not None else float('nan')):+8.4f} "
            f"{(pd['clip_l1_share_of_abs_margin'] if pd['clip_l1_share_of_abs_margin'] is not None else float('nan')):5.2f} "
            f"{repo}"
        )
    lines.append("")
    lines.append("H3 probe (valid under current knobs):")
    for k, v in h3.items():
        lines.append(f"  {k}: {v}")
    (HERE / "table.txt").write_text("\n".join(lines) + "\n")
    print("\n".join(lines))


if __name__ == "__main__":
    main()
