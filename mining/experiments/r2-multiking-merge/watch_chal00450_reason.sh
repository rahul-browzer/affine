#!/usr/bin/env bash
# CPU watcher: when chal-00450 (syntaxsorcerer1/…-sft3) publishes a duel gzip,
# recompute Reason = mean(lpC_yc_za − lpC_yc_e) per turn, paired vs Tok af10,
# stamp headroom_vs_3se. Gates possible Talent×sft3 merge after Reason+ without waiting for
# the next Ralph pass. No GPU. Does not submit.
set -euo pipefail
LOG=/root/logs/watch_chal00450_reason.log
DONE=/root/logs/watch_chal00450_reason.done
PIDF=/root/logs/watch_chal00450_reason.pid
OUT=${OUT:-/root/affine_data/chal00450_reason.json}
CHAL=${CHAL:-chal-00450}
KING_REPO=${KING_REPO:-Tok331102/affine-5EqYW8McUc-af10}
KING_REV=${KING_REV:-eb8bf9a356a254f71faaa439e8abc3cfba572c53}
BASE=${BASE:-https://s3.hippius.com/affine-sn120}
mkdir -p /root/logs /root/affine_data
echo $$ >"$PIDF"
exec > >(tee -a "$LOG") 2>&1

echo "[watch-450] $(date -u +%Y-%m-%dT%H:%M:%SZ) start chal=$CHAL"
if [[ -f "$DONE" && -f "$OUT" ]]; then
  echo "[watch-450] already done: $(cat "$DONE")"
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
print(f"[watch-450] polling {url}", flush=True)
for i in range(1, 2880):  # ~8h @10s
    try:
        raw = fetch_bytes(url)
        print(f"[watch-450] got {len(raw)} bytes at iter={i}", flush=True)
        result = score_duel(raw)
        out.write_text(json.dumps(result, indent=2) + "\n")
        hr = result.get("headroom_vs_3se")
        line = (
            f"OK {result['scored_at']} hr={hr} margin={result['reason_margin']} "
            f"n={result['n_paired']} repo={result.get('challenger_repo')}"
        )
        done.write_text(line + "\n")
        print(f"[watch-450] {line}", flush=True)
        raise SystemExit(0)
    except Exception as e:
        if i % 12 == 0:
            print(f"[watch-450] wait iter={i} err={type(e).__name__}: {e}", flush=True)
        time.sleep(10)
print("[watch-450] TIMEOUT", flush=True)
raise SystemExit(2)
PY
