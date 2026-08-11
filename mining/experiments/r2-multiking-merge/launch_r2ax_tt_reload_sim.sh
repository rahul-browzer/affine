#!/usr/bin/env bash
# R2ax: after R2av (pure v2) finishes or Stage-5-skips, serve pure
# leary-criste/...-tt (chal-00337) as chall -> fresh n80 vs Tok.
# Prefer pure board parents -- Talent0.25 skew keeps REFUTEing.
# Board chal-00337 was an n=80 probe (hr3≈0.775×) — NOT a full-2080
# sub-bar stamp; do NOT board-first-skip on that short duel. Fresh local n80.
# Wait R2av terminal + tt prefetch. Kill chall by PID file only.
set -euo pipefail
LOG=/root/logs/r2ax_tt_reload.log
DONE=/root/logs/r2ax_tt_reload.done
PIDF=/root/logs/r2ax_tt_reload.pid
HOLDING=${HOLDING:-/root/logs/r2ax_tt_holding.stamp}
mkdir -p /root/logs /root/affine_data /root/r2_out
echo $$ >"$PIDF"
exec > >(tee -a "$LOG") 2>&1

echo "[r2ax-tt] $(date -u +%Y-%m-%dT%H:%M:%SZ) start"
if [[ -f "$DONE" ]]; then
  echo "[r2ax-tt] already done: $(cat "$DONE")"
  exit 0
fi

HEADROOM_BAR=${HEADROOM_BAR:-1.5}
TT_REPO=${TT_REPO:-leary-criste/affine-5g4yy75zuz-tt}
TT_REV=${TT_REV:-93aeaa1765a79d0444b688e2de53864c23a320b9}
TT_SNAP=${TT_SNAP:-/root/hf/hub/models--leary-criste--affine-5g4yy75zuz-tt/snapshots/${TT_REV}}
CHALL_DIR=${CHALL_DIR:-/root/r2_out/tt_chall}
LINK=${LINK:-/tmp/r2ax_tt}
WARM=${WARM_DONE:-/root/logs/warm_stack_ready.done}
PREFETCH_DONE=${PREFETCH_DONE:-/root/logs/r2_prefetch_tt.done}
R2AV_DEC=${R2AV_DEC:-/root/affine_data/r2av_v2_decision.json}
R2AV_DONE=${R2AV_DONE:-/root/logs/r2av_v2_reload.done}
STAGE5_R2AV=${STAGE5_R2AV:-/root/affine_data/r2av_stage5_ready.json}

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
echo "[r2ax-tt] waiting for warm_stack_ready"
for i in $(seq 1 2880); do
  if [[ -f "$WARM" ]]; then
    echo "[r2ax-tt] warm ready at iter=$i $(date -u +%Y-%m-%dT%H:%M:%SZ)"
    break
  fi
  if (( i % 12 == 0 )); then
    echo "[r2ax-tt] wait-warm iter=$i"
  fi
  if (( i == 2880 )); then
    echo "[r2ax-tt] TIMEOUT waiting warm_stack_ready" >&2
    exit 2
  fi
  sleep 10
done

# 1) Wait R2av terminal. Skip if R2av already clears Stage-5 / ≥1.5×.
echo "[r2ax-tt] waiting for R2av terminal (pure tt next)"
for i in $(seq 1 2880); do
  if [[ -f "$STAGE5_R2AV" ]]; then
    echo "SKIP_R2AX_R2AV_STAGE5 $(date -u +%Y-%m-%dT%H:%M:%SZ)" | tee "$DONE"
    exit 0
  fi
  if [[ -f "$R2AV_DEC" ]] && headroom_ok "$R2AV_DEC"; then
    echo "SKIP_R2AX_R2AV_CLEARS file=$R2AV_DEC $(date -u +%Y-%m-%dT%H:%M:%SZ)" | tee "$DONE"
    exit 0
  fi
  if [[ -f "$R2AV_DONE" || -f "$R2AV_DEC" ]]; then
    echo "[r2ax-tt] R2av terminal at iter=$i $(date -u +%Y-%m-%dT%H:%M:%SZ)"
    break
  fi
  if (( i % 12 == 0 )); then
    crumb=$(python3 -c "import json;from pathlib import Path;p=Path('/root/affine_data/r2av_v2_reason_progress.json');
print(p.read_text().strip() if p.is_file() else 'no-progress')" 2>/dev/null || echo none)
    crumb2=$(python3 -c "import json;from pathlib import Path;p=Path('/root/affine_data/r2as_726_reason_progress.json');
print(p.read_text().strip() if p.is_file() else 'no-r2as')" 2>/dev/null || echo none)
    echo "[r2ax-tt] wait-r2av iter=$i crumb=${crumb:-none} r2as=${crumb2:-none}"
  fi
  if (( i == 2880 )); then
    echo "[r2ax-tt] TIMEOUT waiting R2av" >&2
    exit 2
  fi
  sleep 10
done

# 2) No board-first skip: chal-00337 board was n=80 only (not full 2080).

# 3) Wait tt prefetch (or accept snapshot already on disk).
echo "[r2ax-tt] waiting for tt prefetch/index at $TT_SNAP"
for i in $(seq 1 1440); do
  if [[ -f "$TT_SNAP/model.safetensors.index.json" ]]; then
    echo "[r2ax-tt] tt snapshot ready at iter=$i"
    break
  fi
  if [[ -f "$PREFETCH_DONE" ]] && [[ ! -f "$TT_SNAP/model.safetensors.index.json" ]]; then
    echo "[r2ax-tt] FATAL prefetch done but index missing at $TT_SNAP" >&2
    exit 2
  fi
  if (( i % 12 == 0 )); then
    crumb=$(tail -n 2 /root/logs/r2_prefetch_tt.log 2>/dev/null | tr '\r' '\n' | tail -1 || true)
    echo "[r2ax-tt] wait-prefetch iter=$i crumb=${crumb:-none}"
  fi
  if (( i == 1440 )); then
    echo "[r2ax-tt] TIMEOUT waiting tt snapshot" >&2
    exit 2
  fi
  sleep 10
done

# 4) Materialize thin chall dir.
mkdir -p "$CHALL_DIR"
for f in "$TT_SNAP"/*; do
  base=$(basename "$f")
  [[ "$base" == "." || "$base" == ".." ]] && continue
  ln -sfn "$(readlink -f "$f")" "$CHALL_DIR/$base"
done
if [[ ! -f "$CHALL_DIR/preprocessor_config.json" ]]; then
  if [[ -f "$CHALL_DIR/processor_config.json" ]]; then
    cp -L "$CHALL_DIR/processor_config.json" "$CHALL_DIR/preprocessor_config.json"
    echo "[r2ax-tt] derived preprocessor_config.json from processor_config.json"
  else
    KING_PP=/root/hf/hub/models--Tok331102--affine-5EqYW8McUc-af10/snapshots/eb8bf9a356a254f71faaa439e8abc3cfba572c53/preprocessor_config.json
    if [[ -f "$KING_PP" ]]; then
      cp -L "$KING_PP" "$CHALL_DIR/preprocessor_config.json"
      echo "[r2ax-tt] copied preprocessor_config.json from Tok king"
    else
      echo "[r2ax-tt] FATAL no processor/preprocessor config" >&2
      exit 2
    fi
  fi
fi
echo "[r2ax-tt] chall dir ready: $CHALL_DIR"

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
echo "[r2ax-tt] link $LINK -> $(readlink -f "$LINK")"

echo "$(date -u +%Y-%m-%dT%H:%M:%SZ) claiming chall pure-tt" >"$HOLDING"
trap 'rm -f "$HOLDING"' EXIT

# Do not source wait_r2q here after setting our own HOLDING — that deadlocks
# on R2AX_PIDF+HOLDING (self). Prior R2av is terminal (or SKIP). Sibling
# waiters honor R2ax via wait_r2q.

CHALL_PID_FILE=/root/logs/vllm_chall.pid
if [[ -f "$CHALL_PID_FILE" ]]; then
  CPID=$(cat "$CHALL_PID_FILE" || true)
  if [[ -n "${CPID:-}" ]] && kill -0 "$CPID" 2>/dev/null; then
    echo "[r2ax-tt] stopping chall pid=$CPID"
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
# NEVER pgrep bare 'VLLM::EngineCore' — that also matches teacher/king EngCores.
# Only orphans on GPUs 4,5.
sleep 3
for op in $(pgrep -f 'VLLM::EngineCore|VLLM::Worker' 2>/dev/null || true); do
  envf="/proc/$op/environ"
  if [[ -r "$envf" ]] && tr '\0' '\n' <"$envf" 2>/dev/null | grep -qx 'CUDA_VISIBLE_DEVICES=4,5'; then
    echo "[r2ax-tt] killing leftover chall orphan pid=$op (CUDA 4,5)"
    kill "$op" 2>/dev/null || true
  fi
done
for op in $(pgrep -f 'vllm serve .*--port 8002' 2>/dev/null || true); do
  if [[ "$op" != "$$" ]] && kill -0 "$op" 2>/dev/null; then
    echo "[r2ax-tt] killing leftover chall serve pid=$op"
    kill "$op" 2>/dev/null || true
  fi
done
sleep 2

if [[ ! -d /root/.triton/cache/chall ]] || [[ -z "$(find /root/.triton/cache/chall -name '*.so' 2>/dev/null | head -1)" ]]; then
  if [[ -d /root/.triton/cache/king ]]; then
    echo "[r2ax-tt] seeding chall Triton cache from king"
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

echo "[r2ax-tt] launching chall :8002 on $LINK ($TT_REPO@$TT_REV)"
CUDA_VISIBLE_DEVICES=4,5 TRITON_CACHE_DIR=/root/.triton/cache/chall \
  nohup /root/venv/bin/vllm serve "$LINK" \
    --port 8002 --gpu-memory-utilization 0.72 \
    "${COMMON[@]}" \
    >/root/logs/vllm_chall.log 2>&1 &
echo $! >/root/logs/vllm_chall.pid
echo "[r2ax-tt] chall pid=$(cat /root/logs/vllm_chall.pid)"

for i in $(seq 1 480); do
  c0=$(curl -s -o /dev/null -w "%{http_code}" --max-time 3 http://127.0.0.1:8000/v1/models || true)
  c1=$(curl -s -o /dev/null -w "%{http_code}" --max-time 3 http://127.0.0.1:8001/v1/models || true)
  c2=$(curl -s -o /dev/null -w "%{http_code}" --max-time 3 http://127.0.0.1:8002/v1/models || true)
  if [[ "$c0$c1$c2" == "200200200" ]]; then
    echo "[r2ax-tt] engines 200/200/200 at iter=$i"
    break
  fi
  if (( i % 12 == 0 )); then
    echo "[r2ax-tt] wait-engines iter=$i codes=${c0}/${c1}/${c2}"
  fi
  if (( i == 480 )); then
    echo "[r2ax-tt] TIMEOUT engines; see vllm_chall.log" >&2
    exit 2
  fi
  sleep 5
done

OUT=/root/affine_data/r2ax_tt_reason_sim.json
DEC=/root/affine_data/r2ax_tt_decision.json
PROG=/root/affine_data/r2ax_tt_reason_progress.json
rm -f "$OUT" "$DEC" "$PROG"
BH=$(python - <<'PY'
import hashlib, time
print(hashlib.sha256(f"r2ax-tt-{time.time_ns()}".encode()).hexdigest())
PY
)

echo "[r2ax-tt] launching R2ax n80 block_hash=${BH:0:16}…"
python /root/mining_src/r1-reason-distill/run_reason_sim.py \
  --n-turns 80 \
  --block-hash "$BH" \
  --hotkey "local-r2ax-tt-$(date -u +%Y%m%dT%H:%M:%SZ)" \
  --king-repo Tok331102/affine-5EqYW8McUc-af10 \
  --king-rev eb8bf9a356a254f71faaa439e8abc3cfba572c53 \
  --chall-repo "$LINK" \
  --out "$OUT" \
  --progress-out "$PROG" \
  --save-artifact \
  2>&1 | tee /root/logs/r2ax_tt_reason_sim.log

python /root/mining_src/r1-reason-distill/write_reason_decision.py \
  --sim-result "$OUT" --out "$DEC" --hyp R2ax \
  2>&1 | tee -a /root/logs/r2ax_tt_reason_sim.log

echo "[r2ax-tt] DONE $(date -u +%Y-%m-%dT%H:%M:%SZ)"
cat "$DEC"
echo "OK $(date -u +%Y-%m-%dT%H:%M:%SZ)" >"$DONE"
cp -f "$DEC" /root/logs/r2ax_tt_decision.json 2>/dev/null || true
cp -f "$DONE" /root/affine_data/r2ax_tt_reload.done 2>/dev/null || true
