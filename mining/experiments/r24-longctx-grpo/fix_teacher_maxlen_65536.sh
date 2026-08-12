#!/usr/bin/env bash
# R24 (mine-r3-grpo-1): teacher is stuck at max_model_len=32768 (prewarm legacy).
# Live contract / LESSONS require 65536 or n80 dies on ~31k prefixes.
# Wait for train.done (do not yank teacher mid-GRPO), then relaunch :8000 @65536.
set -euo pipefail

LOG=${LOG:-/root/logs/r24_fix_teacher_maxlen.nohup}
TRAIN_DONE=${TRAIN_DONE:-/root/r3/train/train.done}
TRAIN_PIDF=${TRAIN_PIDF:-/root/logs/r3_train.pid}
TEACHER_PIDF=${TEACHER_PIDF:-/root/logs/vllm_teacher.pid}
NEED_LEN=${NEED_LEN:-65536}
PORT=${PORT:-8000}

log() { echo "[r24-tmax] $(date -u +%Y-%m-%dT%H:%M:%SZ) $*" | tee -a "$LOG"; }

_train_alive() {
  if [[ -f "$TRAIN_PIDF" ]]; then
    local tpid
    tpid=$(cat "$TRAIN_PIDF" 2>/dev/null || true)
    if [[ -n "${tpid:-}" ]] && kill -0 "$tpid" 2>/dev/null; then
      return 0
    fi
  fi
  return 1
}

_cur_len() {
  curl -sS --max-time 5 "http://127.0.0.1:${PORT}/v1/models" 2>/dev/null \
    | python3 -c 'import sys,json
try:
 d=json.load(sys.stdin); print(int((d.get("data") or [{}])[0].get("max_model_len") or 0))
except Exception:
 print(0)' || echo 0
}

mkdir -p /root/logs /root/affine_data
log "armed need_len=$NEED_LEN wait_for=$TRAIN_DONE"

# Already correct?
cur=$(_cur_len)
if [[ "$cur" -ge "$NEED_LEN" ]]; then
  log "teacher already max_model_len=$cur — nothing to do"
  echo "{\"utc\":\"$(date -u +%Y-%m-%dT%H:%M:%SZ)\",\"action\":\"skip\",\"max_model_len\":$cur}" \
    >/root/affine_data/r24_teacher_maxlen_fix.json
  exit 0
fi

log "current max_model_len=$cur — waiting for train.done (do not restart mid-score)"
_i=0
while [[ ! -f "$TRAIN_DONE" ]]; do
  if ! _train_alive && [[ -f /root/r3/train/adapter/adapter_config.json ]]; then
    log "train gone + adapter present without train.done — proceed"
    break
  fi
  _i=$((_i + 1))
  if (( _i % 20 == 0 )); then
    log "still waiting train.done poll=$_i alive=$(_train_alive && echo yes || echo no)"
  fi
  sleep 15
done

log "train gate cleared; waiting train pid exit"
for _ in $(seq 1 240); do
  _train_alive || break
  sleep 5
done
if _train_alive; then
  log "ERROR: train still alive after gate; abort teacher swap"
  exit 2
fi
sleep 5

cur=$(_cur_len)
if [[ "$cur" -ge "$NEED_LEN" ]]; then
  log "teacher already fixed to $cur before our kill — skip"
  echo "{\"utc\":\"$(date -u +%Y-%m-%dT%H:%M:%SZ)\",\"action\":\"skip_race\",\"max_model_len\":$cur}" \
    >/root/affine_data/r24_teacher_maxlen_fix.json
  exit 0
fi

old_pid=$(cat "$TEACHER_PIDF" 2>/dev/null || true)
if [[ -z "${old_pid:-}" ]]; then
  old_pid=$(pgrep -f "vllm serve zai-org/GLM-4.5-Air-FP8 --port ${PORT}" | head -1 || true)
fi
# Collect PIDs listening on :8000 + pidfile (never pkill -f — kills SSH scrapes).
mapfile -t _kill_pids < <(
  {
    [[ -n "${old_pid:-}" ]] && echo "$old_pid"
    if command -v ss >/dev/null 2>&1; then
      ss -lptn "sport = :${PORT}" 2>/dev/null | sed -n 's/.*pid=\([0-9]\+\).*/\1/p'
    fi
  } | awk 'NF && !seen[$0]++'
)
log "killing teacher pids=${_kill_pids[*]:-none} (was max_model_len=$cur)"
for p in "${_kill_pids[@]:-}"; do
  kill "$p" 2>/dev/null || true
done
for _ in $(seq 1 60); do
  alive=0
  for p in "${_kill_pids[@]:-}"; do
    kill -0 "$p" 2>/dev/null && alive=1 && break
  done
  (( alive == 0 )) && break
  sleep 2
done
for p in "${_kill_pids[@]:-}"; do
  kill -9 "$p" 2>/dev/null || true
done
sleep 8

# Free GPUs 0,1 settle
for _ in $(seq 1 30); do
  used=$(nvidia-smi --query-gpu=memory.used --format=csv,noheader,nounits -i 0,1 2>/dev/null \
    | awk '{s+=$1} END{print s+0}')
  if [[ "${used:-999999}" -lt 2000 ]]; then
    break
  fi
  sleep 2
done
log "GPU0/1 used_mib_sum=${used:-?} — relaunch teacher @${NEED_LEN}"

if [[ -f /root/mine.env ]]; then
  set -a
  # shellcheck disable=SC1091
  source /root/mine.env
  set +a
fi
export HF_HOME=${HF_HOME:-/root/hf}
export CUDA_HOME=${CUDA_HOME:-/root/venv/lib/python3.12/site-packages/nvidia/cu13}
export CUDA_PATH=${CUDA_PATH:-$CUDA_HOME}
export LD_LIBRARY_PATH="${CUDA_HOME}/lib:${CUDA_HOME}/lib64:${LD_LIBRARY_PATH:-}"
export VLLM_USE_FLASHINFER_SAMPLER=${VLLM_USE_FLASHINFER_SAMPLER:-0}
export VLLM_ALLREDUCE_USE_FLASHINFER=${VLLM_ALLREDUCE_USE_FLASHINFER:-0}
export VLLM_USE_FLASHINFER_MOE_FP8=${VLLM_USE_FLASHINFER_MOE_FP8:-0}
export VLLM_USE_FLASHINFER_MOE_FP4=${VLLM_USE_FLASHINFER_MOE_FP4:-0}
export VLLM_USE_FLASHINFER_MOE_FP16=${VLLM_USE_FLASHINFER_MOE_FP16:-0}
export VLLM_USE_DEEP_GEMM=${VLLM_USE_DEEP_GEMM:-0}
export VLLM_MOE_USE_DEEP_GEMM=${VLLM_MOE_USE_DEEP_GEMM:-0}

: >"/root/logs/vllm_teacher.log"
CUDA_VISIBLE_DEVICES=0,1 TRITON_CACHE_DIR=/root/.triton/cache/teacher \
  nohup /root/venv/bin/vllm serve zai-org/GLM-4.5-Air-FP8 \
    --port "$PORT" \
    --gpu-memory-utilization 0.80 \
    --tensor-parallel-size 2 \
    --max-model-len "$NEED_LEN" \
    --max-num-batched-tokens 8192 \
    --attention-backend FLASH_ATTN \
    --attention-config.use_trtllm_attention 0 \
    --compilation-config.pass_config.fuse_allreduce_rms false \
    --moe-backend triton \
    --additional-config '{"gdn_prefill_backend": "triton"}' \
    >>/root/logs/vllm_teacher.log 2>&1 &
echo $! >"$TEACHER_PIDF"
log "launched teacher pid=$(cat "$TEACHER_PIDF") log=/root/logs/vllm_teacher.log"

ok=0
for i in $(seq 1 360); do
  cur=$(_cur_len)
  code=$(curl -s -o /dev/null -w "%{http_code}" --max-time 3 "http://127.0.0.1:${PORT}/v1/models" || true)
  if [[ "$code" == "200" && "$cur" -ge "$NEED_LEN" ]]; then
    log "PROMPTABLE teacher max_model_len=$cur iter=$i"
    ok=1
    break
  fi
  if (( i % 12 == 0 )); then
    log "wait iter=$i code=$code len=$cur"
  fi
  sleep 5
done

if [[ "$ok" != "1" ]]; then
  log "ERROR: teacher did not reach max_model_len=$NEED_LEN"
  echo "{\"utc\":\"$(date -u +%Y-%m-%dT%H:%M:%SZ)\",\"action\":\"fail\",\"max_model_len\":$(_cur_len)}" \
    >/root/affine_data/r24_teacher_maxlen_fix.json
  exit 3
fi

python3 - <<PY
import json, time
from pathlib import Path
Path("/root/affine_data/r24_teacher_maxlen_fix.json").write_text(json.dumps({
  "utc": time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime()),
  "action": "relaunched",
  "max_model_len": int("$(_cur_len)"),
  "need": int("$NEED_LEN"),
  "pid": int(open("$TEACHER_PIDF").read().strip()),
  "axis": "R24",
  "why": "prewarm left teacher at 32768; n80 needs 65536 (LESSONS ContextLengthError)",
}, indent=2) + "\n")
PY
log "DONE fix json=/root/affine_data/r24_teacher_maxlen_fix.json"
