#!/usr/bin/env bash
# After R1 lane resolves below submit bar + R2 parents prefetched:
# α-merge Tok×TalentPigs×kevin → reload chall:8002 → fresh n80 vs Tok.
# CPU merge (no GPU). Does NOT touch teacher:8000 or king:8001.
# Kill chall by PID file only (never pkill -f).
set -euo pipefail
LOG=/root/logs/r2_merge_reload.log
DONE=/root/logs/r2_merge_reload.done
mkdir -p /root/logs /root/affine_data /root/r2_out
exec > >(tee -a "$LOG") 2>&1

echo "[r2-merge] $(date -u +%Y-%m-%dT%H:%M:%SZ) start"
if [[ -f "$DONE" ]]; then
  echo "[r2-merge] already done: $(cat "$DONE")"
  exit 0
fi

PREFETCH_DONE=${PREFETCH_DONE:-/root/logs/r2_prefetch_parents.done}
CHAIN_STAMP=${CHAIN_STAMP:-/root/logs/r1b_to_r1c_chain.done}
R1C_DEC=${R1C_DEC:-/root/affine_data/r1c_lora_decision.json}
R1B_DEC=${R1B_DEC:-/root/affine_data/r1b_lora_decision.json}
HEADROOM_BAR=${HEADROOM_BAR:-1.5}
# Equal α (pre-registered). Distinct from Tok required.
W_TOK=${W_TOK:-1}
W_TALENT=${W_TALENT:-1}
W_KEVIN=${W_KEVIN:-1}

TOK_REV=eb8bf9a356a254f71faaa439e8abc3cfba572c53
TALENT_REV=dbfbb3e2a17c7603e7fc68a3a15b343f42dfdef4
KEVIN_REV=6a5815fad8f4e34c983b1933c1fae5762fe25220

resolve_snap() {
  local repo="$1" rev="$2"
  local d="/root/hf/hub/models--${repo//\//--}/snapshots/${rev}"
  if [[ -d "$d" && -f "$d/model.safetensors.index.json" ]]; then
    echo "$d"
    return 0
  fi
  return 1
}

# 1) Wait prefetch.
for i in $(seq 1 2160); do
  if [[ -f "$PREFETCH_DONE" ]]; then
    echo "[r2-merge] prefetch done at iter=$i $(date -u +%Y-%m-%dT%H:%M:%SZ)"
    break
  fi
  if (( i % 12 == 0 )); then
    crumb=$(tail -n 3 /root/logs/r2_prefetch_parents.log 2>/dev/null | tr '\r' '\n' | tail -1 || true)
    echo "[r2-merge] wait-prefetch iter=$i crumb=${crumb:-none}"
  fi
  if (( i == 2160 )); then
    echo "[r2-merge] TIMEOUT prefetch" >&2
    exit 2
  fi
  sleep 10
done

# 2) Wait R1 lane: either R1b cleared bar (skip R2) OR R1c decision exists
#    below bar and r1c train/merge pidfiles are dead (pidfile kill -0 only).
for i in $(seq 1 2880); do
  if [[ -f "$R1B_DEC" ]]; then
    read -r d1 h1 < <(python - <<'PY'
import json
from pathlib import Path
d=json.loads(Path("/root/affine_data/r1b_lora_decision.json").read_text())
print(d.get("decision","?"), d.get("headroom_vs_3se","nan"))
PY
)
    if python - <<PY
h=float("$h1") if "$h1"!="nan" else -1
raise SystemExit(0 if h>=float("$HEADROOM_BAR") else 1)
PY
    then
      echo "SKIP_R2_R1B_CLEARS decision=$d1 headroom=$h1 $(date -u +%Y-%m-%dT%H:%M:%SZ)" | tee "$DONE"
      exit 0
    fi
  fi
  if [[ -f "$R1C_DEC" ]]; then
    read -r d2 h2 < <(python - <<'PY'
import json
from pathlib import Path
d=json.loads(Path("/root/affine_data/r1c_lora_decision.json").read_text())
print(d.get("decision","?"), d.get("headroom_vs_3se","nan"))
PY
)
    if python - <<PY
h=float("$h2") if "$h2"!="nan" else -1
raise SystemExit(0 if h>=float("$HEADROOM_BAR") else 1)
PY
    then
      echo "SKIP_R2_R1C_CLEARS decision=$d2 headroom=$h2 $(date -u +%Y-%m-%dT%H:%M:%SZ)" | tee "$DONE"
      exit 0
    fi
    # R1c finished below bar → proceed only when R1c train/merge waiters are dead.
    # Use pidfile kill -0 (never pgrep -af): SSH/diagnostics contain the needle and
    # false-positive stall the α→n80 lane forever.
    r1c_busy=0
    for pf in /root/logs/r1c_train.pid /root/logs/r1c_merge_reload.pid; do
      if [[ -f "$pf" ]]; then
        ppid=$(cat "$pf" 2>/dev/null || true)
        if [[ -n "${ppid:-}" ]] && kill -0 "$ppid" 2>/dev/null; then
          r1c_busy=1
          break
        fi
      fi
    done
    if (( r1c_busy == 0 )); then
      echo "[r2-merge] R1c below bar; lane free at iter=$i"
      break
    fi
  fi
  # If chain stamped SKIP_R1C (R1b cleared) we already exited above when DEC present.
  # If chain LAUNCHED_R1C, keep waiting for R1C_DEC.
  if [[ -f "$CHAIN_STAMP" ]] && grep -q 'SKIP_R1C' "$CHAIN_STAMP" 2>/dev/null; then
    # R1b cleared — should have exited; if DEC missing, keep waiting.
    :
  fi
  if (( i % 12 == 0 )); then
    echo "[r2-merge] wait-r1-lane iter=$i $(date -u +%Y-%m-%dT%H:%M:%SZ) r1b_dec=$([[ -f $R1B_DEC ]] && echo y || echo n) r1c_dec=$([[ -f $R1C_DEC ]] && echo y || echo n)"
  fi
  if (( i == 2880 )); then
    echo "[r2-merge] TIMEOUT waiting R1 lane" >&2
    exit 2
  fi
  sleep 10
done

# shellcheck disable=SC1091
source /root/venv/bin/activate
if [[ -f /root/mine.env ]]; then
  set -a
  # shellcheck disable=SC1091
  source /root/mine.env
  set +a
fi
export PYTHONPATH=/root/mining_src/affine_pkg${PYTHONPATH:+:$PYTHONPATH}
export AFFINE_DATA_DIR=${AFFINE_DATA_DIR:-/root/affine_data}
export HF_HOME=${HF_HOME:-/root/hf}
export VLLM_USE_DEEP_GEMM=0
export VLLM_USE_FLASHINFER_SAMPLER=0
export VLLM_ALLREDUCE_USE_FLASHINFER=0
export VLLM_MOE_USE_DEEP_GEMM=0
export VLLM_USE_FLASHINFER_MOE_FP16=0
export VLLM_USE_FLASHINFER_MOE_FP4=0
export VLLM_USE_FLASHINFER_MOE_FP8=0

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
fi
if [[ -L /usr/local/cuda ]]; then
  rm -f /usr/local/cuda
fi

TOK=$(resolve_snap Tok331102/affine-5EqYW8McUc-af10 "$TOK_REV") || {
  echo "[r2-merge] FATAL missing Tok snapshot" >&2
  exit 2
}
TALENT=$(resolve_snap TalentPigs/affine-5ekxlcg3fx-abc "$TALENT_REV") || {
  echo "[r2-merge] FATAL missing TalentPigs snapshot" >&2
  exit 2
}
KEVIN=$(resolve_snap kevin954/Affine-5dfqbbh8ev-sft "$KEVIN_REV") || {
  echo "[r2-merge] FATAL missing kevin954 snapshot" >&2
  exit 2
}

MERGED=${MERGED:-/root/r2_out/alpha_tok_talent_kevin}
LINK=${LINK:-/tmp/r2_alpha_merged}
PREMERGE_DONE=${PREMERGE_DONE:-/root/logs/r2_premerge.done}

# Prefer CPU premerge stamped while R1 lane was still busy.
if [[ -f "$PREMERGE_DONE" && -f "$MERGED/model.safetensors.index.json" ]]; then
  echo "[r2-merge] reusing premerge $(cat "$PREMERGE_DONE")"
else
  rm -rf "$MERGED"
  mkdir -p "$MERGED"
  echo "[r2-merge] α-merge Tok:$W_TOK Talent:$W_TALENT Kevin:$W_KEVIN → $MERGED"
  python /root/mining_src/r2-multiking-merge/merge_alpha.py \
    --parent "${TOK}:${W_TOK}" \
    --parent "${TALENT}:${W_TALENT}" \
    --parent "${KEVIN}:${W_KEVIN}" \
    --out "$MERGED"
fi
ln -sfn "$MERGED" "$LINK"
echo "[r2-merge] link $LINK -> $(readlink -f "$LINK")"

# Stop chall by PID file only.
CHALL_PID_FILE=/root/logs/vllm_chall.pid
if [[ -f "$CHALL_PID_FILE" ]]; then
  CPID=$(cat "$CHALL_PID_FILE" || true)
  if [[ -n "${CPID:-}" ]] && kill -0 "$CPID" 2>/dev/null; then
    echo "[r2-merge] stopping chall pid=$CPID"
    kill "$CPID" || true
    for j in $(seq 1 60); do
      kill -0 "$CPID" 2>/dev/null || break
      sleep 2
    done
    if kill -0 "$CPID" 2>/dev/null; then
      kill -9 "$CPID" || true
    fi
  fi
fi
sleep 3

if [[ ! -d /root/.triton/cache/chall ]] || [[ -z "$(find /root/.triton/cache/chall -name '*.so' 2>/dev/null | head -1)" ]]; then
  if [[ -d /root/.triton/cache/king ]]; then
    echo "[r2-merge] seeding chall Triton cache from king"
    mkdir -p /root/.triton/cache/chall
    cp -a /root/.triton/cache/king/. /root/.triton/cache/chall/ || true
  fi
fi

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

echo "[r2-merge] launching chall :8002 on $LINK"
CUDA_VISIBLE_DEVICES=4,5 TRITON_CACHE_DIR=/root/.triton/cache/chall \
  nohup /root/venv/bin/vllm serve "$LINK" \
    --port 8002 --gpu-memory-utilization 0.72 \
    "${COMMON[@]}" \
    >/root/logs/vllm_chall.log 2>&1 &
echo $! >/root/logs/vllm_chall.pid
echo "[r2-merge] chall pid=$(cat /root/logs/vllm_chall.pid)"

for i in $(seq 1 480); do
  c0=$(curl -s -o /dev/null -w "%{http_code}" --max-time 3 http://127.0.0.1:8000/v1/models || true)
  c1=$(curl -s -o /dev/null -w "%{http_code}" --max-time 3 http://127.0.0.1:8001/v1/models || true)
  c2=$(curl -s -o /dev/null -w "%{http_code}" --max-time 3 http://127.0.0.1:8002/v1/models || true)
  if [[ "$c0$c1$c2" == "200200200" ]]; then
    echo "[r2-merge] engines 200/200/200 at iter=$i"
    break
  fi
  if (( i % 12 == 0 )); then
    echo "[r2-merge] wait-engines iter=$i codes=${c0}/${c1}/${c2}"
  fi
  if (( i == 480 )); then
    echo "[r2-merge] TIMEOUT engines; see vllm_chall.log" >&2
    exit 2
  fi
  sleep 5
done

OUT=/root/affine_data/r2_alpha_reason_sim.json
DEC=/root/affine_data/r2_alpha_decision.json
PROG=/root/affine_data/r2_alpha_reason_progress.json
rm -f "$OUT" "$DEC" "$PROG"
BH=$(python - <<'PY'
import hashlib, time
print(hashlib.sha256(f"r2-alpha-{time.time_ns()}".encode()).hexdigest())
PY
)

echo "[r2-merge] launching R2 n80 block_hash=${BH:0:16}…"
python /root/mining_src/r1-reason-distill/run_reason_sim.py \
  --n-turns 80 \
  --block-hash "$BH" \
  --hotkey "local-r2-alpha-$(date -u +%Y%m%dT%H%M%SZ)" \
  --king-repo Tok331102/affine-5EqYW8McUc-af10 \
  --king-rev eb8bf9a356a254f71faaa439e8abc3cfba572c53 \
  --chall-repo "$LINK" \
  --out "$OUT" \
  --progress-out "$PROG" \
  --save-artifact \
  2>&1 | tee /root/logs/r2_alpha_reason_sim.log

python /root/mining_src/r1-reason-distill/write_reason_decision.py \
  --sim-result "$OUT" --out "$DEC" --hyp R2 \
  2>&1 | tee -a /root/logs/r2_alpha_reason_sim.log

echo "[r2-merge] DONE $(date -u +%Y-%m-%dT%H:%M:%SZ)"
cat "$DEC"
echo "OK $(date -u +%Y-%m-%dT%H:%M:%SZ)" >"$DONE"
