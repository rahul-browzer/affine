#!/usr/bin/env bash
# R2al: after R2ak (pure google / chal-00470) finishes or SKIP_BOARD, serve pure
# diceofgod/…-pig (queue chal-00471) as chall → fresh n80 vs Tok.
# Prefer pure board parents — Talent skews keep REFUTING.
# Board-first: skip if chal00471 already Reason− OR known hr < 1.5×.
# Wait warm + R2ak terminal + pig prefetch. Kill chall by PID file only.
# Pre-registered: submit only if headroom ≥ 1.5×(3·SE).
set -euo pipefail
LOG=/root/logs/r2al_pig_reload.log
DONE=/root/logs/r2al_pig_reload.done
PIDF=/root/logs/r2al_pig_reload.pid
HOLDING=${HOLDING:-/root/logs/r2al_pig_holding.stamp}
mkdir -p /root/logs /root/affine_data /root/r2_out
echo $$ >"$PIDF"
exec > >(tee -a "$LOG") 2>&1

echo "[r2al-pig] $(date -u +%Y-%m-%dT%H:%M:%SZ) start"
if [[ -f "$DONE" ]]; then
  echo "[r2al-pig] already done: $(cat "$DONE")"
  exit 0
fi

HEADROOM_BAR=${HEADROOM_BAR:-1.5}
PIG_REPO=${PIG_REPO:-diceofgod/affine-5fjgc5jhxq-pig}
PIG_REV=${PIG_REV:-e4889db406e743bc878d75183aed79bc59915463}
PIG_SNAP=${PIG_SNAP:-/root/hf/hub/models--diceofgod--affine-5fjgc5jhxq-pig/snapshots/${PIG_REV}}
CHALL_DIR=${CHALL_DIR:-/root/r2_out/pig_chall}
LINK=${LINK:-/tmp/r2al_pig}
BOARD_REASON=${BOARD_REASON:-/root/affine_data/chal00471_reason.json}
WARM=${WARM_DONE:-/root/logs/warm_stack_ready.done}
PREFETCH_DONE=${PREFETCH_DONE:-/root/logs/r2_prefetch_pig.done}
R2AK_DEC=${R2AK_DEC:-/root/affine_data/r2ak_google_decision.json}
R2AK_DONE=${R2AK_DONE:-/root/logs/r2ak_google_reload.done}
STAGE5_R2AK=${STAGE5_R2AK:-/root/affine_data/r2ak_stage5_ready.json}

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

# 0) Wait warm TKC stack (R2ak may still be waiting on it).
echo "[r2al-pig] waiting for warm_stack_ready"
for i in $(seq 1 2880); do
  if [[ -f "$WARM" ]]; then
    echo "[r2al-pig] warm ready at iter=$i $(date -u +%Y-%m-%dT%H:%M:%SZ)"
    break
  fi
  if (( i % 12 == 0 )); then
    echo "[r2al-pig] wait-warm iter=$i"
  fi
  if (( i == 2880 )); then
    echo "[r2al-pig] TIMEOUT waiting warm_stack_ready" >&2
    exit 2
  fi
  sleep 10
done

# 1) Wait R2ak terminal. Skip if R2ak already clears Stage-5 / ≥1.5×.
echo "[r2al-pig] waiting for R2ak terminal (pure pig next)"
for i in $(seq 1 2880); do
  if [[ -f "$STAGE5_R2AK" ]]; then
    echo "SKIP_R2AL_R2AK_STAGE5 $(date -u +%Y-%m-%dT%H:%M:%SZ)" | tee "$DONE"
    exit 0
  fi
  if [[ -f "$R2AK_DEC" ]] && headroom_ok "$R2AK_DEC"; then
    echo "SKIP_R2AL_R2AK_CLEARS file=$R2AK_DEC $(date -u +%Y-%m-%dT%H:%M:%SZ)" | tee "$DONE"
    exit 0
  fi
  if [[ -f "$R2AK_DONE" || -f "$R2AK_DEC" ]]; then
    echo "[r2al-pig] R2ak terminal at iter=$i $(date -u +%Y-%m-%dT%H:%M:%SZ)"
    break
  fi
  if (( i % 12 == 0 )); then
    echo "[r2al-pig] wait-r2ak iter=$i"
  fi
  if (( i == 2880 )); then
    echo "[r2al-pig] TIMEOUT waiting R2ak" >&2
    exit 2
  fi
  sleep 10
done

# 2) Board-first skip if chal-00471 already Reason− OR known hr < 1.5×.
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
Path("/root/affine_data/r2al_pig_decision.json").write_text(json.dumps({
    "utc": time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime()),
    "hyp": "R2al",
    "decision": "SKIP_BOARD_FIRST",
    "headroom_vs_3se": float("$hr"),
    "headroom_bar": float("$HEADROOM_BAR"),
    "note": "board chal-00471 hr already known < 1.5×; do not burn pure-pig n80",
    "board_reason": "$BOARD_REASON",
    "pig_repo": "$PIG_REPO",
    "pig_rev": "$PIG_REV",
}, indent=2) + "\n")
PY
      exit 0
    fi
  fi
fi

# 3) Wait pig prefetch (or accept snapshot already on disk).
echo "[r2al-pig] waiting for pig prefetch/index at $PIG_SNAP"
for i in $(seq 1 1440); do
  if [[ -f "$PIG_SNAP/model.safetensors.index.json" ]]; then
    echo "[r2al-pig] pig snapshot ready at iter=$i"
    break
  fi
  if [[ -f "$PREFETCH_DONE" ]] && [[ ! -f "$PIG_SNAP/model.safetensors.index.json" ]]; then
    echo "[r2al-pig] FATAL prefetch done but index missing at $PIG_SNAP" >&2
    exit 2
  fi
  if (( i % 12 == 0 )); then
    crumb=$(tail -n 2 /root/logs/r2_prefetch_pig.log 2>/dev/null | tr '\r' '\n' | tail -1 || true)
    echo "[r2al-pig] wait-prefetch iter=$i crumb=${crumb:-none}"
  fi
  if (( i == 1440 )); then
    echo "[r2al-pig] TIMEOUT waiting pig snapshot" >&2
    exit 2
  fi
  sleep 10
done

# 4) Materialize thin chall dir.
mkdir -p "$CHALL_DIR"
for f in "$PIG_SNAP"/*; do
  base=$(basename "$f")
  [[ "$base" == "." || "$base" == ".." ]] && continue
  ln -sfn "$(readlink -f "$f")" "$CHALL_DIR/$base"
done
if [[ ! -f "$CHALL_DIR/preprocessor_config.json" ]]; then
  if [[ -f "$CHALL_DIR/processor_config.json" ]]; then
    cp -L "$CHALL_DIR/processor_config.json" "$CHALL_DIR/preprocessor_config.json"
    echo "[r2al-pig] derived preprocessor_config.json from processor_config.json"
  else
    KING_PP=/root/hf/hub/models--Tok331102--affine-5EqYW8McUc-af10/snapshots/eb8bf9a356a254f71faaa439e8abc3cfba572c53/preprocessor_config.json
    if [[ -f "$KING_PP" ]]; then
      cp -L "$KING_PP" "$CHALL_DIR/preprocessor_config.json"
      echo "[r2al-pig] copied preprocessor_config.json from Tok king"
    else
      echo "[r2al-pig] FATAL no processor/preprocessor config" >&2
      exit 2
    fi
  fi
fi
echo "[r2al-pig] chall dir ready: $CHALL_DIR"

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
echo "[r2al-pig] link $LINK -> $(readlink -f "$LINK")"

echo "$(date -u +%Y-%m-%dT%H:%M:%SZ) claiming chall pure-pig" >"$HOLDING"
trap 'rm -f "$HOLDING"' EXIT

CHALL_PID_FILE=/root/logs/vllm_chall.pid
if [[ -f "$CHALL_PID_FILE" ]]; then
  CPID=$(cat "$CHALL_PID_FILE" || true)
  if [[ -n "${CPID:-}" ]] && kill -0 "$CPID" 2>/dev/null; then
    echo "[r2al-pig] stopping chall pid=$CPID"
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
    echo "[r2al-pig] seeding chall Triton cache from king"
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

echo "[r2al-pig] launching chall :8002 on $LINK ($PIG_REPO@$PIG_REV)"
CUDA_VISIBLE_DEVICES=4,5 TRITON_CACHE_DIR=/root/.triton/cache/chall \
  nohup /root/venv/bin/vllm serve "$LINK" \
    --port 8002 --gpu-memory-utilization 0.72 \
    "${COMMON[@]}" \
    >/root/logs/vllm_chall.log 2>&1 &
echo $! >/root/logs/vllm_chall.pid
echo "[r2al-pig] chall pid=$(cat /root/logs/vllm_chall.pid)"

for i in $(seq 1 480); do
  c0=$(curl -s -o /dev/null -w "%{http_code}" --max-time 3 http://127.0.0.1:8000/v1/models || true)
  c1=$(curl -s -o /dev/null -w "%{http_code}" --max-time 3 http://127.0.0.1:8001/v1/models || true)
  c2=$(curl -s -o /dev/null -w "%{http_code}" --max-time 3 http://127.0.0.1:8002/v1/models || true)
  if [[ "$c0$c1$c2" == "200200200" ]]; then
    echo "[r2al-pig] engines 200/200/200 at iter=$i"
    break
  fi
  if (( i % 12 == 0 )); then
    echo "[r2al-pig] wait-engines iter=$i codes=${c0}/${c1}/${c2}"
  fi
  if (( i == 480 )); then
    echo "[r2al-pig] TIMEOUT engines; see vllm_chall.log" >&2
    exit 2
  fi
  sleep 5
done

OUT=/root/affine_data/r2al_pig_reason_sim.json
DEC=/root/affine_data/r2al_pig_decision.json
PROG=/root/affine_data/r2al_pig_reason_progress.json
rm -f "$OUT" "$DEC" "$PROG"
BH=$(python - <<'PY'
import hashlib, time
print(hashlib.sha256(f"r2al-pig-{time.time_ns()}".encode()).hexdigest())
PY
)

echo "[r2al-pig] launching R2al n80 block_hash=${BH:0:16}…"
python /root/mining_src/r1-reason-distill/run_reason_sim.py \
  --n-turns 80 \
  --block-hash "$BH" \
  --hotkey "local-r2al-pig-$(date -u +%Y%m%dT%H:%M:%SZ)" \
  --king-repo Tok331102/affine-5EqYW8McUc-af10 \
  --king-rev eb8bf9a356a254f71faaa439e8abc3cfba572c53 \
  --chall-repo "$LINK" \
  --out "$OUT" \
  --progress-out "$PROG" \
  --save-artifact \
  2>&1 | tee /root/logs/r2al_pig_reason_sim.log

python /root/mining_src/r1-reason-distill/write_reason_decision.py \
  --sim-result "$OUT" --out "$DEC" --hyp R2al \
  2>&1 | tee -a /root/logs/r2al_pig_reason_sim.log

echo "[r2al-pig] DONE $(date -u +%Y-%m-%dT%H:%M:%SZ)"
cat "$DEC"
echo "OK $(date -u +%Y-%m-%dT%H:%M:%SZ)" >"$DONE"
