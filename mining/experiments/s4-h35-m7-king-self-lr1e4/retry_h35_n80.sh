#!/usr/bin/env bash
# Restart H35 n80 after crash. Engines must already be up.
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
MERGED=${MERGED:-/root/h35/merged}
SIM=/root/affine_data/h35_sim_result.json
PROG=/root/affine_data/h35_sim_progress.json
DEC=/root/affine_data/h35_decision.json
LOG=/root/logs/h35_n80_retry.nohup
MAX_ATTEMPTS=${MAX_ATTEMPTS:-3}

log() { echo "[h35-n80-retry] $(date -u +%Y-%m-%dT%H:%M:%SZ) $*" | tee -a "$LOG"; }

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
    --hyp h35 --sim-result "$SIM" --out "$DEC"
  date -u +%Y-%m-%dT%H:%M:%SZ > /root/logs/h35_n80.done
  exit 0
fi
if pgrep -f "run_sim_duel.py .*local-h35" >/dev/null 2>&1; then
  log "sim already running — noop"
  exit 0
fi
if ! _engines_ok; then
  log "ABORT: engines not healthy"
  echo "aborted_engines_unhealthy $(date -u +%Y-%m-%dT%H:%M:%SZ)" \
    >/root/logs/h35_n80_retry.aborted
  exit 1
fi
test -d "$MERGED"
test -f /root/logs/h35_merge.done

for attempt in $(seq 1 "$MAX_ATTEMPTS"); do
  rm -f "$SIM" "$PROG"
  log "n80 attempt $attempt/$MAX_ATTEMPTS"
  set +e
  python /root/mining_src/s4-h2-merge/run_sim_duel.py \
    --king-repo "$KING_REPO" \
    --king-rev "$KING_REV" \
    --chall-repo "$MERGED" \
    --chall-rev local \
    --n-turns 80 \
    --hotkey local-h35 \
    --out "$SIM" \
    --progress-out "$PROG" \
    --save-artifact \
    2>&1 | tee /root/logs/h35_n80.log
  rc=${PIPESTATUS[0]}
  set -e
  if [[ $rc -eq 0 && -f "$SIM" ]]; then
    python3 /root/mining_src/s4-h2-merge/write_merge_decision.py \
      --hyp h35 --sim-result "$SIM" --out "$DEC"
    date -u +%Y-%m-%dT%H:%M:%SZ > /root/logs/h35_n80.done
    log "N80_DONE"
    exit 0
  fi
  log "WARN attempt $attempt failed rc=$rc; sleep 30"
  sleep 30
  if ! _engines_ok; then
    log "ABORT: engines unhealthy mid-retry"
    echo "aborted_engines_unhealthy $(date -u +%Y-%m-%dT%H:%M:%SZ)" \
      >/root/logs/h35_n80_retry.aborted
    exit 1
  fi
done

log "ERROR: all $MAX_ATTEMPTS attempts failed"
echo "aborted_n80_retry_failed $(date -u +%Y-%m-%dT%H:%M:%SZ)" \
  >/root/logs/h35_n80_retry.aborted
exit 1
