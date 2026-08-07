#!/usr/bin/env python3
"""Stage 4 local duel: challenger (candidate) vs king on public D.

Wraps evalsrv.dueling.run_duel against already-served vLLM ports.
Does NOT submit. Decision: margin > 0.04 + gates + H4 envelope.
"""
from __future__ import annotations

import argparse
import asyncio
import json
import sys
import time
from pathlib import Path

import tomllib

from affine.score import duel as score_duel  # noqa: F401 — import path check
from evalsrv.dueling import run_duel
from evalsrv.vllm_client import Served


def load_engine_cfg(toml_path: Path) -> dict:
    raw = tomllib.loads(toml_path.read_text())
    # Flatten the pieces run_duel expects (engine_cfg["duel"]).
    return {"duel": dict(raw["duel"]), "raw": raw}


async def main_async(args: argparse.Namespace) -> dict:
    engine = load_engine_cfg(args.toml)
    duel_cfg = engine["duel"]
    if args.n_turns is not None:
        duel_cfg["n_turns"] = int(args.n_turns)
        engine["duel"] = duel_cfg

    progress_state: dict[str, int] = {}

    def on_progress(name: str, done: int, total: int) -> None:
        progress_state[name] = done
        progress_state[f"{name}_total"] = total
        if done == total or done % 5 == 0:
            print(f"[sim] {name} {done}/{total}", flush=True)
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

    teacher = Served(name="teacher", repo=args.teacher_repo,
                     revision=None, port=args.teacher_port)
    king = Served(name="king", repo=args.king_repo,
                  revision=args.king_rev, port=args.king_port)
    chall = Served(name="challenger", repo=args.chall_repo,
                   revision=args.chall_rev, port=args.chall_port)

    corpus_info = {
        "corpus_epoch": 0,
        "manifest_sha256": args.manifest_sha or "",
    }
    t0 = time.time()
    verdict, artifact = await run_duel(
        engine,
        args.turns,
        king,
        chall,
        teacher,
        block_hash=args.block_hash,
        hotkey=args.hotkey,
        corpus_info=corpus_info,
        on_progress=on_progress,
    )
    out = {
        "elapsed_s": time.time() - t0,
        "king_repo": args.king_repo,
        "chall_repo": args.chall_repo,
        "block_hash": args.block_hash,
        "hotkey": args.hotkey,
        "verdict": verdict,
        "h4": {
            "chall_r": (verdict.get("challenger") or {}).get("calib_ratio"),
            "chall_baseline_abs": (verdict.get("challenger") or {}).get("baseline_abs"),
            "king_baseline_abs": (verdict.get("king") or {}).get("baseline_abs"),
        },
    }
    # Paired baseline ratio if both present.
    cb = out["h4"]["chall_baseline_abs"]
    kb = out["h4"]["king_baseline_abs"]
    if cb and kb and kb > 0:
        out["h4"]["base_x"] = cb / kb
    args.out.parent.mkdir(parents=True, exist_ok=True)
    args.out.write_text(json.dumps(out, indent=2, default=str))
    # Compact artifact sidecar (turn ids + summaries only by default).
    if args.save_artifact:
        art_path = args.out.with_name(args.out.stem + "_artifact.json")
        art_path.write_text(json.dumps(artifact, default=str))
        print(f"[sim] artifact -> {art_path}", flush=True)
    print(json.dumps({
        "wins": verdict.get("challenger_wins"),
        "margin": verdict.get("margin"),
        "z": verdict.get("z"),
        "se": verdict.get("se"),
        "king_S": (verdict.get("king") or {}).get("S"),
        "chall_S": (verdict.get("challenger") or {}).get("S"),
        "chall_valid": (verdict.get("challenger") or {}).get("valid"),
        "king_valid": (verdict.get("king") or {}).get("valid"),
        "h4": out["h4"],
        "out": str(args.out),
    }, indent=2), flush=True)
    return out


def main() -> None:
    ap = argparse.ArgumentParser()
    ap.add_argument("--turns", type=Path, default=Path("/root/affine_data/turns.jsonl"))
    ap.add_argument("--toml", type=Path, default=Path("/root/mining_src/affine_pkg/affine.toml"))
    ap.add_argument("--out", type=Path, default=Path("/root/affine_data/h2_sim_result.json"))
    ap.add_argument("--teacher-port", type=int, default=8000)
    ap.add_argument("--king-port", type=int, default=8001)
    ap.add_argument("--chall-port", type=int, default=8002)
    ap.add_argument("--teacher-repo", default="zai-org/GLM-4.5-Air-FP8")
    ap.add_argument("--king-repo", default="kevin954/Affine-5dfqbbh8ev-sft")
    ap.add_argument("--king-rev", default="6a5815fad8f4e34c983b1933c1fae5762fe25220")
    ap.add_argument("--chall-repo", default="/root/merges/h2-kp50",
                    help="local path or HF repo id served on chall port")
    ap.add_argument("--chall-rev", default=None)
    ap.add_argument("--block-hash", default="0" * 64,
                    help="fake reveal hash for local slice seed")
    ap.add_argument("--hotkey", default="local-h2-sim")
    ap.add_argument("--manifest-sha", default="")
    ap.add_argument("--save-artifact", action="store_true")
    ap.add_argument(
        "--n-turns",
        type=int,
        default=None,
        help="override duel.n_turns from toml (default: contract value)",
    )
    ap.add_argument(
        "--progress-out",
        type=Path,
        default=None,
        help="write sampling progress JSON for host harvest / TTL watch",
    )
    args = ap.parse_args()
    asyncio.run(main_async(args))


if __name__ == "__main__":
    main()
