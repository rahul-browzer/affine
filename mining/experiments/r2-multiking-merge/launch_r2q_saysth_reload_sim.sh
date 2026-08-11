#!/usr/bin/env bash
# R2q: after R2i…R2p resolve below bar / skip, serve pure
# saysth/…-v9a (live Reason+ hr≈0.73×) as chall and run fresh n80 vs Tok.
# Talent×saysth skew REFUTED (−0.89×); this is the pure-parent transfer
# test (R2d analogue). Does NOT touch teacher:8000 or king:8001.
# Kill chall by PID file only. Submit only if headroom ≥ 1.5×(3·SE).
set -euo pipefail
LOG=/root/logs/r2q_saysth_reload.log
DONE=/root/logs/r2q_saysth_reload.done
PIDF=/root/logs/r2q_saysth_reload.pid
mkdir -p /root/logs /root/affine_data /root/r2_out
echo $$ >"$PIDF"
exec > >(tee -a "$LOG") 2>&1

echo "[r2q-saysth] $(date -u +%Y-%m-%dT%H:%M:%SZ) start"
if [[ -f "$DONE" ]]; then
  echo "[r2q-saysth] already done: $(cat "$DONE")"
  exit 0
fi

HEADROOM_BAR=${HEADROOM_BAR:-1.5}
SAYSTH_SNAP=${SAYSTH_SNAP:-/root/hf/hub/models--saysth--Affine-5dtnxamt4t-v9a/snapshots/6e13f365b36000cf631aad2fa9fb05fdabae0044}
CHALL_DIR=${CHALL_DIR:-/root/r2_out/saysth_v9a_chall}
LINK=${LINK:-/tmp/r2q_saysth_v9a}

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

pid_alive() {
  local pf="$1"
  [[ -f "$pf" ]] || return 1
  local ppid
  ppid=$(cat "$pf" 2>/dev/null || true)
  [[ -n "${ppid:-}" ]] && kill -0 "$ppid" 2>/dev/null
}

lane_terminal() {
  # done | premerge.skip | decision ⇒ prior lane will not claim chall again
  local done="$1" skip="$2" dec="$3"
  [[ -f "$done" || -f "$skip" || -f "$dec" ]]
}

# GPU-claiming = blended weights ready (premerge.done) and not yet terminal.
# Reason-only waiters must NOT block — queue duels can take hours; pure saysth
# (hr≈0.73×) is the best DL Reason+ parent and should burn idle GPUs now.
# Sibling merge scripts wait on r2q_saysth_reload.pid before killing chall.
lane_claiming_gpu() {
  local done="$1" skip="$2" dec="$3" premerge_done="$4"
  if lane_terminal "$done" "$skip" "$dec"; then
    return 1
  fi
  [[ -f "$premerge_done" ]]
}

# 1) Materialize thin chall dir (symlinks + preprocessor for vLLM).
mkdir -p "$CHALL_DIR"
if [[ ! -f "$SAYSTH_SNAP/model.safetensors.index.json" ]]; then
  echo "[r2q-saysth] FATAL missing saysth snapshot index at $SAYSTH_SNAP" >&2
  exit 2
fi
for f in "$SAYSTH_SNAP"/*; do
  base=$(basename "$f")
  [[ "$base" == "." || "$base" == ".." ]] && continue
  ln -sfn "$(readlink -f "$f")" "$CHALL_DIR/$base"
done
if [[ ! -f "$CHALL_DIR/preprocessor_config.json" ]]; then
  if [[ -f "$CHALL_DIR/processor_config.json" ]]; then
    cp -L "$CHALL_DIR/processor_config.json" "$CHALL_DIR/preprocessor_config.json"
    echo "[r2q-saysth] derived preprocessor_config.json from processor_config.json"
  else
    echo "[r2q-saysth] FATAL no processor/preprocessor config" >&2
    exit 2
  fi
fi
echo "[r2q-saysth] chall dir ready: $CHALL_DIR"

# 2) Wait only while a prior lane has claimed / is about to claim chall
#    (premerge.done). Reason-stamp waiters stay armed but do not idle GPUs.
for i in $(seq 1 2880); do
  for f in "$R2D_DEC" "$R2E_DEC" "$R2H_DEC" "$R2G_DEC" "$R2I_DEC" "$R2J_DEC" \
           "$R2K_DEC" "$R2L_DEC" "$R2M_DEC" "$R2N_DEC" "$R2O_DEC" "$R2P_DEC"; do
    if [[ -f "$f" ]] && headroom_ok "$f"; then
      echo "SKIP_R2Q_PRIOR_CLEARS file=$f $(date -u +%Y-%m-%dT%H:%M:%SZ)" | tee "$DONE"
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
    echo "[r2q-saysth] no GPU claimant ahead; lane free at iter=$i $(date -u +%Y-%m-%dT%H:%M:%SZ)"
    break
  fi
  if (( i % 12 == 0 )); then
    echo "[r2q-saysth] wait-claimant iter=$i $(date -u +%Y-%m-%dT%H:%M:%SZ) busy=$busy"
  fi
  if (( i == 2880 )); then
    echo "[r2q-saysth] TIMEOUT waiting GPU claimant lane" >&2
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
echo "[r2q-saysth] link $LINK -> $(readlink -f "$LINK")"

CHALL_PID_FILE=/root/logs/vllm_chall.pid
if [[ -f "$CHALL_PID_FILE" ]]; then
  CPID=$(cat "$CHALL_PID_FILE" || true)
  if [[ -n "${CPID:-}" ]] && kill -0 "$CPID" 2>/dev/null; then
    echo "[r2q-saysth] stopping chall pid=$CPID"
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
    echo "[r2q-saysth] seeding chall Triton cache from king"
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

echo "[r2q-saysth] launching chall :8002 on $LINK"
CUDA_VISIBLE_DEVICES=4,5 TRITON_CACHE_DIR=/root/.triton/cache/chall \
  nohup /root/venv/bin/vllm serve "$LINK" \
    --port 8002 --gpu-memory-utilization 0.72 \
    "${COMMON[@]}" \
    >/root/logs/vllm_chall.log 2>&1 &
echo $! >/root/logs/vllm_chall.pid
echo "[r2q-saysth] chall pid=$(cat /root/logs/vllm_chall.pid)"

for i in $(seq 1 480); do
  c0=$(curl -s -o /dev/null -w "%{http_code}" --max-time 3 http://127.0.0.1:8000/v1/models || true)
  c1=$(curl -s -o /dev/null -w "%{http_code}" --max-time 3 http://127.0.0.1:8001/v1/models || true)
  c2=$(curl -s -o /dev/null -w "%{http_code}" --max-time 3 http://127.0.0.1:8002/v1/models || true)
  if [[ "$c0$c1$c2" == "200200200" ]]; then
    echo "[r2q-saysth] engines 200/200/200 at iter=$i"
    break
  fi
  if (( i % 12 == 0 )); then
    echo "[r2q-saysth] wait-engines iter=$i codes=${c0}/${c1}/${c2}"
  fi
  if (( i == 480 )); then
    echo "[r2q-saysth] TIMEOUT engines; see vllm_chall.log" >&2
    exit 2
  fi
  sleep 5
done

OUT=/root/affine_data/r2q_saysth_reason_sim.json
DEC=/root/affine_data/r2q_saysth_decision.json
PROG=/root/affine_data/r2q_saysth_reason_progress.json
rm -f "$OUT" "$DEC" "$PROG"
BH=$(python - <<'PY'
import hashlib, time
print(hashlib.sha256(f"r2q-saysth-{time.time_ns()}".encode()).hexdigest())
PY
)

echo "[r2q-saysth] launching R2q n80 block_hash=${BH:0:16}…"
python /root/mining_src/r1-reason-distill/run_reason_sim.py \
  --n-turns 80 \
  --block-hash "$BH" \
  --hotkey "local-r2q-saysth-$(date -u +%Y%m%dT%H:%M:%SZ)" \
  --king-repo Tok331102/affine-5EqYW8McUc-af10 \
  --king-rev eb8bf9a356a254f71faaa439e8abc3cfba572c53 \
  --chall-repo "$LINK" \
  --out "$OUT" \
  --progress-out "$PROG" \
  --save-artifact \
  2>&1 | tee /root/logs/r2q_saysth_reason_sim.log

python /root/mining_src/r1-reason-distill/write_reason_decision.py \
  --sim-result "$OUT" --out "$DEC" --hyp R2q \
  2>&1 | tee -a /root/logs/r2q_saysth_reason_sim.log

echo "[r2q-saysth] DONE $(date -u +%Y-%m-%dT%H:%M:%SZ)"
cat "$DEC"
echo "OK $(date -u +%Y-%m-%dT%H:%M:%SZ)" >"$DONE"
