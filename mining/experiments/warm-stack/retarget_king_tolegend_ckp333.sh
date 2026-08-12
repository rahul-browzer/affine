#!/usr/bin/env bash
# p2152: after reign-5 crown, swap :8001 king Tok→tolegend ckp333.
# Wait R2bj n80 terminal so we do not kill mid-gather. Leave teacher/chall/R9 alone.
# Kill king by pidfile only — never pkill -f.
set -euo pipefail
LOG=/root/logs/retarget_king_tolegend_ckp333.log
DONE=/root/logs/retarget_king_tolegend_ckp333.done
PIDF=/root/logs/retarget_king_tolegend_ckp333.pid
mkdir -p /root/logs /root/affine_data
echo $$ >"$PIDF"
exec > >(tee -a "$LOG") 2>&1

echo "[retarget-king] $(date -u +%Y-%m-%dT%H:%M:%SZ) start p2152"
if [[ -f "$DONE" ]]; then
  echo "[retarget-king] already done: $(cat "$DONE")"
  exit 0
fi

KING_REPO=${KING_REPO:-tolegend/Affine-5fqbxvz29b-ckp333}
KING_REV=${KING_REV:-24c137e8a978aea1e2b4abeec594fb6ca943f03c}
R2BJ_DEC=${R2BJ_DEC:-/root/logs/r2bj_saysth_decision.json}
R2BJ_ALT=${R2BJ_ALT:-/root/affine_data/r2bj_saysth_decision.json}
R2BJ_SIM=${R2BJ_SIM:-/root/affine_data/r2bj_saysth_reason_sim.json}
PREFETCH_DONE=${PREFETCH_DONE:-/root/logs/r2_prefetch_ckp333.done}
PREFETCH_SH=${PREFETCH_SH:-/root/mining_src/r2-multiking-merge/launch_prefetch_ckp333.sh}

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

# 0) Ensure weights present (p2152: hub dir was evicted; stale .done lied).
hub_ok() {
  python3 - <<PY
from pathlib import Path
import os
repo=os.environ.get("KING_REPO","$KING_REPO")
rev=os.environ.get("KING_REV","$KING_REV")
# HF cache layout
name="models--" + repo.replace("/","--")
snap=Path(os.environ.get("HF_HOME","/root/hf"))/"hub"/name/"snapshots"/rev
idx=snap/"model.safetensors.index.json"
raise SystemExit(0 if idx.is_file() else 1)
PY
}
export KING_REPO KING_REV
if ! hub_ok; then
  echo "[retarget-king] cache miss — force prefetch"
  rm -f "$PREFETCH_DONE" /root/affine_data/r2_prefetch_ckp333.done
  if [[ -x "$PREFETCH_SH" ]]; then
    bash "$PREFETCH_SH"
  else
    echo "[retarget-king] FATAL missing $PREFETCH_SH" >&2
    exit 2
  fi
fi
if ! hub_ok; then
  echo "[retarget-king] FATAL still no hub snapshot after prefetch" >&2
  exit 2
fi
echo "[retarget-king] hub OK $KING_REPO@$KING_REV"

# 1) Wait R2bj terminal (decision or finished sim json).
echo "[retarget-king] waiting R2bj terminal"
for i in $(seq 1 2880); do
  if [[ -f "$R2BJ_DEC" || -f "$R2BJ_ALT" ]]; then
    echo "[retarget-king] R2bj decision at iter=$i"
    break
  fi
  if [[ -f "$R2BJ_SIM" ]]; then
    # sim json present and sim process gone ⇒ terminal even if decision writer lagging
    if ! pgrep -f 'run_reason_sim.py .*r2bj_saysth' >/dev/null 2>&1; then
      echo "[retarget-king] R2bj sim file + process gone at iter=$i"
      break
    fi
  fi
  # Also proceed if current :8001 already serves the new king
  if curl -s --max-time 3 http://127.0.0.1:8001/v1/models 2>/dev/null \
    | python3 -c 'import sys,json; d=json.load(sys.stdin); raise SystemExit(0 if any("ckp333" in (x.get("id") or "") for x in d.get("data",[])) else 1)' 2>/dev/null; then
    echo "OK already_serving_ckp333 $(date -u +%Y-%m-%dT%H:%M:%SZ)" | tee "$DONE"
    exit 0
  fi
  if (( i % 12 == 0 )); then
    crumb=$(python3 -c "from pathlib import Path;p=Path('/root/affine_data/r2bj_saysth_reason_progress.json');print(p.read_text().strip() if p.is_file() else 'no-progress')" 2>/dev/null || echo none)
    echo "[retarget-king] wait-r2bj iter=$i crumb=${crumb:-none}"
  fi
  if (( i == 2880 )); then
    echo "[retarget-king] TIMEOUT waiting R2bj" >&2
    exit 2
  fi
  sleep 10
done

# 2) Stop king by pidfile only.
stop_pidfile() {
  local f=$1 name=$2 pid
  [[ -f "$f" ]] || { echo "[retarget-king] no pidfile $f ($name)"; return 0; }
  pid=$(cat "$f" || true)
  [[ -n "${pid:-}" ]] || return 0
  if kill -0 "$pid" 2>/dev/null; then
    echo "[retarget-king] stop $name pid=$pid"
    kill "$pid" || true
    for j in $(seq 1 40); do
      kill -0 "$pid" 2>/dev/null || break
      sleep 1
    done
    kill -9 "$pid" 2>/dev/null || true
    # children of APIServer
    kill -9 $(pstree -p "$pid" 2>/dev/null | grep -oE '[0-9]+' | tr '\n' ' ') 2>/dev/null || true
  fi
  rm -f "$f"
}
stop_pidfile /root/logs/vllm_king.pid king
sleep 3

# 3) Serve new king on GPUs 2,3 :8001 (same knobs as restore / re65536).
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
echo "[retarget-king] launch $KING_REPO@$KING_REV :8001"
CUDA_VISIBLE_DEVICES=2,3 TRITON_CACHE_DIR=/root/.triton/cache/king \
  nohup /root/venv/bin/vllm serve "$KING_REPO" \
    --port 8001 --gpu-memory-utilization 0.80 \
    "${COMMON[@]}" --revision "$KING_REV" \
    >/root/logs/vllm_king.log 2>&1 &
echo $! >/root/logs/vllm_king.pid
echo "[retarget-king] king pid=$(cat /root/logs/vllm_king.pid)"

for i in $(seq 1 480); do
  code=$(curl -s -o /dev/null -w "%{http_code}" --max-time 3 http://127.0.0.1:8001/v1/models || true)
  if [[ "$code" == "200" ]]; then
    id=$(curl -s --max-time 3 http://127.0.0.1:8001/v1/models | python3 -c 'import sys,json; print(json.load(sys.stdin)["data"][0]["id"])')
    echo "[retarget-king] :8001 ready id=$id iter=$i"
    if [[ "$id" != *ckp333* && "$id" != *tolegend* ]]; then
      echo "[retarget-king] WARN unexpected model id=$id" >&2
    fi
    meta=/root/affine_data/retarget_king_tolegend_ckp333.json
    python3 - <<PY
import json, time
from pathlib import Path
Path("$meta").write_text(json.dumps({
    "utc": time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime()),
    "pass": 2152,
    "king_repo": "$KING_REPO",
    "king_rev": "$KING_REV",
    "served_id": "$id",
    "note": "reign-5 live king on crown :8001; R9/R2 post-train n80s must use this baseline",
}, indent=2) + "\n")
PY
    echo "OK $KING_REPO@$KING_REV id=$id $(date -u +%Y-%m-%dT%H:%M:%SZ)" | tee "$DONE"
    exit 0
  fi
  if grep -aEq 'Could not find nvcc|headers are incompatible|Error|Traceback' /root/logs/vllm_king.log 2>/dev/null \
     && ! kill -0 "$(cat /root/logs/vllm_king.pid)" 2>/dev/null; then
    echo "[retarget-king] FATAL king died; tail:" >&2
    tail -40 /root/logs/vllm_king.log >&2 || true
    exit 2
  fi
  if (( i % 12 == 0 )); then
    echo "[retarget-king] wait-ready iter=$i code=$code"
  fi
  sleep 5
done
echo "[retarget-king] TIMEOUT waiting :8001" >&2
exit 2
