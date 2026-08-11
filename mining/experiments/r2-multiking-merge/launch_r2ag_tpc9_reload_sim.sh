#!/usr/bin/env bash
# R2ag: while chal-00463 (llorite/…-tpc9) sits in load_challenger and Talent×tpc9
# (R2y) is still Reason-gated, burn idle crown GPUs on pure tpc9 as chall → fresh
# n80 vs Tok (R2v/R2af analogue). Does NOT wait on board Reason stamps.
# Sibling merge scripts wait on r2ag holding via wait_r2q_before_chall_kill.inc.sh.
# Does NOT touch teacher:8000 or king:8001. Kill chall by PID file only.
# Pre-registered: submit only if headroom ≥ 1.5×(3·SE).
set -euo pipefail
LOG=/root/logs/r2ag_tpc9_reload.log
DONE=/root/logs/r2ag_tpc9_reload.done
PIDF=/root/logs/r2ag_tpc9_reload.pid
HOLDING=${HOLDING:-/root/logs/r2ag_tpc9_holding.stamp}
mkdir -p /root/logs /root/affine_data /root/r2_out
echo $$ >"$PIDF"
exec > >(tee -a "$LOG") 2>&1

echo "[r2ag-tpc9] $(date -u +%Y-%m-%dT%H:%M:%SZ) start"
if [[ -f "$DONE" ]]; then
  echo "[r2ag-tpc9] already done: $(cat "$DONE")"
  exit 0
fi

HEADROOM_BAR=${HEADROOM_BAR:-1.5}
TPC9_REPO=${TPC9_REPO:-llorite/affine-5cjfxpsxn8-tpc9}
TPC9_REV=${TPC9_REV:-dba3b6f31b3078cda332434b962c8343ea2aa7d4}
TPC9_SNAP=${TPC9_SNAP:-/root/hf/hub/models--llorite--affine-5cjfxpsxn8-tpc9/snapshots/${TPC9_REV}}
CHALL_DIR=${CHALL_DIR:-/root/r2_out/tpc9_chall}
LINK=${LINK:-/tmp/r2ag_tpc9}
BOARD_REASON=${BOARD_REASON:-/root/affine_data/chal00463_reason.json}
R2Y_DEC=${R2Y_DEC:-/root/affine_data/r2y_alpha_decision.json}
R2Y_DONE=${R2Y_DONE:-/root/logs/r2y_merge_reload.done}
R2Y_PREMERGE_SKIP=${R2Y_PREMERGE_SKIP:-/root/logs/r2y_premerge.skip}
R2Y_PREMERGE_DONE=${R2Y_PREMERGE_DONE:-/root/logs/r2y_premerge.done}
STAGE5_R2Y=${STAGE5_R2Y:-/root/affine_data/r2y_stage5_ready.json}

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

lane_terminal() {
  local done="$1" skip="$2" dec="$3"
  [[ -f "$done" || -f "$skip" || -f "$dec" ]]
}

# 0) If board already stamped Reason−, skip pure local (R2af lesson).
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
    ok=$(python3 -c "print(1 if float('$hr')>0 else 0)")
    if [[ "$ok" != "1" ]]; then
      echo "SKIP_BOARD_REASON_NEG hr=$hr $(date -u +%Y-%m-%dT%H:%M:%SZ)" | tee "$DONE"
      python3 - <<PY
import json, time
from pathlib import Path
Path("/root/affine_data/r2ag_tpc9_decision.json").write_text(json.dumps({
    "utc": time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime()),
    "hyp": "R2ag",
    "decision": "SKIP_BOARD_FIRST",
    "headroom_vs_3se": float("$hr"),
    "note": "board chal-00463 already Reason−; do not burn pure-tpc9 n80",
    "board_reason": "$BOARD_REASON",
}, indent=2) + "\n")
PY
      exit 0
    fi
  fi
fi

# 1) Yield if R2y already cleared Stage-5 / bar, or already claimed GPU via premerge.done.
if [[ -f "$STAGE5_R2Y" ]]; then
  echo "SKIP_R2AG_R2Y_STAGE5 $(date -u +%Y-%m-%dT%H:%M:%SZ)" | tee "$DONE"
  exit 0
fi
if [[ -f "$R2Y_DEC" ]] && headroom_ok "$R2Y_DEC"; then
  echo "SKIP_R2AG_R2Y_CLEARS file=$R2Y_DEC $(date -u +%Y-%m-%dT%H:%M:%SZ)" | tee "$DONE"
  exit 0
fi

for i in $(seq 1 2880); do
  if [[ -f "$R2Y_DEC" ]] && headroom_ok "$R2Y_DEC"; then
    echo "SKIP_R2AG_R2Y_CLEARS file=$R2Y_DEC $(date -u +%Y-%m-%dT%H:%M:%SZ)" | tee "$DONE"
    exit 0
  fi
  busy=0
  if [[ -f "$R2Y_PREMERGE_DONE" ]] && ! lane_terminal "$R2Y_DONE" "$R2Y_PREMERGE_SKIP" "$R2Y_DEC"; then
    busy=1
  fi
  if (( busy == 0 )); then
    echo "[r2ag-tpc9] lane free at iter=$i $(date -u +%Y-%m-%dT%H:%M:%SZ)"
    break
  fi
  if (( i % 12 == 0 )); then
    echo "[r2ag-tpc9] wait-claimant iter=$i busy=$busy (R2y premerge)"
  fi
  if (( i == 2880 )); then
    echo "[r2ag-tpc9] TIMEOUT waiting GPU claimant" >&2
    exit 2
  fi
  sleep 10
done

# 2) Materialize thin chall dir from cached tpc9.
if [[ ! -f "$TPC9_SNAP/model.safetensors.index.json" ]]; then
  echo "[r2ag-tpc9] FATAL missing tpc9 snapshot at $TPC9_SNAP" >&2
  exit 2
fi
mkdir -p "$CHALL_DIR"
for f in "$TPC9_SNAP"/*; do
  base=$(basename "$f")
  [[ "$base" == "." || "$base" == ".." ]] && continue
  ln -sfn "$(readlink -f "$f")" "$CHALL_DIR/$base"
done
if [[ ! -f "$CHALL_DIR/preprocessor_config.json" ]]; then
  if [[ -f "$CHALL_DIR/processor_config.json" ]]; then
    cp -L "$CHALL_DIR/processor_config.json" "$CHALL_DIR/preprocessor_config.json"
    echo "[r2ag-tpc9] derived preprocessor_config.json from processor_config.json"
  else
    KING_PP=/root/hf/hub/models--Tok331102--affine-5EqYW8McUc-af10/snapshots/eb8bf9a356a254f71faaa439e8abc3cfba572c53/preprocessor_config.json
    if [[ -f "$KING_PP" ]]; then
      cp -L "$KING_PP" "$CHALL_DIR/preprocessor_config.json"
      echo "[r2ag-tpc9] copied preprocessor_config.json from Tok king"
    else
      echo "[r2ag-tpc9] FATAL no processor/preprocessor config" >&2
      exit 2
    fi
  fi
fi
echo "[r2ag-tpc9] chall dir ready: $CHALL_DIR"

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
echo "[r2ag-tpc9] link $LINK -> $(readlink -f "$LINK")"

echo "$(date -u +%Y-%m-%dT%H:%M:%SZ) claiming chall pure-tpc9" >"$HOLDING"
trap 'rm -f "$HOLDING"' EXIT

CHALL_PID_FILE=/root/logs/vllm_chall.pid
if [[ -f "$CHALL_PID_FILE" ]]; then
  CPID=$(cat "$CHALL_PID_FILE" || true)
  if [[ -n "${CPID:-}" ]] && kill -0 "$CPID" 2>/dev/null; then
    echo "[r2ag-tpc9] stopping chall pid=$CPID"
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
    echo "[r2ag-tpc9] seeding chall Triton cache from king"
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

echo "[r2ag-tpc9] launching chall :8002 on $LINK ($TPC9_REPO@$TPC9_REV)"
CUDA_VISIBLE_DEVICES=4,5 TRITON_CACHE_DIR=/root/.triton/cache/chall \
  nohup /root/venv/bin/vllm serve "$LINK" \
    --port 8002 --gpu-memory-utilization 0.72 \
    "${COMMON[@]}" \
    >/root/logs/vllm_chall.log 2>&1 &
echo $! >/root/logs/vllm_chall.pid
echo "[r2ag-tpc9] chall pid=$(cat /root/logs/vllm_chall.pid)"

for i in $(seq 1 480); do
  c0=$(curl -s -o /dev/null -w "%{http_code}" --max-time 3 http://127.0.0.1:8000/v1/models || true)
  c1=$(curl -s -o /dev/null -w "%{http_code}" --max-time 3 http://127.0.0.1:8001/v1/models || true)
  c2=$(curl -s -o /dev/null -w "%{http_code}" --max-time 3 http://127.0.0.1:8002/v1/models || true)
  if [[ "$c0$c1$c2" == "200200200" ]]; then
    echo "[r2ag-tpc9] engines 200/200/200 at iter=$i"
    break
  fi
  if (( i % 12 == 0 )); then
    echo "[r2ag-tpc9] wait-engines iter=$i codes=${c0}/${c1}/${c2}"
  fi
  if (( i == 480 )); then
    echo "[r2ag-tpc9] TIMEOUT engines; see vllm_chall.log" >&2
    exit 2
  fi
  sleep 5
done

OUT=/root/affine_data/r2ag_tpc9_reason_sim.json
DEC=/root/affine_data/r2ag_tpc9_decision.json
PROG=/root/affine_data/r2ag_tpc9_reason_progress.json
rm -f "$OUT" "$DEC" "$PROG"
BH=$(python - <<'PY'
import hashlib, time
print(hashlib.sha256(f"r2ag-tpc9-{time.time_ns()}".encode()).hexdigest())
PY
)

echo "[r2ag-tpc9] launching R2ag n80 block_hash=${BH:0:16}…"
python /root/mining_src/r1-reason-distill/run_reason_sim.py \
  --n-turns 80 \
  --block-hash "$BH" \
  --hotkey "local-r2ag-tpc9-$(date -u +%Y%m%dT%H:%M:%SZ)" \
  --king-repo Tok331102/affine-5EqYW8McUc-af10 \
  --king-rev eb8bf9a356a254f71faaa439e8abc3cfba572c53 \
  --chall-repo "$LINK" \
  --out "$OUT" \
  --progress-out "$PROG" \
  --save-artifact \
  2>&1 | tee /root/logs/r2ag_tpc9_reason_sim.log

python /root/mining_src/r1-reason-distill/write_reason_decision.py \
  --sim-result "$OUT" --out "$DEC" --hyp R2ag \
  2>&1 | tee -a /root/logs/r2ag_tpc9_reason_sim.log

echo "[r2ag-tpc9] DONE $(date -u +%Y-%m-%dT%H:%M:%SZ)"
cat "$DEC"
echo "OK $(date -u +%Y-%m-%dT%H:%M:%SZ)" >"$DONE"
