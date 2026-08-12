#!/usr/bin/env python3
"""Reason v3 n=80 duel sim: challenger vs live king via evalsrv.run_duel.

Uses live CorpusSync (schema v2 Parquet index). Score path is affine.score
(Reason = lpC(y_C|z_A) − lpC(y_C|∅); crown = margin > 3·SE). No S* gates.
Does NOT submit.
"""
from __future__ import annotations

import argparse
import asyncio
import json
import os
import sys
import time
from pathlib import Path

import tomllib

from affine.config import load_config
from evalsrv.corpus import CorpusSync
from evalsrv.dueling import run_duel
from evalsrv.vllm_client import Served


def load_engine_cfg(toml_path: Path) -> dict:
    raw = tomllib.loads(toml_path.read_text())
    return {"duel": dict(raw["duel"]), "raw": raw}


async def main_async(args: argparse.Namespace) -> dict:
    engine = load_engine_cfg(args.toml)
    duel_cfg = engine["duel"]
    if args.n_turns is not None:
        duel_cfg["n_turns"] = int(args.n_turns)
        engine["duel"] = duel_cfg

    cfg = load_config(str(args.toml))
    data_dir = Path(os.environ.get("AFFINE_DATA_DIR", "/root/affine_data"))
    corpus = CorpusSync(
        cfg.dataset.corpus_base_url, cfg.dataset.manifest_key, data_dir
    )
    if not corpus.ready and not corpus.refresh():
        raise SystemExit("[reason-sim] FATAL: corpus not ready")
    info = corpus.info()
    print(f"[reason-sim] corpus {json.dumps(info)}", flush=True)

    progress_state: dict[str, int] = {}

    def on_progress(name: str, done: int, total: int) -> None:
        progress_state[name] = done
        progress_state[f"{name}_total"] = total
        if done == total or done % 5 == 0:
            print(f"[reason-sim] {name} {done}/{total}", flush=True)
        if args.progress_out:
            payload = {
                "utc": time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime()),
                "hotkey": args.hotkey,
                "chall_repo": args.chall_repo,
                "n_turns": duel_cfg.get("n_turns"),
                **progress_state,
            }
            args.progress_out.parent.mkdir(parents=True, exist_ok=True)
            args.progress_out.write_text(json.dumps(payload, indent=2))

    teacher = Served(
        name="teacher", repo=args.teacher_repo, revision=None, port=args.teacher_port
    )
    king = Served(
        name="king",
        repo=args.king_repo,
        revision=args.king_rev,
        port=args.king_port,
    )
    chall = Served(
        name="challenger",
        repo=args.chall_repo,
        revision=args.chall_rev,
        port=args.chall_port,
    )

    t0 = time.time()
    turns_path = data_dir / "turns.jsonl"
    verdict, artifact = await run_duel(
        engine,
        turns_path if turns_path.exists() else None,
        king,
        chall,
        teacher,
        block_hash=args.block_hash,
        hotkey=args.hotkey,
        corpus_info=info,
        on_progress=on_progress,
        corpus=corpus if corpus.schema_version >= 2 else None,
    )
    elapsed = time.time() - t0

    margin = verdict.get("margin")
    se = verdict.get("se")
    k_sigma = float(verdict.get("k_sigma") or duel_cfg.get("k_sigma") or 2.0)  # live contract 2026-08-11
    thresh = (k_sigma * se) if se is not None else None
    headroom = (margin / thresh) if (margin is not None and thresh and thresh > 0) else None
    chal = verdict.get("challenger") or {}
    king_s = verdict.get("king") or {}

    out = {
        "elapsed_s": elapsed,
        "contract": "Reason v3",
        "ranking_formula": verdict.get("ranking_formula"),
        "king_repo": args.king_repo,
        "king_rev": args.king_rev,
        "chall_repo": args.chall_repo,
        "chall_rev": args.chall_rev,
        "block_hash": args.block_hash,
        "hotkey": args.hotkey,
        "corpus": info,
        "verdict": verdict,
        "reason": {
            "margin": margin,
            "se": se,
            "z": verdict.get("z"),
            "k_sigma": k_sigma,
            "threshold_3se": thresh,
            "headroom_vs_3se": headroom,
            "submit_bar_1_5x": 1.5,
            "clears_3se": bool(verdict.get("challenger_wins")),
            "clears_1_5x_3se": bool(
                headroom is not None and headroom >= 1.5
            ),
            "reason_c": chal.get("reason"),
            "reason_k": king_s.get("reason"),
            "n_paired_turns": verdict.get("n_paired_turns"),
        },
    }
    args.out.parent.mkdir(parents=True, exist_ok=True)
    args.out.write_text(json.dumps(out, indent=2, default=str))
    if args.save_artifact:
        art_path = args.out.with_name(args.out.stem + "_artifact.json")
        art_path.write_text(json.dumps(artifact, default=str))
        print(f"[reason-sim] artifact -> {art_path}", flush=True)

    print(
        json.dumps(
            {
                "wins": verdict.get("challenger_wins"),
                "rejection_reason": verdict.get("rejection_reason"),
                **out["reason"],
                "out": str(args.out),
            },
            indent=2,
        ),
        flush=True,
    )
    return out


def main() -> None:
    ap = argparse.ArgumentParser()
    ap.add_argument(
        "--toml",
        type=Path,
        default=Path("/root/mining_src/affine_pkg/affine.toml"),
    )
    ap.add_argument(
        "--out",
        type=Path,
        default=Path("/root/affine_data/r1_reason_sim.json"),
    )
    ap.add_argument("--teacher-port", type=int, default=8000)
    ap.add_argument("--king-port", type=int, default=8001)
    ap.add_argument("--chall-port", type=int, default=8002)
    ap.add_argument("--teacher-repo", default="zai-org/GLM-4.5-Air-FP8")
    ap.add_argument(
        "--king-repo", default="Tok331102/affine-5EqYW8McUc-af10"
    )
    ap.add_argument(
        "--king-rev",
        default="eb8bf9a356a254f71faaa439e8abc3cfba572c53",
    )
    ap.add_argument(
        "--chall-repo",
        default="/tmp/h64_merged",
        help="local path or HF id served on chall port (H64 baseline)",
    )
    ap.add_argument("--chall-rev", default=None)
    ap.add_argument(
        "--block-hash",
        default="0" * 64,
        help="fake reveal hash for local slice seed",
    )
    ap.add_argument("--hotkey", default="local-r1-reason-sim")
    ap.add_argument("--n-turns", type=int, default=None)
    ap.add_argument("--save-artifact", action="store_true")
    ap.add_argument("--progress-out", type=Path, default=None)
    args = ap.parse_args()
    asyncio.run(main_async(args))


if __name__ == "__main__":
    main()
