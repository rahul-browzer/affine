#!/usr/bin/env bash
# R2v: while chal-00450 (sft3) sits in load_challenger on the eval box and
# Talent×sft3 (R2l) is still Reason-gated, burn idle crown GPUs on pure
# syntaxsorcerer1/…-sft3 as chall → fresh n80 vs Tok (R2d/R2q analogue).
# Does NOT wait on board Reason stamps. Sibling merge scripts wait on
# r2v_sft3_reload.pid via wait_r2q_before_chall_kill.inc.sh before killing
# chall. Does NOT touch teacher:8000 or king:8001. Kill chall by PID file only.
# Pre-registered: submit only if headroom ≥ 1.5×(3·SE).
set -euo pipefail
LOG=/root/logs/r2v_sft3_reload.log
DONE=/root/logs/r2v_sft3_reload.done
PIDF=/root/logs/r2v_sft3_reload.pid
mkdir -p /root/logs /root/affine_data /root/r2_out
echo $$ >"$PIDF"
exec > >(tee -a "$LOG") 2>&1

echo "[r2v-sft3] $(date -u +%Y-%m-%dT%H:%M:%SZ) start"
if [[ -f "$DONE" ]]; then
  echo "[r2v-sft3] already done: $(cat "$DONE")"
  exit 0
fi

HEADROOM_BAR=${HEADROOM_BAR:-1.5}
SFT3_SNAP=${SFT3_SNAP:-/root/hf/hub/models--syntaxsorcerer1--Affine-5gbhwtw4zo-sft3/snapshots/381dbc8245e29bccbf39de78fdbc20acbfadec8d}
CHALL_DIR=${CHALL_DIR:-/root/r2_out/sft3_chall}
LINK=${LINK:-/tmp/r2v_sft3}

R2D_DEC=${R2D_DEC:-/root/affine_data/r2d_awesome_decision.json}
R2E_DEC=${R2E_DEC:-/root/affine_data/r2e_alpha_decision.json}
R2G_DEC=${R2G_DEC:-/root/affine_data/r2g_alpha_decision.json}
R2H_DEC=${R2H_DEC:-/root/affine_data/r2h_ttk_decision.json}
R2I_DEC=${R2I_DEC:-/root/affine_data/r2i_alpha_decision.json}
R2I_DONE=${R2I_DONE:-/root/logs/r2i_merge_reload.done}
R2I_PREMERGE_SKIP=${R2I_PREMERGE_SKIP:-/root/logs/r2i_premerge.skip}
R2J_DEC=${R2J_DEC:-/root/affine_data/r2j_alpha_decision.json}
R2J_DONE=${R2J_DONE:-/root/logs/r2j_merge_reload.done}
R2J_PREMERGE_SKIP=${R2J_PREMERGE_SKIP:-/root/logs/r2j_premerge.skip}
R2K_DEC=${R2K_DEC:-/root/affine_data/r2k_alpha_decision.json}
R2K_DONE=${R2K_DONE:-/root/logs/r2k_merge_reload.done}
R2K_PREMERGE_SKIP=${R2K_PREMERGE_SKIP:-/root/logs/r2k_premerge.skip}
R2L_DEC=${R2L_DEC:-/root/affine_data/r2l_alpha_decision.json}
R2L_DONE=${R2L_DONE:-/root/logs/r2l_merge_reload.done}
R2L_PREMERGE_SKIP=${R2L_PREMERGE_SKIP:-/root/logs/r2l_premerge.skip}
R2M_DEC=${R2M_DEC:-/root/affine_data/r2m_alpha_decision.json}
R2M_DONE=${R2M_DONE:-/root/logs/r2m_merge_reload.done}
R2M_PREMERGE_SKIP=${R2M_PREMERGE_SKIP:-/root/logs/r2m_premerge.skip}
R2N_DEC=${R2N_DEC:-/root/affine_data/r2n_alpha_decision.json}
R2N_DONE=${R2N_DONE:-/root/logs/r2n_merge_reload.done}
R2N_PREMERGE_SKIP=${R2N_PREMERGE_SKIP:-/root/logs/r2n_premerge.skip}
R2O_DEC=${R2O_DEC:-/root/affine_data/r2o_alpha_decision.json}
R2O_DONE=${R2O_DONE:-/root/logs/r2o_merge_reload.done}
R2O_PREMERGE_SKIP=${R2O_PREMERGE_SKIP:-/root/logs/r2o_premerge.skip}
R2P_DEC=${R2P_DEC:-/root/affine_data/r2p_alpha_decision.json}
R2P_DONE=${R2P_DONE:-/root/logs/r2p_merge_reload.done}
R2P_PREMERGE_SKIP=${R2P_PREMERGE_SKIP:-/root/logs/r2p_premerge.skip}

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

# GPU-claiming = blended weights ready (premerge.done) and not yet terminal.
# Reason-only waiters must NOT block — board load_challenger can take hours.
lane_claiming_gpu() {
  local done="$1" skip="$2" dec="$3" premerge_done="$4"
  if lane_terminal "$done" "$skip" "$dec"; then
    return 1
  fi
  [[ -f "$premerge_done" ]]
}

# 1) Materialize thin chall dir (symlinks + preprocessor for vLLM).
mkdir -p "$CHALL_DIR"
if [[ ! -f "$SFT3_SNAP/model.safetensors.index.json" ]]; then
  echo "[r2v-sft3] FATAL missing sft3 snapshot index at $SFT3_SNAP" >&2
  exit 2
fi
for f in "$SFT3_SNAP"/*; do
  base=$(basename "$f")
  [[ "$base" == "." || "$base" == ".." ]] && continue
  ln -sfn "$(readlink -f "$f")" "$CHALL_DIR/$base"
done
if [[ ! -f "$CHALL_DIR/preprocessor_config.json" ]]; then
  if [[ -f "$CHALL_DIR/processor_config.json" ]]; then
    cp -L "$CHALL_DIR/processor_config.json" "$CHALL_DIR/preprocessor_config.json"
    echo "[r2v-sft3] derived preprocessor_config.json from processor_config.json"
  else
    echo "[r2v-sft3] FATAL no processor/preprocessor config" >&2
    exit 2
  fi
fi
echo "[r2v-sft3] chall dir ready: $CHALL_DIR"

# 2) Wait only while a prior lane has claimed / is about to claim chall
#    (premerge.done). Reason-stamp waiters stay armed but do not idle GPUs.
for i in $(seq 1 2880); do
  for f in "$R2D_DEC" "$R2E_DEC" "$R2H_DEC" "$R2G_DEC" "$R2I_DEC" "$R2J_DEC" \
           "$R2K_DEC" "$R2L_DEC" "$R2M_DEC" "$R2N_DEC" "$R2O_DEC" "$R2P_DEC"; do
    if [[ -f "$f" ]] && headroom_ok "$f"; then
      echo "SKIP_R2V_PRIOR_CLEARS file=$f $(date -u +%Y-%m-%dT%H:%M:%SZ)" | tee "$DONE"
      exit 0
    fi
  done

  busy=0
  if lane_claiming_gpu "$R2I_DONE" "$R2I_PREMERGE_SKIP" "$R2I_DEC" /root/logs/r2i_premerge.done; then busy=1; fi
  if lane_claiming_gpu "$R2J_DONE" "$R2J_PREMERGE_SKIP" "$R2J_DEC" /root/logs/r2j_premerge.done; then busy=1; fi
  if lane_claiming_gpu "$R2K_DONE" "$R2K_PREMERGE_SKIP" "$R2K_DEC" /root/logs/r2k_premerge.done; then busy=1; fi
  if lane_claiming_gpu "$R2L_DONE" "$R2L_PREMERGE_SKIP" "$R2L_DEC" /root/logs/r2l_premerge.done; then busy=1; fi
  if lane_claiming_gpu "$R2M_DONE" "$R2M_PREMERGE_SKIP" "$R2M_DEC" /root/logs/r2m_premerge.done; then busy=1; fi
  if lane_claiming_gpu "$R2N_DONE" "$R2N_PREMERGE_SKIP" "$R2N_DEC" /root/logs/r2n_premerge.done; then busy=1; fi
  if lane_claiming_gpu "$R2O_DONE" "$R2O_PREMERGE_SKIP" "$R2O_DEC" /root/logs/r2o_premerge.done; then busy=1; fi
  if lane_claiming_gpu "$R2P_DONE" "$R2P_PREMERGE_SKIP" "$R2P_DEC" /root/logs/r2p_premerge.done; then busy=1; fi

  if (( busy == 0 )); then
    echo "[r2v-sft3] no GPU claimant ahead; lane free at iter=$i $(date -u +%Y-%m-%dT%H:%M:%SZ)"
    break
  fi
  if (( i % 12 == 0 )); then
    echo "[r2v-sft3] wait-claimant iter=$i $(date -u +%Y-%m-%dT%H:%M:%SZ) busy=$busy"
  fi
  if (( i == 2880 )); then
    echo "[r2v-sft3] TIMEOUT waiting GPU claimant lane" >&2
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
echo "[r2v-sft3] link $LINK -> $(readlink -f "$LINK")"

CHALL_PID_FILE=/root/logs/vllm_chall.pid
if [[ -f "$CHALL_PID_FILE" ]]; then
  CPID=$(cat "$CHALL_PID_FILE" || true)
  if [[ -n "${CPID:-}" ]] && kill -0 "$CPID" 2>/dev/null; then
    echo "[r2v-sft3] stopping chall pid=$CPID"
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
    echo "[r2v-sft3] seeding chall Triton cache from king"
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

echo "[r2v-sft3] launching chall :8002 on $LINK"
CUDA_VISIBLE_DEVICES=4,5 TRITON_CACHE_DIR=/root/.triton/cache/chall \
  nohup /root/venv/bin/vllm serve "$LINK" \
    --port 8002 --gpu-memory-utilization 0.72 \
    "${COMMON[@]}" \
    >/root/logs/vllm_chall.log 2>&1 &
echo $! >/root/logs/vllm_chall.pid
echo "[r2v-sft3] chall pid=$(cat /root/logs/vllm_chall.pid)"

for i in $(seq 1 480); do
  c0=$(curl -s -o /dev/null -w "%{http_code}" --max-time 3 http://127.0.0.1:8000/v1/models || true)
  c1=$(curl -s -o /dev/null -w "%{http_code}" --max-time 3 http://127.0.0.1:8001/v1/models || true)
  c2=$(curl -s -o /dev/null -w "%{http_code}" --max-time 3 http://127.0.0.1:8002/v1/models || true)
  if [[ "$c0$c1$c2" == "200200200" ]]; then
    echo "[r2v-sft3] engines 200/200/200 at iter=$i"
    break
  fi
  if (( i % 12 == 0 )); then
    echo "[r2v-sft3] wait-engines iter=$i codes=${c0}/${c1}/${c2}"
  fi
  if (( i == 480 )); then
    echo "[r2v-sft3] TIMEOUT engines; see vllm_chall.log" >&2
    exit 2
  fi
  sleep 5
done

OUT=/root/affine_data/r2v_sft3_reason_sim.json
DEC=/root/affine_data/r2v_sft3_decision.json
PROG=/root/affine_data/r2v_sft3_reason_progress.json
rm -f "$OUT" "$DEC" "$PROG"
BH=$(python - <<'PY'
import hashlib, time
print(hashlib.sha256(f"r2v-sft3-{time.time_ns()}".encode()).hexdigest())
PY
)

echo "[r2v-sft3] launching R2v n80 block_hash=${BH:0:16}…"
python /root/mining_src/r1-reason-distill/run_reason_sim.py \
  --n-turns 80 \
  --block-hash "$BH" \
  --hotkey "local-r2v-sft3-$(date -u +%Y%m%dT%H:%M:%SZ)" \
  --king-repo Tok331102/affine-5EqYW8McUc-af10 \
  --king-rev eb8bf9a356a254f71faaa439e8abc3cfba572c53 \
  --chall-repo "$LINK" \
  --out "$OUT" \
  --progress-out "$PROG" \
  --save-artifact \
  2>&1 | tee /root/logs/r2v_sft3_reason_sim.log

python /root/mining_src/r1-reason-distill/write_reason_decision.py \
  --sim-result "$OUT" --out "$DEC" --hyp R2v \
  2>&1 | tee -a /root/logs/r2v_sft3_reason_sim.log

echo "[r2v-sft3] DONE $(date -u +%Y-%m-%dT%H:%M:%SZ)"
cat "$DEC"
echo "OK $(date -u +%Y-%m-%dT%H:%M:%SZ)" >"$DONE"
