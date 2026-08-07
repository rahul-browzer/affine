#!/usr/bin/env python3
"""Harvest high clip-L1 miner thoughts (z_A) for H27 clip-L1 shaping.

Unlike teacher_refs distill (z_C), this keeps challenger z_A from public
duels where clipped L1lift was high, paired with teacher y_C for that turn.
Init will be TalentPigs; loss is thought-only on z_A.
"""
from __future__ import annotations

import argparse
import gzip
import json
import re
import sys
from collections import Counter
from pathlib import Path

sys.path.insert(0, "/home/const/subnet120")
from affine.affine.score import DEFAULT_L1_CLIP, clipped_l1_lift  # noqa: E402

LISTY_RE = re.compile(r"(?m)^(\s*[-*]|\s*\d+\.)\s+")


def turn_key(traj_id: str, turn_idx: int) -> str:
    return f"{traj_id}:{turn_idx}"


def load_corpus_index(turns_path: Path) -> dict[str, list[dict]]:
    idx: dict[str, list[dict]] = {}
    with turns_path.open() as f:
        for line in f:
            if not line.strip():
                continue
            t = json.loads(line)
            idx[turn_key(t["traj_id"], int(t["turn_idx"]))] = t["prefix"]
    return idx


def pick_best_yc(samples: list[dict]) -> dict | None:
    best = None
    best_lp = float("-inf")
    for s in samples:
        y = (s.get("y") or "").strip()
        if not y.startswith("```bash"):
            continue
        try:
            lpv = float(s["lp_own"]) if s.get("lp_own") is not None else float("-inf")
        except (TypeError, ValueError):
            lpv = float("-inf")
        if best is None or lpv > best_lp:
            best = s
            best_lp = lpv
    return best


def completion_from_zy(z: str, y: str) -> str:
    return f"</think>\nTHOUGHT: {z.strip()}\n\n{y.strip()}"


def main() -> None:
    ap = argparse.ArgumentParser()
    ap.add_argument("--duels-dir", type=Path, required=True)
    ap.add_argument("--turns", type=Path, required=True)
    ap.add_argument("--rank-json", type=Path, required=True)
    ap.add_argument("--out", type=Path, required=True)
    ap.add_argument("--min-clip-l1", type=float, default=0.05)
    ap.add_argument("--min-duel-clip", type=float, default=0.032)
    ap.add_argument("--max-z-chars", type=int, default=250)
    ap.add_argument("--drop-listy", action="store_true", default=True)
    ap.add_argument("--sample", type=int, default=20)
    ap.add_argument("--stats-out", type=Path, default=None)
    ap.add_argument("--min-examples", type=int, default=200)
    args = ap.parse_args()

    rank = json.loads(args.rank_json.read_text())
    cids = {
        r["cid"]
        for r in rank["all_by_clipL1"]
        if float(r.get("c_clipL1") or 0) >= args.min_duel_clip
    }
    cids.add("chal-00284")  # TalentPigs crown

    print(f"[harvest] indexing corpus {args.turns}", flush=True)
    corpus = load_corpus_index(args.turns)
    print(f"[harvest] corpus turns={len(corpus)} cids={sorted(cids)}", flush=True)

    best: dict[str, dict] = {}
    src_hits: Counter[str] = Counter()
    n_pairs = 0
    n_pass_clip = 0
    n_no_yc = 0
    n_no_corpus = 0
    n_z_long = 0
    n_listy = 0

    for cid in sorted(cids):
        path = args.duels_dir / f"{cid}.json.gz"
        if not path.exists():
            print(f"[harvest] missing {path}", flush=True)
            continue
        with gzip.open(path, "rt") as f:
            d = json.load(f)
        refs = d.get("teacher_refs") or {}
        for row in d.get("challenger_rows") or []:
            if not row.get("valid"):
                continue
            tid = row.get("turn_id")
            if not tid:
                continue
            yc_src = pick_best_yc(refs.get(tid) or [])
            if yc_src is None:
                n_no_yc += 1
                continue
            y = (yc_src.get("y") or "").strip()
            for pair in row.get("pairs") or []:
                n_pairs += 1
                z = (pair.get("z_a") or "").strip()
                if not z:
                    continue
                cl = float(clipped_l1_lift(pair, DEFAULT_L1_CLIP))
                if cl < args.min_clip_l1:
                    continue
                n_pass_clip += 1
                if args.max_z_chars and len(z) > args.max_z_chars:
                    n_z_long += 1
                    continue
                if args.drop_listy and LISTY_RE.search(z):
                    n_listy += 1
                    continue
                if tid not in corpus:
                    n_no_corpus += 1
                    continue
                prev = best.get(tid)
                if prev is None or cl > prev["_clip"]:
                    best[tid] = {
                        "turn_id": tid,
                        "messages": corpus[tid],
                        "completion": completion_from_zy(z, y),
                        "z": z,
                        "y": y,
                        "clip_l1": cl,
                        "src": path.name,
                        "_clip": cl,
                        "z_chars": len(z),
                        "listy": bool(LISTY_RE.search(z)),
                    }
                    src_hits[path.name] += 1

    rows = sorted(best.values(), key=lambda r: -r["_clip"])
    for r in rows:
        r.pop("_clip", None)

    args.out.parent.mkdir(parents=True, exist_ok=True)
    with args.out.open("w") as f:
        for r in rows:
            f.write(json.dumps(r, ensure_ascii=False) + "\n")

    sample_path = args.out.with_suffix(".sample.jsonl")
    with sample_path.open("w") as f:
        for r in rows[: args.sample]:
            f.write(json.dumps(r, ensure_ascii=False) + "\n")

    z_lens = sorted(r["z_chars"] for r in rows)
    stats = {
        "n_examples": len(rows),
        "n_pairs_scanned": n_pairs,
        "n_pass_min_clip": n_pass_clip,
        "n_no_yc": n_no_yc,
        "n_no_corpus": n_no_corpus,
        "n_z_long": n_z_long,
        "n_listy": n_listy,
        "min_clip_l1": args.min_clip_l1,
        "max_z_chars": args.max_z_chars,
        "cids": sorted(cids),
        "src_hits": dict(src_hits),
        "z_chars_p50": z_lens[len(z_lens) // 2] if z_lens else None,
        "z_chars_mean": (sum(z_lens) / len(z_lens)) if z_lens else None,
        "clip_l1_mean": (sum(r["clip_l1"] for r in rows) / len(rows)) if rows else None,
    }
    stats_path = args.stats_out or args.out.with_suffix(".stats.json")
    stats_path.write_text(json.dumps(stats, indent=2) + "\n")
    print(json.dumps(stats, indent=2), flush=True)
    if len(rows) < args.min_examples:
        raise SystemExit(f"too few examples: {len(rows)} < {args.min_examples}")
    print(f"[harvest] wrote {args.out} n={len(rows)}", flush=True)


if __name__ == "__main__":
    main()
