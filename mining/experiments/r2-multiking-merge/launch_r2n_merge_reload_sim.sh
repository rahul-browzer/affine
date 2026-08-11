#!/usr/bin/env bash
# R2n: after R2g/R2i/R2j/R2k/R2l/R2m resolve below bar + Talent×asdf skew premerge
# ready (gated on chal-00451 Reason hr>0) → reload chall → fresh n80.
# If R2n premerge SKIP (Reason− / mismatch / timeout) → exit without chall kill.
# Does NOT touch teacher:8000 or king:8001. Kill chall by PID file only.
# Pre-registered: submit only if headroom ≥ 1.5×(3·SE).
set -euo pipefail
LOG=/root/logs/r2n_merge_reload.log
DONE=/root/logs/r2n_merge_reload.done
PIDF=/root/logs/r2n_merge_reload.pid
mkdir -p /root/logs /root/affine_data /root/r2_out
echo $$ >"$PIDF"
exec > >(tee -a "$LOG") 2>&1

echo "[r2n-merge] $(date -u +%Y-%m-%dT%H:%M:%SZ) start"
if [[ -f "$DONE" ]]; then
  echo "[r2n-merge] already done: $(cat "$DONE")"
  exit 0
fi

PREMERGE_DONE=${PREMERGE_DONE:-/root/logs/r2n_premerge.done}
PREMERGE_SKIP=${PREMERGE_SKIP:-/root/logs/r2n_premerge.skip}
R2D_DEC=${R2D_DEC:-/root/affine_data/r2d_awesome_decision.json}
R2E_DEC=${R2E_DEC:-/root/affine_data/r2e_alpha_decision.json}
R2G_DEC=${R2G_DEC:-/root/affine_data/r2g_alpha_decision.json}
R2G_DONE=${R2G_DONE:-/root/logs/r2g_merge_reload.done}
R2G_PREMERGE_SKIP=${R2G_PREMERGE_SKIP:-/root/logs/r2g_premerge.skip}
R2H_DEC=${R2H_DEC:-/root/affine_data/r2h_ttk_decision.json}
R2H_DONE=${R2H_DONE:-/root/logs/r2h_ttk_reload.done}
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
HEADROOM_BAR=${HEADROOM_BAR:-1.5}
MERGED=${MERGED:-/root/r2_out/alpha_talent_asdf_skew}
LINK=${LINK:-/tmp/r2n_alpha_merged}

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

# 1) Wait R2n CPU premerge outcome (done with weights, or skip).
for i in $(seq 1 2880); do
  if [[ -f "$PREMERGE_SKIP" ]]; then
    echo "SKIP_R2N_PREMERGE_SKIPPED $(cat "$PREMERGE_SKIP") $(date -u +%Y-%m-%dT%H:%M:%SZ)" | tee "$DONE"
    exit 0
  fi
  if [[ -f "$PREMERGE_DONE" && -f "$MERGED/model.safetensors.index.json" ]]; then
    echo "[r2n-merge] premerge ready at iter=$i $(date -u +%Y-%m-%dT%H:%M:%SZ) $(cat "$PREMERGE_DONE")"
    break
  fi
  if (( i % 12 == 0 )); then
    crumb=$(tail -n 3 /root/logs/r2n_premerge.log 2>/dev/null | tr '\r' '\n' | tail -1 || true)
    echo "[r2n-merge] wait-premerge iter=$i crumb=${crumb:-none}"
  fi
  if (( i == 2880 )); then
    echo "SKIP_R2N_PREMERGE_TIMEOUT $(date -u +%Y-%m-%dT%H:%M:%SZ)" | tee "$DONE"
    exit 0
  fi
  sleep 10
done

# 2) Wait R2g + R2i + R2j + R2k + R2l + R2m lanes free (or prior clears 1.5×). Pidfile kill -0 only.
for i in $(seq 1 2880); do
  for f in "$R2D_DEC" "$R2E_DEC" "$R2H_DEC" "$R2G_DEC" "$R2I_DEC" "$R2J_DEC" "$R2K_DEC" "$R2L_DEC" "$R2M_DEC"; do
    if [[ -f "$f" ]] && headroom_ok "$f"; then
      echo "SKIP_R2N_PRIOR_CLEARS file=$f $(date -u +%Y-%m-%dT%H:%M:%SZ)" | tee "$DONE"
      exit 0
    fi
  done
  if [[ -f "$PREMERGE_SKIP" ]]; then
    echo "SKIP_R2N_PREMERGE_SKIPPED $(cat "$PREMERGE_SKIP") $(date -u +%Y-%m-%dT%H:%M:%SZ)" | tee "$DONE"
    exit 0
  fi

  r2g_busy=0
  if pid_alive /root/logs/r2g_merge_reload.pid; then
    if [[ -f "$R2G_DONE" ]] || [[ -f "$R2G_PREMERGE_SKIP" ]]; then
      r2g_busy=0
    else
      r2g_busy=1
    fi
  elif [[ -f "$R2G_DONE" ]] || [[ -f "$R2G_PREMERGE_SKIP" ]] || [[ -f "$R2G_DEC" ]]; then
    r2g_busy=0
  else
    r2g_busy=1
  fi

  r2i_busy=0
  if [[ -f "$R2I_DONE" ]] || [[ -f "$R2I_PREMERGE_SKIP" ]] || [[ -f "$R2I_DEC" ]]; then
    r2i_busy=0
  elif pid_alive /root/logs/r2i_merge_reload.pid || pid_alive /root/logs/r2i_premerge.pid; then
    r2i_busy=1
  else
    r2i_busy=1
  fi

  r2j_busy=0
  if [[ -f "$R2J_DONE" ]] || [[ -f "$R2J_PREMERGE_SKIP" ]] || [[ -f "$R2J_DEC" ]]; then
    r2j_busy=0
  elif pid_alive /root/logs/r2j_merge_reload.pid || pid_alive /root/logs/r2j_premerge.pid; then
    r2j_busy=1
  else
    r2j_busy=1
  fi

  r2k_busy=0
  if [[ -f "$R2K_DONE" ]] || [[ -f "$R2K_PREMERGE_SKIP" ]] || [[ -f "$R2K_DEC" ]]; then
    r2k_busy=0
  elif pid_alive /root/logs/r2k_merge_reload.pid || pid_alive /root/logs/r2k_premerge.pid; then
    r2k_busy=1
  else
    r2k_busy=1
  fi

  r2l_busy=0
  if [[ -f "$R2L_DONE" ]] || [[ -f "$R2L_PREMERGE_SKIP" ]] || [[ -f "$R2L_DEC" ]]; then
    r2l_busy=0
  elif pid_alive /root/logs/r2l_merge_reload.pid || pid_alive /root/logs/r2l_premerge.pid; then
    r2l_busy=1
  else
    r2l_busy=1
  fi

  # R2m only blocks when premerge.done exists (ready to claim GPU) and not terminal.
  # merge_reload.pid alone is NOT enough — that waiter idles on chal-00456 Reason for hours
  # (same p1933 R2q lesson; p1958: pid-alive + no premerge.done still starved R2n).
  R2M_PREMERGE_DONE=${R2M_PREMERGE_DONE:-/root/logs/r2m_premerge.done}
  r2m_busy=0
  if [[ -f "$R2M_DONE" ]] || [[ -f "$R2M_PREMERGE_SKIP" ]] || [[ -f "$R2M_DEC" ]]; then
    r2m_busy=0
  elif [[ -f "$R2M_PREMERGE_DONE" ]]; then
    r2m_busy=1
  else
    r2m_busy=0
  fi

  if (( r2g_busy == 0 && r2i_busy == 0 && r2j_busy == 0 && r2k_busy == 0 && r2l_busy == 0 && r2m_busy == 0 )); then
    echo "[r2n-merge] R2g/R2i/R2j/R2k/R2l/R2m below bar or skipped; lane free at iter=$i"
    break
  fi
  if (( i % 12 == 0 )); then
    echo "[r2n-merge] wait-lane iter=$i $(date -u +%Y-%m-%dT%H:%M:%SZ) r2g_busy=$r2g_busy r2i_busy=$r2i_busy r2j_busy=$r2j_busy r2k_busy=$r2k_busy r2l_busy=$r2l_busy r2m_busy=$r2m_busy r2g_dec=$([[ -f $R2G_DEC ]] && echo y || echo n) r2m_pre=$([[ -f $R2M_PREMERGE_DONE ]] && echo y || echo n) r2m_done=$([[ -f $R2M_DONE ]] && echo y || echo n)"
  fi
  if (( i == 2880 )); then
    echo "[r2n-merge] TIMEOUT waiting R2g/R2i/R2j/R2k/R2l/R2m lane" >&2
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
  echo "[r2n-merge] FATAL missing merged index at $MERGED" >&2
  exit 2
fi

ln -sfn "$MERGED" "$LINK"
echo "[r2n-merge] link $LINK -> $(readlink -f "$LINK")"

# Wait if R2q pure-saysth currently owns chall (do not yank mid-n80).
_WAIT_R2Q_TAG=r2n-merge
# shellcheck disable=SC1091
source /root/mining_src/r2-multiking-merge/wait_r2q_before_chall_kill.inc.sh

CHALL_PID_FILE=/root/logs/vllm_chall.pid
if [[ -f "$CHALL_PID_FILE" ]]; then
  CPID=$(cat "$CHALL_PID_FILE" || true)
  if [[ -n "${CPID:-}" ]] && kill -0 "$CPID" 2>/dev/null; then
    echo "[r2n-merge] stopping chall pid=$CPID"
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
    echo "[r2n-merge] seeding chall Triton cache from king"
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

echo "[r2n-merge] launching chall :8002 on $LINK"
CUDA_VISIBLE_DEVICES=4,5 TRITON_CACHE_DIR=/root/.triton/cache/chall \
  nohup /root/venv/bin/vllm serve "$LINK" \
    --port 8002 --gpu-memory-utilization 0.72 \
    "${COMMON[@]}" \
    >/root/logs/vllm_chall.log 2>&1 &
echo $! >/root/logs/vllm_chall.pid
echo "[r2n-merge] chall pid=$(cat /root/logs/vllm_chall.pid)"

for i in $(seq 1 480); do
  c0=$(curl -s -o /dev/null -w "%{http_code}" --max-time 3 http://127.0.0.1:8000/v1/models || true)
  c1=$(curl -s -o /dev/null -w "%{http_code}" --max-time 3 http://127.0.0.1:8001/v1/models || true)
  c2=$(curl -s -o /dev/null -w "%{http_code}" --max-time 3 http://127.0.0.1:8002/v1/models || true)
  if [[ "$c0$c1$c2" == "200200200" ]]; then
    echo "[r2n-merge] engines 200/200/200 at iter=$i"
    break
  fi
  if (( i % 12 == 0 )); then
    echo "[r2n-merge] wait-engines iter=$i codes=${c0}/${c1}/${c2}"
  fi
  if (( i == 480 )); then
    echo "[r2n-merge] TIMEOUT engines; see vllm_chall.log" >&2
    exit 2
  fi
  sleep 5
done

OUT=/root/affine_data/r2n_alpha_reason_sim.json
DEC=/root/affine_data/r2n_alpha_decision.json
PROG=/root/affine_data/r2n_alpha_reason_progress.json
rm -f "$OUT" "$DEC" "$PROG"
BH=$(python - <<'PY'
import hashlib, time
print(hashlib.sha256(f"r2n-talent-asdf-{time.time_ns()}".encode()).hexdigest())
PY
)

echo "[r2n-merge] launching R2n n80 block_hash=${BH:0:16}…"
python /root/mining_src/r1-reason-distill/run_reason_sim.py \
  --n-turns 80 \
  --block-hash "$BH" \
  --hotkey "local-r2n-talent-asdf-$(date -u +%Y%m%dT%H%M%SZ)" \
  --king-repo Tok331102/affine-5EqYW8McUc-af10 \
  --king-rev eb8bf9a356a254f71faaa439e8abc3cfba572c53 \
  --chall-repo "$LINK" \
  --out "$OUT" \
  --progress-out "$PROG" \
  --save-artifact \
  2>&1 | tee /root/logs/r2n_alpha_reason_sim.log

python /root/mining_src/r1-reason-distill/write_reason_decision.py \
  --sim-result "$OUT" --out "$DEC" --hyp R2n \
  2>&1 | tee -a /root/logs/r2n_alpha_reason_sim.log

echo "[r2n-merge] DONE $(date -u +%Y-%m-%dT%H:%M:%SZ)"
cat "$DEC"
echo "OK $(date -u +%Y-%m-%dT%H:%M:%SZ)" >"$DONE"
