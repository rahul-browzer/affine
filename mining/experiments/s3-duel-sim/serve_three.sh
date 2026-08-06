#!/usr/bin/env bash
# Launch teacher / king / challenger under eval-pod vLLM knobs.
# Run on mine-sim-1 after /root/logs/bootstrap.done exists.
# Defaults match Stage 3 gate (chal-00224 shape): kevin challenger vs genesis king.
set -euo pipefail

# shellcheck disable=SC1091
source /root/venv/bin/activate
if [[ -f /root/mine.env ]]; then
  # shellcheck disable=SC1091
  source /root/mine.env
fi

export HF_HOME=${HF_HOME:-/root/hf}
export HF_HUB_ENABLE_HF_TRANSFER=${HF_HUB_ENABLE_HF_TRANSFER:-1}
export VLLM_USE_FLASHINFER_SAMPLER=0
export VLLM_ALLREDUCE_USE_FLASHINFER=0
export VLLM_USE_FLASHINFER_MOE_FP16=0
export VLLM_USE_FLASHINFER_MOE_FP8=0
export VLLM_USE_FLASHINFER_MOE_FP4=0
# Stock `uv pip install vllm==0.22.1` does not ship a working deep_gemm on
# these H200 images; FP8 load then hard-fails at KV-cache init. Eval pod may
# bake deep_gemm in; until we match that, disable globally (vLLM documents
# VLLM_USE_DEEP_GEMM=0 as the escape hatch).
export VLLM_USE_DEEP_GEMM=0
export VLLM_MOE_USE_DEEP_GEMM=0

# Mirror evalsrv.engine._cuda_home: Lium images lack /usr/local/cuda; the
# nvidia-cuda-nvcc wheel under site-packages/nvidia/cu13 has nvcc + headers.
# Qwen3.6 GDN linear-attn JIT dies on first request without this.
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
  echo "[serve] CUDA_HOME=$CUDA_HOME"
else
  echo "[serve] WARN: no complete pip cu13 toolkit at $_CU13 — GDN JIT may fail"
fi

TEACHER_REPO=${TEACHER_REPO:-zai-org/GLM-4.5-Air-FP8}
TEACHER_REV=${TEACHER_REV:-}
KING_REPO=${KING_REPO:-dendriteholdings/albedo-qwen3.6-35b-king-genesis}
KING_REV=${KING_REV:-abe89194d6addf82e71f3f1ba9fef94b05404abf}
CHALL_REPO=${CHALL_REPO:-kevin954/Affine-5dfqbbh8ev-sft}
CHALL_REV=${CHALL_REV:-6a5815fad8f4e34c983b1933c1fae5762fe25220}

TP=${TP:-2}
MAXLEN=${MAXLEN:-32768}
GPUUTIL=${GPUUTIL:-0.80}
BATCHED=${BATCHED:-8192}

mkdir -p /root/logs

_launch() {
  local name=$1 port=$2 gpus=$3 repo=$4 rev=$5
  local log=/root/logs/vllm_${name}.log
  local pidf=/root/logs/vllm_${name}.pid
  if [[ -f "$pidf" ]] && kill -0 "$(cat "$pidf")" 2>/dev/null; then
    echo "[serve] $name already running pid=$(cat "$pidf")"
    return 0
  fi
  # Local merge dirs must not get a Hub --revision (empty CHALL_REV still
  # expands to the kevin default via ${CHALL_REV:-…} above).
  local rev_args=()
  if [[ -d "$repo" ]]; then
    rev=""
  fi
  if [[ -n "$rev" ]]; then
    rev_args=(--revision "$rev")
  fi
  # Qwen3.6 GDN on Hopper (H200): gdn_prefill_backend=auto → FlashInfer JIT
  # of gdn_prefill_sm90; pip cu13 nvcc/headers are incompatible and the engine
  # dies on first request. Triton skips that path (evalsrv bench role does the
  # same). Harmless on GLM teacher.
  local extra_args=(--additional-config '{"gdn_prefill_backend": "triton"}')
  echo "[serve] $(date -u +%Y-%m-%dT%H:%M:%SZ) start $name repo=$repo rev=${rev:-latest} port=$port gpus=$gpus"
  CUDA_VISIBLE_DEVICES=$gpus nohup vllm serve "$repo" \
    --port "$port" \
    --tensor-parallel-size "$TP" \
    --max-model-len "$MAXLEN" \
    --gpu-memory-utilization "$GPUUTIL" \
    --max-num-batched-tokens "$BATCHED" \
    --attention-backend FLASH_ATTN \
    --attention-config.use_trtllm_attention 0 \
    --compilation-config.pass_config.fuse_allreduce_rms false \
    --moe-backend triton \
    "${extra_args[@]}" \
    "${rev_args[@]}" \
    >"$log" 2>&1 &
  echo $! >"$pidf"
  echo "[serve] $name pid=$! log=$log"
}

_launch teacher 8000 "0,1" "$TEACHER_REPO" "$TEACHER_REV"
_launch king    8001 "2,3" "$KING_REPO"    "$KING_REV"
_launch chall   8002 "4,5" "$CHALL_REPO"   "$CHALL_REV"

echo "[serve] launched. Wait with: bash /root/mining_src/s3-duel-sim/wait_ready.sh"
echo "[serve] $(date -u +%Y-%m-%dT%H:%M:%SZ) DONE_LAUNCH"
