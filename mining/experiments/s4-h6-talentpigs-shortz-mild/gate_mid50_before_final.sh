#!/usr/bin/env bash
# Hold post_train (SIGSTOP) until mid50 n40 finishes or MAX_WAIT, then SIGCONT.
# Mid50 is SIGNAL-only; final n80 is load-bearing. Avoid killing mid50 chall mid-sim.
set -euo pipefail
PIPE_PID=${1:-}
MAX_WAIT_S=${MAX_WAIT_S:-3600}
DECISION=/root/affine_data/h6_mid50_decision.json
SIM_OUT=/root/affine_data/h6_mid50_sim_n40.json
LOG=/root/logs/h6_gate_mid50.nohup
log() { echo "[h6-gate] $(date -u +%Y-%m-%dT%H:%M:%SZ) $*" | tee -a "$LOG"; }

if [[ -z "$PIPE_PID" ]]; then
  PIPE_PID=$(pgrep -f "bash /root/mining_src/s4-h6-talentpigs-shortz-mild/post_train_pipeline.sh" | head -1 || true)
fi
if [[ -z "${PIPE_PID:-}" ]]; then
  log "ERROR: no post_train pid"
  exit 1
fi

# Already done?
if [[ -f "$DECISION" ]] || [[ -f "$SIM_OUT" ]]; then
  log "mid50 already finished; no hold needed (pipe=$PIPE_PID)"
  exit 0
fi

# Mid50 sim running?
if ! pgrep -f "run_sim_duel.py .*local-h6-mid50" >/dev/null 2>&1; then
  log "mid50 sim not running; no hold (pipe=$PIPE_PID)"
  exit 0
fi

log "SIGSTOP post_train pid=$PIPE_PID until mid50 decision/sim or ${MAX_WAIT_S}s"
kill -STOP "$PIPE_PID" || { log "ERROR: SIGSTOP failed"; exit 1; }
echo "$PIPE_PID" > /root/logs/h6_gate_stopped.pid
date -u +%Y-%m-%dT%H:%M:%SZ > /root/logs/h6_gate_started

start=$(date -u +%s)
reason=""
while true; do
  if [[ -f "$DECISION" ]]; then reason=decision; break; fi
  if [[ -f "$SIM_OUT" ]]; then reason=sim_out; break; fi
  if ! pgrep -f "run_sim_duel.py .*local-h6-mid50" >/dev/null 2>&1 \
     && ! pgrep -f "retry_mid50_n40.sh" >/dev/null 2>&1; then
    reason=sim_gone
    break
  fi
  now=$(date -u +%s)
  if (( now - start >= MAX_WAIT_S )); then
    reason=timeout
    break
  fi
  sleep 20
done

log "release reason=$reason elapsed=$(( $(date -u +%s) - start ))s"
if kill -0 "$PIPE_PID" 2>/dev/null; then
  kill -CONT "$PIPE_PID" || true
  log "SIGCONT post_train pid=$PIPE_PID"
else
  log "WARN: post_train pid=$PIPE_PID gone before CONT"
fi
echo "$reason $(date -u +%Y-%m-%dT%H:%M:%SZ)" > /root/logs/h6_gate_released
rm -f /root/logs/h6_gate_stopped.pid
