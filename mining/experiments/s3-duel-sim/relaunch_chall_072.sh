#!/usr/bin/env bash
# Kill chall (:8002) and relaunch at gpu_memory_utilization=0.72.
# Teacher/king stay up. Safe while wait_ready is still polling (before n80).
# Usage: MERGE_DIR=/root/merges/h22-tp90 bash relaunch_chall_072.sh
set -euo pipefail

# shellcheck disable=SC1091
source /root/venv/bin/activate
if [[ -f /root/mine.env ]]; then
  set -a
  # shellcheck disable=SC1091
  source /root/mine.env
  set +a
fi

export HF_HOME=${HF_HOME:-/root/hf}
export VLLM_USE_FLASHINFER_SAMPLER=0
export VLLM_ALLREDUCE_USE_FLASHINFER=0
export VLLM_USE_FLASHINFER_MOE_FP16=0
export VLLM_USE_FLASHINFER_MOE_FP8=0
export VLLM_USE_FLASHINFER_MOE_FP4=0
export VLLM_USE_DEEP_GEMM=0
export VLLM_MOE_USE_DEEP_GEMM=0

_SITE=$(python - <<'PY'
import site
print(site.getsitepackages()[0])
PY
)
_CU13="${_SITE}/nvidia/cu13"
if [[ -x "${_CU13}/bin/nvcc" && -f "${_CU13}/include/cuda_fp16.h" ]]; then
  export CUDA_HOME=${CUDA_HOME:-$_CU13}
  export CUDA_PATH=$CUDA_HOME
  export PATH="${CUDA_HOME}/bin:${PATH}"
  export LD_LIBRARY_PATH="${CUDA_HOME}/lib:${CUDA_HOME}/lib64:${LD_LIBRARY_PATH:-}"
  export LIBRARY_PATH="${CUDA_HOME}/lib:${CUDA_HOME}/lib64:${LIBRARY_PATH:-}"
fi

MERGE_DIR=${MERGE_DIR:?set MERGE_DIR to local merge path}
UTIL=${UTIL:-0.72}
LOG=/root/logs/vllm_chall.log
PIDF=/root/logs/vllm_chall.pid
TCACHE=/root/.triton/cache/chall
mkdir -p "$TCACHE" /root/logs

echo "[relaunch-chall] $(date -u +%Y-%m-%dT%H:%M:%SZ) stop chall merge=$MERGE_DIR util=$UTIL"

if [[ -f "$PIDF" ]]; then
  old=$(cat "$PIDF" || true)
  if [[ -n "${old:-}" ]] && kill -0 "$old" 2>/dev/null; then
    kill "$old" 2>/dev/null || true
    sleep 2
    kill -9 "$old" 2>/dev/null || true
  fi
  rm -f "$PIDF"
fi
# Also reap any leftover serve on :8002 (exact port match).
pkill -f 'vllm serve .*--port 8002' 2>/dev/null || true
sleep 3

# Clear stuck GPU mem on 4,5 if any zombie workers remain.
sleep 2

: >"$LOG"
echo "[relaunch-chall] $(date -u +%Y-%m-%dT%H:%M:%SZ) start chall port=8002 gpus=4,5 util=$UTIL"
CUDA_VISIBLE_DEVICES=4,5 TRITON_CACHE_DIR=$TCACHE nohup vllm serve "$MERGE_DIR" \
  --port 8002 \
  --tensor-parallel-size 2 \
  --max-model-len 32768 \
  --gpu-memory-utilization "$UTIL" \
  --max-num-batched-tokens 8192 \
  --attention-backend FLASH_ATTN \
  --attention-config.use_trtllm_attention 0 \
  --compilation-config.pass_config.fuse_allreduce_rms false \
  --moe-backend triton \
  --additional-config '{"gdn_prefill_backend": "triton"}' \
  >"$LOG" 2>&1 &
echo $! >"$PIDF"
echo "[relaunch-chall] pid=$(cat "$PIDF") log=$LOG"
echo "[relaunch-chall] $(date -u +%Y-%m-%dT%H:%M:%SZ) DONE_LAUNCH"
