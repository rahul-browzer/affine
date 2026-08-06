#!/usr/bin/env python3
"""Offline recompute of chal-00224 / chal-00203 from stored logprobs.

Read-only import of affine.affine.score. No GPU.
"""
from __future__ import annotations

import gzip
import json
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[3]  # subnet120/
sys.path.insert(0, str(ROOT))

from affine.affine.score import duel, score_miner  # noqa: E402

HERE = Path(__file__).resolve().parent


def load(name: str) -> dict:
    with gzip.open(HERE / name, "rt") as f:
        return json.load(f)


def bank_frac(side: dict) -> float:
    return float(side["bank_frac"])


def run(path: str) -> None:
    art = load(path)
    v = art["verdict"]
    cr, kr = art["challenger_rows"], art["king_rows"]
    cbf, kbf = bank_frac(v["challenger"]), bank_frac(v["king"])
    req = art["request"]
    print(f"== {path} ==")
    print(f"challenger={req['challenger_repo']} @ {req['challenger_revision'][:12]}")
    print(f"king={req['king_repo']} @ {req['king_revision'][:12]}")
    print(f"published: wins={v['challenger_wins']} margin={v['margin']} z={v['z']}")

    old = duel(cr, kr, challenger_bank_frac=cbf, king_bank_frac=kbf,
               r_lo=1.0, min_margin=0.05, baseline_band=None)
    cur = duel(cr, kr, challenger_bank_frac=cbf, king_bank_frac=kbf,
               r_lo=0.3, min_margin=0.02, baseline_band=1.25)
    cs = score_miner(cr, bank_frac=cbf, r_lo=0.3)
    ks = score_miner(kr, bank_frac=kbf, r_lo=0.3)
    print(f"old r_lo=1.0: wins={old.challenger_wins} margin={old.margin} z={old.z}")
    print(f"cur knobs:    wins={cur.challenger_wins} margin={cur.margin:.6f} "
          f"se={cur.se:.6f} z={cur.z:.4f} n={cur.n_paired_turns}")
    print(f"  cs: valid={cs.valid} S={cs.S} r={cs.calib_ratio:.4f} "
          f"base={cs.baseline_abs:.6f} gate={cs.gate_pass_rate:.4f} bank={cbf:.4f}")
    print(f"  ks: valid={ks.valid} S={ks.S} r={ks.calib_ratio:.4f} "
          f"base={ks.baseline_abs:.6f} gate={ks.gate_pass_rate:.4f} bank={kbf:.4f}")
    if cs.baseline_abs and ks.baseline_abs:
        print(f"  baseline ratio c/k = {cs.baseline_abs / ks.baseline_abs:.4f} "
              f"(band 1.25)")
    print()


if __name__ == "__main__":
    for name in ("chal-00224.json.gz", "chal-00203.json.gz"):
        run(name)
