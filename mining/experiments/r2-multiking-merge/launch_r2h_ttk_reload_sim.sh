#!/usr/bin/env bash
# R2h: Tok×Talent×kevin equal-α (Δ=0.277, premerged @ /root/r2_out/alpha_tok_talent_kevin)
# was never n80'd — p1893 stubbed r2_alpha_decision for Tok×awesome weak-Δ, not TTK.
# After R2e below-bar + (R2g done/skip OR R2g still waiting Reason stamp), reload
# chall → fresh n80. Does NOT touch teacher:8000 or king:8001.
# Kill chall by PID file only. Submit only if headroom ≥ 1.5×(3·SE).
set -euo pipefail
LOG=/root/logs/r2h_ttk_reload.log
DONE=/root/logs/r2h_ttk_reload.done
PIDF=/root/logs/r2h_ttk_reload.pid
mkdir -p /root/logs /root/affine_data /root/r2_out
echo $$ >"$PIDF"
exec > >(tee -a "$LOG") 2>&1

echo "[r2h-ttk] $(date -u +%Y-%m-%dT%H:%M:%SZ) start"
if [[ -f "$DONE" ]]; then
  echo "[r2h-ttk] already done: $(cat "$DONE")"
  exit 0
fi

R2E_DEC=${R2E_DEC:-/root/affine_data/r2e_alpha_decision.json}
R2E_DONE=${R2E_DONE:-/root/logs/r2e_merge_reload.done}
R2G_DEC=${R2G_DEC:-/root/affine_data/r2g_alpha_decision.json}
R2G_DONE=${R2G_DONE:-/root/logs/r2g_merge_reload.done}
R2G_PREMERGE_DONE=${R2G_PREMERGE_DONE:-/root/logs/r2g_premerge.done}
R2G_PREMERGE_SKIP=${R2G_PREMERGE_SKIP:-/root/logs/r2g_premerge.skip}
HEADROOM_BAR=${HEADROOM_BAR:-1.5}
MERGED=${MERGED:-/root/r2_out/alpha_tok_talent_kevin}
LINK=${LINK:-/tmp/r2h_ttk_merged}

if [[ ! -f "$MERGED/model.safetensors.index.json" ]]; then
  echo "[r2h-ttk] FATAL missing TTK merge at $MERGED" >&2
  exit 2
fi

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

# 1) Wait R2e below bar + lane free (pidfile kill -0 only).
for i in $(seq 1 2880); do
  if [[ -f "$R2E_DEC" ]] && headroom_ok "$R2E_DEC"; then
    echo "SKIP_R2H_R2E_CLEARS $(date -u +%Y-%m-%dT%H:%M:%SZ)" | tee "$DONE"
    exit 0
  fi
  if [[ -f "$R2G_DEC" ]] && headroom_ok "$R2G_DEC"; then
    echo "SKIP_R2H_R2G_CLEARS $(date -u +%Y-%m-%dT%H:%M:%SZ)" | tee "$DONE"
    exit 0
  fi
  if [[ -f "$R2E_DEC" ]] && ! pid_alive /root/logs/r2e_merge_reload.pid; then
    echo "[r2h-ttk] R2e below bar; lane free at iter=$i"
    break
  fi
  if (( i % 12 == 0 )); then
    echo "[r2h-ttk] wait-r2e iter=$i $(date -u +%Y-%m-%dT%H:%M:%SZ) r2e_dec=$([[ -f $R2E_DEC ]] && echo y || echo n) r2e_pid=$(pid_alive /root/logs/r2e_merge_reload.pid && echo y || echo n)"
  fi
  if (( i == 2880 )); then
    echo "[r2h-ttk] TIMEOUT waiting R2e" >&2
    exit 2
  fi
  sleep 10
done

# 2) Serialize vs R2g GPU claim:
#    - R2g done/skip → proceed (check decision)
#    - R2g premerge still waiting Reason (no done/skip) → proceed now (avoid idle GPU)
#    - R2g premerge ready / reload past chall kill → wait for r2g_merge_reload.done
for i in $(seq 1 2880); do
  if [[ -f "$R2E_DEC" ]] && headroom_ok "$R2E_DEC"; then
    echo "SKIP_R2H_R2E_CLEARS $(date -u +%Y-%m-%dT%H:%M:%SZ)" | tee "$DONE"
    exit 0
  fi
  if [[ -f "$R2G_DEC" ]] && headroom_ok "$R2G_DEC"; then
    echo "SKIP_R2H_R2G_CLEARS $(date -u +%Y-%m-%dT%H:%M:%SZ)" | tee "$DONE"
    exit 0
  fi
  if [[ -f "$R2G_DONE" ]]; then
    echo "[r2h-ttk] R2g finished: $(cat "$R2G_DONE")"
    if [[ -f "$R2G_DEC" ]] && headroom_ok "$R2G_DEC"; then
      echo "SKIP_R2H_R2G_CLEARS $(date -u +%Y-%m-%dT%H:%M:%SZ)" | tee "$DONE"
      exit 0
    fi
    break
  fi
  if [[ -f "$R2G_PREMERGE_SKIP" ]]; then
    echo "[r2h-ttk] R2g premerge skipped — taking lane: $(cat "$R2G_PREMERGE_SKIP")"
    break
  fi
  # Still waiting on chal-00440 Reason → R2g has not claimed chall yet.
  if [[ ! -f "$R2G_PREMERGE_DONE" ]] && [[ ! -f "$R2G_PREMERGE_SKIP" ]]; then
    echo "[r2h-ttk] R2g still waiting Reason stamp — taking GPU lane at iter=$i"
    break
  fi
  # Premerge ready: R2g reload owns next chall kill; wait it out.
  if (( i % 12 == 0 )); then
    echo "[r2h-ttk] wait-r2g-gpu iter=$i premerge_done=y r2g_done=n"
  fi
  if (( i == 2880 )); then
    echo "[r2h-ttk] TIMEOUT waiting R2g GPU phase" >&2
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

ln -sfn "$MERGED" "$LINK"
echo "[r2h-ttk] link $LINK -> $(readlink -f "$LINK")"

CHALL_PID_FILE=/root/logs/vllm_chall.pid
if [[ -f "$CHALL_PID_FILE" ]]; then
  CPID=$(cat "$CHALL_PID_FILE" || true)
  if [[ -n "${CPID:-}" ]] && kill -0 "$CPID" 2>/dev/null; then
    echo "[r2h-ttk] stopping chall pid=$CPID"
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
    echo "[r2h-ttk] seeding chall Triton cache from king"
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

echo "[r2h-ttk] launching chall :8002 on $LINK"
CUDA_VISIBLE_DEVICES=4,5 TRITON_CACHE_DIR=/root/.triton/cache/chall \
  nohup /root/venv/bin/vllm serve "$LINK" \
    --port 8002 --gpu-memory-utilization 0.72 \
    "${COMMON[@]}" \
    >/root/logs/vllm_chall.log 2>&1 &
echo $! >/root/logs/vllm_chall.pid
echo "[r2h-ttk] chall pid=$(cat /root/logs/vllm_chall.pid)"

for i in $(seq 1 480); do
  c0=$(curl -s -o /dev/null -w "%{http_code}" --max-time 3 http://127.0.0.1:8000/v1/models || true)
  c1=$(curl -s -o /dev/null -w "%{http_code}" --max-time 3 http://127.0.0.1:8001/v1/models || true)
  c2=$(curl -s -o /dev/null -w "%{http_code}" --max-time 3 http://127.0.0.1:8002/v1/models || true)
  if [[ "$c0$c1$c2" == "200200200" ]]; then
    echo "[r2h-ttk] engines 200/200/200 at iter=$i"
    break
  fi
  if (( i % 12 == 0 )); then
    echo "[r2h-ttk] wait-engines iter=$i codes=${c0}/${c1}/${c2}"
  fi
  if (( i == 480 )); then
    echo "[r2h-ttk] TIMEOUT engines; see vllm_chall.log" >&2
    exit 2
  fi
  sleep 5
done

OUT=/root/affine_data/r2h_ttk_reason_sim.json
DEC=/root/affine_data/r2h_ttk_decision.json
PROG=/root/affine_data/r2h_ttk_reason_progress.json
rm -f "$OUT" "$DEC" "$PROG"
BH=$(python - <<'PY'
import hashlib, time
print(hashlib.sha256(f"r2h-tok-talent-kevin-{time.time_ns()}".encode()).hexdigest())
PY
)

echo "[r2h-ttk] launching n80 block_hash=${BH:0:16}…"
python /root/mining_src/r1-reason-distill/run_reason_sim.py \
  --n-turns 80 \
  --block-hash "$BH" \
  --hotkey "local-r2h-ttk-$(date -u +%Y%m%dT%H%M%SZ)" \
  --king-repo Tok331102/affine-5EqYW8McUc-af10 \
  --king-rev eb8bf9a356a254f71faaa439e8abc3cfba572c53 \
  --chall-repo "$LINK" \
  --out "$OUT" \
  --progress-out "$PROG" \
  --save-artifact \
  2>&1 | tee /root/logs/r2h_ttk_reason_sim.log

python /root/mining_src/r1-reason-distill/write_reason_decision.py \
  --sim-result "$OUT" --out "$DEC" --hyp R2h \
  2>&1 | tee -a /root/logs/r2h_ttk_reason_sim.log

echo "[r2h-ttk] DONE $(date -u +%Y-%m-%dT%H:%M:%SZ)"
cat "$DEC"
echo "OK $(date -u +%Y-%m-%dT%H:%M:%SZ)" >"$DONE"
