#!/usr/bin/env bash
# H100/F4 pass376: GPU merge save hung on gocryptfs request_wait_answer
# (same failure mode as H95 p352). Kill hung merge+post_train, pause Tok DL
# to cut FS pressure, relaunch merge --device-map cpu, then resume post_train
# with SKIP_MERGE=1 once shards exist.
set -euo pipefail

EXP=/root/mining_src/s4-h100-f4-genesis-base
LOG=/root/logs/h100_merge_recover_pass376.nohup
PIDF=/root/logs/h100_merge_recover_pass376.pid
MERGED=/root/h100/merged
ADAPTER=/root/h100/train/adapter
BASE=/root/hf/hub/models--dendriteholdings--albedo-qwen3.6-35b-king-genesis/snapshots/abe89194d6addf82e71f3f1ba9fef94b05404abf

log() { echo "[h100-merge376] $(date -u +%Y-%m-%dT%H:%M:%SZ) $*" | tee -a "$LOG"; }

mkdir -p /root/logs /root/affine_data
: >"$LOG"
echo $$ >"$PIDF"

# --- kill hung merge + its post_train parent (by PID, never pkill -f) ---
MERGE_PID=$(ps -eo pid,cmd | awk '/[p]ython .*merge_lora.py --base .*h100\/merged/{print $1; exit}')
POST_PID=$(ps -eo pid,cmd | awk '/[b]ash .*s4-h100-f4-genesis-base\/post_train_pipeline\.sh/{print $1; exit}')
TOK_PID=$(ps -eo pid,cmd | awk '/[p]ython -$/ && /h100_tok_redownload/{print $1; exit}')
# tok is `python -` with stdout → h100_tok_redownload.nohup
if [[ -z "${TOK_PID:-}" ]]; then
  for p in /proc/[0-9]*; do
    pid=${p#/proc/}
    cmd=$(tr '\0' ' ' <"$p/cmdline" 2>/dev/null || true)
    [[ "$cmd" == "python - " || "$cmd" == "python -" ]] || continue
    out=$(readlink "$p/fd/1" 2>/dev/null || true)
    if [[ "$out" == *h100_tok_redownload* ]]; then
      TOK_PID=$pid
      break
    fi
  done
fi

log "found MERGE_PID=${MERGE_PID:-none} POST_PID=${POST_PID:-none} TOK_PID=${TOK_PID:-none}"

if [[ -n "${MERGE_PID:-}" ]]; then
  kill "$MERGE_PID" 2>/dev/null || true
  sleep 2
  kill -9 "$MERGE_PID" 2>/dev/null || true
  log "killed merge $MERGE_PID"
fi
if [[ -n "${POST_PID:-}" ]]; then
  # disarm EXIT abort trap side-effects: remove aborted if freshly written
  kill "$POST_PID" 2>/dev/null || true
  sleep 1
  kill -9 "$POST_PID" 2>/dev/null || true
  log "killed post_train $POST_PID"
fi
rm -f /root/logs/h100_pipeline.aborted

# Pause Tok DL so gocryptfs isn't dual-writing 50G+ shards (resume after merge).
TOK_PAUSED=0
if [[ -n "${TOK_PID:-}" ]]; then
  kill "$TOK_PID" 2>/dev/null || true
  sleep 1
  kill -9 "$TOK_PID" 2>/dev/null || true
  TOK_PAUSED=1
  echo "paused $(date -u +%Y-%m-%dT%H:%M:%SZ)" >/root/logs/h100_tok_paused_pass376
  log "paused Tok DL pid=$TOK_PID (will resume after CPU merge)"
fi

# Clear partial GPU save
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
# CPU merge — leave GPUs free; do not pin CUDA
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
date -u +%Y-%m-%dT%H:%M:%SZ >/root/logs/h100_merge.done
cp -f "$MERGED/merge_meta.json" /root/affine_data/h100_merge_meta.json 2>/dev/null || true
nshard=$(ls "$MERGED"/model-*-of-*.safetensors | wc -l)
log "merge.done shards=$nshard → resume post_train SKIP_MERGE=1"

# Resume Tok DL if we paused it (prewarm still needs /root/logs/tok331102.done)
if [[ "$TOK_PAUSED" == "1" ]]; then
  log "resuming Tok snapshot_download"
  echo "[p376] DOWNLOAD tok331102 resume after merge-recover" \
    >>/root/logs/h100_tok_redownload.nohup
  nohup python - <<'PY' >>/root/logs/h100_tok_redownload.nohup 2>&1 &
import os
from huggingface_hub import snapshot_download
os.environ.setdefault("HF_HOME", "/root/hf")
kpath = snapshot_download(
    "Tok331102/affine-5EqYW8McUc-af10",
    revision="eb8bf9a356a254f71faaa439e8abc3cfba572c53",
)
open("/root/logs/tok331102.done", "w").write(kpath + "\n")
print(f"[p376] DOWNLOAD tok331102 done -> {kpath}", flush=True)
PY
  echo $! >/root/logs/h100_tok_redownload.pid
  log "Tok DL relaunched pid=$(cat /root/logs/h100_tok_redownload.pid)"
fi

export SKIP_MERGE=1
export MERGE_DEVICE_MAP=cpu
export CUDA_VISIBLE_DEVICES=6,7
export SOFT_DEADLINE_UTC=2026-08-09T06:18:00Z
export DEADMAN_UTC=2026-08-09T06:48:00Z
nohup bash "$EXP/post_train_pipeline.sh" \
  >>/root/logs/h100_pipeline.nohup 2>&1 &
echo $! >/root/logs/h100_post_train.pid
log "post_train resumed pid=$(cat /root/logs/h100_post_train.pid) SKIP_MERGE=1"
log "DONE recover376"
