#!/usr/bin/env bash
# R2f: after R2e (Talent×awesome) resolves below bar + kevin×awesome skew
# premerge ready → reload chall → fresh n80 vs Tok.
# Does NOT touch teacher:8000 or king:8001. Kill chall by PID file only.
# Pre-registered: submit only if headroom ≥ 1.5×(3·SE).
set -euo pipefail
LOG=/root/logs/r2f_merge_reload.log
DONE=/root/logs/r2f_merge_reload.done
PIDF=/root/logs/r2f_merge_reload.pid
mkdir -p /root/logs /root/affine_data /root/r2_out
echo $$ >"$PIDF"
exec > >(tee -a "$LOG") 2>&1

echo "[r2f-merge] $(date -u +%Y-%m-%dT%H:%M:%SZ) start"
if [[ -f "$DONE" ]]; then
  echo "[r2f-merge] already done: $(cat "$DONE")"
  exit 0
fi

PREMERGE_DONE=${PREMERGE_DONE:-/root/logs/r2f_premerge.done}
R2D_DEC=${R2D_DEC:-/root/affine_data/r2d_awesome_decision.json}
R2E_DEC=${R2E_DEC:-/root/affine_data/r2e_alpha_decision.json}
R2E_DONE=${R2E_DONE:-/root/logs/r2e_merge_reload.done}
HEADROOM_BAR=${HEADROOM_BAR:-1.5}
MERGED=${MERGED:-/root/r2_out/alpha_kevin_awesome_v6_skew}
LINK=${LINK:-/tmp/r2f_alpha_merged}

# 1) Wait R2f CPU premerge.
for i in $(seq 1 2160); do
  if [[ -f "$PREMERGE_DONE" && -f "$MERGED/model.safetensors.index.json" ]]; then
    echo "[r2f-merge] premerge ready at iter=$i $(date -u +%Y-%m-%dT%H:%M:%SZ) $(cat "$PREMERGE_DONE")"
    break
  fi
  if (( i % 12 == 0 )); then
    crumb=$(tail -n 3 /root/logs/r2f_premerge.log 2>/dev/null | tr '\r' '\n' | tail -1 || true)
    echo "[r2f-merge] wait-premerge iter=$i crumb=${crumb:-none}"
  fi
  if (( i == 2160 )); then
    echo "[r2f-merge] TIMEOUT premerge" >&2
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

# 2) Wait prior lanes: skip if R2d/R2e clears bar; else need R2e decision + R2e reload dead.
for i in $(seq 1 2880); do
  for f in "$R2D_DEC" "$R2E_DEC"; do
    if [[ -f "$f" ]] && headroom_ok "$f"; then
      echo "SKIP_R2F_PRIOR_CLEARS file=$f $(date -u +%Y-%m-%dT%H:%M:%SZ)" | tee "$DONE"
      exit 0
    fi
  done
  if [[ -f "$R2E_DONE" ]] && grep -q 'SKIP_R2E' "$R2E_DONE" 2>/dev/null; then
    # R2e skipped for a non-clear reason — still require its decision path or R2d free
    :
  fi
  if [[ -f "$R2E_DEC" ]]; then
    r2e_busy=0
    if [[ -f /root/logs/r2e_merge_reload.pid ]]; then
      ppid=$(cat /root/logs/r2e_merge_reload.pid 2>/dev/null || true)
      if [[ -n "${ppid:-}" ]] && kill -0 "$ppid" 2>/dev/null; then
        r2e_busy=1
      fi
    fi
    if (( r2e_busy == 0 )); then
      echo "[r2f-merge] R2e below bar; lane free at iter=$i"
      break
    fi
  fi
  if (( i % 12 == 0 )); then
    echo "[r2f-merge] wait-r2e-lane iter=$i $(date -u +%Y-%m-%dT%H:%M:%SZ) r2e_dec=$([[ -f $R2E_DEC ]] && echo y || echo n) r2d_dec=$([[ -f $R2D_DEC ]] && echo y || echo n) r2e_done=$([[ -f $R2E_DONE ]] && echo y || echo n) premerge=$([[ -f $PREMERGE_DONE ]] && echo y || echo n)"
  fi
  if (( i == 2880 )); then
    echo "[r2f-merge] TIMEOUT waiting R2e lane" >&2
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
echo "[r2f-merge] link $LINK -> $(readlink -f "$LINK")"

CHALL_PID_FILE=/root/logs/vllm_chall.pid
if [[ -f "$CHALL_PID_FILE" ]]; then
  CPID=$(cat "$CHALL_PID_FILE" || true)
  if [[ -n "${CPID:-}" ]] && kill -0 "$CPID" 2>/dev/null; then
    echo "[r2f-merge] stopping chall pid=$CPID"
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
    echo "[r2f-merge] seeding chall Triton cache from king"
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

echo "[r2f-merge] launching chall :8002 on $LINK"
CUDA_VISIBLE_DEVICES=4,5 TRITON_CACHE_DIR=/root/.triton/cache/chall \
  nohup /root/venv/bin/vllm serve "$LINK" \
    --port 8002 --gpu-memory-utilization 0.72 \
    "${COMMON[@]}" \
    >/root/logs/vllm_chall.log 2>&1 &
echo $! >/root/logs/vllm_chall.pid
echo "[r2f-merge] chall pid=$(cat /root/logs/vllm_chall.pid)"

for i in $(seq 1 480); do
  c0=$(curl -s -o /dev/null -w "%{http_code}" --max-time 3 http://127.0.0.1:8000/v1/models || true)
  c1=$(curl -s -o /dev/null -w "%{http_code}" --max-time 3 http://127.0.0.1:8001/v1/models || true)
  c2=$(curl -s -o /dev/null -w "%{http_code}" --max-time 3 http://127.0.0.1:8002/v1/models || true)
  if [[ "$c0$c1$c2" == "200200200" ]]; then
    echo "[r2f-merge] engines 200/200/200 at iter=$i"
    break
  fi
  if (( i % 12 == 0 )); then
    echo "[r2f-merge] wait-engines iter=$i codes=${c0}/${c1}/${c2}"
  fi
  if (( i == 480 )); then
    echo "[r2f-merge] TIMEOUT engines; see vllm_chall.log" >&2
    exit 2
  fi
  sleep 5
done

OUT=/root/affine_data/r2f_alpha_reason_sim.json
DEC=/root/affine_data/r2f_alpha_decision.json
PROG=/root/affine_data/r2f_alpha_reason_progress.json
rm -f "$OUT" "$DEC" "$PROG"
BH=$(python - <<'PY'
import hashlib, time
print(hashlib.sha256(f"r2f-kevin-awesome-{time.time_ns()}".encode()).hexdigest())
PY
)

echo "[r2f-merge] launching R2f n80 block_hash=${BH:0:16}…"
python /root/mining_src/r1-reason-distill/run_reason_sim.py \
  --n-turns 80 \
  --block-hash "$BH" \
  --hotkey "local-r2f-kevin-awesome-$(date -u +%Y%m%dT%H%M%SZ)" \
  --king-repo Tok331102/affine-5EqYW8McUc-af10 \
  --king-rev eb8bf9a356a254f71faaa439e8abc3cfba572c53 \
  --chall-repo "$LINK" \
  --out "$OUT" \
  --progress-out "$PROG" \
  --save-artifact \
  2>&1 | tee /root/logs/r2f_alpha_reason_sim.log

python /root/mining_src/r1-reason-distill/write_reason_decision.py \
  --sim-result "$OUT" --out "$DEC" --hyp R2f \
  2>&1 | tee -a /root/logs/r2f_alpha_reason_sim.log

echo "[r2f-merge] DONE $(date -u +%Y-%m-%dT%H:%M:%SZ)"
cat "$DEC"
echo "OK $(date -u +%Y-%m-%dT%H:%M:%SZ)" >"$DONE"
