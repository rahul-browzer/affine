#!/usr/bin/env bash
# After R2b resolves below bar + R2c skew premerge: reload chall from
# /root/r2_out/alpha_tok_awesome_v6_skew → fresh n80 vs Tok.
# Does NOT touch teacher:8000 or king:8001. Kill chall by PID file only.
# Pre-registered: submit only if headroom ≥ 1.5×(3·SE).
set -euo pipefail
LOG=/root/logs/r2c_merge_reload.log
DONE=/root/logs/r2c_merge_reload.done
PIDF=/root/logs/r2c_merge_reload.pid
mkdir -p /root/logs /root/affine_data /root/r2_out
echo $$ >"$PIDF"
exec > >(tee -a "$LOG") 2>&1

echo "[r2c-merge] $(date -u +%Y-%m-%dT%H:%M:%SZ) start"
if [[ -f "$DONE" ]]; then
  echo "[r2c-merge] already done: $(cat "$DONE")"
  exit 0
fi

PREMERGE_DONE=${PREMERGE_DONE:-/root/logs/r2c_premerge.done}
R1C_DEC=${R1C_DEC:-/root/affine_data/r1c_lora_decision.json}
R1B_DEC=${R1B_DEC:-/root/affine_data/r1b_lora_decision.json}
R2_DEC=${R2_DEC:-/root/affine_data/r2_alpha_decision.json}
R2B_DEC=${R2B_DEC:-/root/affine_data/r2b_alpha_decision.json}
HEADROOM_BAR=${HEADROOM_BAR:-1.5}
MERGED=${MERGED:-/root/r2_out/alpha_tok_awesome_v6_skew}
LINK=${LINK:-/tmp/r2c_alpha_merged}

# 1) Wait R2c CPU skew premerge.
for i in $(seq 1 2160); do
  if [[ -f "$PREMERGE_DONE" && -f "$MERGED/model.safetensors.index.json" ]]; then
    echo "[r2c-merge] premerge ready at iter=$i $(date -u +%Y-%m-%dT%H:%M:%SZ) $(cat "$PREMERGE_DONE")"
    break
  fi
  if (( i % 12 == 0 )); then
    crumb=$(tail -n 3 /root/logs/r2c_premerge.log 2>/dev/null | tr '\r' '\n' | tail -1 || true)
    echo "[r2c-merge] wait-premerge iter=$i crumb=${crumb:-none}"
  fi
  if (( i == 2160 )); then
    echo "[r2c-merge] TIMEOUT premerge" >&2
    exit 2
  fi
  sleep 10
done

headroom_ok() {
  local f="$1"
  python - <<PY
import json
from pathlib import Path
p=Path("$f")
if not p.is_file():
    raise SystemExit(1)
d=json.loads(p.read_text())
h=d.get("headroom_vs_3se")
raise SystemExit(0 if h is not None and float(h)>=float("$HEADROOM_BAR") else 1)
PY
}

# 2) Wait prior lanes: skip if any clears bar; else need R2b decision + R2b reload dead.
R2B_DONE=${R2B_DONE:-/root/logs/r2b_merge_reload.done}
for i in $(seq 1 2880); do
  for f in "$R1B_DEC" "$R1C_DEC" "$R2_DEC" "$R2B_DEC"; do
    if [[ -f "$f" ]] && headroom_ok "$f"; then
      echo "SKIP_R2C_PRIOR_CLEARS file=$f $(date -u +%Y-%m-%dT%H:%M:%SZ)" | tee "$DONE"
      exit 0
    fi
  done
  if [[ -f "$R2B_DONE" ]] && grep -q 'SKIP_R2B' "$R2B_DONE" 2>/dev/null; then
    echo "SKIP_R2C_R2B_SKIPPED $(cat "$R2B_DONE")" | tee "$DONE"
    exit 0
  fi
  if [[ -f "$R2B_DEC" ]]; then
    r2b_busy=0
    if [[ -f /root/logs/r2b_merge_reload.pid ]]; then
      ppid=$(cat /root/logs/r2b_merge_reload.pid 2>/dev/null || true)
      if [[ -n "${ppid:-}" ]] && kill -0 "$ppid" 2>/dev/null; then
        r2b_busy=1
      fi
    fi
    if (( r2b_busy == 0 )); then
      echo "[r2c-merge] R2b below bar; lane free at iter=$i"
      break
    fi
  fi
  if (( i % 12 == 0 )); then
    echo "[r2c-merge] wait-r2b-lane iter=$i $(date -u +%Y-%m-%dT%H:%M:%SZ) r2b_dec=$([[ -f $R2B_DEC ]] && echo y || echo n) r1c_dec=$([[ -f $R1C_DEC ]] && echo y || echo n) r2b_done=$([[ -f $R2B_DONE ]] && echo y || echo n)"
  fi
  if (( i == 2880 )); then
    echo "[r2c-merge] TIMEOUT waiting R2b lane" >&2
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

ln -sfn "$MERGED" "$LINK"
echo "[r2c-merge] link $LINK -> $(readlink -f "$LINK")"

CHALL_PID_FILE=/root/logs/vllm_chall.pid
if [[ -f "$CHALL_PID_FILE" ]]; then
  CPID=$(cat "$CHALL_PID_FILE" || true)
  if [[ -n "${CPID:-}" ]] && kill -0 "$CPID" 2>/dev/null; then
    echo "[r2c-merge] stopping chall pid=$CPID"
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
    echo "[r2c-merge] seeding chall Triton cache from king"
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

echo "[r2c-merge] launching chall :8002 on $LINK"
CUDA_VISIBLE_DEVICES=4,5 TRITON_CACHE_DIR=/root/.triton/cache/chall \
  nohup /root/venv/bin/vllm serve "$LINK" \
    --port 8002 --gpu-memory-utilization 0.72 \
    "${COMMON[@]}" \
    >/root/logs/vllm_chall.log 2>&1 &
echo $! >/root/logs/vllm_chall.pid
echo "[r2c-merge] chall pid=$(cat /root/logs/vllm_chall.pid)"

for i in $(seq 1 480); do
  c0=$(curl -s -o /dev/null -w "%{http_code}" --max-time 3 http://127.0.0.1:8000/v1/models || true)
  c1=$(curl -s -o /dev/null -w "%{http_code}" --max-time 3 http://127.0.0.1:8001/v1/models || true)
  c2=$(curl -s -o /dev/null -w "%{http_code}" --max-time 3 http://127.0.0.1:8002/v1/models || true)
  if [[ "$c0$c1$c2" == "200200200" ]]; then
    echo "[r2c-merge] engines 200/200/200 at iter=$i"
    break
  fi
  if (( i % 12 == 0 )); then
    echo "[r2c-merge] wait-engines iter=$i codes=${c0}/${c1}/${c2}"
  fi
  if (( i == 480 )); then
    echo "[r2c-merge] TIMEOUT engines; see vllm_chall.log" >&2
    exit 2
  fi
  sleep 5
done

OUT=/root/affine_data/r2c_alpha_reason_sim.json
DEC=/root/affine_data/r2c_alpha_decision.json
PROG=/root/affine_data/r2c_alpha_reason_progress.json
rm -f "$OUT" "$DEC" "$PROG"
BH=$(python - <<'PY'
import hashlib, time
print(hashlib.sha256(f"r2c-skew-{time.time_ns()}".encode()).hexdigest())
PY
)

echo "[r2c-merge] launching R2c n80 block_hash=${BH:0:16}…"
python /root/mining_src/r1-reason-distill/run_reason_sim.py \
  --n-turns 80 \
  --block-hash "$BH" \
  --hotkey "local-r2c-skew-$(date -u +%Y%m%dT%H%M%SZ)" \
  --king-repo Tok331102/affine-5EqYW8McUc-af10 \
  --king-rev eb8bf9a356a254f71faaa439e8abc3cfba572c53 \
  --chall-repo "$LINK" \
  --out "$OUT" \
  --progress-out "$PROG" \
  --save-artifact \
  2>&1 | tee /root/logs/r2c_alpha_reason_sim.log

python /root/mining_src/r1-reason-distill/write_reason_decision.py \
  --sim-result "$OUT" --out "$DEC" --hyp R2c \
  2>&1 | tee -a /root/logs/r2c_alpha_reason_sim.log

echo "[r2c-merge] DONE $(date -u +%Y-%m-%dT%H:%M:%SZ)"
cat "$DEC"
echo "OK $(date -u +%Y-%m-%dT%H:%M:%SZ)" >"$DONE"
