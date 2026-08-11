#!/usr/bin/env bash
# p2113: chall recover hardcodes max_model_len=32768 (n80 ContextLengthError).
# Patch → 65536, kill recover+chall by PID, relaunch recover, arm n80 retry watcher.
set -euo pipefail
LOG=/root/logs/p2113_chall_maxlen_n80.nohup
exec > >(tee -a "$LOG") 2>&1
log(){ echo "[p2113] $(date -u +%Y-%m-%dT%H:%M:%SZ) $*"; }

SRC=/root/mining_src/s4-h121-f26-full-ft/relaunch_chall_pass264.sh
N80=/root/mining_src/s4-h121-f26-full-ft/retry_h121_n80_d203first.sh

if [[ ! -f "$SRC" ]]; then
  log "ABORT missing $SRC"; exit 1
fi

# Patch only if still 32768 (idempotent)
if grep -q -- '--max-model-len 32768' "$SRC"; then
  cp -a "$SRC" "${SRC}.bak_p2113"
  # never edit running file in place while bash re-reads — kill first, then patch
  log "will patch after kill: 32768 → 65536"
  NEED_PATCH=1
else
  log "already patched (no 32768 in launch block)"
  NEED_PATCH=0
fi

# Kill recover watcher by PID file / known pid
RECOVER_PIDF=/root/logs/h121_chall_recover_pass264.pid
if [[ -f "$RECOVER_PIDF" ]]; then
  rp=$(cat "$RECOVER_PIDF" || true)
  if [[ -n "${rp:-}" ]] && kill -0 "$rp" 2>/dev/null; then
    log "kill recover pid=$rp"
    kill "$rp" 2>/dev/null || true
    sleep 2
    kill -9 "$rp" 2>/dev/null || true
  fi
fi

# Kill chall parent + children on GPUs 4,5 only (by pid file)
CHALL_PIDF=/root/logs/vllm_chall.pid
if [[ -f "$CHALL_PIDF" ]]; then
  cp=$(cat "$CHALL_PIDF" || true)
  if [[ -n "${cp:-}" ]] && kill -0 "$cp" 2>/dev/null; then
    log "kill chall parent pid=$cp and process group"
    # children first
    pkill -P "$cp" 2>/dev/null || true
    kill "$cp" 2>/dev/null || true
    sleep 3
    kill -9 "$cp" 2>/dev/null || true
    # orphan engine cores that may remain
    for p in $(pgrep -f 'vllm serve /root/h121/merged' || true); do
      log "kill leftover chall-serve pid=$p"
      kill "$p" 2>/dev/null || true
      sleep 1
      kill -9 "$p" 2>/dev/null || true
    done
  fi
fi

# Wait GPUs 4,5 free
for i in $(seq 1 60); do
  used=$(nvidia-smi --query-gpu=memory.used --format=csv,noheader,nounits -i 4,5 | awk '{s+=$1} END{print s+0}')
  log "gpu4+5 used_mib=$used poll=$i"
  if [[ "$used" -lt 1000 ]]; then
    break
  fi
  # force-kill any remaining python on those devices via fuser if still hot
  if (( i % 10 == 0 )); then
    fuser -k /dev/nvidia4 /dev/nvidia5 2>/dev/null || true
  fi
  sleep 5
done

if [[ "$NEED_PATCH" == "1" ]]; then
  # safe: recover is dead
  sed -i 's/--max-model-len 32768/--max-model-len 65536/' "$SRC"
  if grep -q -- '--max-model-len 65536' "$SRC" && ! grep -q -- '--max-model-len 32768' "$SRC"; then
    log "PATCH_OK max_model_len=65536"
  else
    log "ABORT patch failed"; exit 1
  fi
fi

# Ensure mine.env exports
if [[ -f /root/mine.env ]]; then
  set -a
  # shellcheck disable=SC1091
  source /root/mine.env
  set +a
fi
# shellcheck disable=SC1091
source /root/venv/bin/activate

# B300 flashinfer off + CUDA_HOME (match restore; do NOT put cu13/bin on PATH)
export VLLM_USE_FLASHINFER_SAMPLER=0
export VLLM_ALLREDUCE_USE_FLASHINFER=0
export VLLM_USE_FLASHINFER_MOE_FP16=0
export VLLM_USE_FLASHINFER_MOE_FP8=0
export VLLM_USE_FLASHINFER_MOE_FP4=0
export VLLM_USE_DEEP_GEMM=0
export VLLM_MOE_USE_DEEP_GEMM=0
_SITE=$(python - <<'PY'
import site
print(site.getsitepackages()[0])
PY
)
_CU13="${_SITE}/nvidia/cu13"
if [[ -x "${_CU13}/bin/nvcc" ]]; then
  export CUDA_HOME=${CUDA_HOME:-$_CU13}
  export CUDA_PATH=$CUDA_HOME
  export LD_LIBRARY_PATH="${CUDA_HOME}/lib:${CUDA_HOME}/lib64:${LD_LIBRARY_PATH:-}"
  log "CUDA_HOME=$CUDA_HOME (PATH untouched)"
fi

log "relaunch recover with 65536"
: > /root/logs/h121_chall_recover_pass264.nohup
nohup bash "$SRC" >>/root/logs/h121_chall_recover_pass264.nohup 2>&1 &
echo $! >"$RECOVER_PIDF"
log "recover_pid=$(cat $RECOVER_PIDF)"

# Arm n80 retry if not already running
if pgrep -f 'retry_h121_n80_d203first' >/dev/null; then
  log "n80 retry already running: $(pgrep -af retry_h121_n80_d203first | head -1)"
else
  nohup bash "$N80" >>/root/logs/h121_n80_retry.nohup 2>&1 &
  echo $! >/root/logs/h121_n80_retry.pid
  log "armed n80 retry pid=$(cat /root/logs/h121_n80_retry.pid)"
fi

python3 - <<'PY'
import json, time
from pathlib import Path
Path("/root/affine_data").mkdir(parents=True, exist_ok=True)
Path("/root/affine_data/p2113_chall_maxlen_n80.json").write_text(json.dumps({
  "utc": time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime()),
  "pass": 2113,
  "action": "patch_chall_max_model_len_32768_to_65536_relaunch_recover_arm_n80",
  "recover_pidf": "/root/logs/h121_chall_recover_pass264.pid",
  "n80_pidf": "/root/logs/h121_n80_retry.pid",
  "note": "serve_three defaults MAXLEN=65536; recover_pass264 had hardcoded 32768",
}, indent=2) + "\n")
print("wrote /root/affine_data/p2113_chall_maxlen_n80.json")
PY
log "DONE"
