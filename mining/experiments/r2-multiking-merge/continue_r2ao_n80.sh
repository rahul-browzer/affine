#!/usr/bin/env bash
# p2033: R2ao waiter died after engines 200/200/200 (bash re-read mid-script
# when orphan-kill was patched). TKC already serving af17 — run n80 only.
# Do NOT kill chall / teacher / king.
set -euo pipefail
LOG=/root/logs/r2ao_af17_reload.log
DONE=/root/logs/r2ao_af17_reload.done
PIDF=/root/logs/r2ao_af17_reload.pid
HOLDING=${HOLDING:-/root/logs/r2ao_af17_holding.stamp}
LINK=${LINK:-/tmp/r2ao_af17}
mkdir -p /root/logs /root/affine_data
echo $$ >"$PIDF"
exec > >(tee -a "$LOG") 2>&1

echo "[r2ao-af17-cont] $(date -u +%Y-%m-%dT%H:%M:%SZ) start (n80 only)"
if [[ -f "$DONE" ]]; then
  echo "[r2ao-af17-cont] already done: $(cat "$DONE")"
  exit 0
fi
if [[ -f /root/affine_data/r2ao_af17_decision.json ]]; then
  echo "[r2ao-af17-cont] decision already present; stamping DONE"
  echo "OK $(date -u +%Y-%m-%dT%H:%M:%SZ)" >"$DONE"
  cp -f "$DONE" /root/affine_data/r2ao_af17_reload.done 2>/dev/null || true
  exit 0
fi

# shellcheck disable=SC1091
source /root/venv/bin/activate
if [[ -f /root/mine.env ]]; then
  set -a
  # shellcheck disable=SC1091
  source /root/mine.env
  set +a
fi
export PYTHONPATH=/root/mining_src/affine_pkg${PYTHONPATH:+:$PYTHONPATH}
export AFFINE_DATA_DIR=${AFFINE_DATA_DIR:-/root/affine_data}
export HF_HOME=${HF_HOME:-/root/hf}
PY=/root/venv/bin/python

c0=$($PY - <<'PY'
import urllib.request
try:
    urllib.request.urlopen("http://127.0.0.1:8000/v1/models", timeout=3).status
    print(200)
except Exception:
    print(0)
PY
)
c1=$($PY - <<'PY'
import urllib.request
try:
    urllib.request.urlopen("http://127.0.0.1:8001/v1/models", timeout=3).status
    print(200)
except Exception:
    print(0)
PY
)
c2=$($PY - <<'PY'
import urllib.request
try:
    urllib.request.urlopen("http://127.0.0.1:8002/v1/models", timeout=3).status
    print(200)
except Exception:
    print(0)
PY
)
echo "[r2ao-af17-cont] engines codes=${c0}/${c1}/${c2}"
if [[ "$c0$c1$c2" != "200200200" ]]; then
  echo "[r2ao-af17-cont] FATAL need 200/200/200 before n80" >&2
  exit 2
fi
if [[ ! -e "$LINK" ]]; then
  echo "[r2ao-af17-cont] FATAL missing chall link $LINK" >&2
  exit 2
fi
date -u +%Y-%m-%dT%H:%M:%SZ >"$HOLDING"

OUT=/root/affine_data/r2ao_af17_reason_sim.json
DEC=/root/affine_data/r2ao_af17_decision.json
PROG=/root/affine_data/r2ao_af17_reason_progress.json
rm -f "$OUT" "$DEC" "$PROG"
BH=$($PY - <<'PY'
import hashlib, time
print(hashlib.sha256(f"r2ao-af17-{time.time_ns()}".encode()).hexdigest())
PY
)

echo "[r2ao-af17-cont] launching R2ao n80 block_hash=${BH:0:16}"
$PY /root/mining_src/r1-reason-distill/run_reason_sim.py \
  --n-turns 80 \
  --block-hash "$BH" \
  --hotkey "local-r2ao-af17-$(date -u +%Y%m%dT%H:%M:%SZ)" \
  --king-repo Tok331102/affine-5EqYW8McUc-af10 \
  --king-rev eb8bf9a356a254f71faaa439e8abc3cfba572c53 \
  --chall-repo "$LINK" \
  --out "$OUT" \
  --progress-out "$PROG" \
  --save-artifact \
  2>&1 | tee /root/logs/r2ao_af17_reason_sim.log

$PY /root/mining_src/r1-reason-distill/write_reason_decision.py \
  --sim-result "$OUT" --out "$DEC" --hyp R2ao \
  2>&1 | tee -a /root/logs/r2ao_af17_reason_sim.log

echo "[r2ao-af17-cont] DONE $(date -u +%Y-%m-%dT%H:%M:%SZ)"
cat "$DEC"
echo "OK $(date -u +%Y-%m-%dT%H:%M:%SZ)" >"$DONE"
cp -f "$DEC" /root/logs/r2ao_af17_decision.json 2>/dev/null || true
cp -f "$DONE" /root/affine_data/r2ao_af17_reload.done 2>/dev/null || true
