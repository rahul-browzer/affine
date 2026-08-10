#!/usr/bin/env python3
"""Join high-Reason completions to live corpus prefixes for R1 LoRA SFT.

Input: high_reason_za.jsonl rows {turn_id, reason, completion, ...}
Output: sft_high_reason.jsonl rows {turn_id, reason, messages, completion}
  messages = corpus prefix (ends on user) — same shape as teacher_refs SFT.
"""
from __future__ import annotations

import argparse
import json
import os
from pathlib import Path

import pandas as pd

from affine.config import load_config
from evalsrv.corpus import CorpusSync


def _row_to_dict(r: dict) -> dict:
    out = {}
    for k, v in r.items():
        if hasattr(v, "item"):
            try:
                v = v.item()
            except Exception:
                pass
        out[k] = v
    return out


def main() -> None:
    ap = argparse.ArgumentParser()
    ap.add_argument("--high-reason", type=Path, required=True)
    ap.add_argument("--out", type=Path, required=True)
    ap.add_argument(
        "--toml",
        type=Path,
        default=Path("/root/mining_src/affine_pkg/affine.toml"),
    )
    ap.add_argument(
        "--data-dir",
        type=Path,
        default=Path(os.environ.get("AFFINE_DATA_DIR", "/root/affine_data")),
    )
    ap.add_argument("--min-reason", type=float, default=0.0)
    ap.add_argument("--max-rows", type=int, default=0, help="0 = all")
    args = ap.parse_args()

    hr: list[dict] = []
    with args.high_reason.open() as f:
        for line in f:
            if not line.strip():
                continue
            r = json.loads(line)
            if float(r.get("reason") or 0.0) < args.min_reason:
                continue
            hr.append(r)
    hr.sort(key=lambda r: float(r["reason"]), reverse=True)
    if args.max_rows > 0:
        hr = hr[: args.max_rows]
    want = {r["turn_id"] for r in hr}
    print(f"[build-sft] high_reason={len(hr)} unique_turn_ids={len(want)}", flush=True)

    cfg = load_config(str(args.toml))
    corpus = CorpusSync(
        cfg.dataset.corpus_base_url, cfg.dataset.manifest_key, args.data_dir
    )
    if not corpus.ready:
        raise SystemExit("[build-sft] FATAL: corpus not ready")

    idx = pd.read_parquet(args.data_dir / "turns_index.parquet")
    idx = idx[idx["turn_id"].astype(str).isin(want)]
    by_id = {str(r["turn_id"]): _row_to_dict(r) for r in idx.to_dict("records")}
    print(f"[build-sft] index hits={len(by_id)}/{len(want)}", flush=True)

    # Materialize in chunk order for cache locality.
    index_rows = [by_id[tid] for tid in want if tid in by_id]
    index_rows.sort(key=lambda r: (r["chunk_key"], int(r["traj_line"]), int(r["turn_idx"])))
    mats = corpus.materialize_turns(index_rows)
    prefix_by_tid: dict[str, list] = {}
    for ir, mat in zip(index_rows, mats):
        tid = str(ir["turn_id"])
        prefix = mat.get("prefix") or []
        if not prefix or prefix[-1].get("role") != "user":
            continue
        prefix_by_tid[tid] = prefix

    out_rows: list[dict] = []
    missing = 0
    for r in hr:
        tid = r["turn_id"]
        prefix = prefix_by_tid.get(tid)
        if not prefix:
            missing += 1
            continue
        out_rows.append(
            {
                "turn_id": tid,
                "reason": float(r["reason"]),
                "side": r.get("side"),
                "challenge_id": r.get("challenge_id"),
                "messages": prefix,
                "completion": r["completion"],
            }
        )

    args.out.parent.mkdir(parents=True, exist_ok=True)
    with args.out.open("w") as f:
        for row in out_rows:
            f.write(json.dumps(row, ensure_ascii=False) + "\n")

    reasons = [float(r["reason"]) for r in out_rows]
    stats = {
        "n_out": len(out_rows),
        "n_in": len(hr),
        "missing_prefix": missing,
        "reason_mean": (sum(reasons) / len(reasons)) if reasons else None,
        "reason_max": max(reasons) if reasons else None,
        "out": str(args.out),
    }
    stats_path = args.out.with_name(args.out.stem + "_stats.json")
    stats_path.write_text(json.dumps(stats, indent=2))
    print(json.dumps(stats, indent=2), flush=True)


if __name__ == "__main__":
    main()
