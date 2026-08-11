#!/usr/bin/env bash
# R2ai: after R2ah (pure awesome-v9) finishes / board-skips, serve pure
# ammazon/…-sbs-v0 (live board chal-00468) as chall → fresh n80 vs Tok.
# Prefer pure board parents over Talent×sbs (R2aa) — Talent skews keep REFUTING.
# Sibling Talent waiters block on R2ai PID via wait_r2q_before_chall_kill.inc.sh.
# Skip if board chal00468 already stamped Reason− or hr known < 1.5× (R2w lesson).
# Does NOT touch teacher:8000 or king:8001. Kill chall by PID file only.
# Pre-registered: submit only if headroom ≥ 1.5×(3·SE).
set -euo pipefail
LOG=/root/logs/r2ai_sbs_reload.log
DONE=/root/logs/r2ai_sbs_reload.done
PIDF=/root/logs/r2ai_sbs_reload.pid
HOLDING=${HOLDING:-/root/logs/r2ai_sbs_holding.stamp}
mkdir -p /root/logs /root/affine_data /root/r2_out
echo $$ >"$PIDF"
exec > >(tee -a "$LOG") 2>&1

echo "[r2ai-sbs] $(date -u +%Y-%m-%dT%H:%M:%SZ) start"
if [[ -f "$DONE" ]]; then
  echo "[r2ai-sbs] already done: $(cat "$DONE")"
  exit 0
fi

HEADROOM_BAR=${HEADROOM_BAR:-1.5}
SBS_REPO=${SBS_REPO:-ammazon/Affine-5dvqtektxx-sbs-v0}
SBS_REV=${SBS_REV:-c175fe8b79a66a8de97953677f1a489cb386261d}
SBS_SNAP=${SBS_SNAP:-/root/hf/hub/models--ammazon--Affine-5dvqtektxx-sbs-v0/snapshots/${SBS_REV}}
CHALL_DIR=${CHALL_DIR:-/root/r2_out/sbs_chall}
LINK=${LINK:-/tmp/r2ai_sbs}
BOARD_REASON=${BOARD_REASON:-/root/affine_data/chal00468_reason.json}
STAGE5_R2AH=${STAGE5_R2AH:-/root/affine_data/r2ah_stage5_ready.json}
R2AH_DEC=${R2AH_DEC:-/root/affine_data/r2ah_awesome_v9_decision.json}
R2AH_DONE=${R2AH_DONE:-/root/logs/r2ah_awesome_v9_reload.done}
R2AH_SKIP=${R2AH_SKIP:-/root/logs/r2ah_awesome_v9_reload.skip}
R2AA_DEC=${R2AA_DEC:-/root/affine_data/r2aa_alpha_decision.json}
STAGE5_R2AA=${STAGE5_R2AA:-/root/affine_data/r2aa_stage5_ready.json}

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

# 0) Wait R2ah terminal. Skip if R2ah already clears Stage-5.
echo "[r2ai-sbs] waiting for R2ah terminal (pure sbs-v0 next)"
for i in $(seq 1 2880); do
  if [[ -f "$STAGE5_R2AH" ]]; then
    echo "SKIP_R2AI_R2AH_STAGE5 $(date -u +%Y-%m-%dT%H:%M:%SZ)" | tee "$DONE"
    exit 0
  fi
  if [[ -f "$R2AH_DEC" ]] && headroom_ok "$R2AH_DEC"; then
    echo "SKIP_R2AI_R2AH_CLEARS file=$R2AH_DEC $(date -u +%Y-%m-%dT%H:%M:%SZ)" | tee "$DONE"
    exit 0
  fi
  if [[ -f "$R2AH_DONE" || -f "$R2AH_DEC" || -f "$R2AH_SKIP" ]]; then
    echo "[r2ai-sbs] R2ah terminal at iter=$i $(date -u +%Y-%m-%dT%H:%M:%SZ)"
    break
  fi
  if (( i % 12 == 0 )); then
    echo "[r2ai-sbs] wait-r2ah iter=$i"
  fi
  if (( i == 2880 )); then
    echo "[r2ai-sbs] TIMEOUT waiting R2ah" >&2
    exit 2
  fi
  sleep 10
done

# 1) Board-first skip if chal-00468 already Reason− OR known hr < 1.5×.
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
    # Skip Reason− and known sub-bar (R2w: board 0.40× → no local n80).
    skip=$(python3 -c "print(1 if float('$hr') < float('$HEADROOM_BAR') else 0)")
    if [[ "$skip" == "1" ]]; then
      echo "SKIP_BOARD_SUB_BAR hr=$hr bar=$HEADROOM_BAR $(date -u +%Y-%m-%dT%H:%M:%SZ)" | tee "$DONE"
      python3 - <<PY
import json, time
from pathlib import Path
Path("/root/affine_data/r2ai_sbs_decision.json").write_text(json.dumps({
    "utc": time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime()),
    "hyp": "R2ai",
    "decision": "SKIP_BOARD_FIRST",
    "headroom_vs_3se": float("$hr"),
    "headroom_bar": float("$HEADROOM_BAR"),
    "note": "board chal-00468 hr already known < 1.5×; do not burn pure-sbs n80",
    "board_reason": "$BOARD_REASON",
}, indent=2) + "\n")
PY
      exit 0
    fi
  fi
fi

# 2) Yield if R2aa somehow already clears Stage-5.
if [[ -f "$STAGE5_R2AA" ]]; then
  echo "SKIP_R2AI_R2AA_STAGE5 $(date -u +%Y-%m-%dT%H:%M:%SZ)" | tee "$DONE"
  exit 0
fi
if [[ -f "$R2AA_DEC" ]] && headroom_ok "$R2AA_DEC"; then
  echo "SKIP_R2AI_R2AA_CLEARS file=$R2AA_DEC $(date -u +%Y-%m-%dT%H:%M:%SZ)" | tee "$DONE"
  exit 0
fi

# 3) Materialize thin chall dir from cached sbs-v0.
if [[ ! -f "$SBS_SNAP/model.safetensors.index.json" ]]; then
  echo "[r2ai-sbs] FATAL missing sbs snapshot at $SBS_SNAP" >&2
  exit 2
fi
mkdir -p "$CHALL_DIR"
for f in "$SBS_SNAP"/*; do
  base=$(basename "$f")
  [[ "$base" == "." || "$base" == ".." ]] && continue
  ln -sfn "$(readlink -f "$f")" "$CHALL_DIR/$base"
done
if [[ ! -f "$CHALL_DIR/preprocessor_config.json" ]]; then
  if [[ -f "$CHALL_DIR/processor_config.json" ]]; then
    cp -L "$CHALL_DIR/processor_config.json" "$CHALL_DIR/preprocessor_config.json"
    echo "[r2ai-sbs] derived preprocessor_config.json from processor_config.json"
  else
    KING_PP=/root/hf/hub/models--Tok331102--affine-5EqYW8McUc-af10/snapshots/eb8bf9a356a254f71faaa439e8abc3cfba572c53/preprocessor_config.json
    if [[ -f "$KING_PP" ]]; then
      cp -L "$KING_PP" "$CHALL_DIR/preprocessor_config.json"
      echo "[r2ai-sbs] copied preprocessor_config.json from Tok king"
    else
      echo "[r2ai-sbs] FATAL no processor/preprocessor config" >&2
      exit 2
    fi
  fi
fi
echo "[r2ai-sbs] chall dir ready: $CHALL_DIR"

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
echo "[r2ai-sbs] link $LINK -> $(readlink -f "$LINK")"

echo "$(date -u +%Y-%m-%dT%H:%M:%SZ) claiming chall pure-sbs" >"$HOLDING"
trap 'rm -f "$HOLDING"' EXIT

CHALL_PID_FILE=/root/logs/vllm_chall.pid
if [[ -f "$CHALL_PID_FILE" ]]; then
  CPID=$(cat "$CHALL_PID_FILE" || true)
  if [[ -n "${CPID:-}" ]] && kill -0 "$CPID" 2>/dev/null; then
    echo "[r2ai-sbs] stopping chall pid=$CPID"
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
    echo "[r2ai-sbs] seeding chall Triton cache from king"
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

echo "[r2ai-sbs] launching chall :8002 on $LINK ($SBS_REPO@$SBS_REV)"
CUDA_VISIBLE_DEVICES=4,5 TRITON_CACHE_DIR=/root/.triton/cache/chall \
  nohup /root/venv/bin/vllm serve "$LINK" \
    --port 8002 --gpu-memory-utilization 0.72 \
    "${COMMON[@]}" \
    >/root/logs/vllm_chall.log 2>&1 &
echo $! >/root/logs/vllm_chall.pid
echo "[r2ai-sbs] chall pid=$(cat /root/logs/vllm_chall.pid)"

for i in $(seq 1 480); do
  c0=$(curl -s -o /dev/null -w "%{http_code}" --max-time 3 http://127.0.0.1:8000/v1/models || true)
  c1=$(curl -s -o /dev/null -w "%{http_code}" --max-time 3 http://127.0.0.1:8001/v1/models || true)
  c2=$(curl -s -o /dev/null -w "%{http_code}" --max-time 3 http://127.0.0.1:8002/v1/models || true)
  if [[ "$c0$c1$c2" == "200200200" ]]; then
    echo "[r2ai-sbs] engines 200/200/200 at iter=$i"
    break
  fi
  if (( i % 12 == 0 )); then
    echo "[r2ai-sbs] wait-engines iter=$i codes=${c0}/${c1}/${c2}"
  fi
  if (( i == 480 )); then
    echo "[r2ai-sbs] TIMEOUT engines; see vllm_chall.log" >&2
    exit 2
  fi
  sleep 5
done

OUT=/root/affine_data/r2ai_sbs_reason_sim.json
DEC=/root/affine_data/r2ai_sbs_decision.json
PROG=/root/affine_data/r2ai_sbs_reason_progress.json
rm -f "$OUT" "$DEC" "$PROG"
BH=$(python - <<'PY'
import hashlib, time
print(hashlib.sha256(f"r2ai-sbs-{time.time_ns()}".encode()).hexdigest())
PY
)

echo "[r2ai-sbs] launching R2ai n80 block_hash=${BH:0:16}…"
python /root/mining_src/r1-reason-distill/run_reason_sim.py \
  --n-turns 80 \
  --block-hash "$BH" \
  --hotkey "local-r2ai-sbs-$(date -u +%Y%m%dT%H:%M:%SZ)" \
  --king-repo Tok331102/affine-5EqYW8McUc-af10 \
  --king-rev eb8bf9a356a254f71faaa439e8abc3cfba572c53 \
  --chall-repo "$LINK" \
  --out "$OUT" \
  --progress-out "$PROG" \
  --save-artifact \
  2>&1 | tee /root/logs/r2ai_sbs_reason_sim.log

python /root/mining_src/r1-reason-distill/write_reason_decision.py \
  --sim-result "$OUT" --out "$DEC" --hyp R2ai \
  2>&1 | tee -a /root/logs/r2ai_sbs_reason_sim.log

echo "[r2ai-sbs] DONE $(date -u +%Y-%m-%dT%H:%M:%SZ)"
cat "$DEC"
echo "OK $(date -u +%Y-%m-%dT%H:%M:%SZ)" >"$DONE"
