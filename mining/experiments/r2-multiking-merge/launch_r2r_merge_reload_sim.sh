#!/usr/bin/env bash
# R2r: after R2q (+ R2i…R2p + R2s/R2t/R2u) resolve below bar + Talent×whoami skew
# premerge ready (gated on chal-00458 Reason hr>0) → reload chall → fresh n80.
# If R2r premerge SKIP (Reason− / mismatch / timeout) → exit without chall kill.
# Yields when r2t/r2u_premerge.done exists until those lanes terminal.
# Does NOT touch teacher:8000 or king:8001. Kill chall by PID file only.
# Pre-registered: submit only if headroom ≥ 1.5×(3·SE).
set -euo pipefail
LOG=/root/logs/r2r_merge_reload.log
DONE=/root/logs/r2r_merge_reload.done
PIDF=/root/logs/r2r_merge_reload.pid
mkdir -p /root/logs /root/affine_data /root/r2_out
echo $$ >"$PIDF"
exec > >(tee -a "$LOG") 2>&1

echo "[r2r-merge] $(date -u +%Y-%m-%dT%H:%M:%SZ) start"
if [[ -f "$DONE" ]]; then
  echo "[r2r-merge] already done: $(cat "$DONE")"
  exit 0
fi

PREMERGE_DONE=${PREMERGE_DONE:-/root/logs/r2r_premerge.done}
PREMERGE_SKIP=${PREMERGE_SKIP:-/root/logs/r2r_premerge.skip}
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
R2Q_DEC=${R2Q_DEC:-/root/affine_data/r2q_saysth_decision.json}
R2Q_DONE=${R2Q_DONE:-/root/logs/r2q_saysth_reload.done}
R2S_DEC=${R2S_DEC:-/root/affine_data/r2s_alpha_decision.json}
R2S_DONE=${R2S_DONE:-/root/logs/r2s_merge_reload.done}
R2S_PREMERGE_SKIP=${R2S_PREMERGE_SKIP:-/root/logs/r2s_premerge.skip}
R2T_DEC=${R2T_DEC:-/root/affine_data/r2t_alpha_decision.json}
R2T_DONE=${R2T_DONE:-/root/logs/r2t_merge_reload.done}
R2T_PREMERGE_SKIP=${R2T_PREMERGE_SKIP:-/root/logs/r2t_premerge.skip}
R2U_DEC=${R2U_DEC:-/root/affine_data/r2u_alpha_decision.json}
R2U_DONE=${R2U_DONE:-/root/logs/r2u_merge_reload.done}
R2U_PREMERGE_SKIP=${R2U_PREMERGE_SKIP:-/root/logs/r2u_premerge.skip}
R2V_DEC=${R2V_DEC:-/root/affine_data/r2v_sft3_decision.json}
R2V_DONE=${R2V_DONE:-/root/logs/r2v_sft3_reload.done}
HEADROOM_BAR=${HEADROOM_BAR:-1.5}
MERGED=${MERGED:-/root/r2_out/alpha_talent_whoami_skew}
LINK=${LINK:-/tmp/r2r_alpha_merged}

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
  local done="$1" skip="$2" dec="$3"
  [[ -f "$done" || -f "$skip" || -f "$dec" ]]
}

# 1) Wait R2r CPU premerge outcome (done with weights, or skip).
for i in $(seq 1 2880); do
  if [[ -f "$PREMERGE_SKIP" ]]; then
    echo "SKIP_R2R_PREMERGE_SKIPPED $(cat "$PREMERGE_SKIP") $(date -u +%Y-%m-%dT%H:%M:%SZ)" | tee "$DONE"
    exit 0
  fi
  if [[ -f "$PREMERGE_DONE" && -f "$MERGED/model.safetensors.index.json" ]]; then
    echo "[r2r-merge] premerge ready at iter=$i $(date -u +%Y-%m-%dT%H:%M:%SZ) $(cat "$PREMERGE_DONE")"
    break
  fi
  if (( i % 12 == 0 )); then
    crumb=$(tail -n 3 /root/logs/r2r_premerge.log 2>/dev/null | tr '\r' '\n' | tail -1 || true)
    echo "[r2r-merge] wait-premerge iter=$i crumb=${crumb:-none}"
  fi
  if (( i == 2880 )); then
    echo "SKIP_R2R_PREMERGE_TIMEOUT $(date -u +%Y-%m-%dT%H:%M:%SZ)" | tee "$DONE"
    exit 0
  fi
  sleep 10
done

# 2) Wait R2i…R2q + R2s/R2t/R2u terminal (or any prior clears 1.5×). Pidfile kill -0 only.
for i in $(seq 1 2880); do
  for f in "$R2D_DEC" "$R2E_DEC" "$R2H_DEC" "$R2G_DEC" "$R2I_DEC" "$R2J_DEC" \
           "$R2K_DEC" "$R2L_DEC" "$R2M_DEC" "$R2N_DEC" "$R2O_DEC" "$R2P_DEC" \
           "$R2Q_DEC" "$R2S_DEC" "$R2T_DEC" "$R2U_DEC"; do
    if [[ -f "$f" ]] && headroom_ok "$f"; then
      echo "SKIP_R2R_PRIOR_CLEARS file=$f $(date -u +%Y-%m-%dT%H:%M:%SZ)" | tee "$DONE"
      exit 0
    fi
  done
  if [[ -f "$PREMERGE_SKIP" ]]; then
    echo "SKIP_R2R_PREMERGE_SKIPPED $(cat "$PREMERGE_SKIP") $(date -u +%Y-%m-%dT%H:%M:%SZ)" | tee "$DONE"
    exit 0
  fi

  busy=0
  if ! lane_terminal "$R2I_DONE" "$R2I_PREMERGE_SKIP" "$R2I_DEC"; then busy=1; fi
  if ! lane_terminal "$R2J_DONE" "$R2J_PREMERGE_SKIP" "$R2J_DEC"; then busy=1; fi
  if ! lane_terminal "$R2K_DONE" "$R2K_PREMERGE_SKIP" "$R2K_DEC"; then busy=1; fi
  if ! lane_terminal "$R2L_DONE" "$R2L_PREMERGE_SKIP" "$R2L_DEC"; then busy=1; fi
  if ! lane_terminal "$R2M_DONE" "$R2M_PREMERGE_SKIP" "$R2M_DEC"; then busy=1; fi
  if ! lane_terminal "$R2N_DONE" "$R2N_PREMERGE_SKIP" "$R2N_DEC"; then busy=1; fi
  if ! lane_terminal "$R2O_DONE" "$R2O_PREMERGE_SKIP" "$R2O_DEC"; then busy=1; fi
  if ! lane_terminal "$R2P_DONE" "$R2P_PREMERGE_SKIP" "$R2P_DEC"; then busy=1; fi
  # R2q has no premerge.skip — done or decision
  if [[ ! -f "$R2Q_DONE" && ! -f "$R2Q_DEC" ]]; then busy=1; fi
  # R2s only blocks once its premerge finished (or merge pid holds chall).
  if [[ -f /root/logs/r2s_premerge.done ]] && ! lane_terminal "$R2S_DONE" "$R2S_PREMERGE_SKIP" "$R2S_DEC"; then
    busy=1
  fi
  # R2t (saysth×Talent) blocks once premerge.done exists until terminal.
  if [[ -f /root/logs/r2t_premerge.done ]] && ! lane_terminal "$R2T_DONE" "$R2T_PREMERGE_SKIP" "$R2T_DEC"; then
    busy=1
  fi
  # R2u (saysth×kevin) blocks once premerge.done exists until terminal.
  if [[ -f /root/logs/r2u_premerge.done ]] && ! lane_terminal "$R2U_DONE" "$R2U_PREMERGE_SKIP" "$R2U_DEC"; then
    busy=1
  fi

  for pf in /root/logs/r2{i,j,k,l,m,n,o,p}_merge_reload.pid /root/logs/r2q_saysth_reload.pid /root/logs/r2s_merge_reload.pid /root/logs/r2t_merge_reload.pid /root/logs/r2u_merge_reload.pid /root/logs/r2v_sft3_reload.pid; do
    if pid_alive "$pf"; then
      case "$pf" in
        *r2i*) lane_terminal "$R2I_DONE" "$R2I_PREMERGE_SKIP" "$R2I_DEC" || busy=1 ;;
        *r2j*) lane_terminal "$R2J_DONE" "$R2J_PREMERGE_SKIP" "$R2J_DEC" || busy=1 ;;
        *r2k*) lane_terminal "$R2K_DONE" "$R2K_PREMERGE_SKIP" "$R2K_DEC" || busy=1 ;;
        *r2l*) lane_terminal "$R2L_DONE" "$R2L_PREMERGE_SKIP" "$R2L_DEC" || busy=1 ;;
        *r2m*) lane_terminal "$R2M_DONE" "$R2M_PREMERGE_SKIP" "$R2M_DEC" || busy=1 ;;
        *r2n*) lane_terminal "$R2N_DONE" "$R2N_PREMERGE_SKIP" "$R2N_DEC" || busy=1 ;;
        *r2o*) lane_terminal "$R2O_DONE" "$R2O_PREMERGE_SKIP" "$R2O_DEC" || busy=1 ;;
        *r2p*) lane_terminal "$R2P_DONE" "$R2P_PREMERGE_SKIP" "$R2P_DEC" || busy=1 ;;
        *r2q*) [[ -f "$R2Q_DONE" || -f "$R2Q_DEC" ]] || busy=1 ;;
        *r2s*) lane_terminal "$R2S_DONE" "$R2S_PREMERGE_SKIP" "$R2S_DEC" || busy=1 ;;
        *r2t*) lane_terminal "$R2T_DONE" "$R2T_PREMERGE_SKIP" "$R2T_DEC" || busy=1 ;;
        *r2u*) lane_terminal "$R2U_DONE" "$R2U_PREMERGE_SKIP" "$R2U_DEC" || busy=1 ;;
        *r2v*) [[ -f "$R2V_DONE" || -f "$R2V_DEC" ]] || busy=1 ;;
      esac
    fi
  done

  if (( busy == 0 )); then
    echo "[r2r-merge] R2i…R2q/R2v below bar/skipped + R2s/R2t/R2u not claiming; lane free at iter=$i"
    break
  fi
  if (( i % 12 == 0 )); then
    echo "[r2r-merge] wait-lane iter=$i $(date -u +%Y-%m-%dT%H:%M:%SZ) busy=$busy r2q_term=$([[ -f $R2Q_DONE || -f $R2Q_DEC ]] && echo y || echo n) r2v_term=$([[ -f $R2V_DONE || -f $R2V_DEC ]] && echo y || echo n) r2s_claim=$([[ -f /root/logs/r2s_premerge.done ]] && ! lane_terminal "$R2S_DONE" "$R2S_PREMERGE_SKIP" "$R2S_DEC" && echo y || echo n) r2t_claim=$([[ -f /root/logs/r2t_premerge.done ]] && ! lane_terminal "$R2T_DONE" "$R2T_PREMERGE_SKIP" "$R2T_DEC" && echo y || echo n) r2u_claim=$([[ -f /root/logs/r2u_premerge.done ]] && ! lane_terminal "$R2U_DONE" "$R2U_PREMERGE_SKIP" "$R2U_DEC" && echo y || echo n)"
  fi
  if (( i == 2880 )); then
    echo "[r2r-merge] TIMEOUT waiting R2i…R2q/R2v+R2s/R2t/R2u lane" >&2
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

if [[ ! -f "$MERGED/model.safetensors.index.json" ]]; then
  echo "[r2r-merge] FATAL missing merged index at $MERGED" >&2
  exit 2
fi

ln -sfn "$MERGED" "$LINK"
echo "[r2r-merge] link $LINK -> $(readlink -f "$LINK")"

CHALL_PID_FILE=/root/logs/vllm_chall.pid
if [[ -f "$CHALL_PID_FILE" ]]; then
  CPID=$(cat "$CHALL_PID_FILE" || true)
  if [[ -n "${CPID:-}" ]] && kill -0 "$CPID" 2>/dev/null; then
    echo "[r2r-merge] stopping chall pid=$CPID"
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
    echo "[r2r-merge] seeding chall Triton cache from king"
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

echo "[r2r-merge] launching chall :8002 on $LINK"
CUDA_VISIBLE_DEVICES=4,5 TRITON_CACHE_DIR=/root/.triton/cache/chall \
  nohup /root/venv/bin/vllm serve "$LINK" \
    --port 8002 --gpu-memory-utilization 0.72 \
    "${COMMON[@]}" \
    >/root/logs/vllm_chall.log 2>&1 &
echo $! >/root/logs/vllm_chall.pid
echo "[r2r-merge] chall pid=$(cat /root/logs/vllm_chall.pid)"

for i in $(seq 1 480); do
  c0=$(curl -s -o /dev/null -w "%{http_code}" --max-time 3 http://127.0.0.1:8000/v1/models || true)
  c1=$(curl -s -o /dev/null -w "%{http_code}" --max-time 3 http://127.0.0.1:8001/v1/models || true)
  c2=$(curl -s -o /dev/null -w "%{http_code}" --max-time 3 http://127.0.0.1:8002/v1/models || true)
  if [[ "$c0$c1$c2" == "200200200" ]]; then
    echo "[r2r-merge] engines 200/200/200 at iter=$i"
    break
  fi
  if (( i % 12 == 0 )); then
    echo "[r2r-merge] wait-engines iter=$i codes=${c0}/${c1}/${c2}"
  fi
  if (( i == 480 )); then
    echo "[r2r-merge] TIMEOUT engines; see vllm_chall.log" >&2
    exit 2
  fi
  sleep 5
done

OUT=/root/affine_data/r2r_alpha_reason_sim.json
DEC=/root/affine_data/r2r_alpha_decision.json
PROG=/root/affine_data/r2r_alpha_reason_progress.json
rm -f "$OUT" "$DEC" "$PROG"
BH=$(python - <<'PY'
import hashlib, time
print(hashlib.sha256(f"r2r-talent-whoami-{time.time_ns()}".encode()).hexdigest())
PY
)

echo "[r2r-merge] launching R2r n80 block_hash=${BH:0:16}…"
python /root/mining_src/r1-reason-distill/run_reason_sim.py \
  --n-turns 80 \
  --block-hash "$BH" \
  --hotkey "local-r2r-talent-whoami-$(date -u +%Y%m%dT%H:%M:%SZ)" \
  --king-repo Tok331102/affine-5EqYW8McUc-af10 \
  --king-rev eb8bf9a356a254f71faaa439e8abc3cfba572c53 \
  --chall-repo "$LINK" \
  --out "$OUT" \
  --progress-out "$PROG" \
  --save-artifact \
  2>&1 | tee /root/logs/r2r_alpha_reason_sim.log

python /root/mining_src/r1-reason-distill/write_reason_decision.py \
  --sim-result "$OUT" --out "$DEC" --hyp R2r \
  2>&1 | tee -a /root/logs/r2r_alpha_reason_sim.log

echo "[r2r-merge] DONE $(date -u +%Y-%m-%dT%H:%M:%SZ)"
cat "$DEC"
echo "OK $(date -u +%Y-%m-%dT%H:%M:%SZ)" >"$DONE"
