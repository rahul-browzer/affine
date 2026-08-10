#!/usr/bin/env python3
"""Harvest high-Reason (z_A) chat rows from public duel gzips for R1 SFT.

Reason per pair = lpC(y_C|z_A) - lpC(y_C|empty) = lpC_yc_za - lpC_yc_e.
Keeps king (or challenger) thoughts that raise teacher lp on y_C.
Does not use L1lift / lpA as selection criteria.
"""
from __future__ import annotations

import argparse
import gzip
import json
import urllib.request
from collections import defaultdict
from pathlib import Path

BASE = "https://s3.hippius.com/affine-sn120"


def reason_pair(p: dict) -> float | None:
    a, b = p.get("lpC_yc_za"), p.get("lpC_yc_e")
    if a is None or b is None:
        return None
    try:
        return float(a) - float(b)
    except (TypeError, ValueError):
        return None


def completion_from_za(z_a: str, y_a: str) -> str | None:
    z = (z_a or "").strip()
    y = (y_a or "").strip()
    if not z or not y or not y.startswith("```bash"):
        return None
    # Rows already embed <think>/THOUGHT in some kings; normalize lightly.
    if z.startswith("<think>"):
        body = z
        if "THOUGHT:" not in body:
            body = body.replace("<think>", "<think>\nTHOUGHT:", 1)
        return f"{body}\n\n{y}"
    return f"</think>\nTHOUGHT: {z}\n\n{y}"


def fetch(url: str, dest: Path) -> None:
    dest.parent.mkdir(parents=True, exist_ok=True)
    if dest.exists() and dest.stat().st_size > 0:
        return
    tmp = dest.with_suffix(dest.suffix + ".part")
    urllib.request.urlretrieve(url, tmp)
    tmp.replace(dest)


def load_index(path: Path) -> list[dict]:
    rows = []
    with path.open() as f:
        for line in f:
            line = line.strip()
            if line:
                rows.append(json.loads(line))
    return rows


def extract_from_duel(
    path: Path,
    *,
    side: str,
    min_reason: float,
) -> list[dict]:
    with gzip.open(path, "rt") as f:
        d = json.load(f)
    v = d.get("verdict") or {}
    formula = str(v.get("ranking_formula") or "")
    key = "king_rows" if side == "king" else "challenger_rows"
    out: list[dict] = []
    for row in d.get(key) or []:
        tid = row.get("turn_id")
        for p in row.get("pairs") or []:
            r = reason_pair(p)
            if r is None or r < min_reason:
                continue
            comp = completion_from_za(p.get("z_a") or "", p.get("y_a") or "")
            if not comp:
                continue
            out.append(
                {
                    "turn_id": tid,
                    "side": side,
                    "reason": r,
                    "challenge_id": d.get("job_id") or path.stem.replace(".json", ""),
                    "ranking_formula": formula,
                    "completion": comp,
                    "z_a": p.get("z_a"),
                    "y_a": p.get("y_a"),
                }
            )
    return out


def main() -> None:
    ap = argparse.ArgumentParser()
    ap.add_argument("--out-dir", type=Path, default=Path("/root/r1_data"))
    ap.add_argument("--side", choices=("king", "challenger", "both"), default="king")
    ap.add_argument("--min-reason", type=float, default=0.0)
    ap.add_argument("--top-n-duels", type=int, default=40)
    ap.add_argument("--max-rows", type=int, default=4000)
    args = ap.parse_args()

    out_dir = args.out_dir
    duel_dir = out_dir / "duels"
    out_dir.mkdir(parents=True, exist_ok=True)

    idx_path = out_dir / "evals_index.jsonl"
    print(f"[harvest] fetching index → {idx_path}", flush=True)
    fetch(f"{BASE}/evals/index.jsonl", idx_path)
    index = load_index(idx_path)
    # Prefer scored duels with positive margin / high |z|; skip rejections.
    scored = [
        r
        for r in index
        if r.get("rejection_reason") in (None, "")
        and r.get("margin") is not None
        and r.get("key")
    ]
    scored.sort(key=lambda r: float(r.get("z") or 0.0), reverse=True)
    pick = scored[: args.top_n_duels]
    print(f"[harvest] index={len(index)} scored={len(scored)} pick={len(pick)}", flush=True)

    sides = ["king", "challenger"] if args.side == "both" else [args.side]
    rows: list[dict] = []
    for meta in pick:
        key = meta["key"]
        dest = duel_dir / Path(key).name
        url = f"{BASE}/{key}"
        try:
            fetch(url, dest)
        except Exception as e:
            print(f"[harvest] skip {key}: {e}", flush=True)
            continue
        for side in sides:
            got = extract_from_duel(dest, side=side, min_reason=args.min_reason)
            rows.extend(got)
            print(f"[harvest] {dest.name} {side} +{len(got)}", flush=True)

    # Dedupe by turn_id keeping max Reason.
    best: dict[str, dict] = {}
    for r in rows:
        tid = r.get("turn_id") or ""
        prev = best.get(tid)
        if prev is None or float(r["reason"]) > float(prev["reason"]):
            best[tid] = r
    uniq = sorted(best.values(), key=lambda r: float(r["reason"]), reverse=True)
    uniq = uniq[: args.max_rows]

    out_jsonl = out_dir / "high_reason_za.jsonl"
    with out_jsonl.open("w") as f:
        for r in uniq:
            # Chat-SFT-friendly: completion only; train script can wrap with prefix.
            f.write(
                json.dumps(
                    {
                        "turn_id": r["turn_id"],
                        "reason": r["reason"],
                        "side": r["side"],
                        "challenge_id": r["challenge_id"],
                        "completion": r["completion"],
                    },
                    ensure_ascii=False,
                )
                + "\n"
            )

    reasons = [float(r["reason"]) for r in uniq]
    stats = {
        "n_rows": len(uniq),
        "n_raw": len(rows),
        "n_duels": len(pick),
        "min_reason_filter": args.min_reason,
        "reason_min": min(reasons) if reasons else None,
        "reason_max": max(reasons) if reasons else None,
        "reason_mean": (sum(reasons) / len(reasons)) if reasons else None,
        "out": str(out_jsonl),
    }
    (out_dir / "high_reason_za_stats.json").write_text(json.dumps(stats, indent=2))
    print(json.dumps(stats, indent=2), flush=True)


if __name__ == "__main__":
    main()
