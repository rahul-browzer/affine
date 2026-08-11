#!/usr/bin/env bash
# R2an: after R2ac/R2ad/R2am resolve below bar + Talent×cp13 skew
# premerge ready (gated on chal-00481 Reason hr>0) → reload chall → fresh n80.
# If R2an premerge SKIP (Reason− / mismatch / timeout) → exit without chall kill.
# Does NOT touch teacher:8000 or king:8001. Kill chall by PID file only.
# Pre-registered: submit only if headroom ≥ 1.5×(3·SE).
set -euo pipefail
LOG=/root/logs/r2an_merge_reload.log
DONE=/root/logs/r2an_merge_reload.done
PIDF=/root/logs/r2an_merge_reload.pid
mkdir -p /root/logs /root/affine_data /root/r2_out
echo $$ >"$PIDF"
exec > >(tee -a "$LOG") 2>&1

echo "[r2an-merge] $(date -u +%Y-%m-%dT%H:%M:%SZ) start"
if [[ -f "$DONE" ]]; then
  echo "[r2an-merge] already done: $(cat "$DONE")"
  exit 0
fi

PREMERGE_DONE=${PREMERGE_DONE:-/root/logs/r2an_premerge.done}
PREMERGE_SKIP=${PREMERGE_SKIP:-/root/logs/r2an_premerge.skip}
R2AC_DEC=${R2AC_DEC:-/root/affine_data/r2ac_alpha_decision.json}
R2AC_DONE=${R2AC_DONE:-/root/logs/r2ac_merge_reload.done}
R2AC_PREMERGE_SKIP=${R2AC_PREMERGE_SKIP:-/root/logs/r2ac_premerge.skip}
R2AD_DEC=${R2AD_DEC:-/root/affine_data/r2ad_alpha_decision.json}
R2AD_DONE=${R2AD_DONE:-/root/logs/r2ad_merge_reload.done}
R2AD_PREMERGE_SKIP=${R2AD_PREMERGE_SKIP:-/root/logs/r2ad_premerge.skip}
R2AM_DEC=${R2AM_DEC:-/root/affine_data/r2am_alpha_decision.json}
R2AM_DONE=${R2AM_DONE:-/root/logs/r2am_merge_reload.done}
R2AM_PREMERGE_SKIP=${R2AM_PREMERGE_SKIP:-/root/logs/r2am_premerge.skip}
HEADROOM_BAR=${HEADROOM_BAR:-1.5}
MERGED=${MERGED:-/root/r2_out/alpha_talent_cp13_skew}
LINK=${LINK:-/tmp/r2an_alpha_merged}
HOLDING=${HOLDING:-/root/logs/r2an_talent_cp13_holding.stamp}

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

# 1) Wait R2an CPU premerge outcome (done with weights, or skip).
for i in $(seq 1 2880); do
  if [[ -f "$PREMERGE_SKIP" ]]; then
    echo "SKIP_R2AN_PREMERGE_SKIPPED $(cat "$PREMERGE_SKIP") $(date -u +%Y-%m-%dT%H:%M:%SZ)" | tee "$DONE"
    exit 0
  fi
  if [[ -f "$PREMERGE_DONE" && -f "$MERGED/model.safetensors.index.json" ]]; then
    echo "[r2an-merge] premerge ready at iter=$i $(date -u +%Y-%m-%dT%H:%M:%SZ) $(cat "$PREMERGE_DONE")"
    break
  fi
  if (( i % 12 == 0 )); then
    crumb=$(tail -n 3 /root/logs/r2an_premerge.log 2>/dev/null | tr '\r' '\n' | tail -1 || true)
    echo "[r2an-merge] wait-premerge iter=$i crumb=${crumb:-none}"
  fi
  if (( i == 2880 )); then
    echo "SKIP_R2AN_PREMERGE_TIMEOUT $(date -u +%Y-%m-%dT%H:%M:%SZ)" | tee "$DONE"
    exit 0
  fi
  sleep 10
done

# 2) Wait R2ac/R2ad/R2am terminal (or any prior clears 1.5×).
for i in $(seq 1 2880); do
  for f in "$R2AC_DEC" "$R2AD_DEC" "$R2AM_DEC"; do
    if [[ -f "$f" ]] && headroom_ok "$f"; then
      echo "SKIP_R2AN_PRIOR_CLEARS file=$f $(date -u +%Y-%m-%dT%H:%M:%SZ)" | tee "$DONE"
      exit 0
    fi
  done
  if [[ -f "$PREMERGE_SKIP" ]]; then
    echo "SKIP_R2AN_PREMERGE_SKIPPED $(cat "$PREMERGE_SKIP") $(date -u +%Y-%m-%dT%H:%M:%SZ)" | tee "$DONE"
    exit 0
  fi

  busy=0
  if [[ -f /root/logs/r2ac_premerge.done ]] && ! lane_terminal "$R2AC_DONE" "$R2AC_PREMERGE_SKIP" "$R2AC_DEC"; then busy=1; fi
  if [[ -f /root/logs/r2ad_premerge.done ]] && ! lane_terminal "$R2AD_DONE" "$R2AD_PREMERGE_SKIP" "$R2AD_DEC"; then busy=1; fi
  if [[ -f /root/logs/r2am_premerge.done ]] && ! lane_terminal "$R2AM_DONE" "$R2AM_PREMERGE_SKIP" "$R2AM_DEC"; then busy=1; fi

  for pf in /root/logs/r2ac_merge_reload.pid /root/logs/r2ad_merge_reload.pid /root/logs/r2am_merge_reload.pid; do
    if pid_alive "$pf"; then
      case "$pf" in
        *r2ac*) lane_terminal "$R2AC_DONE" "$R2AC_PREMERGE_SKIP" "$R2AC_DEC" || busy=1 ;;
        *r2ad*) lane_terminal "$R2AD_DONE" "$R2AD_PREMERGE_SKIP" "$R2AD_DEC" || busy=1 ;;
        *r2am*) lane_terminal "$R2AM_DONE" "$R2AM_PREMERGE_SKIP" "$R2AM_DEC" || busy=1 ;;
      esac
    fi
  done

  if (( busy == 0 )); then
    echo "[r2an-merge] R2ac/R2ad/R2am below bar or skipped; lane free at iter=$i"
    break
  fi
  if (( i % 12 == 0 )); then
    echo "[r2an-merge] wait-lane iter=$i $(date -u +%Y-%m-%dT%H:%M:%SZ) busy=$busy r2ac_term=$(lane_terminal "$R2AC_DONE" "$R2AC_PREMERGE_SKIP" "$R2AC_DEC" && echo y || echo n) r2ad_term=$(lane_terminal "$R2AD_DONE" "$R2AD_PREMERGE_SKIP" "$R2AD_DEC" && echo y || echo n) r2am_term=$(lane_terminal "$R2AM_DONE" "$R2AM_PREMERGE_SKIP" "$R2AM_DEC" && echo y || echo n)"
  fi
  if (( i == 2880 )); then
    echo "[r2an-merge] TIMEOUT waiting R2ac/R2ad/R2am lane" >&2
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
  echo "[r2an-merge] FATAL missing merged index at $MERGED" >&2
  exit 2
fi

ln -sfn "$MERGED" "$LINK"
echo "[r2an-merge] link $LINK -> $(readlink -f "$LINK")"

# Wait if a sibling currently owns chall (do not yank mid-n80).
rm -f "$HOLDING"
_WAIT_R2Q_TAG=r2an-merge
# shellcheck disable=SC1091
source /root/mining_src/r2-multiking-merge/wait_r2q_before_chall_kill.inc.sh

# Claim chall before kill so siblings honor holding stamp.
date -u +%Y-%m-%dT%H:%M:%SZ >"$HOLDING"

CHALL_PID_FILE=/root/logs/vllm_chall.pid
if [[ -f "$CHALL_PID_FILE" ]]; then
  CPID=$(cat "$CHALL_PID_FILE" || true)
  if [[ -n "${CPID:-}" ]] && kill -0 "$CPID" 2>/dev/null; then
    echo "[r2an-merge] stopping chall pid=$CPID"
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
    echo "[r2an-merge] seeding chall Triton cache from king"
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

echo "[r2an-merge] launching chall :8002 on $LINK"
CUDA_VISIBLE_DEVICES=4,5 TRITON_CACHE_DIR=/root/.triton/cache/chall \
  nohup /root/venv/bin/vllm serve "$LINK" \
    --port 8002 --gpu-memory-utilization 0.72 \
    "${COMMON[@]}" \
    >/root/logs/vllm_chall.log 2>&1 &
echo $! >/root/logs/vllm_chall.pid
echo "[r2an-merge] chall pid=$(cat /root/logs/vllm_chall.pid)"

for i in $(seq 1 480); do
  c0=$(curl -s -o /dev/null -w "%{http_code}" --max-time 3 http://127.0.0.1:8000/v1/models || true)
  c1=$(curl -s -o /dev/null -w "%{http_code}" --max-time 3 http://127.0.0.1:8001/v1/models || true)
  c2=$(curl -s -o /dev/null -w "%{http_code}" --max-time 3 http://127.0.0.1:8002/v1/models || true)
  if [[ "$c0$c1$c2" == "200200200" ]]; then
    echo "[r2an-merge] engines 200/200/200 at iter=$i"
    break
  fi
  if (( i % 12 == 0 )); then
    echo "[r2an-merge] wait-engines iter=$i codes=${c0}/${c1}/${c2}"
  fi
  if (( i == 480 )); then
    echo "[r2an-merge] TIMEOUT engines; see vllm_chall.log" >&2
    rm -f "$HOLDING"
    exit 2
  fi
  sleep 5
done

OUT=/root/affine_data/r2an_alpha_reason_sim.json
DEC=/root/affine_data/r2an_alpha_decision.json
PROG=/root/affine_data/r2an_alpha_reason_progress.json
rm -f "$OUT" "$DEC" "$PROG"
BH=$(python - <<'PY'
import hashlib, time
print(hashlib.sha256(f"r2an-talent-cp13-{time.time_ns()}".encode()).hexdigest())
PY
)

echo "[r2an-merge] launching R2an n80 block_hash=${BH:0:16}…"
python /root/mining_src/r1-reason-distill/run_reason_sim.py \
  --n-turns 80 \
  --block-hash "$BH" \
  --hotkey "local-r2an-talent-cp13-$(date -u +%Y%m%dT%H%M%SZ)" \
  --king-repo Tok331102/affine-5EqYW8McUc-af10 \
  --king-rev eb8bf9a356a254f71faaa439e8abc3cfba572c53 \
  --chall-repo "$LINK" \
  --out "$OUT" \
  --progress-out "$PROG" \
  --save-artifact \
  2>&1 | tee /root/logs/r2an_alpha_reason_sim.log

python /root/mining_src/r1-reason-distill/write_reason_decision.py \
  --sim-result "$OUT" --out "$DEC" --hyp R2an \
  2>&1 | tee -a /root/logs/r2an_alpha_reason_sim.log

rm -f "$HOLDING"
echo "[r2an-merge] DONE $(date -u +%Y-%m-%dT%H:%M:%SZ)"
cat "$DEC"
echo "OK $(date -u +%Y-%m-%dT%H:%M:%SZ)" >"$DONE"
