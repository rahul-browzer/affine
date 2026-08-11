#!/usr/bin/env bash
# R2w: after pure-sft3 (R2v) finishes below Stage-5 bar, burn idle crown GPUs
# on pure adsbasd31badsf/…-asdf (queue chal-00451) as chall → fresh n80 vs Tok.
# Does NOT wait on board Reason stamps. Sibling merges wait on
# r2w_asdf_reload.pid via wait_r2q_before_chall_kill.inc.sh.
# Waits for R2v terminal + bridge_r2v_to_r2l so a local Reason+ sft3 can
# still hand the lane to Talent×sft3 (R2l) before we take chall.
# Does NOT touch teacher:8000 or king:8001. Kill chall by PID file only.
# Pre-registered: submit only if headroom ≥ 1.5×(3·SE).
set -euo pipefail
LOG=/root/logs/r2w_asdf_reload.log
DONE=/root/logs/r2w_asdf_reload.done
PIDF=/root/logs/r2w_asdf_reload.pid
mkdir -p /root/logs /root/affine_data /root/r2_out
echo $$ >"$PIDF"
exec > >(tee -a "$LOG") 2>&1

echo "[r2w-asdf] $(date -u +%Y-%m-%dT%H:%M:%SZ) start"
if [[ -f "$DONE" ]]; then
  echo "[r2w-asdf] already done: $(cat "$DONE")"
  exit 0
fi

HEADROOM_BAR=${HEADROOM_BAR:-1.5}
ASDF_SNAP=${ASDF_SNAP:-/root/hf/hub/models--adsbasd31badsf--affine-5ec3jw68ha-asdf/snapshots/c23098154fd717e64f577cd863f0e1ba8e96ee84}
CHALL_DIR=${CHALL_DIR:-/root/r2_out/asdf_chall}
LINK=${LINK:-/tmp/r2w_asdf}

R2V_DEC=${R2V_DEC:-/root/affine_data/r2v_sft3_decision.json}
R2V_DONE=${R2V_DONE:-/root/logs/r2v_sft3_reload.done}
R2V_PIDF=${R2V_PIDF:-/root/logs/r2v_sft3_reload.pid}
BRIDGE_DONE=${BRIDGE_DONE:-/root/logs/bridge_r2v_to_r2l.done}
STAGE5=${STAGE5:-/root/affine_data/r2v_stage5_ready.json}

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
R2R_DEC=${R2R_DEC:-/root/affine_data/r2r_alpha_decision.json}
R2R_DONE=${R2R_DONE:-/root/logs/r2r_merge_reload.done}
R2R_PREMERGE_SKIP=${R2R_PREMERGE_SKIP:-/root/logs/r2r_premerge.skip}

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

pid_alive() {
  local pf="$1"
  local ppid
  ppid=$(cat "$pf" 2>/dev/null || true)
  [[ -n "${ppid:-}" ]] && kill -0 "$ppid" 2>/dev/null
}

lane_claiming_gpu() {
  local done="$1" skip="$2" dec="$3" premerge_done="$4"
  if lane_terminal "$done" "$skip" "$dec"; then
    return 1
  fi
  [[ -f "$premerge_done" ]]
}

# R2l after board/local Reason+ must beat pure-asdf to the chall slot.
# lane_claiming_gpu only sees premerge.done — mid-blend has none yet, so
# without this R2w steals GPU while Talent×sft3 is still writing shards.
r2l_claiming_gpu() {
  if lane_terminal "$R2L_DONE" "$R2L_PREMERGE_SKIP" "$R2L_DEC"; then
    return 1
  fi
  if [[ -f /root/logs/r2l_premerge.done ]]; then
    return 0
  fi
  if pid_alive /root/logs/r2l_premerge.pid; then
    return 0
  fi
  if pid_alive /root/logs/r2l_merge_reload.pid; then
    return 0
  fi
  if [[ -f /root/affine_data/chal00450_reason.json && -f /root/logs/watch_chal00450_reason.done ]]; then
    if python - <<'PY'
import json
from pathlib import Path
d = json.loads(Path("/root/affine_data/chal00450_reason.json").read_text())
hr = d.get("headroom_vs_3se")
raise SystemExit(0 if d.get("king_match") and hr is not None and float(hr) > 0.0 else 1)
PY
    then
      return 0
    fi
  fi
  return 1
}

# 0) Wait for R2v to finish holding chall (decision or reload.done).
echo "[r2w-asdf] waiting for R2v terminal"
for i in $(seq 1 2880); do
  if [[ -f "$STAGE5" ]]; then
    echo "SKIP_R2W_STAGE5 $(date -u +%Y-%m-%dT%H:%M:%SZ) $(head -1 "$STAGE5")" | tee "$DONE"
    exit 0
  fi
  if [[ -f "$R2V_DEC" ]] && headroom_ok "$R2V_DEC"; then
    echo "SKIP_R2W_R2V_CLEARS file=$R2V_DEC $(date -u +%Y-%m-%dT%H:%M:%SZ)" | tee "$DONE"
    exit 0
  fi
  if [[ -f "$R2V_DONE" || -f "$R2V_DEC" ]]; then
    echo "[r2w-asdf] R2v terminal at iter=$i $(date -u +%Y-%m-%dT%H:%M:%SZ)"
    break
  fi
  if [[ -f "$R2V_PIDF" ]]; then
    _ppid=$(cat "$R2V_PIDF" 2>/dev/null || true)
    if [[ -n "${_ppid:-}" ]] && kill -0 "$_ppid" 2>/dev/null; then
      if (( i % 12 == 0 )); then
        crumb=$(python3 -c "import json;from pathlib import Path;p=Path('/root/affine_data/r2v_sft3_reason_progress.json');
print(p.read_text().strip() if p.is_file() else 'no-progress')" 2>/dev/null || echo none)
        echo "[r2w-asdf] wait-r2v iter=$i pid=$_ppid crumb=${crumb:-none}"
      fi
      sleep 10
      continue
    fi
  fi
  if (( i % 12 == 0 )); then
    echo "[r2w-asdf] wait-r2v iter=$i (no pid / no dec yet)"
  fi
  if (( i == 2880 )); then
    echo "[r2w-asdf] TIMEOUT waiting R2v" >&2
    exit 2
  fi
  sleep 10
done

# Let bridge_r2v_to_r2l react (Stage-5 / proxy Reason+ / keep board) before we claim.
echo "[r2w-asdf] waiting for bridge_r2v_to_r2l.done"
for i in $(seq 1 180); do
  if [[ -f "$STAGE5" ]]; then
    echo "SKIP_R2W_STAGE5 $(date -u +%Y-%m-%dT%H:%M:%SZ)" | tee "$DONE"
    exit 0
  fi
  if [[ -f "$BRIDGE_DONE" ]]; then
    echo "[r2w-asdf] bridge done: $(head -1 "$BRIDGE_DONE")"
    break
  fi
  if (( i % 12 == 0 )); then
    echo "[r2w-asdf] wait-bridge iter=$i $(date -u +%Y-%m-%dT%H:%M:%SZ)"
  fi
  if (( i == 180 )); then
    echo "[r2w-asdf] bridge timeout — proceed cautiously (R2v dec present)"
    break
  fi
  sleep 5
done

# 1) Materialize thin chall dir (symlinks + preprocessor for vLLM).
mkdir -p "$CHALL_DIR"
if [[ ! -f "$ASDF_SNAP/model.safetensors.index.json" ]]; then
  echo "[r2w-asdf] FATAL missing asdf snapshot index at $ASDF_SNAP" >&2
  exit 2
fi
for f in "$ASDF_SNAP"/*; do
  base=$(basename "$f")
  [[ "$base" == "." || "$base" == ".." ]] && continue
  ln -sfn "$(readlink -f "$f")" "$CHALL_DIR/$base"
done
if [[ ! -f "$CHALL_DIR/preprocessor_config.json" ]]; then
  if [[ -f "$CHALL_DIR/processor_config.json" ]]; then
    cp -L "$CHALL_DIR/processor_config.json" "$CHALL_DIR/preprocessor_config.json"
    echo "[r2w-asdf] derived preprocessor_config.json from processor_config.json"
  else
    echo "[r2w-asdf] FATAL no processor/preprocessor config" >&2
    exit 2
  fi
fi
echo "[r2w-asdf] chall dir ready: $CHALL_DIR"

# 2) Yield to any sibling that claimed GPU (esp. R2l after local-proxy).
for i in $(seq 1 2880); do
  for f in "$R2D_DEC" "$R2E_DEC" "$R2H_DEC" "$R2G_DEC" "$R2I_DEC" "$R2J_DEC" \
           "$R2K_DEC" "$R2L_DEC" "$R2M_DEC" "$R2N_DEC" "$R2O_DEC" "$R2P_DEC" \
           "$R2R_DEC" "$R2V_DEC"; do
    if [[ -f "$f" ]] && headroom_ok "$f"; then
      echo "SKIP_R2W_PRIOR_CLEARS file=$f $(date -u +%Y-%m-%dT%H:%M:%SZ)" | tee "$DONE"
      exit 0
    fi
  done
  if [[ -f "$STAGE5" ]]; then
    echo "SKIP_R2W_STAGE5 $(date -u +%Y-%m-%dT%H:%M:%SZ)" | tee "$DONE"
    exit 0
  fi

  busy=0
  if lane_claiming_gpu "$R2I_DONE" "$R2I_PREMERGE_SKIP" "$R2I_DEC" /root/logs/r2i_premerge.done; then busy=1; fi
  if lane_claiming_gpu "$R2J_DONE" "$R2J_PREMERGE_SKIP" "$R2J_DEC" /root/logs/r2j_premerge.done; then busy=1; fi
  if lane_claiming_gpu "$R2K_DONE" "$R2K_PREMERGE_SKIP" "$R2K_DEC" /root/logs/r2k_premerge.done; then busy=1; fi
  if r2l_claiming_gpu; then busy=1; fi
  if lane_claiming_gpu "$R2M_DONE" "$R2M_PREMERGE_SKIP" "$R2M_DEC" /root/logs/r2m_premerge.done; then busy=1; fi
  if lane_claiming_gpu "$R2N_DONE" "$R2N_PREMERGE_SKIP" "$R2N_DEC" /root/logs/r2n_premerge.done; then busy=1; fi
  if lane_claiming_gpu "$R2O_DONE" "$R2O_PREMERGE_SKIP" "$R2O_DEC" /root/logs/r2o_premerge.done; then busy=1; fi
  if lane_claiming_gpu "$R2P_DONE" "$R2P_PREMERGE_SKIP" "$R2P_DEC" /root/logs/r2p_premerge.done; then busy=1; fi
  if lane_claiming_gpu "$R2R_DONE" "$R2R_PREMERGE_SKIP" "$R2R_DEC" /root/logs/r2r_premerge.done; then busy=1; fi

  if (( busy == 0 )); then
    echo "[r2w-asdf] no GPU claimant ahead; lane free at iter=$i $(date -u +%Y-%m-%dT%H:%M:%SZ)"
    break
  fi
  if (( i % 12 == 0 )); then
    echo "[r2w-asdf] wait-claimant iter=$i $(date -u +%Y-%m-%dT%H:%M:%SZ) busy=$busy r2l=$(r2l_claiming_gpu && echo y || echo n)"
  fi
  if (( i == 2880 )); then
    echo "[r2w-asdf] TIMEOUT waiting GPU claimant lane" >&2
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
echo "[r2w-asdf] link $LINK -> $(readlink -f "$LINK")"

CHALL_PID_FILE=/root/logs/vllm_chall.pid
if [[ -f "$CHALL_PID_FILE" ]]; then
  CPID=$(cat "$CHALL_PID_FILE" || true)
  if [[ -n "${CPID:-}" ]] && kill -0 "$CPID" 2>/dev/null; then
    echo "[r2w-asdf] stopping chall pid=$CPID"
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
    echo "[r2w-asdf] seeding chall Triton cache from king"
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

echo "[r2w-asdf] launching chall :8002 on $LINK"
CUDA_VISIBLE_DEVICES=4,5 TRITON_CACHE_DIR=/root/.triton/cache/chall \
  nohup /root/venv/bin/vllm serve "$LINK" \
    --port 8002 --gpu-memory-utilization 0.72 \
    "${COMMON[@]}" \
    >/root/logs/vllm_chall.log 2>&1 &
echo $! >/root/logs/vllm_chall.pid
echo "[r2w-asdf] chall pid=$(cat /root/logs/vllm_chall.pid)"

for i in $(seq 1 480); do
  c0=$(curl -s -o /dev/null -w "%{http_code}" --max-time 3 http://127.0.0.1:8000/v1/models || true)
  c1=$(curl -s -o /dev/null -w "%{http_code}" --max-time 3 http://127.0.0.1:8001/v1/models || true)
  c2=$(curl -s -o /dev/null -w "%{http_code}" --max-time 3 http://127.0.0.1:8002/v1/models || true)
  if [[ "$c0$c1$c2" == "200200200" ]]; then
    echo "[r2w-asdf] engines 200/200/200 at iter=$i"
    break
  fi
  if (( i % 12 == 0 )); then
    echo "[r2w-asdf] wait-engines iter=$i codes=${c0}/${c1}/${c2}"
  fi
  if (( i == 480 )); then
    echo "[r2w-asdf] TIMEOUT engines; see vllm_chall.log" >&2
    exit 2
  fi
  sleep 5
done

OUT=/root/affine_data/r2w_asdf_reason_sim.json
DEC=/root/affine_data/r2w_asdf_decision.json
PROG=/root/affine_data/r2w_asdf_reason_progress.json
rm -f "$OUT" "$DEC" "$PROG"
BH=$(python - <<'PY'
import hashlib, time
print(hashlib.sha256(f"r2w-asdf-{time.time_ns()}".encode()).hexdigest())
PY
)

echo "[r2w-asdf] launching R2w n80 block_hash=${BH:0:16}…"
python /root/mining_src/r1-reason-distill/run_reason_sim.py \
  --n-turns 80 \
  --block-hash "$BH" \
  --hotkey "local-r2w-asdf-$(date -u +%Y%m%dT%H:%M:%SZ)" \
  --king-repo Tok331102/affine-5EqYW8McUc-af10 \
  --king-rev eb8bf9a356a254f71faaa439e8abc3cfba572c53 \
  --chall-repo "$LINK" \
  --out "$OUT" \
  --progress-out "$PROG" \
  --save-artifact \
  2>&1 | tee /root/logs/r2w_asdf_reason_sim.log

python /root/mining_src/r1-reason-distill/write_reason_decision.py \
  --sim-result "$OUT" --out "$DEC" --hyp R2w \
  2>&1 | tee -a /root/logs/r2w_asdf_reason_sim.log

echo "[r2w-asdf] DONE $(date -u +%Y-%m-%dT%H:%M:%SZ)"
cat "$DEC"
echo "OK $(date -u +%Y-%m-%dT%H:%M:%SZ)" >"$DONE"
