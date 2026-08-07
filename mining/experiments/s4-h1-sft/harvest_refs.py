#!/usr/bin/env python3
"""Harvest teacher_refs from public duel gz into chat-SFT jsonl.

Each example: prefix messages from corpus turn + completion in the Affine
canonical assistant body (starts inside open <think>):

  </think>
  THOUGHT: {z}

  {y}

Dedupes by turn_id, keeping the teacher sample with highest lp_own.
Writes meta.json alongside the jsonl.
"""
from __future__ import annotations

import argparse
import gzip
import json
import sys
from pathlib import Path


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
    # Canonical body after open <think> (see evalsrv/chat.py inject_prompt).
    return f"</think>\nTHOUGHT: {z.strip()}\n\n{y.strip()}"


def main() -> None:
    ap = argparse.ArgumentParser()
    ap.add_argument("--duels-dir", type=Path, required=True)
    ap.add_argument("--turns", type=Path, required=True)
    ap.add_argument("--out", type=Path, required=True)
    ap.add_argument(
        "--glob",
        default="chal-*.json.gz",
        help="duel file glob under --duels-dir",
    )
    args = ap.parse_args()

    print(f"[harvest] indexing corpus {args.turns}", flush=True)
    corpus = load_corpus_index(args.turns)
    print(f"[harvest] corpus turns={len(corpus)}", flush=True)

    best_by_tid: dict[str, dict] = {}
    src_files = 0
    raw_samples = 0
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
    for tid, rec in sorted(best_by_tid.items()):
        prefix = corpus.get(tid)
        if prefix is None:
            missing += 1
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
            }
        )

    args.out.parent.mkdir(parents=True, exist_ok=True)
    with args.out.open("w") as f:
        for r in rows:
            f.write(json.dumps(r, ensure_ascii=False) + "\n")

    meta = {
        "duels_dir": str(args.duels_dir),
        "turns": str(args.turns),
        "out": str(args.out),
        "src_files": src_files,
        "raw_teacher_samples": raw_samples,
        "unique_turn_ids_with_refs": len(best_by_tid),
        "examples_written": len(rows),
        "missing_from_corpus": missing,
        "completion_format": "</think>\\nTHOUGHT: {z}\\n\\n{y}",
    }
    meta_path = args.out.with_suffix(".meta.json")
    meta_path.write_text(json.dumps(meta, indent=2))
    print(json.dumps(meta, indent=2), flush=True)
    if len(rows) < 50:
        print("[harvest] ERROR: too few examples", file=sys.stderr)
        sys.exit(2)


if __name__ == "__main__":
    main()
