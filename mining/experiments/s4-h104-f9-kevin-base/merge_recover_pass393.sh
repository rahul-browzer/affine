#!/usr/bin/env bash
# H104/F9 pass393: GPU merge save hung on gocryptfs request_wait_answer
# (.tmpXtu1cz stuck 49739502312 B; WCHAN=request_wait_answer; GPUs 6,7 ~34GiB 0%).
# Kill hung merge+post_train, relaunch --device-map cpu, resume SKIP_MERGE=1.
# Teacher:8000 + king:8001 already live.
set -euo pipefail

EXP=/root/mining_src/s4-h104-f9-kevin-base
LOG=/root/logs/h104_merge_recover_pass393.nohup
PIDF=/root/logs/h104_merge_recover_pass393.pid
MERGED=/root/h104/merged
ADAPTER=/root/h104/train/adapter
BASE=/root/hf/hub/models--kevin954--Affine-5dfqbbh8ev-sft/snapshots/3fb79cfbf3a21c7a2d2cf3ac5161a9a46277c152

log() { echo "[h104-merge393] $(date -u +%Y-%m-%dT%H:%M:%SZ) $*" | tee -a "$LOG"; }

mkdir -p /root/logs /root/affine_data
: >"$LOG"
echo $$ >"$PIDF"

MERGE_PID=$(ps -eo pid,cmd | awk '/[p]ython .*merge_lora.py --base .*h104\/merged/{print $1; exit}')
POST_PID=$(ps -eo pid,cmd | awk '/[b]ash .*s4-h104-f9-kevin-base\/post_train_pipeline\.sh/{print $1; exit}')

log "found MERGE_PID=${MERGE_PID:-none} POST_PID=${POST_PID:-none}"

if [[ -n "${MERGE_PID:-}" ]]; then
  kill "$MERGE_PID" 2>/dev/null || true
  sleep 2
  kill -9 "$MERGE_PID" 2>/dev/null || true
  log "killed merge $MERGE_PID"
fi
if [[ -n "${POST_PID:-}" ]]; then
  kill "$POST_PID" 2>/dev/null || true
  sleep 1
  kill -9 "$POST_PID" 2>/dev/null || true
  log "killed post_train $POST_PID"
fi
rm -f /root/logs/h104_pipeline.aborted

# Free GPUs 6,7 after hung merge held ~34GiB each
sleep 5
nvidia-smi --query-gpu=index,memory.used --format=csv,noheader | tee -a "$LOG"

rm -rf "$MERGED"
mkdir -p "$MERGED"

if [[ ! -f "$ADAPTER/adapter_config.json" ]]; then
  log "ERROR: no adapter at $ADAPTER"
  exit 1
fi

# shellcheck disable=SC1091
source /root/venv/bin/activate
if [[ -f /root/mine.env ]]; then
  set -a
  # shellcheck disable=SC1091
  source /root/mine.env
  set +a
fi
export HF_HOME=${HF_HOME:-/root/hf}
export PYTHONPATH=/root/mining_src/affine_pkg:${PYTHONPATH:-}
unset CUDA_VISIBLE_DEVICES || true

log "CPU merge start base=$BASE adapter=$ADAPTER out=$MERGED"
python /root/mining_src/s4-h1-sft/merge_lora.py \
  --base "$BASE" \
  --adapter "$ADAPTER" \
  --out "$MERGED" \
  --device-map cpu \
  2>&1 | tee -a "$LOG"
log "CPU merge finished"

if [[ ! -f "$MERGED/config.json" ]] \
  || ! ls "$MERGED"/model-*-of-*.safetensors >/dev/null 2>&1; then
  log "ERROR: merge incomplete"
  exit 1
fi
date -u +%Y-%m-%dT%H:%M:%SZ >/root/logs/h104_merge.done
cp -f "$MERGED/merge_meta.json" /root/affine_data/h104_merge_meta.json 2>/dev/null || true
nshard=$(ls "$MERGED"/model-*-of-*.safetensors | wc -l)
log "merge.done shards=$nshard → resume post_train SKIP_MERGE=1"

# Rearm preempt (prior watch timed out waiting for chall during hung merge)
if [[ -x "$EXP/watch_preempt_bare_tcache_pass264.sh" ]]; then
  nohup bash "$EXP/watch_preempt_bare_tcache_pass264.sh" \
    >>/root/logs/h104_preempt_bare_pass264.log 2>&1 &
  echo $! >/root/logs/h104_preempt_bare_pass264.pid
  log "rearmed preempt264 pid=$(cat /root/logs/h104_preempt_bare_pass264.pid)"
fi

export SKIP_MERGE=1
export MERGE_DEVICE_MAP=cpu
export CUDA_VISIBLE_DEVICES=6,7
export SOFT_DEADLINE_UTC=2026-08-09T08:12:00Z
export DEADMAN_UTC=2026-08-09T08:42:00Z
nohup bash "$EXP/post_train_pipeline.sh" \
  >>/root/logs/h104_pipeline.nohup 2>&1 &
echo $! >/root/logs/h104_post_train.pid
log "post_train resumed pid=$(cat /root/logs/h104_post_train.pid) SKIP_MERGE=1"
log "DONE recover393"
