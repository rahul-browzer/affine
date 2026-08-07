#!/usr/bin/env bash
# Restart H32 n80 after crash. Engines must already be up.
# 3× retry (LESSON: dual-side n80 can stall teacher sample even at 480s×5).
set -euo pipefail

# shellcheck disable=SC1091
source /root/venv/bin/activate
if [[ -f /root/mine.env ]]; then
  set -a
  # shellcheck disable=SC1091
  source /root/mine.env
  set +a
fi
export PYTHONPATH=/root/mining_src/affine_pkg${PYTHONPATH:+:$PYTHONPATH}
export HF_HOME=${HF_HOME:-/root/hf}

KING_REPO=${KING_REPO:-TalentPigs/affine-5ekxlcg3fx-abc}
KING_REV=${KING_REV:-dbfbb3e2a17c7603e7fc68a3a15b343f42dfdef4}
MERGED=${MERGED:-/root/h32/merged}
SIM=/root/affine_data/h32_sim_result.json
PROG=/root/affine_data/h32_sim_progress.json
DEC=/root/affine_data/h32_decision.json
LOG=/root/logs/h32_n80_retry.nohup
MAX_ATTEMPTS=${MAX_ATTEMPTS:-3}

log() { echo "[h32-n80-retry] $(date -u +%Y-%m-%dT%H:%M:%SZ) $*" | tee -a "$LOG"; }

_engines_ok() {
  local t k c
  t=$(curl -s -o /dev/null -w "%{http_code}" --max-time 3 http://127.0.0.1:8000/health || true)
  k=$(curl -s -o /dev/null -w "%{http_code}" --max-time 3 http://127.0.0.1:8001/health || true)
  c=$(curl -s -o /dev/null -w "%{http_code}" --max-time 3 http://127.0.0.1:8002/health || true)
  [[ "$t" == "200" && "$k" == "200" && "$c" == "200" ]]
}

mkdir -p /root/logs /root/affine_data

if [[ -f "$DEC" ]]; then
  log "decision already present — noop"
  exit 0
fi
if [[ -f "$SIM" ]]; then
  log "sim result present — writing decision only"
  python3 /root/mining_src/s4-h2-merge/write_merge_decision.py \
    --hyp h32 --sim-result "$SIM" --out "$DEC"
  date -u +%Y-%m-%dT%H:%M:%SZ > /root/logs/h32_n80.done
  exit 0
fi
# Narrow match — pgrep -f false-matches SSH/bash cmdlines that embed the
# pattern (LESSON + H32 pass198).
if ps -eo pid,cmd | awk '/[r]un_sim_duel.py/ && /local-h32/ {found=1} END{exit !found}'; then
  log "sim already running — noop"
  exit 0
fi
if ! _engines_ok; then
  log "ABORT: engines not healthy"
  echo "aborted_engines_unhealthy $(date -u +%Y-%m-%dT%H:%M:%SZ)" \
    >/root/logs/h32_n80_retry.aborted
  exit 1
fi
test -d "$MERGED"

# Completions probe (health=200 ≠ promptable; also catches model-id 404).
_probe_ok() {
  python3 - <<'PY'
import json, urllib.request
for port in (8000, 8001, 8002):
    mid = json.load(urllib.request.urlopen(f"http://127.0.0.1:{port}/v1/models", timeout=5))["data"][0]["id"]
    req = urllib.request.Request(
        f"http://127.0.0.1:{port}/v1/completions",
        data=json.dumps({"model": mid, "prompt": "hi", "max_tokens": 1, "temperature": 0}).encode(),
        headers={"Content-Type": "application/json"},
        method="POST",
    )
    with urllib.request.urlopen(req, timeout=60) as r:
        if r.status != 200:
            raise SystemExit(1)
print("probe_ok")
PY
}

# Fresh block_hash per outer retry budget: default 0*64 slice hit a turn with
# prompt≈30977 + max_tokens 1792 > 32768 → teacher 400 → whole n80 dies
# (H32 pass198). Alternate seeds dodge that turn without changing scoring.
BLOCK_HASHES=(
  "a198000000000000000000000000000000000000000000000000000000000001"
  "b198000000000000000000000000000000000000000000000000000000000002"
  "c198000000000000000000000000000000000000000000000000000000000003"
)

for attempt in $(seq 1 "$MAX_ATTEMPTS"); do
  rm -f "$SIM" "$PROG"
  bh="${BLOCK_HASHES[$(( (attempt - 1) % ${#BLOCK_HASHES[@]} ))]}"
  log "n80 attempt $attempt/$MAX_ATTEMPTS block_hash=${bh:0:16}…"
  if ! _probe_ok; then
    log "WARN completions probe failed before attempt $attempt — continuing anyway"
  fi
  set +e
  python /root/mining_src/s4-h2-merge/run_sim_duel.py \
    --king-repo "$KING_REPO" \
    --king-rev "$KING_REV" \
    --chall-repo "$MERGED" \
    --chall-rev local \
    --n-turns 80 \
    --hotkey local-h32 \
    --block-hash "$bh" \
    --out "$SIM" \
    --progress-out "$PROG" \
    --save-artifact \
    2>&1 | tee /root/logs/h32_n80.log
  rc=${PIPESTATUS[0]}
  set -e
  if [[ $rc -eq 0 && -f "$SIM" ]]; then
    python3 /root/mining_src/s4-h2-merge/write_merge_decision.py \
      --hyp h32 --sim-result "$SIM" --out "$DEC"
    date -u +%Y-%m-%dT%H:%M:%SZ > /root/logs/h32_n80.done
    log "N80_DONE"
    exit 0
  fi
  log "WARN attempt $attempt failed rc=$rc; sleep 30"
  sleep 30
  if ! _engines_ok; then
    log "ABORT: engines unhealthy mid-retry"
    echo "aborted_engines_unhealthy $(date -u +%Y-%m-%dT%H:%M:%SZ)" \
      >/root/logs/h32_n80_retry.aborted
    exit 1
  fi
done

log "ERROR: all $MAX_ATTEMPTS attempts failed"
echo "aborted_n80_retry_failed $(date -u +%Y-%m-%dT%H:%M:%SZ)" \
  >/root/logs/h32_n80_retry.aborted
exit 1
