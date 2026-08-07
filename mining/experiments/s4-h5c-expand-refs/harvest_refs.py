#!/usr/bin/env python3
"""Harvest teacher_refs from public duel gz into chat-SFT jsonl (H5c expand).

Same completion format as s4-h1-sft/harvest_refs.py, plus:
  --max-z-chars N   keep only rows with len(z) <= N
  --drop-listy      drop thoughts with list markers (\\n- / \\n* / \\n1.)
  --sample N        also write a .sample.jsonl with N rows
  --stats-out PATH  write length / list / src coverage stats JSON

Dedupes by turn_id, keeping the teacher sample with highest lp_own.
"""
from __future__ import annotations

import argparse
import gzip
import json
import re
import sys
from collections import Counter
from pathlib import Path

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


def pick_best_sample(samples: list[dict]) -> dict | None:
    best = None
    best_lp = float("-inf")
    for s in samples:
        z = (s.get("z") or "").strip()
        y = (s.get("y") or "").strip()
        if not z or not y:
            continue
        if not y.startswith("```bash"):
            continue
        lp = s.get("lp_own")
        try:
            lpv = float(lp) if lp is not None else float("-inf")
        except (TypeError, ValueError):
            lpv = float("-inf")
        if best is None or lpv > best_lp:
            best = s
            best_lp = lpv
    return best


def completion_from_zy(z: str, y: str) -> str:
    return f"</think>\nTHOUGHT: {z.strip()}\n\n{y.strip()}"


def is_listy(z: str) -> bool:
    return bool(LISTY_RE.search(z))


def percentile(sorted_vals: list[int], p: float) -> int | None:
    if not sorted_vals:
        return None
    i = int(round((len(sorted_vals) - 1) * p))
    return sorted_vals[max(0, min(i, len(sorted_vals) - 1))]


def main() -> None:
    ap = argparse.ArgumentParser()
    ap.add_argument("--duels-dir", type=Path, required=True)
    ap.add_argument("--turns", type=Path, required=True)
    ap.add_argument("--out", type=Path, required=True)
    ap.add_argument("--glob", default="chal-*.json.gz")
    ap.add_argument("--max-z-chars", type=int, default=0, help="0 = no cap")
    ap.add_argument("--drop-listy", action="store_true")
    ap.add_argument("--sample", type=int, default=20)
    ap.add_argument("--stats-out", type=Path, default=None)
    ap.add_argument("--min-examples", type=int, default=50)
    args = ap.parse_args()

    print(f"[harvest] indexing corpus {args.turns}", flush=True)
    corpus = load_corpus_index(args.turns)
    print(f"[harvest] corpus turns={len(corpus)}", flush=True)

    best_by_tid: dict[str, dict] = {}
    src_files = 0
    raw_samples = 0
    src_hits: Counter[str] = Counter()
    for path in sorted(args.duels_dir.glob(args.glob)):
        src_files += 1
        with gzip.open(path, "rt") as f:
            d = json.load(f)
        refs = d.get("teacher_refs") or {}
        for tid, samples in refs.items():
            raw_samples += len(samples)
            picked = pick_best_sample(samples)
            if picked is None:
                continue
            lp = picked.get("lp_own")
            try:
                lpv = float(lp) if lp is not None else float("-inf")
            except (TypeError, ValueError):
                lpv = float("-inf")
            prev = best_by_tid.get(tid)
            if prev is None or lpv > prev["_lp"]:
                best_by_tid[tid] = {
                    "turn_id": tid,
                    "z": picked["z"],
                    "y": picked["y"],
                    "_lp": lpv,
                    "src": path.name,
                }

    rows = []
    missing = 0
    dropped_z = 0
    dropped_listy = 0
    for tid, rec in sorted(best_by_tid.items()):
        prefix = corpus.get(tid)
        if prefix is None:
            missing += 1
            continue
        z = rec["z"]
        if args.max_z_chars and len(z) > args.max_z_chars:
            dropped_z += 1
            continue
        if args.drop_listy and is_listy(z):
            dropped_listy += 1
            continue
        rows.append(
            {
                "turn_id": tid,
                "messages": prefix,
                "completion": completion_from_zy(rec["z"], rec["y"]),
                "z": rec["z"],
                "y": rec["y"],
                "lp_own": None if rec["_lp"] == float("-inf") else rec["_lp"],
                "src": rec["src"],
                "z_chars": len(z),
                "listy": is_listy(z),
            }
        )
        src_hits[rec["src"]] += 1

    args.out.parent.mkdir(parents=True, exist_ok=True)
    with args.out.open("w") as f:
        for r in rows:
            f.write(json.dumps(r, ensure_ascii=False) + "\n")

    if args.sample > 0:
        sample_path = args.out.with_suffix(".sample.jsonl")
        with sample_path.open("w") as f:
            for r in rows[: args.sample]:
                f.write(json.dumps(r, ensure_ascii=False) + "\n")

    z_chars = sorted(r["z_chars"] for r in rows)
    n_listy = sum(1 for r in rows if r["listy"])
    meta = {
        "duels_dir": str(args.duels_dir),
        "turns": str(args.turns),
        "out": str(args.out),
        "src_files": src_files,
        "raw_teacher_samples": raw_samples,
        "unique_turn_ids_with_refs": len(best_by_tid),
        "examples_written": len(rows),
        "missing_from_corpus": missing,
        "max_z_chars": args.max_z_chars or None,
        "drop_listy": bool(args.drop_listy),
        "dropped_max_z": dropped_z,
        "dropped_listy": dropped_listy,
        "z_chars_p10": percentile(z_chars, 0.10),
        "z_chars_p50": percentile(z_chars, 0.50),
        "z_chars_p90": percentile(z_chars, 0.90),
        "z_chars_mean": (round(sum(z_chars) / len(z_chars), 1) if z_chars else None),
        "listy_frac": (round(n_listy / len(rows), 4) if rows else None),
        "out_bytes": args.out.stat().st_size,
        "completion_format": "</think>\\nTHOUGHT: {z}\\n\\n{y}",
        "vs_h1_440": {
            "h1_examples": 440,
            "delta_examples": len(rows) - 440,
            "expand_factor": (round(len(rows) / 440, 3) if rows else None),
        },
        "top_src_files": src_hits.most_common(10),
    }
    meta_path = args.out.with_suffix(".meta.json")
    meta_path.write_text(json.dumps(meta, indent=2))
    if args.stats_out is not None:
        args.stats_out.parent.mkdir(parents=True, exist_ok=True)
        args.stats_out.write_text(json.dumps(meta, indent=2))
    print(json.dumps(meta, indent=2), flush=True)
    if len(rows) < args.min_examples:
        print("[harvest] ERROR: too few examples", file=sys.stderr)
        sys.exit(2)


if __name__ == "__main__":
    main()
