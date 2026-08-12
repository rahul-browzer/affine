#!/usr/bin/env bash
# p2247: after lium reboot of mine-r25 — restore T/K/C from /root/r25_merged and n80 vs guass.
# Chall on B200 uses enforce-eager + Triton warm/freeze (p2246 lesson).
set -euo pipefail
source /root/venv/bin/activate
set -a; [[ -f /root/mine.env ]] && source /root/mine.env; set +a

export HF_HOME=${HF_HOME:-/root/hf}
export VLLM_USE_FLASHINFER_SAMPLER=0
export VLLM_ALLREDUCE_USE_FLASHINFER=0
export VLLM_USE_FLASHINFER_MOE_FP16=0
export VLLM_USE_FLASHINFER_MOE_FP8=0
export VLLM_USE_FLASHINFER_MOE_FP4=0
export VLLM_USE_DEEP_GEMM=0
export VLLM_MOE_USE_DEEP_GEMM=0
_SITE=$(python -c 'import site; print(site.getsitepackages()[0])')
export CUDA_HOME="${_SITE}/nvidia/cu13"
export CUDA_PATH=$CUDA_HOME

MERGE=${MERGE:-/root/r25_merged}
[[ -f "$MERGE/config.json" ]] || MERGE=/tmp/r3_merged
KING_REPO=${KING_REPO:-ttttxxxxsada/Affine-5guassq3tu}
KING_REV=${KING_REV:-e86758f5080d1e373e5fbbd7b4fbf6af327aeb44}
TEACHER_REPO=${TEACHER_REPO:-zai-org/GLM-4.5-Air-FP8}
SIM=/root/affine_data/r3_sim_result.json
DEC=/root/affine_data/r3_decision.json
PROG=/root/affine_data/r3_sim_progress.json

log(){ echo "[p2247-r25] $(date -u +%Y-%m-%dT%H:%M:%SZ) $*"; }

# wait for healthy NVML (all 8 GPUs)
for i in $(seq 1 60); do
  n=$(nvidia-smi -L 2>/dev/null | grep -c 'NVIDIA' || true)
  err=$(nvidia-smi -L 2>&1 | grep -c 'Unknown Error' || true)
  log "gpu_ok=$n err_lines=$err poll=$i"
  [[ "$n" -ge 8 && "$err" -eq 0 ]] && break
  sleep 5
done
n=$(nvidia-smi -L 2>/dev/null | grep -c 'NVIDIA' || true)
err=$(nvidia-smi -L 2>&1 | grep -c 'Unknown Error' || true)
[[ "$n" -ge 8 && "$err" -eq 0 ]] || { log "FATAL GPUs not healthy"; nvidia-smi -L; exit 1; }

# symlink merge into /tmp for chall id continuity
mkdir -p /tmp
if [[ "$MERGE" != /tmp/r3_merged ]]; then
  rm -rf /tmp/r3_merged
  ln -s "$MERGE" /tmp/r3_merged
  MERGE=/tmp/r3_merged
fi
test -f "$MERGE/config.json"

# serve teacher+king (stock); chall enforce-eager separately
export KING_REPO KING_REV TEACHER_REPO
export CHALL_REPO="$MERGE" CHALL_REV=""
# only launch T+K — chall needs enforce-eager on B200
bash /root/mining_src/s3-duel-sim/serve_three.sh &
# serve_three also starts chall — kill that chall and replace
sleep 5

# wait T+K
for i in $(seq 1 90); do
  t=$(curl -s -o /dev/null -w "%{http_code}" --max-time 5 http://127.0.0.1:8000/v1/models || true)
  k=$(curl -s -o /dev/null -w "%{http_code}" --max-time 5 http://127.0.0.1:8001/v1/models || true)
  log "wait T=$t K=$k"
  [[ "$t" == "200" && "$k" == "200" ]] && break
  sleep 10
done
[[ "$(curl -s -o /dev/null -w "%{http_code}" --max-time 5 http://127.0.0.1:8000/v1/models)" == "200" ]] || { log "teacher fail"; exit 2; }
[[ "$(curl -s -o /dev/null -w "%{http_code}" --max-time 5 http://127.0.0.1:8001/v1/models)" == "200" ]] || { log "king fail"; exit 2; }

# kill stock chall if present; launch enforce-eager + warm via p2246 helper if present
if [[ -x /root/p2246_chall_warm_n80.sh ]]; then
  log "hand off to p2246_chall_warm_n80.sh (expects T/K up)"
  MERGE="$MERGE" bash /root/p2246_chall_warm_n80.sh
else
  log "FATAL missing /root/p2246_chall_warm_n80.sh"
  exit 3
fi
