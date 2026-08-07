#!/usr/bin/env bash
# Sidecar: when live start_*_n80.sh dies without a decision, launch retry_*_n80.sh.
# Do NOT edit the live start_*.sh (bash-by-offset LESSON). Args: <hyp> <retry_script>
set -euo pipefail

HYP=${1:?hyp id e.g. h10}
RETRY=${2:?path to retry_*_n80.sh}
HOTKEY="local-${HYP}"
DEC="/root/affine_data/${HYP}_decision.json"
SIM="/root/affine_data/${HYP}_sim_result.json"
LOG="/root/logs/${HYP}_watch_retry.nohup"
POLL=${POLL_S:-30}

log() { echo "[${HYP}-watch-retry] $(date -u +%Y-%m-%dT%H:%M:%SZ) $*" | tee -a "$LOG"; }

mkdir -p /root/logs /root/affine_data
log "armed hyp=$HYP retry=$RETRY"

while true; do
  if [[ -f "$DEC" ]]; then
    log "decision present — exit"
    exit 0
  fi
  if [[ -f "$SIM" ]]; then
    log "sim result present without decision — write decision"
    # shellcheck disable=SC1091
    source /root/venv/bin/activate
    python3 /root/mining_src/s4-h2-merge/write_merge_decision.py \
      --hyp "$HYP" --sim-result "$SIM" --out "$DEC"
    date -u +%Y-%m-%dT%H:%M:%SZ > "/root/logs/${HYP}_n80.done"
    exit 0
  fi
  if pgrep -f "run_sim_duel.py .*${HOTKEY}" >/dev/null 2>&1; then
    sleep "$POLL"
    continue
  fi
  # also wait out parent start_* that may still be writing decision
  if pgrep -f "start_${HYP}_n80\\.sh|retry_${HYP}_n80\\.sh" >/dev/null 2>&1; then
    sleep "$POLL"
    continue
  fi
  log "no sim / no decision — launching retry"
  exec bash "$RETRY"
done
