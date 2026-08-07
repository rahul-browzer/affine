#!/usr/bin/env bash
# Restart H6 mid50 n40 after httpx.ReadTimeout abort. Engines must already be up.
# Yields if final pipe writes h6_merge.done. Do NOT edit while live.
set -euo pipefail

# shellcheck disable=SC1091
source /root/venv/bin/activate
if [[ -f /root/mine.env ]]; then
  set -a
  # shellcheck disable=SC1091
  source /root/mine.env
  set +a
fi
export PYTHONPATH=/root/mining_src/affine_pkg:${PYTHONPATH:-}

KING_REPO=${KING_REPO:-TalentPigs/affine-5ekxlcg3fx-abc}
KING_REV=${KING_REV:-dbfbb3e2a17c7603e7fc68a3a15b343f42dfdef4}
MERGED=${MERGED:-/root/h6/merged_mid50}
SIM_N40=${SIM_N40:-/root/affine_data/h6_mid50_sim_n40.json}
PROG=${PROG:-/root/affine_data/h6_mid50_sim_progress.json}
LOG=/root/logs/h6_mid50_retry.nohup
MAX_ATTEMPTS=${MAX_ATTEMPTS:-3}

log() { echo "[h6-mid50-retry] $(date -u +%Y-%m-%dT%H:%M:%SZ) $*" | tee -a "$LOG"; }

_final_merge_done() { [[ -f /root/logs/h6_merge.done ]]; }

_engines_ok() {
  local t k c
  t=$(curl -s -o /dev/null -w "%{http_code}" --max-time 3 http://127.0.0.1:8000/health || true)
  k=$(curl -s -o /dev/null -w "%{http_code}" --max-time 3 http://127.0.0.1:8001/health || true)
  c=$(curl -s -o /dev/null -w "%{http_code}" --max-time 3 http://127.0.0.1:8002/health || true)
  [[ "$t" == "200" && "$k" == "200" && "$c" == "200" ]]
}

mkdir -p /root/logs /root/affine_data
rm -f /root/logs/h6_mid50_early.aborted /root/logs/h6_mid50_sim_n40.done

if _final_merge_done; then
  log "final merge already done — yield, no retry"
  echo "yielded_to_final_pipe $(date -u +%Y-%m-%dT%H:%M:%SZ)" \
    >/root/logs/h6_mid50_early.aborted
  exit 0
fi

if ! _engines_ok; then
  log "ABORT: engines not healthy t/k/c"
  echo "aborted_engines_unhealthy $(date -u +%Y-%m-%dT%H:%M:%SZ)" \
    >/root/logs/h6_mid50_early.aborted
  exit 1
fi

for attempt in $(seq 1 "$MAX_ATTEMPTS"); do
  if _final_merge_done; then
    log "YIELD during retry — h6_merge.done"
    echo "yielded_to_final_pipe $(date -u +%Y-%m-%dT%H:%M:%SZ)" \
      >/root/logs/h6_mid50_early.aborted
    exit 0
  fi
  rm -f "$SIM_N40" "$PROG"
  log "n40 attempt $attempt/$MAX_ATTEMPTS → $SIM_N40"
  set +e
  python /root/mining_src/s4-h2-merge/run_sim_duel.py \
    --king-repo "$KING_REPO" \
    --king-rev "$KING_REV" \
    --chall-repo "$MERGED" \
    --chall-rev local \
    --n-turns 40 \
    --hotkey local-h6-mid50 \
    --out "$SIM_N40" \
    --progress-out "$PROG" \
    --save-artifact \
    2>&1 | tee -a /root/logs/h6_mid50_sim.nohup &
  sim_pid=$!
  set -e
  while kill -0 "$sim_pid" 2>/dev/null; do
    if _final_merge_done; then
      log "YIELD: kill mid50 sim for final pipe"
      kill "$sim_pid" 2>/dev/null || true
      wait "$sim_pid" 2>/dev/null || true
      echo "yielded_to_final_pipe $(date -u +%Y-%m-%dT%H:%M:%SZ)" \
        >/root/logs/h6_mid50_early.aborted
      exit 0
    fi
    sleep 15
  done
  wait "$sim_pid" || true
  sim_rc=$?
  if [[ -f "$SIM_N40" ]]; then
    date -u +%Y-%m-%dT%H:%M:%SZ > /root/logs/h6_mid50_sim_n40.done
    date -u +%Y-%m-%dT%H:%M:%SZ > /root/logs/h6_mid50_early.done
    log "N40_DONE rc=$sim_rc (watcher writes decision)"
    exit 0
  fi
  log "WARN attempt $attempt failed rc=$sim_rc"
  sleep 10
done

log "ERROR: all $MAX_ATTEMPTS attempts failed"
echo "aborted_n40_retry_failed $(date -u +%Y-%m-%dT%H:%M:%SZ)" \
  >/root/logs/h6_mid50_early.aborted
exit 1
