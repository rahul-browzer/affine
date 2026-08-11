#!/usr/bin/env bash
# R2bc retry (p2117): serve pure ec08 via HF repo+rev (same path as live king),
# not the thin local symlink dir that died with language_model.model.* uninit.
# If engines still fail → stamp UNSERVABLE and leave next pass to arm R2bd ckp55.
set -euo pipefail
LOG=/root/logs/r2bc_ec08_hf_serve.log
DONE=/root/logs/r2bc_ec08_reload.done
PIDF=/root/logs/r2bc_ec08_hf_serve.pid
HOLDING=${HOLDING:-/root/logs/r2bc_ec08_holding.stamp}
mkdir -p /root/logs /root/affine_data /root/r2_out
echo $$ >"$PIDF"
exec > >(tee -a "$LOG") 2>&1

echo "[r2bc-hf] $(date -u +%Y-%m-%dT%H:%M:%SZ) start HF-id serve retry"

EC08_REPO=${EC08_REPO:-arbosfan/Affine-5eqdtdzqle-ec08cldg}
EC08_REV=${EC08_REV:-24a3a65eb68bfc1e412b1169c5d4a8c82491d227}
EC08_SNAP=${EC08_SNAP:-/root/hf/hub/models--arbosfan--Affine-5eqdtdzqle-ec08cldg/snapshots/${EC08_REV}}
WARM=${WARM_DONE:-/root/logs/warm_stack_ready.done}

if [[ -f "$DONE" ]]; then
  echo "[r2bc-hf] prior done present: $(cat "$DONE")"
  # allow retry after weight-fail; only skip if a decision already exists
  if [[ -f /root/affine_data/r2bc_ec08_decision.json ]]; then
    echo "[r2bc-hf] decision already stamped; exit"
    exit 0
  fi
fi

if [[ ! -f "$WARM" ]]; then
  echo "[r2bc-hf] FATAL no warm_stack_ready" >&2
  exit 2
fi
if [[ ! -f "$EC08_SNAP/model.safetensors.index.json" ]]; then
  echo "[r2bc-hf] FATAL missing snapshot index at $EC08_SNAP" >&2
  exit 2
fi

# Ensure preprocessor exists in the HF snapshot (vLLM multimodal).
if [[ ! -f "$EC08_SNAP/preprocessor_config.json" ]]; then
  if [[ -f "$EC08_SNAP/processor_config.json" ]]; then
    cp -L "$EC08_SNAP/processor_config.json" "$EC08_SNAP/preprocessor_config.json"
    echo "[r2bc-hf] derived preprocessor_config.json in snapshot"
  else
    KING_PP=/root/hf/hub/models--Tok331102--affine-5EqYW8McUc-af10/snapshots/eb8bf9a356a254f71faaa439e8abc3cfba572c53/preprocessor_config.json
    cp -L "$KING_PP" "$EC08_SNAP/preprocessor_config.json"
    echo "[r2bc-hf] copied preprocessor from Tok king into snapshot"
  fi
fi

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

echo "$(date -u +%Y-%m-%dT%H:%M:%SZ) claiming chall pure-ec08 HF-id" >"$HOLDING"
trap 'rm -f "$HOLDING"' EXIT

CHALL_PID_FILE=/root/logs/vllm_chall.pid
if [[ -f "$CHALL_PID_FILE" ]]; then
  CPID=$(cat "$CHALL_PID_FILE" || true)
  if [[ -n "${CPID:-}" ]] && kill -0 "$CPID" 2>/dev/null; then
    echo "[r2bc-hf] stopping chall pid=$CPID"
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
for op in $(pgrep -f 'VLLM::EngineCore|VLLM::Worker' 2>/dev/null || true); do
  envf="/proc/$op/environ"
  if [[ -r "$envf" ]] && tr '\0' '\n' <"$envf" 2>/dev/null | grep -qx 'CUDA_VISIBLE_DEVICES=4,5'; then
    echo "[r2bc-hf] killing leftover chall orphan pid=$op (CUDA 4,5)"
    kill "$op" 2>/dev/null || true
  fi
done
for op in $(pgrep -f 'vllm serve .*--port 8002' 2>/dev/null || true); do
  if [[ "$op" != "$$" ]] && kill -0 "$op" 2>/dev/null; then
    echo "[r2bc-hf] killing leftover chall serve pid=$op"
    kill "$op" 2>/dev/null || true
  fi
done
sleep 2

if [[ ! -d /root/.triton/cache/chall ]] || [[ -z "$(find /root/.triton/cache/chall -name '*.so' 2>/dev/null | head -1)" ]]; then
  if [[ -d /root/.triton/cache/king ]]; then
    echo "[r2bc-hf] seeding chall Triton cache from king"
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

echo "[r2bc-hf] launching chall :8002 via HF $EC08_REPO@$EC08_REV"
CUDA_VISIBLE_DEVICES=4,5 TRITON_CACHE_DIR=/root/.triton/cache/chall \
  nohup /root/venv/bin/vllm serve "$EC08_REPO" \
    --revision "$EC08_REV" \
    --port 8002 --gpu-memory-utilization 0.72 \
    "${COMMON[@]}" \
    >/root/logs/vllm_chall.log 2>&1 &
echo $! >/root/logs/vllm_chall.pid
echo "[r2bc-hf] chall pid=$(cat /root/logs/vllm_chall.pid)"

ok=0
for i in $(seq 1 360); do
  c0=$(curl -s -o /dev/null -w "%{http_code}" --max-time 3 http://127.0.0.1:8000/v1/models || true)
  c1=$(curl -s -o /dev/null -w "%{http_code}" --max-time 3 http://127.0.0.1:8001/v1/models || true)
  c2=$(curl -s -o /dev/null -w "%{http_code}" --max-time 3 http://127.0.0.1:8002/v1/models || true)
  if [[ "$c0$c1$c2" == "200200200" ]]; then
    echo "[r2bc-hf] engines 200/200/200 at iter=$i"
    ok=1
    break
  fi
  # Fail-fast if chall process died (weight-init etc).
  CPID=$(cat /root/logs/vllm_chall.pid || true)
  if [[ -n "${CPID:-}" ]] && ! kill -0 "$CPID" 2>/dev/null; then
    echo "[r2bc-hf] chall pid=$CPID died early; see vllm_chall.log"
    break
  fi
  if (( i % 12 == 0 )); then
    echo "[r2bc-hf] wait-engines iter=$i codes=${c0}/${c1}/${c2}"
  fi
  sleep 5
done

if [[ "$ok" != "1" ]]; then
  echo "[r2bc-hf] UNSERVABLE via HF-id; stamping decision for R2bd handoff"
  python3 - <<PY
import json, time
from pathlib import Path
dec = {
  "utc": time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime()),
  "hyp": "R2bc",
  "decision": "UNSERVABLE_WEIGHT_INIT",
  "serve_mode": "hf_repo_rev",
  "ec08_repo": "$EC08_REPO",
  "ec08_rev": "$EC08_REV",
  "note": "local symlink dir and HF-id serve both failed language_model.model.* uninit; skip to R2bd ckp55",
  "next": "R2bd",
  "next_parent": {
    "repo": "nerojimmy/Affine-5fqbxvz29b-ckp55",
    "revision": "bf4d01359355df32cdcd1332a9cc587eb8835f7d",
    "challenge_id": "chal-00504",
  },
  "vllm_chall_log_tail": Path("/root/logs/vllm_chall.log").read_text(errors="replace")[-2000:],
}
Path("/root/affine_data/r2bc_ec08_decision.json").write_text(json.dumps(dec, indent=2) + "\n")
Path("/root/logs/r2bc_ec08_decision.json").write_text(json.dumps(dec, indent=2) + "\n")
Path("$DONE").write_text(f"UNSERVABLE_HF {dec['utc']}\n")
Path("/root/affine_data/r2bc_ec08_reload.done").write_text(f"UNSERVABLE_HF {dec['utc']}\n")
print(json.dumps(dec, indent=2))
PY
  exit 3
fi

OUT=/root/affine_data/r2bc_ec08_reason_sim.json
DEC=/root/affine_data/r2bc_ec08_decision.json
PROG=/root/affine_data/r2bc_ec08_reason_progress.json
rm -f "$OUT" "$DEC" "$PROG"
BH=$(python - <<'PY'
import hashlib, time
print(hashlib.sha256(f"r2bc-ec08-hf-{time.time_ns()}".encode()).hexdigest())
PY
)

echo "[r2bc-hf] launching R2bc n80 block_hash=${BH:0:16}…"
python /root/mining_src/r1-reason-distill/run_reason_sim.py \
  --n-turns 80 \
  --block-hash "$BH" \
  --hotkey "local-r2bc-ec08-hf-$(date -u +%Y%m%dT%H:%M:%SZ)" \
  --king-repo Tok331102/affine-5EqYW8McUc-af10 \
  --king-rev eb8bf9a356a254f71faaa439e8abc3cfba572c53 \
  --chall-repo "$EC08_REPO" \
  --chall-rev "$EC08_REV" \
  --out "$OUT" \
  --progress-out "$PROG" \
  --save-artifact \
  2>&1 | tee /root/logs/r2bc_ec08_reason_sim.log

python /root/mining_src/r1-reason-distill/write_reason_decision.py \
  --sim-result "$OUT" --out "$DEC" --hyp R2bc \
  2>&1 | tee -a /root/logs/r2bc_ec08_reason_sim.log

echo "[r2bc-hf] DONE $(date -u +%Y-%m-%dT%H:%M:%SZ)"
cat "$DEC"
echo "OK_HF $(date -u +%Y-%m-%dT%H:%M:%SZ)" >"$DONE"
cp -f "$DEC" /root/logs/r2bc_ec08_decision.json 2>/dev/null || true
cp -f "$DONE" /root/affine_data/r2bc_ec08_reload.done 2>/dev/null || true
