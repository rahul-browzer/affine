#!/usr/bin/env bash
# CPU watcher: when chal-00463 (llorite/…-tpc9) publishes a duel gzip,
# recompute Reason = mean(lpC_yc_za − lpC_yc_e) per turn, paired vs Tok af10,
# stamp headroom_vs_3se. No GPU. Does not submit.
set -euo pipefail
LOG=/root/logs/watch_chal00463_reason.log
DONE=/root/logs/watch_chal00463_reason.done
PIDF=/root/logs/watch_chal00463_reason.pid
OUT=${OUT:-/root/affine_data/chal00463_reason.json}
CHAL=${CHAL:-chal-00463}
KING_REPO=${KING_REPO:-Tok331102/affine-5EqYW8McUc-af10}
KING_REV=${KING_REV:-eb8bf9a356a254f71faaa439e8abc3cfba572c53}
BASE=${BASE:-https://s3.hippius.com/affine-sn120}
mkdir -p /root/logs /root/affine_data
echo $$ >"$PIDF"
exec > >(tee -a "$LOG") 2>&1

echo "[watch-463] $(date -u +%Y-%m-%dT%H:%M:%SZ) start chal=$CHAL"
if [[ -f "$DONE" && -f "$OUT" ]]; then
  echo "[watch-463] already done: $(cat "$DONE")"
  exit 0
fi

# shellcheck disable=SC1091
source /root/venv/bin/activate

export CHAL KING_REPO KING_REV BASE OUT DONE
python - <<'PY'
import gzip, io, json, math, statistics, time, urllib.request
from pathlib import Path

chal = __import__("os").environ["CHAL"]
king_repo = __import__("os").environ["KING_REPO"]
king_rev = __import__("os").environ["KING_REV"]
base = __import__("os").environ["BASE"].rstrip("/")
out = Path(__import__("os").environ["OUT"])
done = Path(__import__("os").environ["DONE"])

def fetch_bytes(url: str) -> bytes:
    req = urllib.request.Request(url, headers={"User-Agent": "mine-crown-watch/1"})
    with urllib.request.urlopen(req, timeout=60) as r:
        return r.read()

def reason_of_row(row: dict) -> float | None:
    vals = []
    for p in row.get("pairs") or []:
        a, b = p.get("lpC_yc_za"), p.get("lpC_yc_e")
        if a is None or b is None:
            continue
        try:
            vals.append(float(a) - float(b))
        except (TypeError, ValueError):
            continue
    if not vals:
        return None
    return statistics.fmean(vals)

def score_duel(raw: bytes) -> dict:
    d = json.loads(gzip.GzipFile(fileobj=io.BytesIO(raw)).read())
    req = d.get("request") or {}
    v = d.get("verdict") or {}
    k_repo = req.get("king_repo") or (d.get("king") or {}).get("repo")
    k_rev = req.get("king_revision") or (d.get("king") or {}).get("revision")
    c_repo = req.get("challenger_repo") or req.get("repo")
    c_rev = req.get("challenger_revision") or req.get("revision")
    by_turn_k, by_turn_c = {}, {}
    for row in d.get("king_rows") or []:
        tid = row.get("turn_id")
        r = reason_of_row(row)
        if tid is not None and r is not None:
            by_turn_k[tid] = r
    for row in d.get("challenger_rows") or []:
        tid = row.get("turn_id")
        r = reason_of_row(row)
        if tid is not None and r is not None:
            by_turn_c[tid] = r
    deltas = [by_turn_c[t] - by_turn_k[t] for t in by_turn_c if t in by_turn_k]
    n = len(deltas)
    if n == 0:
        raise RuntimeError("no paired turns with Reason components")
    margin = statistics.fmean(deltas)
    if n > 1:
        se = statistics.stdev(deltas) / math.sqrt(n)
    else:
        se = float("inf")
    three_se = 3.0 * se
    hr = (margin / three_se) if three_se and three_se > 0 else None
    z = (margin / se) if se and se > 0 else None
    return {
        "challenge_id": chal,
        "king_repo": k_repo,
        "king_revision": k_rev,
        "challenger_repo": c_repo,
        "challenger_revision": c_rev,
        "published_margin": v.get("margin"),
        "published_z": v.get("z"),
        "published_formula": v.get("ranking_formula"),
        "challenger_wins": v.get("challenger_wins"),
        "reason_margin": margin,
        "reason_se": se,
        "reason_z": z,
        "three_se": three_se,
        "headroom_vs_3se": hr,
        "n_paired": n,
        "king_match": (k_repo == king_repo and (not k_rev or k_rev.startswith(king_rev[:12]) or k_rev == king_rev)),
        "scored_at": time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime()),
        "source_url": f"{base}/evals/{chal}.json.gz",
    }

url = f"{base}/evals/{chal}.json.gz"
hist_url = f"https://affine.io/api/v1/history?q={chal}&limit=5"
print(f"[watch-463] polling {url} (+ history fast-path)", flush=True)

def try_history() -> dict | None:
    """Stamp Reason gate from published margin/se when gzip not up yet."""
    try:
        raw = fetch_bytes(hist_url)
        payload = json.loads(raw.decode("utf-8"))
    except Exception:
        return None
    for item in payload.get("items") or []:
        if item.get("challenge_id") != chal or item.get("event") != "verdict":
            continue
        margin = item.get("margin")
        se = item.get("se")
        if margin is None or se is None:
            continue
        try:
            margin_f = float(margin)
            se_f = float(se)
        except (TypeError, ValueError):
            continue
        three_se = 3.0 * se_f
        hr = (margin_f / three_se) if three_se > 0 else None
        z = (margin_f / se_f) if se_f > 0 else None
        return {
            "challenge_id": chal,
            "king_repo": king_repo,
            "king_revision": king_rev,
            "challenger_repo": item.get("repo"),
            "challenger_revision": item.get("revision"),
            "published_margin": margin_f,
            "published_z": item.get("z"),
            "published_formula": None,
            "challenger_wins": item.get("challenger_wins"),
            "reason_margin": margin_f,
            "reason_se": se_f,
            "reason_z": z,
            "three_se": three_se,
            "headroom_vs_3se": hr,
            "n_paired": item.get("n_paired_turns"),
            "king_match": True,
            "scored_at": time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime()),
            "source_url": hist_url,
            "source": "history_api",
        }
    return None

for i in range(1, 2880):  # ~8h @10s
    try:
        hist = try_history()
        if hist is not None:
            out.write_text(json.dumps(hist, indent=2) + "\n")
            hr = hist.get("headroom_vs_3se")
            line = (
                f"OK {hist['scored_at']} hr={hr} margin={hist['reason_margin']} "
                f"n={hist.get('n_paired')} repo={hist.get('challenger_repo')} src=history"
            )
            done.write_text(line + "\n")
            print(f"[watch-463] {line}", flush=True)
            raise SystemExit(0)
        raw = fetch_bytes(url)
        print(f"[watch-463] got {len(raw)} bytes at iter={i}", flush=True)
        result = score_duel(raw)
        out.write_text(json.dumps(result, indent=2) + "\n")
        hr = result.get("headroom_vs_3se")
        line = (
            f"OK {result['scored_at']} hr={hr} margin={result['reason_margin']} "
            f"n={result['n_paired']} repo={result.get('challenger_repo')}"
        )
        done.write_text(line + "\n")
        print(f"[watch-463] {line}", flush=True)
        raise SystemExit(0)
    except SystemExit:
        raise
    except Exception as e:
        if i % 12 == 0:
            print(f"[watch-463] wait iter={i} err={type(e).__name__}: {e}", flush=True)
        time.sleep(10)
print("[watch-463] TIMEOUT", flush=True)
raise SystemExit(2)
PY
