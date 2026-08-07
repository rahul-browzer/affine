#!/usr/bin/env bash
# Wait for H1 LoRA train.done → merge → re-serve chall → sim vs kevin.
# Designed to run under nohup on mine-sim-1 so a Ralph pass gap cannot miss TTL.
set -euo pipefail

# shellcheck disable=SC1091
source /root/venv/bin/activate
if [[ -f /root/mine.env ]]; then
  # shellcheck disable=SC1091
  source /root/mine.env
fi

export HF_HOME=/root/hf
export PYTHONPATH=/root/mining_src/affine_pkg:/root/mining_src:${PYTHONPATH:-}

BASE=/root/hf/hub/models--kevin954--Affine-5dfqbbh8ev-sft/snapshots/6a5815fad8f4e34c983b1933c1fae5762fe25220
ADAPTER=/root/h1/train/adapter
MERGED=/root/h1/merged
TRAIN_DONE=/root/h1/train/train.done
SIM_OUT=/root/affine_data/h1_sim_result.json
MARKER=/root/logs/h1_pipeline.done

log() { echo "[h1-pipe] $(date -u +%Y-%m-%dT%H:%M:%SZ) $*"; }

if [[ -f "$MARKER" ]]; then
  log "already done ($(cat "$MARKER")); exit"
  exit 0
fi

log "waiting for $TRAIN_DONE (poll 30s)"
while [[ ! -f "$TRAIN_DONE" ]]; do
  # Bail if train pid died without writing done.
  if [[ -f /root/logs/h1_train.pid ]]; then
    tpid=$(cat /root/logs/h1_train.pid)
    if ! kill -0 "$tpid" 2>/dev/null && [[ ! -f "$TRAIN_DONE" ]]; then
      log "ERROR: train pid $tpid dead and no train.done"
      exit 1
    fi
  fi
  sleep 30
done
log "train.done present: $(cat "$TRAIN_DONE")"

# Ensure train process has fully exited so adapter flush is complete.
if [[ -f /root/logs/h1_train.pid ]]; then
  tpid=$(cat /root/logs/h1_train.pid)
  for _ in $(seq 1 60); do
    kill -0 "$tpid" 2>/dev/null || break
    sleep 2
  done
fi

if [[ ! -d "$ADAPTER" ]]; then
  log "ERROR: adapter dir missing at $ADAPTER"
  exit 1
fi

log "merge LoRA → $MERGED"
CUDA_VISIBLE_DEVICES= python3 /root/mining_src/s4-h1-sft/merge_lora.py \
  --base "$BASE" \
  --adapter "$ADAPTER" \
  --out "$MERGED"
log "merge DONE"

log "re-serve chall=$MERGED (king=kevin, teacher kept)"
MERGE="$MERGED" bash /root/mining_src/s4-h2-merge/restart_for_h2.sh
log "serve READY"

log "launch sim → $SIM_OUT"
python /root/mining_src/s4-h2-merge/run_sim_duel.py \
  --chall-repo "$MERGED" \
  --out "$SIM_OUT" \
  --hotkey local-h1-sim \
  --save-artifact \
  >>/root/logs/h1_sim.nohup 2>&1

date -u +%Y-%m-%dT%H:%M:%SZ >"$MARKER"
log "SIM_DONE → $SIM_OUT"
date -u +%Y-%m-%dT%H:%M:%SZ > /root/logs/h1_sim.done
