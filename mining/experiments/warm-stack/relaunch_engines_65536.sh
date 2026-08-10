#!/usr/bin/env bash
# Restart teacher/king/chall with max_model_len=65536 (live affine.toml).
# Does NOT touch GPUs 6–7. Kill by PID file only — never pkill -f.
# Env must match restore_warm_stack / serve_commands.md:
#   CUDA_HOME=venv nvidia/cu13 + VLLM_USE_FLASHINFER_*=0
# Do NOT symlink /usr/local/cuda → cu13 (flashinfer CCCL header clash).
# Do NOT put cu13/bin on PATH (same clash via nvcc 13.3).
set -euo pipefail
LOG=/root/logs/relaunch_engines_65536.log
mkdir -p /root/logs
exec > >(tee -a "$LOG") 2>&1

echo "[re65536] $(date -u +%Y-%m-%dT%H:%M:%SZ) start"

# shellcheck disable=SC1091
source /root/venv/bin/activate
if [[ -f /root/mine.env ]]; then
  set -a
  # shellcheck disable=SC1091
  source /root/mine.env
  set +a
fi
export HF_HOME=${HF_HOME:-/root/hf}
export HF_HUB_ENABLE_HF_TRANSFER=${HF_HUB_ENABLE_HF_TRANSFER:-1}
export HF_XET_HIGH_PERFORMANCE=${HF_XET_HIGH_PERFORMANCE:-1}
export VLLM_USE_DEEP_GEMM=0
export VLLM_USE_FLASHINFER_SAMPLER=0
export VLLM_ALLREDUCE_USE_FLASHINFER=0
export VLLM_MOE_USE_DEEP_GEMM=0
export VLLM_USE_FLASHINFER_MOE_FP16=0
export VLLM_USE_FLASHINFER_MOE_FP4=0
export VLLM_USE_FLASHINFER_MOE_FP8=0
export CUDA_HOME=/root/venv/lib/python3.12/site-packages/nvidia/cu13
export CUDA_PATH=$CUDA_HOME
export LD_LIBRARY_PATH="${CUDA_HOME}/lib:${CUDA_HOME}/lib64:${LD_LIBRARY_PATH:-}"
rm -f /usr/local/cuda
echo "[re65536] CUDA_HOME=$CUDA_HOME FLASHINFER_SAMPLER=$VLLM_USE_FLASHINFER_SAMPLER"

stop_pidfile() {
  local f=$1 name=$2 pid
  [[ -f "$f" ]] || { echo "[re65536] no pidfile $f ($name)"; return 0; }
  pid=$(cat "$f" || true)
  [[ -n "${pid:-}" ]] || return 0
  if kill -0 "$pid" 2>/dev/null; then
    echo "[re65536] stop $name pid=$pid"
    kill "$pid" || true
    for j in $(seq 1 20); do
      kill -0 "$pid" 2>/dev/null || break
      sleep 1
    done
    kill -9 "$pid" 2>/dev/null || true
    kill -9 $(pstree -p "$pid" 2>/dev/null | grep -oE '[0-9]+' | tr '\n' ' ') 2>/dev/null || true
  fi
}

stop_pidfile /root/logs/vllm_chall.pid chall
stop_pidfile /root/logs/vllm_king.pid king
stop_pidfile /root/logs/vllm_teacher.pid teacher
sleep 3

COMMON=(
  --tensor-parallel-size 2
  --max-model-len 65536
  --max-num-batched-tokens 8192
  --attention-backend FLASH_ATTN
  --attention-config.use_trtllm_attention 0
  --compilation-config.pass_config.fuse_allreduce_rms false
  --moe-backend triton
  --additional-config '{"gdn_prefill_backend": "triton"}'
)

CHALL_MODEL=/tmp/r1_lora_merged
[[ -e $CHALL_MODEL ]] || CHALL_MODEL=/tmp/h64_merged
[[ -e $CHALL_MODEL ]] || { echo "[re65536] FATAL missing chall model"; exit 2; }
echo "[re65536] chall=$CHALL_MODEL"

echo "[re65536] launch teacher :8000"
CUDA_VISIBLE_DEVICES=0,1 TRITON_CACHE_DIR=/root/.triton/cache/teacher \
  nohup /root/venv/bin/vllm serve zai-org/GLM-4.5-Air-FP8 \
    --port 8000 --gpu-memory-utilization 0.80 \
    "${COMMON[@]}" >/root/logs/vllm_teacher.log 2>&1 &
echo $! >/root/logs/vllm_teacher.pid

echo "[re65536] launch king :8001"
CUDA_VISIBLE_DEVICES=2,3 TRITON_CACHE_DIR=/root/.triton/cache/king \
  nohup /root/venv/bin/vllm serve Tok331102/affine-5EqYW8McUc-af10 \
    --port 8001 --gpu-memory-utilization 0.80 \
    "${COMMON[@]}" --revision eb8bf9a356a254f71faaa439e8abc3cfba572c53 \
    >/root/logs/vllm_king.log 2>&1 &
echo $! >/root/logs/vllm_king.pid

echo "[re65536] launch chall :8002"
CUDA_VISIBLE_DEVICES=4,5 TRITON_CACHE_DIR=/root/.triton/cache/chall \
  nohup /root/venv/bin/vllm serve "$CHALL_MODEL" \
    --port 8002 --gpu-memory-utilization 0.72 \
    "${COMMON[@]}" >/root/logs/vllm_chall.log 2>&1 &
echo $! >/root/logs/vllm_chall.pid

echo "[re65536] pids teacher=$(cat /root/logs/vllm_teacher.pid) king=$(cat /root/logs/vllm_king.pid) chall=$(cat /root/logs/vllm_chall.pid)"

for i in $(seq 1 480); do
  c0=$(curl -s -o /dev/null -w "%{http_code}" --max-time 3 http://127.0.0.1:8000/v1/models || true)
  c1=$(curl -s -o /dev/null -w "%{http_code}" --max-time 3 http://127.0.0.1:8001/v1/models || true)
  c2=$(curl -s -o /dev/null -w "%{http_code}" --max-time 3 http://127.0.0.1:8002/v1/models || true)
  if [[ "$c0$c1$c2" == "200200200" ]]; then
    echo "[re65536] engines 200/200/200 at iter=$i $(date -u +%Y-%m-%dT%H:%M:%SZ)"
    for p in 8000 8001 8002; do
      echo -n ":$p max_model_len="
      curl -s --max-time 3 "http://127.0.0.1:$p/v1/models" | python3 -c 'import sys,json; print(json.load(sys.stdin)["data"][0].get("max_model_len"))'
    done
    echo READY >/root/logs/engines_65536.done
    exit 0
  fi
  if grep -aEq 'Could not find nvcc|headers are incompatible' /root/logs/vllm_teacher.log /root/logs/vllm_king.log /root/logs/vllm_chall.log 2>/dev/null; then
    echo "[re65536] FATAL cuda/nvcc error in engine logs" >&2
    exit 2
  fi
  if (( i % 12 == 0 )); then
    echo "[re65536] wait iter=$i codes=${c0}/${c1}/${c2} $(date -u +%Y-%m-%dT%H:%M:%SZ)"
  fi
  sleep 5
done
echo "[re65536] TIMEOUT" >&2
exit 2
