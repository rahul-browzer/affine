#!/usr/bin/env bash
# R2az: after R2ay (pure sbs-v2) finishes or Stage-5-skips, serve pure
# vera6/...-vvv (queue chal-00497) as chall -> fresh n80 vs Tok.
# Prefer pure board parents -- Talent0.25 skew keeps REFUTEing.
# Board-first: skip if chal00497 already Reason− OR known hr < 1.5x.
# Wait R2ay terminal + vvv prefetch. Kill chall by PID file only.
set -euo pipefail
LOG=/root/logs/r2az_vvv_reload.log
DONE=/root/logs/r2az_vvv_reload.done
PIDF=/root/logs/r2az_vvv_reload.pid
HOLDING=${HOLDING:-/root/logs/r2az_vvv_holding.stamp}
mkdir -p /root/logs /root/affine_data /root/r2_out
echo $$ >"$PIDF"
exec > >(tee -a "$LOG") 2>&1

echo "[r2az-vvv] $(date -u +%Y-%m-%dT%H:%M:%SZ) start"
if [[ -f "$DONE" ]]; then
  echo "[r2az-vvv] already done: $(cat "$DONE")"
  exit 0
fi

HEADROOM_BAR=${HEADROOM_BAR:-1.5}
VVV_REPO=${VVV_REPO:-vera6/affine-5g4yy75zuz-vvv}
VVV_REV=${VVV_REV:-464761496a109a8140021e6232b2083f4268dc13}
VVV_SNAP=${VVV_SNAP:-/root/hf/hub/models--vera6--affine-5g4yy75zuz-vvv/snapshots/${VVV_REV}}
CHALL_DIR=${CHALL_DIR:-/root/r2_out/vvv_chall}
LINK=${LINK:-/tmp/r2az_vvv}
BOARD_REASON=${BOARD_REASON:-/root/affine_data/chal00497_reason.json}
WARM=${WARM_DONE:-/root/logs/warm_stack_ready.done}
PREFETCH_DONE=${PREFETCH_DONE:-/root/logs/r2_prefetch_vvv.done}
R2AY_PRIOR_DEC=${R2AY_PRIOR_DEC:-/root/affine_data/r2ay_sbs_v2_decision.json}
R2AY_PRIOR_DONE=${R2AY_PRIOR_DONE:-/root/logs/r2ay_sbs_v2_reload.done}
STAGE5_R2AY=${STAGE5_R2AY:-/root/affine_data/r2ay_stage5_ready.json}

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

# 0) Wait warm TKC stack.
echo "[r2az-vvv] waiting for warm_stack_ready"
for i in $(seq 1 2880); do
  if [[ -f "$WARM" ]]; then
    echo "[r2az-vvv] warm ready at iter=$i $(date -u +%Y-%m-%dT%H:%M:%SZ)"
    break
  fi
  if (( i % 12 == 0 )); then
    echo "[r2az-vvv] wait-warm iter=$i"
  fi
  if (( i == 2880 )); then
    echo "[r2az-vvv] TIMEOUT waiting warm_stack_ready" >&2
    exit 2
  fi
  sleep 10
done

# 1) Wait R2ay terminal. Skip if R2ay already clears Stage-5 / ≥1.5×.
echo "[r2az-vvv] waiting for R2ay terminal (pure vvv next)"
for i in $(seq 1 2880); do
  if [[ -f "$STAGE5_R2AY" ]]; then
    echo "SKIP_R2AZ_R2AY_STAGE5 $(date -u +%Y-%m-%dT%H:%M:%SZ)" | tee "$DONE"
    exit 0
  fi
  if [[ -f "$R2AY_PRIOR_DEC" ]] && headroom_ok "$R2AY_PRIOR_DEC"; then
    echo "SKIP_R2AZ_R2AY_CLEARS file=$R2AY_PRIOR_DEC $(date -u +%Y-%m-%dT%H:%M:%SZ)" | tee "$DONE"
    exit 0
  fi
  if [[ -f "$R2AY_PRIOR_DONE" || -f "$R2AY_PRIOR_DEC" ]]; then
    echo "[r2az-vvv] R2ay terminal at iter=$i $(date -u +%Y-%m-%dT%H:%M:%SZ)"
    break
  fi
  if (( i % 12 == 0 )); then
    crumb=$(python3 -c "from pathlib import Path;p=Path('/root/affine_data/r2ay_sbs_v2_reason_progress.json');
print(p.read_text().strip() if p.is_file() else 'no-progress')" 2>/dev/null || echo none)
    echo "[r2az-vvv] wait-r2ay iter=$i crumb=${crumb:-none}"
  fi
  if (( i == 2880 )); then
    echo "[r2az-vvv] TIMEOUT waiting R2ay" >&2
    exit 2
  fi
  sleep 10
done

# 2) Board-first skip if chal-00497 already Reason− OR known hr < 1.5×.
if [[ -f "$BOARD_REASON" ]]; then
  hr=$(python3 - <<PY
import json
from pathlib import Path
d=json.loads(Path("$BOARD_REASON").read_text())
h=d.get("headroom_vs_3se")
print("" if h is None else h)
PY
)
  if [[ -n "${hr}" ]]; then
    skip=$(python3 -c "print(1 if float('$hr') < float('$HEADROOM_BAR') else 0)")
    if [[ "$skip" == "1" ]]; then
      echo "SKIP_BOARD_SUB_BAR hr=$hr bar=$HEADROOM_BAR $(date -u +%Y-%m-%dT%H:%M:%SZ)" | tee "$DONE"
      python3 - <<PY
import json, time
from pathlib import Path
Path("/root/affine_data/r2az_vvv_decision.json").write_text(json.dumps({
    "utc": time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime()),
    "hyp": "R2az",
    "decision": "SKIP_BOARD_FIRST",
    "headroom_vs_3se": float("$hr"),
    "headroom_bar": float("$HEADROOM_BAR"),
    "note": "board chal-00497 hr already known < 1.5x; do not burn pure-vvv n80",
    "board_reason": "$BOARD_REASON",
    "vvv_repo": "$VVV_REPO",
    "vvv_rev": "$VVV_REV",
}, indent=2) + "\n")
PY
      exit 0
    fi
  fi
fi

# 3) Wait vvv prefetch (or accept snapshot already on disk).
echo "[r2az-vvv] waiting for vvv prefetch/index at $VVV_SNAP"
for i in $(seq 1 1440); do
  if [[ -f "$VVV_SNAP/model.safetensors.index.json" ]]; then
    echo "[r2az-vvv] vvv snapshot ready at iter=$i"
    break
  fi
  if [[ -f "$PREFETCH_DONE" ]] && [[ ! -f "$VVV_SNAP/model.safetensors.index.json" ]]; then
    echo "[r2az-vvv] FATAL prefetch done but index missing at $VVV_SNAP" >&2
    exit 2
  fi
  if (( i % 12 == 0 )); then
    crumb=$(tail -n 2 /root/logs/r2_prefetch_vvv.log 2>/dev/null | tr '\r' '\n' | tail -1 || true)
    echo "[r2az-vvv] wait-prefetch iter=$i crumb=${crumb:-none}"
  fi
  if (( i == 1440 )); then
    echo "[r2az-vvv] TIMEOUT waiting vvv snapshot" >&2
    exit 2
  fi
  sleep 10
done

# 4) Materialize thin chall dir.
mkdir -p "$CHALL_DIR"
for f in "$VVV_SNAP"/*; do
  base=$(basename "$f")
  [[ "$base" == "." || "$base" == ".." ]] && continue
  ln -sfn "$(readlink -f "$f")" "$CHALL_DIR/$base"
done
if [[ ! -f "$CHALL_DIR/preprocessor_config.json" ]]; then
  if [[ -f "$CHALL_DIR/processor_config.json" ]]; then
    cp -L "$CHALL_DIR/processor_config.json" "$CHALL_DIR/preprocessor_config.json"
    echo "[r2az-vvv] derived preprocessor_config.json from processor_config.json"
  else
    KING_PP=/root/hf/hub/models--Tok331102--affine-5EqYW8McUc-af10/snapshots/eb8bf9a356a254f71faaa439e8abc3cfba572c53/preprocessor_config.json
    if [[ -f "$KING_PP" ]]; then
      cp -L "$KING_PP" "$CHALL_DIR/preprocessor_config.json"
      echo "[r2az-vvv] copied preprocessor_config.json from Tok king"
    else
      echo "[r2az-vvv] FATAL no processor/preprocessor config" >&2
      exit 2
    fi
  fi
fi
echo "[r2az-vvv] chall dir ready: $CHALL_DIR"

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

ln -sfn "$CHALL_DIR" "$LINK"
echo "[r2az-vvv] link $LINK -> $(readlink -f "$LINK")"

echo "$(date -u +%Y-%m-%dT%H:%M:%SZ) claiming chall pure-vvv" >"$HOLDING"
trap 'rm -f "$HOLDING"' EXIT

CHALL_PID_FILE=/root/logs/vllm_chall.pid
if [[ -f "$CHALL_PID_FILE" ]]; then
  CPID=$(cat "$CHALL_PID_FILE" || true)
  if [[ -n "${CPID:-}" ]] && kill -0 "$CPID" 2>/dev/null; then
    echo "[r2az-vvv] stopping chall pid=$CPID"
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
# Orphan EngCore/Workers can OOM the next chall load.
# NEVER pgrep bare 'VLLM::EngineCore' — that also matches teacher/king.
# Only orphans on GPUs 4,5.
sleep 3
for op in $(pgrep -f 'VLLM::EngineCore|VLLM::Worker' 2>/dev/null || true); do
  envf="/proc/$op/environ"
  if [[ -r "$envf" ]] && tr '\0' '\n' <"$envf" 2>/dev/null | grep -qx 'CUDA_VISIBLE_DEVICES=4,5'; then
    echo "[r2az-vvv] killing leftover chall orphan pid=$op (CUDA 4,5)"
    kill "$op" 2>/dev/null || true
  fi
done
for op in $(pgrep -f 'vllm serve .*--port 8002' 2>/dev/null || true); do
  if [[ "$op" != "$$" ]] && kill -0 "$op" 2>/dev/null; then
    echo "[r2az-vvv] killing leftover chall serve pid=$op"
    kill "$op" 2>/dev/null || true
  fi
done
sleep 2

if [[ ! -d /root/.triton/cache/chall ]] || [[ -z "$(find /root/.triton/cache/chall -name '*.so' 2>/dev/null | head -1)" ]]; then
  if [[ -d /root/.triton/cache/king ]]; then
    echo "[r2az-vvv] seeding chall Triton cache from king"
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

echo "[r2az-vvv] launching chall :8002 on $LINK ($VVV_REPO@$VVV_REV)"
CUDA_VISIBLE_DEVICES=4,5 TRITON_CACHE_DIR=/root/.triton/cache/chall \
  nohup /root/venv/bin/vllm serve "$LINK" \
    --port 8002 --gpu-memory-utilization 0.72 \
    "${COMMON[@]}" \
    >/root/logs/vllm_chall.log 2>&1 &
echo $! >/root/logs/vllm_chall.pid
echo "[r2az-vvv] chall pid=$(cat /root/logs/vllm_chall.pid)"

for i in $(seq 1 480); do
  c0=$(curl -s -o /dev/null -w "%{http_code}" --max-time 3 http://127.0.0.1:8000/v1/models || true)
  c1=$(curl -s -o /dev/null -w "%{http_code}" --max-time 3 http://127.0.0.1:8001/v1/models || true)
  c2=$(curl -s -o /dev/null -w "%{http_code}" --max-time 3 http://127.0.0.1:8002/v1/models || true)
  if [[ "$c0$c1$c2" == "200200200" ]]; then
    echo "[r2az-vvv] engines 200/200/200 at iter=$i"
    break
  fi
  if (( i % 12 == 0 )); then
    echo "[r2az-vvv] wait-engines iter=$i codes=${c0}/${c1}/${c2}"
  fi
  if (( i == 480 )); then
    echo "[r2az-vvv] TIMEOUT engines; see vllm_chall.log" >&2
    exit 2
  fi
  sleep 5
done

OUT=/root/affine_data/r2az_vvv_reason_sim.json
DEC=/root/affine_data/r2az_vvv_decision.json
PROG=/root/affine_data/r2az_vvv_reason_progress.json
rm -f "$OUT" "$DEC" "$PROG"
BH=$(python - <<'PY'
import hashlib, time
print(hashlib.sha256(f"r2az-vvv-{time.time_ns()}".encode()).hexdigest())
PY
)

echo "[r2az-vvv] launching R2az n80 block_hash=${BH:0:16}…"
python /root/mining_src/r1-reason-distill/run_reason_sim.py \
  --n-turns 80 \
  --block-hash "$BH" \
  --hotkey "local-r2az-vvv-$(date -u +%Y%m%dT%H:%M:%SZ)" \
  --king-repo Tok331102/affine-5EqYW8McUc-af10 \
  --king-rev eb8bf9a356a254f71faaa439e8abc3cfba572c53 \
  --chall-repo "$LINK" \
  --out "$OUT" \
  --progress-out "$PROG" \
  --save-artifact \
  2>&1 | tee /root/logs/r2az_vvv_reason_sim.log

python /root/mining_src/r1-reason-distill/write_reason_decision.py \
  --sim-result "$OUT" --out "$DEC" --hyp R2az \
  2>&1 | tee -a /root/logs/r2az_vvv_reason_sim.log

echo "[r2az-vvv] DONE $(date -u +%Y-%m-%dT%H:%M:%SZ)"
cat "$DEC"
echo "OK $(date -u +%Y-%m-%dT%H:%M:%SZ)" >"$DONE"
cp -f "$DEC" /root/logs/r2az_vvv_decision.json 2>/dev/null || true
cp -f "$DONE" /root/affine_data/r2az_vvv_reload.done 2>/dev/null || true
