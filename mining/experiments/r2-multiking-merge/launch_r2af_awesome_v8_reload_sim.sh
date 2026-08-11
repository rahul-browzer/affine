#!/usr/bin/env bash
# R2af: after R2r finishes below Stage-5 bar, serve pure
# 0pentensor/…-awesome-v8 (live board chal-00462) as chall → fresh n80 vs Tok.
# R2ae pure-sth blocked: HF gated=manual + cache purged p1979.
# Does NOT wait on board Reason (gzip may land after duel). Sibling Talent×v8
# (R2x) still waits chal00462 Reason+ via premerge.done — this burns idle GPUs.
# Does NOT touch teacher:8000 or king:8001. Kill chall by PID file only.
# Pre-registered: submit only if headroom ≥ 1.5×(3·SE).
set -euo pipefail
LOG=/root/logs/r2af_awesome_v8_reload.log
DONE=/root/logs/r2af_awesome_v8_reload.done
PIDF=/root/logs/r2af_awesome_v8_reload.pid
HOLDING=${HOLDING:-/root/logs/r2af_awesome_v8_holding.stamp}
mkdir -p /root/logs /root/affine_data /root/r2_out
echo $$ >"$PIDF"
exec > >(tee -a "$LOG") 2>&1

echo "[r2af-v8] $(date -u +%Y-%m-%dT%H:%M:%SZ) start"
if [[ -f "$DONE" ]]; then
  echo "[r2af-v8] already done: $(cat "$DONE")"
  exit 0
fi

HEADROOM_BAR=${HEADROOM_BAR:-1.5}
V8_REPO=${V8_REPO:-0pentensor/Affine-5dflhtkufw-awesome-v8}
V8_REV=${V8_REV:-6c04b16d461d429f9e288508e92f9e42322baec6}
V8_SNAP=${V8_SNAP:-/root/hf/hub/models--0pentensor--Affine-5dflhtkufw-awesome-v8/snapshots/${V8_REV}}
CHALL_DIR=${CHALL_DIR:-/root/r2_out/awesome_v8_chall}
LINK=${LINK:-/tmp/r2af_awesome_v8}
STAGE5_R2R=${STAGE5_R2R:-/root/affine_data/r2r_stage5_ready.json}
STAGE5_R2AE=${STAGE5_R2AE:-/root/affine_data/r2ae_stage5_ready.json}

R2R_DEC=${R2R_DEC:-/root/affine_data/r2r_alpha_decision.json}
R2R_DONE=${R2R_DONE:-/root/logs/r2r_merge_reload.done}
R2R_PREMERGE_SKIP=${R2R_PREMERGE_SKIP:-/root/logs/r2r_premerge.skip}
R2AE_DEC=${R2AE_DEC:-/root/affine_data/r2ae_sth_decision.json}
R2AE_DONE=${R2AE_DONE:-/root/logs/r2ae_sth_reload.done}
R2AE_SKIP=${R2AE_SKIP:-/root/logs/r2ae_sth_reload.skip}
R2X_DEC=${R2X_DEC:-/root/affine_data/r2x_alpha_decision.json}
R2X_DONE=${R2X_DONE:-/root/logs/r2x_merge_reload.done}
R2X_PREMERGE_SKIP=${R2X_PREMERGE_SKIP:-/root/logs/r2x_premerge.skip}

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

# 0) Wait R2r terminal. Skip if R2r/R2ae clears Stage-5.
echo "[r2af-v8] waiting for R2r terminal (pure awesome-v8; sth gated)"
for i in $(seq 1 2880); do
  if [[ -f "$STAGE5_R2R" ]]; then
    echo "SKIP_R2AF_R2R_STAGE5 $(date -u +%Y-%m-%dT%H:%M:%SZ)" | tee "$DONE"
    exit 0
  fi
  if [[ -f "$STAGE5_R2AE" ]]; then
    echo "SKIP_R2AF_R2AE_STAGE5 $(date -u +%Y-%m-%dT%H:%M:%SZ)" | tee "$DONE"
    exit 0
  fi
  if [[ -f "$R2R_DEC" ]] && headroom_ok "$R2R_DEC"; then
    echo "SKIP_R2AF_R2R_CLEARS file=$R2R_DEC $(date -u +%Y-%m-%dT%H:%M:%SZ)" | tee "$DONE"
    exit 0
  fi
  if lane_terminal "$R2R_DONE" "$R2R_PREMERGE_SKIP" "$R2R_DEC"; then
    echo "[r2af-v8] R2r terminal at iter=$i $(date -u +%Y-%m-%dT%H:%M:%SZ)"
    break
  fi
  if (( i % 12 == 0 )); then
    crumb=$(python3 -c "import json;from pathlib import Path;p=Path('/root/affine_data/r2r_alpha_reason_progress.json');
print(p.read_text().strip() if p.is_file() else 'no-progress')" 2>/dev/null || echo none)
    echo "[r2af-v8] wait-r2r iter=$i crumb=${crumb:-none}"
  fi
  if (( i == 2880 )); then
    echo "[r2af-v8] TIMEOUT waiting R2r" >&2
    exit 2
  fi
  sleep 10
done

# 1) Do not steal if R2ae somehow got weights + claimed (gated path normally SKIPs).
for i in $(seq 1 360); do
  if [[ -f "$R2AE_SKIP" || -f "$R2AE_DONE" || -f "$R2AE_DEC" ]]; then
    echo "[r2af-v8] R2ae terminal/skip at iter=$i"
    break
  fi
  if [[ -f /root/logs/r2ae_sth_holding.stamp ]]; then
    if (( i % 12 == 0 )); then
      echo "[r2af-v8] wait-r2ae-holding iter=$i"
    fi
    sleep 10
    continue
  fi
  # R2ae still waiting on gated prefetch — stamp skip so we proceed
  if [[ -f /root/logs/r2ae_sth_reload.pid ]] && kill -0 "$(cat /root/logs/r2ae_sth_reload.pid)" 2>/dev/null; then
    echo "SKIP_GATED_STH $(date -u +%Y-%m-%dT%H:%M:%SZ) R2af claiming; sth HF gated=manual" \
      | tee "$R2AE_SKIP" >/root/logs/r2ae_sth_reload.done
    # stop R2ae waiter by writing skip; its next loop sees R2r terminal + will
    # still wait prefetch forever — kill by pid file only
    APID=$(cat /root/logs/r2ae_sth_reload.pid || true)
    if [[ -n "${APID:-}" ]] && kill -0 "$APID" 2>/dev/null; then
      echo "[r2af-v8] stopping gated R2ae waiter pid=$APID"
      kill "$APID" || true
    fi
    break
  fi
  echo "[r2af-v8] R2ae not active at iter=$i"
  break
done

# 2) Materialize thin chall dir from cached awesome-v8.
if [[ ! -f "$V8_SNAP/model.safetensors.index.json" ]]; then
  echo "[r2af-v8] FATAL missing awesome-v8 snapshot at $V8_SNAP" >&2
  exit 2
fi
mkdir -p "$CHALL_DIR"
for f in "$V8_SNAP"/*; do
  base=$(basename "$f")
  [[ "$base" == "." || "$base" == ".." ]] && continue
  ln -sfn "$(readlink -f "$f")" "$CHALL_DIR/$base"
done
if [[ ! -f "$CHALL_DIR/preprocessor_config.json" ]]; then
  if [[ -f "$CHALL_DIR/processor_config.json" ]]; then
    cp -L "$CHALL_DIR/processor_config.json" "$CHALL_DIR/preprocessor_config.json"
    echo "[r2af-v8] derived preprocessor_config.json from processor_config.json"
  else
    echo "[r2af-v8] FATAL no processor/preprocessor config" >&2
    exit 2
  fi
fi
echo "[r2af-v8] chall dir ready: $CHALL_DIR"

# 3) Yield if R2x already has Reason+ premerge.done (board-gated Talent×v8).
for i in $(seq 1 2880); do
  if [[ -f "$R2X_DEC" ]] && headroom_ok "$R2X_DEC"; then
    echo "SKIP_R2AF_R2X_CLEARS file=$R2X_DEC $(date -u +%Y-%m-%dT%H:%M:%SZ)" | tee "$DONE"
    exit 0
  fi
  busy=0
  if [[ -f /root/logs/r2x_premerge.done ]] && ! lane_terminal "$R2X_DONE" "$R2X_PREMERGE_SKIP" "$R2X_DEC"; then
    busy=1
  fi
  if (( busy == 0 )); then
    echo "[r2af-v8] lane free at iter=$i $(date -u +%Y-%m-%dT%H:%M:%SZ)"
    break
  fi
  if (( i % 12 == 0 )); then
    echo "[r2af-v8] wait-claimant iter=$i busy=$busy (R2x premerge)"
  fi
  if (( i == 2880 )); then
    echo "[r2af-v8] TIMEOUT waiting GPU claimant" >&2
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

ln -sfn "$CHALL_DIR" "$LINK"
echo "[r2af-v8] link $LINK -> $(readlink -f "$LINK")"

echo "$(date -u +%Y-%m-%dT%H:%M:%SZ) claiming chall pure-awesome-v8" >"$HOLDING"
trap 'rm -f "$HOLDING"' EXIT

CHALL_PID_FILE=/root/logs/vllm_chall.pid
if [[ -f "$CHALL_PID_FILE" ]]; then
  CPID=$(cat "$CHALL_PID_FILE" || true)
  if [[ -n "${CPID:-}" ]] && kill -0 "$CPID" 2>/dev/null; then
    echo "[r2af-v8] stopping chall pid=$CPID"
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
    echo "[r2af-v8] seeding chall Triton cache from king"
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

echo "[r2af-v8] launching chall :8002 on $LINK ($V8_REPO@$V8_REV)"
CUDA_VISIBLE_DEVICES=4,5 TRITON_CACHE_DIR=/root/.triton/cache/chall \
  nohup /root/venv/bin/vllm serve "$LINK" \
    --port 8002 --gpu-memory-utilization 0.72 \
    "${COMMON[@]}" \
    >/root/logs/vllm_chall.log 2>&1 &
echo $! >/root/logs/vllm_chall.pid
echo "[r2af-v8] chall pid=$(cat /root/logs/vllm_chall.pid)"

for i in $(seq 1 480); do
  c0=$(curl -s -o /dev/null -w "%{http_code}" --max-time 3 http://127.0.0.1:8000/v1/models || true)
  c1=$(curl -s -o /dev/null -w "%{http_code}" --max-time 3 http://127.0.0.1:8001/v1/models || true)
  c2=$(curl -s -o /dev/null -w "%{http_code}" --max-time 3 http://127.0.0.1:8002/v1/models || true)
  if [[ "$c0$c1$c2" == "200200200" ]]; then
    echo "[r2af-v8] engines 200/200/200 at iter=$i"
    break
  fi
  if (( i % 12 == 0 )); then
    echo "[r2af-v8] wait-engines iter=$i codes=${c0}/${c1}/${c2}"
  fi
  if (( i == 480 )); then
    echo "[r2af-v8] TIMEOUT engines; see vllm_chall.log" >&2
    exit 2
  fi
  sleep 5
done

OUT=/root/affine_data/r2af_awesome_v8_reason_sim.json
DEC=/root/affine_data/r2af_awesome_v8_decision.json
PROG=/root/affine_data/r2af_awesome_v8_reason_progress.json
rm -f "$OUT" "$DEC" "$PROG"
BH=$(python - <<'PY'
import hashlib, time
print(hashlib.sha256(f"r2af-awesome-v8-{time.time_ns()}".encode()).hexdigest())
PY
)

echo "[r2af-v8] launching R2af n80 block_hash=${BH:0:16}…"
python /root/mining_src/r1-reason-distill/run_reason_sim.py \
  --n-turns 80 \
  --block-hash "$BH" \
  --hotkey "local-r2af-awesome-v8-$(date -u +%Y%m%dT%H:%M:%SZ)" \
  --king-repo Tok331102/affine-5EqYW8McUc-af10 \
  --king-rev eb8bf9a356a254f71faaa439e8abc3cfba572c53 \
  --chall-repo "$LINK" \
  --out "$OUT" \
  --progress-out "$PROG" \
  --save-artifact \
  2>&1 | tee /root/logs/r2af_awesome_v8_reason_sim.log

python /root/mining_src/r1-reason-distill/write_reason_decision.py \
  --sim-result "$OUT" --out "$DEC" --hyp R2af \
  2>&1 | tee -a /root/logs/r2af_awesome_v8_reason_sim.log

echo "[r2af-v8] DONE $(date -u +%Y-%m-%dT%H:%M:%SZ)"
cat "$DEC"
echo "OK $(date -u +%Y-%m-%dT%H:%M:%SZ)" >"$DONE"
