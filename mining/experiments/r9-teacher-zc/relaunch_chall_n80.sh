#!/usr/bin/env bash
# p2187 follow-up: merged+grafted already at /tmp/r9_merged; only chall serve+n80.
# Sets B300 CUDA_HOME/flashinfer env that resume_after_merge missed on first try.
set -euo pipefail

LOG=/root/logs/r9_post_train.nohup
DONE=/root/logs/r9_pipeline.done
ABORT=/root/logs/r9_pipeline.aborted
PIDF=/root/logs/r9_post_train.pid
mkdir -p /root/logs /root/affine_data
echo $$ >"$PIDF"
exec > >(tee -a "$LOG") 2>&1

echo "[r9-relaunch] $(date -u +%Y-%m-%dT%H:%M:%SZ) chall+n80 only"

SOFT_DEADLINE_UTC=${SOFT_DEADLINE_UTC:-2026-08-13T01:35:59Z}
DEADMAN_UTC=${DEADMAN_UTC:-2026-08-13T02:05:59Z}
MERGED=${MERGED:-/tmp/r9_merged}
LINK=${LINK:-/tmp/r9_merged_link}
KING_REPO=${KING_REPO:-tolegend/Affine-5fqbxvz29b-ckp333}
KING_REV=${KING_REV:-24c137e8a978aea1e2b4abeec594fb6ca943f03c}
SIM_OUT=/root/affine_data/r9_reason_sim.json
SIM_PROG=/root/affine_data/r9_reason_progress.json
SIM_DEC=/root/affine_data/r9_decision.json

rm -f "$ABORT" "$DONE" /root/logs/r9_chall_serve.done /root/logs/r9_sim_n80.done

if [[ ! -f "$MERGED/model-visual.safetensors" ]]; then
  echo "[r9-relaunch] FATAL missing visual graft" >&2
  echo "aborted_no_visual $(date -u +%Y-%m-%dT%H:%M:%SZ)" >"$ABORT"
  exit 2
fi
ln -sfn "$MERGED" "$LINK"

CHALL_PID_FILE=/root/logs/vllm_chall.pid
if [[ -f "$CHALL_PID_FILE" ]]; then
  CPID=$(cat "$CHALL_PID_FILE" || true)
  if [[ -n "${CPID:-}" ]] && kill -0 "$CPID" 2>/dev/null; then
    echo "[r9-relaunch] stopping chall pid=$CPID"
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
    echo "[r9-relaunch] seeding chall Triton cache from king"
    mkdir -p /root/.triton/cache/chall
    cp -a /root/.triton/cache/king/. /root/.triton/cache/chall/ || true
  fi
fi

export CUDA_HOME=${CUDA_HOME:-/root/venv/lib/python3.12/site-packages/nvidia/cu13}
export CUDA_PATH=$CUDA_HOME
export LD_LIBRARY_PATH=$CUDA_HOME/lib${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}
export LD_LIBRARY_PATH=$CUDA_HOME/lib64${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}
export VLLM_USE_FLASHINFER_SAMPLER=0
export VLLM_ALLREDUCE_USE_FLASHINFER=0
export VLLM_USE_FLASHINFER_MOE_FP16=0
export VLLM_USE_FLASHINFER_MOE_FP4=0
export VLLM_USE_FLASHINFER_MOE_FP8=0

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

echo "[r9-relaunch] launching chall :8002 on $LINK (CUDA_HOME=$CUDA_HOME)"
CUDA_VISIBLE_DEVICES=4,5 TRITON_CACHE_DIR=/root/.triton/cache/chall \
  nohup /root/venv/bin/vllm serve "$LINK" \
    --port 8002 --gpu-memory-utilization 0.72 \
    "${COMMON[@]}" \
    >/root/logs/vllm_chall.log 2>&1 &
echo $! >/root/logs/vllm_chall.pid
echo "[r9-relaunch] chall pid=$(cat /root/logs/vllm_chall.pid)"

for i in $(seq 1 480); do
  c0=$(curl -s -o /dev/null -w "%{http_code}" --max-time 3 http://127.0.0.1:8000/v1/models || true)
  c1=$(curl -s -o /dev/null -w "%{http_code}" --max-time 3 http://127.0.0.1:8001/v1/models || true)
  c2=$(curl -s -o /dev/null -w "%{http_code}" --max-time 3 http://127.0.0.1:8002/v1/models || true)
  if [[ "$c0$c1$c2" == "200200200" ]]; then
    echo "[r9-relaunch] engines 200/200/200 at iter=$i"
    break
  fi
  CPID=$(cat /root/logs/vllm_chall.pid || true)
  if [[ -n "${CPID:-}" ]] && ! kill -0 "$CPID" 2>/dev/null; then
    echo "[r9-relaunch] FATAL chall died; tail vllm_chall.log:" >&2
    tail -40 /root/logs/vllm_chall.log >&2 || true
    echo "aborted_chall_dead $(date -u +%Y-%m-%dT%H:%M:%SZ)" >"$ABORT"
    exit 2
  fi
  if (( i % 12 == 0 )); then
    echo "[r9-relaunch] wait-engines iter=$i codes=${c0}/${c1}/${c2}"
  fi
  if (( i == 480 )); then
    echo "[r9-relaunch] TIMEOUT engines" >&2
    echo "aborted_engines_timeout $(date -u +%Y-%m-%dT%H:%M:%SZ)" >"$ABORT"
    exit 2
  fi
  sleep 5
done
date -u +%Y-%m-%dT%H:%M:%SZ > /root/logs/r9_chall_serve.done

now=$(date -u +%s)
dead=$(date -u -d "$DEADMAN_UTC" +%s)
if (( dead - now < 2400 )); then
  echo "[r9-relaunch] ABORT: <40m to deadman; skip n80"
  echo "aborted_no_n80_budget $(date -u +%Y-%m-%dT%H:%M:%SZ)" >"$ABORT"
  exit 1
fi

rm -f "$SIM_OUT" "$SIM_PROG" "$SIM_DEC"
export PYTHONPATH=/root/mining_src/affine_pkg${PYTHONPATH:+:$PYTHONPATH}
BH=$(/root/venv/bin/python - <<'PY'
import hashlib, time
print(hashlib.sha256(f"r9-teacher-zc-{time.time_ns()}".encode()).hexdigest())
PY
)
echo "[r9-relaunch] launching R9 n80 vs $KING_REPO@$KING_REV block_hash=${BH:0:16}…"
set +e
set -a
# shellcheck disable=SC1091
source /root/mine.env
set +a
# affine_pkg must stay on PYTHONPATH after mine.env (p2187 ModuleNotFoundError).
export PYTHONPATH=/root/mining_src/affine_pkg${PYTHONPATH:+:$PYTHONPATH}
/root/venv/bin/python /root/mining_src/r1-reason-distill/run_reason_sim.py \
  --n-turns 80 \
  --block-hash "$BH" \
  --hotkey "local-r9-teacher-zc-$(date -u +%Y%m%dT%H%M%SZ)" \
  --king-repo "$KING_REPO" \
  --king-rev "$KING_REV" \
  --chall-repo "$LINK" \
  --chall-rev local \
  --out "$SIM_OUT" \
  --progress-out "$SIM_PROG" \
  --save-artifact \
  2>&1 | tee /root/logs/r9_reason_sim.log
sim_rc=${PIPESTATUS[0]}
set -e
if [[ "$sim_rc" -ne 0 || ! -f "$SIM_OUT" ]]; then
  echo "[r9-relaunch] ERROR n80 failed rc=$sim_rc"
  echo "aborted_n80_failed rc=$sim_rc $(date -u +%Y-%m-%dT%H:%M:%SZ)" >"$ABORT"
  exit 1
fi
date -u +%Y-%m-%dT%H:%M:%SZ > /root/logs/r9_sim_n80.done

/root/venv/bin/python /root/mining_src/r1-reason-distill/write_reason_decision.py \
  --sim-result "$SIM_OUT" --out "$SIM_DEC" \
  2>&1 | tee -a /root/logs/r9_reason_sim.log

python3 - <<PY
import json
from pathlib import Path
p = Path("$SIM_DEC")
d = json.loads(p.read_text())
dec = str(d.get("decision") or "")
dec = dec.replace("R1_H64_BASELINE", "R9").replace("R1", "R9")
if dec.startswith("REFUTE_R9"):
    dec = "REFUTE_R9"
elif "ADVANCE" in dec:
    dec = "ADVANCE_STAGE5_SUBMIT"
elif "SIGNAL_CLEARS" in dec:
    dec = "SIGNAL_CLEARS_KSIGMA_NEED_HEADROOM"
elif "SIGNAL_POS" in dec:
    dec = "SIGNAL_POS_BELOW_KSIGMA"
d["decision"] = dec
d["hyp"] = "R9"
d["king_repo"] = "$KING_REPO"
d["king_rev"] = "$KING_REV"
d["axis"] = "teacher_zc_expanded_tok_lora"
p.write_text(json.dumps(d, indent=2) + "\n")
print(json.dumps(d, indent=2))
PY

cp -f "$SIM_DEC" /root/logs/r9_decision.json
echo "OK R9 n80 $(date -u +%Y-%m-%dT%H:%M:%SZ)" | tee "$DONE"
echo "[r9-relaunch] PIPELINE_DONE"
cat "$SIM_DEC"
