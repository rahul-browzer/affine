#!/usr/bin/env bash
# R2u: after R2t resolves below bar + saysth×kevin skew premerge ready →
# reload chall → fresh n80. Priority over R2r (whoami queue): R2r yields
# when r2u_premerge.done exists. Does NOT touch teacher:8000 or king:8001.
# Kill chall by PID file only. Submit only if headroom ≥ 1.5×(3·SE).
# WEAK_SKIP (no chall kill) if max_abs_delta ≪ 0.01.
set -euo pipefail
LOG=/root/logs/r2u_merge_reload.log
DONE=/root/logs/r2u_merge_reload.done
PIDF=/root/logs/r2u_merge_reload.pid
mkdir -p /root/logs /root/affine_data /root/r2_out
echo $$ >"$PIDF"
exec > >(tee -a "$LOG") 2>&1

echo "[r2u-merge] $(date -u +%Y-%m-%dT%H:%M:%SZ) start"
if [[ -f "$DONE" ]]; then
  echo "[r2u-merge] already done: $(cat "$DONE")"
  exit 0
fi

PREMERGE_DONE=${PREMERGE_DONE:-/root/logs/r2u_premerge.done}
PREMERGE_SKIP=${PREMERGE_SKIP:-/root/logs/r2u_premerge.skip}
R2D_DEC=${R2D_DEC:-/root/affine_data/r2d_awesome_decision.json}
R2E_DEC=${R2E_DEC:-/root/affine_data/r2e_alpha_decision.json}
R2G_DEC=${R2G_DEC:-/root/affine_data/r2g_alpha_decision.json}
R2H_DEC=${R2H_DEC:-/root/affine_data/r2h_ttk_decision.json}
R2Q_DEC=${R2Q_DEC:-/root/affine_data/r2q_saysth_decision.json}
R2Q_DONE=${R2Q_DONE:-/root/logs/r2q_saysth_reload.done}
R2R_DEC=${R2R_DEC:-/root/affine_data/r2r_alpha_decision.json}
R2S_DEC=${R2S_DEC:-/root/affine_data/r2s_alpha_decision.json}
R2T_DEC=${R2T_DEC:-/root/affine_data/r2t_alpha_decision.json}
R2T_DONE=${R2T_DONE:-/root/logs/r2t_merge_reload.done}
HEADROOM_BAR=${HEADROOM_BAR:-1.5}
WEAK_DELTA_MAX=${WEAK_DELTA_MAX:-0.01}
MERGED=${MERGED:-/root/r2_out/alpha_saysth_kevin_skew}
LINK=${LINK:-/tmp/r2u_alpha_merged}

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

# 1) Wait R2u CPU premerge outcome.
for i in $(seq 1 2880); do
  if [[ -f "$PREMERGE_SKIP" ]]; then
    echo "SKIP_R2U_PREMERGE_SKIPPED $(cat "$PREMERGE_SKIP") $(date -u +%Y-%m-%dT%H:%M:%SZ)" | tee "$DONE"
    exit 0
  fi
  if [[ -f "$PREMERGE_DONE" && -f "$MERGED/model.safetensors.index.json" ]]; then
    echo "[r2u-merge] premerge ready at iter=$i $(date -u +%Y-%m-%dT%H:%M:%SZ) $(cat "$PREMERGE_DONE")"
    break
  fi
  if (( i % 12 == 0 )); then
    crumb=$(tail -n 3 /root/logs/r2u_premerge.log 2>/dev/null | tr '\r' '\n' | tail -1 || true)
    echo "[r2u-merge] wait-premerge iter=$i crumb=${crumb:-none}"
  fi
  if (( i == 2880 )); then
    echo "SKIP_R2U_PREMERGE_TIMEOUT $(date -u +%Y-%m-%dT%H:%M:%SZ)" | tee "$DONE"
    exit 0
  fi
  sleep 10
done

# WEAK_SKIP near-identical blends before burning GPU / racing R2r.
DELTA_LINE=$(python - <<PY
import json
from pathlib import Path
meta=Path("$MERGED/merge_alpha_meta.json")
if not meta.is_file():
    print("missing_meta"); raise SystemExit(0)
d=json.loads(meta.read_text())
delta=float(d.get("max_abs_delta") or 0.0)
ident=d.get("identical_frac")
weak = delta < float("$WEAK_DELTA_MAX")
print(f"max_abs_delta={delta} identical_frac={ident} weak={weak}")
Path("/tmp/r2u_weak").write_text("1\n" if weak else "0\n")
PY
)
echo "[r2u-merge] delta-gate: $DELTA_LINE"
if [[ "$(cat /tmp/r2u_weak)" == "1" ]]; then
  DEC=/root/affine_data/r2u_alpha_decision.json
  python - <<PY
import json
from datetime import datetime, timezone
from pathlib import Path
meta=json.loads(Path("$MERGED/merge_alpha_meta.json").read_text())
dec={
  "utc": datetime.now(timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ"),
  "hyp": "R2u",
  "contract": "Reason v3",
  "decision": "WEAK_SKIP",
  "headroom_bar": float("$HEADROOM_BAR"),
  "max_abs_delta": meta.get("max_abs_delta"),
  "identical_frac": meta.get("identical_frac"),
  "n_keys": meta.get("n_keys"),
  "note": "saysth×kevin near-identical (Δ≪0.01); no n80",
  "challenger_wins": False,
  "headroom_vs_3se": None,
}
Path("$DEC").write_text(json.dumps(dec, indent=2) + "\n")
print(json.dumps(dec, indent=2))
PY
  echo "WEAK_SKIP $DELTA_LINE $(date -u +%Y-%m-%dT%H:%M:%SZ)" | tee "$DONE"
  exit 0
fi

# 2) Wait R2t terminal (or prior clears 1.5×). R2u has priority over R2r.
for i in $(seq 1 2880); do
  for f in "$R2D_DEC" "$R2E_DEC" "$R2H_DEC" "$R2G_DEC" "$R2Q_DEC" "$R2S_DEC" "$R2T_DEC" "$R2R_DEC"; do
    if [[ -f "$f" ]] && headroom_ok "$f"; then
      echo "SKIP_R2U_PRIOR_CLEARS file=$f $(date -u +%Y-%m-%dT%H:%M:%SZ)" | tee "$DONE"
      exit 0
    fi
  done
  if [[ -f "$PREMERGE_SKIP" ]]; then
    echo "SKIP_R2U_PREMERGE_SKIPPED $(cat "$PREMERGE_SKIP") $(date -u +%Y-%m-%dT%H:%M:%SZ)" | tee "$DONE"
    exit 0
  fi

  busy=0
  if [[ ! -f "$R2T_DONE" && ! -f "$R2T_DEC" ]]; then busy=1; fi
  if pid_alive /root/logs/r2t_merge_reload.pid; then
    [[ -f "$R2T_DONE" || -f "$R2T_DEC" ]] || busy=1
  fi

  if (( busy == 0 )); then
    echo "[r2u-merge] R2t terminal; lane free at iter=$i"
    break
  fi
  if (( i % 12 == 0 )); then
    echo "[r2u-merge] wait-lane iter=$i $(date -u +%Y-%m-%dT%H:%M:%SZ) busy=$busy r2t_term=$([[ -f $R2T_DONE || -f $R2T_DEC ]] && echo y || echo n)"
  fi
  if (( i == 2880 )); then
    echo "[r2u-merge] TIMEOUT waiting R2t lane" >&2
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
  echo "[r2u-merge] FATAL missing merged index at $MERGED" >&2
  exit 2
fi

ln -sfn "$MERGED" "$LINK"
echo "[r2u-merge] link $LINK -> $(readlink -f "$LINK")"

CHALL_PID_FILE=/root/logs/vllm_chall.pid
if [[ -f "$CHALL_PID_FILE" ]]; then
  CPID=$(cat "$CHALL_PID_FILE" || true)
  if [[ -n "${CPID:-}" ]] && kill -0 "$CPID" 2>/dev/null; then
    echo "[r2u-merge] stopping chall pid=$CPID"
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
    echo "[r2u-merge] seeding chall Triton cache from king"
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

echo "[r2u-merge] launching chall :8002 on $LINK"
CUDA_VISIBLE_DEVICES=4,5 TRITON_CACHE_DIR=/root/.triton/cache/chall \
  nohup /root/venv/bin/vllm serve "$LINK" \
    --port 8002 --gpu-memory-utilization 0.72 \
    "${COMMON[@]}" \
    >/root/logs/vllm_chall.log 2>&1 &
echo $! >/root/logs/vllm_chall.pid
echo "[r2u-merge] chall pid=$(cat /root/logs/vllm_chall.pid)"

for i in $(seq 1 480); do
  c0=$(curl -s -o /dev/null -w "%{http_code}" --max-time 3 http://127.0.0.1:8000/v1/models || true)
  c1=$(curl -s -o /dev/null -w "%{http_code}" --max-time 3 http://127.0.0.1:8001/v1/models || true)
  c2=$(curl -s -o /dev/null -w "%{http_code}" --max-time 3 http://127.0.0.1:8002/v1/models || true)
  if [[ "$c0$c1$c2" == "200200200" ]]; then
    echo "[r2u-merge] engines 200/200/200 at iter=$i"
    break
  fi
  if (( i % 12 == 0 )); then
    echo "[r2u-merge] wait-engines iter=$i codes=${c0}/${c1}/${c2}"
  fi
  if (( i == 480 )); then
    echo "[r2u-merge] TIMEOUT engines; see vllm_chall.log" >&2
    exit 2
  fi
  sleep 5
done

OUT=/root/affine_data/r2u_alpha_reason_sim.json
DEC=/root/affine_data/r2u_alpha_decision.json
PROG=/root/affine_data/r2u_alpha_reason_progress.json
rm -f "$OUT" "$DEC" "$PROG"
BH=$(python - <<'PY'
import hashlib, time
print(hashlib.sha256(f"r2u-saysth-kevin-{time.time_ns()}".encode()).hexdigest())
PY
)

echo "[r2u-merge] launching R2u n80 block_hash=${BH:0:16}…"
python /root/mining_src/r1-reason-distill/run_reason_sim.py \
  --n-turns 80 \
  --block-hash "$BH" \
  --hotkey "local-r2u-saysth-kevin-$(date -u +%Y%m%dT%H:%M:%SZ)" \
  --king-repo Tok331102/affine-5EqYW8McUc-af10 \
  --king-rev eb8bf9a356a254f71faaa439e8abc3cfba572c53 \
  --chall-repo "$LINK" \
  --out "$OUT" \
  --progress-out "$PROG" \
  --save-artifact \
  2>&1 | tee /root/logs/r2u_alpha_reason_sim.log

python /root/mining_src/r1-reason-distill/write_reason_decision.py \
  --sim-result "$OUT" --out "$DEC" --hyp R2u \
  2>&1 | tee -a /root/logs/r2u_alpha_reason_sim.log

echo "[r2u-merge] DONE $(date -u +%Y-%m-%dT%H:%M:%SZ)"
cat "$DEC"
echo "OK $(date -u +%Y-%m-%dT%H:%M:%SZ)" >"$DONE"
