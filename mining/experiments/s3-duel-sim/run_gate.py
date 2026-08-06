#!/usr/bin/env python3
"""Stage 3 gate: force-echo chal-00224 texts through live vLLM, rescore S*.

Requires serve_three.sh healthy and corpus synced (turns.jsonl with prefixes).
Recomputes the ranking/gate lp* fields from published (z,y) texts — no fresh
sampling — then compares duel margin to the published +0.070000.

Decision rule (plan.md): kevin wins with margin within ~0.02 of +0.070, or
at least margin ≥ 0.04 with gates passing.
"""
from __future__ import annotations

import argparse
import asyncio
import gzip
import json
import math
import sys
import time
from pathlib import Path

import httpx

from affine.score import duel, score_miner
from evalsrv.dueling import turn_id
from evalsrv.vllm_client import Served, VllmModel

EMPTY = ""


def load_artifact(path: Path) -> dict:
    with gzip.open(path, "rt") as f:
        return json.load(f)


def load_prefixes(turns_path: Path, turn_ids: list[str]) -> dict[str, list]:
    want = set(turn_ids)
    out: dict[str, list] = {}
    with open(turns_path) as f:
        for line in f:
            rec = json.loads(line)
            tid = turn_id(rec)
            if tid in want:
                out[tid] = rec["prefix"]
                if len(out) == len(want):
                    break
    missing = want - set(out)
    if missing:
        raise SystemExit(f"missing {len(missing)} prefixes; e.g. {next(iter(missing))}")
    return out


async def rescore_side(
    teacher: VllmModel,
    miner: VllmModel,
    rows: list[dict],
    refs: dict[str, list],
    prefixes: dict[str, list],
    conc: int,
    label: str,
) -> list[dict]:
    """Rebuild rows with live force-echo lp* for S*/gates; keep published bank."""
    sem = asyncio.Semaphore(conc)
    done = 0
    total = len(rows)

    async def lp(model: VllmModel, prefix, z, y) -> float:
        async with sem:
            return (await model.score_action(prefix, z, y))["lp_per_byte"]

    async def one(row: dict) -> dict:
        nonlocal done
        tid = row["turn_id"]
        prefix = prefixes[tid]
        ref = refs[tid]
        pairs_in = row["pairs"]
        m = min(len(pairs_in), len(ref))
        tasks = []
        meta = []
        for i in range(m):
            z_a, y_a = pairs_in[i]["z_a"], pairs_in[i]["y_a"]
            z_c, y_c = ref[i]["z"], ref[i]["y"]
            # ranking + gate fields
            for name, model, z, y in (
                ("lpC_yc_za", teacher, z_a, y_c),
                ("lpC_yc_e", teacher, EMPTY, y_c),
                ("lpA_yc_za", miner, z_a, y_c),
                ("lpA_yc_e", miner, EMPTY, y_c),
                ("lpA_ya_za", miner, z_a, y_a),
                ("lpA_ya_e", miner, EMPTY, y_a),
            ):
                tasks.append(lp(model, prefix, z, y))
                meta.append((i, name, z_a, y_a))
        vals = await asyncio.gather(*tasks)
        by_i: dict[int, dict] = {i: {} for i in range(m)}
        for (i, name, z_a, y_a), v in zip(meta, vals):
            by_i[i][name] = v
            by_i[i]["z_a"] = z_a
            by_i[i]["y_a"] = y_a
            # carry published bank lift if present (gate 2); avoid re-bank cost
            if "L2_bank" in pairs_in[i]:
                by_i[i]["L2_bank"] = pairs_in[i]["L2_bank"]
        new_pairs = [by_i[i] for i in range(m)]
        done += 1
        if done % 10 == 0 or done == total:
            print(f"[{label}] {done}/{total}", flush=True)
        return {
            "turn_id": tid,
            "miner": row.get("miner", label),
            "valid": True,
            "n_pairs": m,
            "pairs": new_pairs,
            "bank_frac": row.get("bank_frac"),
            "L2_bank": row.get("L2_bank"),
        }

    out_rows = await asyncio.gather(*[one(r) for r in rows])
    return list(out_rows)


async def main_async(args: argparse.Namespace) -> int:
    art = load_artifact(Path(args.artifact))
    turn_ids = art["turn_ids"]
    prefixes = load_prefixes(Path(args.turns), turn_ids)
    pub = art["verdict"]
    print(f"published: wins={pub['challenger_wins']} margin={pub['margin']} z={pub['z']}")
    print(f"slice digest={art['slice']['digest'][:16]}… n={len(turn_ids)}")

    req = art["request"]
    teacher_cfg = Served("teacher", args.teacher_repo, None, args.teacher_port)
    king_cfg = Served(
        "king",
        req["king_repo"],
        req.get("king_revision"),
        args.king_port,
    )
    chall_cfg = Served(
        "challenger",
        req["challenger_repo"],
        req.get("challenger_revision"),
        args.chall_port,
    )

    t0 = time.time()
    async with httpx.AsyncClient() as http:
        teacher = VllmModel(teacher_cfg, http, asyncio.Semaphore(args.conc))
        king = VllmModel(king_cfg, http, asyncio.Semaphore(args.conc))
        chall = VllmModel(chall_cfg, http, asyncio.Semaphore(args.conc))
        # smoke one force-echo
        tid0 = turn_ids[0]
        p0 = prefixes[tid0]
        z0 = art["challenger_rows"][0]["pairs"][0]["z_a"]
        y0 = art["challenger_rows"][0]["pairs"][0]["y_a"]
        smoke = await chall.score_action(p0, z0, y0)
        print(f"smoke chall lp_per_byte={smoke['lp_per_byte']:.6f} n_tok={smoke['n_tokens']}")

        king_rows, chall_rows = await asyncio.gather(
            rescore_side(teacher, king, art["king_rows"], art["teacher_refs"],
                         prefixes, args.conc, "king"),
            rescore_side(teacher, chall, art["challenger_rows"], art["teacher_refs"],
                         prefixes, args.conc, "chall"),
        )

    cbf = float(pub["challenger"]["bank_frac"])
    kbf = float(pub["king"]["bank_frac"])
    cur = duel(
        chall_rows, king_rows,
        challenger_bank_frac=cbf, king_bank_frac=kbf,
        r_lo=0.3, min_margin=0.02, baseline_band=1.25,
    )
    cs = score_miner(chall_rows, bank_frac=cbf, r_lo=0.3)
    ks = score_miner(king_rows, bank_frac=kbf, r_lo=0.3)
    elapsed = time.time() - t0

    result = {
        "elapsed_s": elapsed,
        "published": {
            "challenger_wins": pub["challenger_wins"],
            "margin": pub["margin"],
            "z": pub["z"],
        },
        "live_force_echo": {
            "challenger_wins": cur.challenger_wins,
            "margin": cur.margin if math.isfinite(cur.margin) else None,
            "se": cur.se if math.isfinite(cur.se) else None,
            "z": cur.z if math.isfinite(cur.z) else None,
            "n_paired": cur.n_paired_turns,
        },
        "challenger": {
            "valid": cs.valid, "S": cs.S if math.isfinite(cs.S) else None,
            "r": cs.calib_ratio, "gate": cs.gate_pass_rate,
            "baseline_abs": cs.baseline_abs,
        },
        "king": {
            "valid": ks.valid, "S": ks.S if math.isfinite(ks.S) else None,
            "r": ks.calib_ratio, "gate": ks.gate_pass_rate,
            "baseline_abs": ks.baseline_abs,
        },
    }
    dm = None
    if result["live_force_echo"]["margin"] is not None and pub["margin"] is not None:
        dm = result["live_force_echo"]["margin"] - float(pub["margin"])
    result["delta_margin_vs_published"] = dm

    # Gate decision
    m = result["live_force_echo"]["margin"]
    gate_ok = bool(
        cur.challenger_wins
        and m is not None
        and (m >= 0.04)
        and cs.valid and ks.valid
    )
    close = bool(m is not None and abs(m - float(pub["margin"])) <= 0.02)
    result["stage3_gate"] = "MET" if (gate_ok or close) else "NOT_MET"
    result["stage3_notes"] = (
        f"wins={cur.challenger_wins} margin={m} Δpub={dm} "
        f"close(|Δ|≤0.02)={close} submit_floor(m≥0.04&valid)={gate_ok}"
    )

    out_path = Path(args.out)
    out_path.parent.mkdir(parents=True, exist_ok=True)
    out_path.write_text(json.dumps(result, indent=2) + "\n")
    print(json.dumps(result, indent=2))
    print(f"wrote {out_path}")
    print(f"STAGE3_GATE={result['stage3_gate']}")
    return 0 if result["stage3_gate"] == "MET" else 2


def parse_args() -> argparse.Namespace:
    p = argparse.ArgumentParser()
    p.add_argument("--artifact", default="/root/affine_data/chal-00224.json.gz")
    p.add_argument("--turns", default="/root/affine_data/turns.jsonl")
    p.add_argument("--out", default="/root/affine_data/s3_gate_result.json")
    p.add_argument("--teacher-repo", default="zai-org/GLM-4.5-Air-FP8")
    p.add_argument("--teacher-port", type=int, default=8000)
    p.add_argument("--king-port", type=int, default=8001)
    p.add_argument("--chall-port", type=int, default=8002)
    p.add_argument("--conc", type=int, default=8)
    return p.parse_args()


if __name__ == "__main__":
    args = parse_args()
    try:
        raise SystemExit(asyncio.run(main_async(args)))
    except KeyboardInterrupt:
        sys.exit(130)
