#!/usr/bin/env bash
# After R1 LoRA train + H64 baseline finish: merge → reload chall:8002 → fresh n80.
# Does NOT touch teacher:8000 or king:8001. Kill chall by PID only (never pkill -f).
set -euo pipefail
LOG=/root/logs/r1_merge_reload.log
mkdir -p /root/logs /root/affine_data /root/r1_out
exec > >(tee -a "$LOG") 2>&1

echo "[r1-merge] $(date -u +%Y-%m-%dT%H:%M:%SZ) start"

# Wait for train done (adapter written).
for i in $(seq 1 720); do
  if [[ -f /root/logs/r1_train.done && -d /root/r1_out/lora_tok_high_reason/adapter ]]; then
    echo "[r1-merge] train done at iter=$i $(date -u +%Y-%m-%dT%H:%M:%SZ)"
    break
  fi
  if (( i % 12 == 0 )); then
    echo "[r1-merge] wait-train iter=$i $(date -u +%Y-%m-%dT%H:%M:%SZ)"
  fi
  if (( i == 720 )); then
    echo "[r1-merge] TIMEOUT waiting for train" >&2
    exit 2
  fi
  sleep 10
done

# Wait for H64 baseline sim to finish (do not yank chall mid-n80).
for i in $(seq 1 720); do
  if [[ -f /root/affine_data/r1_decision.json || -f /root/logs/r1_reason_sim.done ]]; then
    echo "[r1-merge] H64 decision present at iter=$i"
    break
  fi
  # Bracket trick avoids matching this waiter's own argv (never pkill -f).
  if ! pgrep -f '[r]un_reason_sim.py' >/dev/null 2>&1; then
    # Sim gone but decision missing — try write from partial/final artifact.
    if [[ -f /root/affine_data/r1_reason_sim.json ]]; then
      echo "[r1-merge] sim process gone; writing decision from artifact"
      # shellcheck disable=SC1091
      source /root/venv/bin/activate
      python /root/mining_src/r1-reason-distill/write_reason_decision.py \
        --sim-result /root/affine_data/r1_reason_sim.json \
        --out /root/affine_data/r1_decision.json || true
    fi
    break
  fi
  if (( i % 12 == 0 )); then
    prog=$(cat /root/affine_data/r1_reason_progress.json 2>/dev/null || echo '{}')
    echo "[r1-merge] wait-h64 iter=$i prog=$prog"
  fi
  if (( i == 720 )); then
    echo "[r1-merge] TIMEOUT waiting for H64 baseline" >&2
    exit 2
  fi
  sleep 10
done

# shellcheck disable=SC1091
source /root/venv/bin/activate
if [[ -f /root/mine.env ]]; then
  # shellcheck disable=SC1091
  set -a
  source /root/mine.env
  set +a
fi
export PYTHONPATH=/root/mining_src/affine_pkg${PYTHONPATH:+:$PYTHONPATH}
export AFFINE_DATA_DIR=${AFFINE_DATA_DIR:-/root/affine_data}
export HF_HOME=${HF_HOME:-/root/hf}
export HF_HUB_ENABLE_HF_TRANSFER=${HF_HUB_ENABLE_HF_TRANSFER:-1}
export HF_XET_HIGH_PERFORMANCE=${HF_XET_HIGH_PERFORMANCE:-1}
# Match restore_warm_stack / serve_commands.md — avoid flashinfer JIT on B300.
export VLLM_USE_DEEP_GEMM=0
export VLLM_USE_FLASHINFER_SAMPLER=0
export VLLM_ALLREDUCE_USE_FLASHINFER=0
export VLLM_MOE_USE_DEEP_GEMM=0
export VLLM_USE_FLASHINFER_MOE_FP16=0
export VLLM_USE_FLASHINFER_MOE_FP4=0
export VLLM_USE_FLASHINFER_MOE_FP8=0

# B300 pods have no system CUDA toolkit — use pip nvidia/cu13 for nvcc.
# Do NOT symlink /usr/local/cuda → cu13 (flashinfer CCCL header clash).
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
  echo "[r1-merge] CUDA_HOME=$CUDA_HOME"
else
  echo "[r1-merge] FATAL no nvcc under ${_CU13}" >&2
  exit 2
fi
if [[ -L /usr/local/cuda ]]; then
  rm -f /usr/local/cuda
  echo "[r1-merge] removed /usr/local/cuda symlink"
fi

BASE=${BASE:-/root/hf/hub/models--Tok331102--affine-5EqYW8McUc-af10/snapshots/eb8bf9a356a254f71faaa439e8abc3cfba572c53}
ADAPTER=${ADAPTER:-/root/r1_out/lora_tok_high_reason/adapter}
MERGED=${MERGED:-/root/r1_out/r1_lora_merged}
LINK=${LINK:-/tmp/r1_lora_merged}

if [[ ! -d "$BASE" ]]; then
  BASE=$(ls -d /root/hf/hub/models--Tok331102--affine-5EqYW8McUc-af10/snapshots/* 2>/dev/null | head -1 || true)
fi
if [[ -z "$BASE" || ! -d "$BASE" ]]; then
  echo "[r1-merge] FATAL missing Tok base" >&2
  exit 2
fi
if [[ ! -f "$ADAPTER/adapter_config.json" ]]; then
  echo "[r1-merge] FATAL missing adapter at $ADAPTER" >&2
  exit 2
fi

# Merge on GPUs 6,7 (freed by train).
export CUDA_VISIBLE_DEVICES=${CUDA_VISIBLE_DEVICES:-6,7}
echo "[r1-merge] merging adapter → $MERGED"
rm -rf "$MERGED"
python /root/mining_src/r1-reason-distill/merge_lora.py \
  --base "$BASE" \
  --adapter "$ADAPTER" \
  --out "$MERGED"
ln -sfn "$MERGED" "$LINK"
echo "[r1-merge] link $LINK -> $(readlink -f "$LINK")"

# Stop H64 chall only (PID file). Never pkill -f.
CHALL_PID_FILE=/root/logs/vllm_chall.pid
if [[ -f "$CHALL_PID_FILE" ]]; then
  CPID=$(cat "$CHALL_PID_FILE" || true)
  if [[ -n "${CPID:-}" ]] && kill -0 "$CPID" 2>/dev/null; then
    echo "[r1-merge] stopping chall pid=$CPID"
    kill "$CPID" || true
    for j in $(seq 1 60); do
      kill -0 "$CPID" 2>/dev/null || break
      sleep 2
    done
    if kill -0 "$CPID" 2>/dev/null; then
      echo "[r1-merge] chall still alive; kill -9 $CPID"
      kill -9 "$CPID" || true
    fi
  fi
fi
# Free port 8002 if orphan children linger.
sleep 3

# Seed chall Triton cache from king if empty (B300 recovery).
if [[ ! -d /root/.triton/cache/chall ]] || [[ -z "$(find /root/.triton/cache/chall -name '*.so' 2>/dev/null | head -1)" ]]; then
  if [[ -d /root/.triton/cache/king ]]; then
    echo "[r1-merge] seeding chall Triton cache from king"
    mkdir -p /root/.triton/cache/chall
    cp -a /root/.triton/cache/king/. /root/.triton/cache/chall/ || true
  fi
fi

# Match live evalsrv max_model_len=65536 (affine.toml). 32768 knife-edges
# long corpus prefixes and aborts the whole n80 gather.
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

echo "[r1-merge] launching chall :8002 on $LINK"
CUDA_VISIBLE_DEVICES=4,5 TRITON_CACHE_DIR=/root/.triton/cache/chall \
  nohup /root/venv/bin/vllm serve "$LINK" \
    --port 8002 --gpu-memory-utilization 0.72 \
    "${COMMON[@]}" \
    >/root/logs/vllm_chall.log 2>&1 &
echo $! >/root/logs/vllm_chall.pid
echo "[r1-merge] chall pid=$(cat /root/logs/vllm_chall.pid)"

for i in $(seq 1 480); do
  c0=$(curl -s -o /dev/null -w "%{http_code}" --max-time 3 http://127.0.0.1:8000/v1/models || true)
  c1=$(curl -s -o /dev/null -w "%{http_code}" --max-time 3 http://127.0.0.1:8001/v1/models || true)
  c2=$(curl -s -o /dev/null -w "%{http_code}" --max-time 3 http://127.0.0.1:8002/v1/models || true)
  if [[ "$c0$c1$c2" == "200200200" ]]; then
    echo "[r1-merge] engines 200/200/200 at iter=$i $(date -u +%Y-%m-%dT%H:%M:%SZ)"
    break
  fi
  if (( i % 12 == 0 )); then
    echo "[r1-merge] wait-engines iter=$i codes=${c0}/${c1}/${c2}"
  fi
  if (( i == 480 )); then
    echo "[r1-merge] TIMEOUT engines; see vllm_chall.log" >&2
    exit 2
  fi
  sleep 5
done

# Fresh n80 vs live king with LoRA-merged chall.
OUT=/root/affine_data/r1_lora_reason_sim.json
DEC=/root/affine_data/r1_lora_decision.json
PROG=/root/affine_data/r1_lora_reason_progress.json
BH=$(python - <<'PY'
import hashlib, time
print(hashlib.sha256(f"r1-lora-{time.time_ns()}".encode()).hexdigest())
PY
)

echo "[r1-merge] launching LoRA n80 block_hash=${BH:0:16}…"
# Archive H64 decision if present; LoRA decision is separate.
python /root/mining_src/r1-reason-distill/run_reason_sim.py \
  --n-turns 80 \
  --block-hash "$BH" \
  --hotkey "local-r1-lora-$(date -u +%Y%m%dT%H%M%SZ)" \
  --king-repo Tok331102/affine-5EqYW8McUc-af10 \
  --king-rev eb8bf9a356a254f71faaa439e8abc3cfba572c53 \
  --chall-repo "$LINK" \
  --out "$OUT" \
  --progress-out "$PROG" \
  --save-artifact \
  2>&1 | tee /root/logs/r1_lora_reason_sim.log

python /root/mining_src/r1-reason-distill/write_reason_decision.py \
  --sim-result "$OUT" --out "$DEC" \
  2>&1 | tee -a /root/logs/r1_lora_reason_sim.log

echo "[r1-merge] DONE $(date -u +%Y-%m-%dT%H:%M:%SZ)"
cat "$DEC"
touch /root/logs/r1_merge_reload.done
