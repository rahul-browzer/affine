#!/usr/bin/env bash
# Pass 401: p397 frozen relaunch died — Worker 'Could not find nvcc' /
# cuda_home='/usr/local/cuda' missing. Same TCACHE but set CUDA_HOME=cu13
# (as pass264) and make TCACHE writable so any missing .so can JIT, then
# freeze after promptable and rearm longwait.
set -euo pipefail
source /root/venv/bin/activate
set -a
# shellcheck disable=SC1091
[ -f /root/mine.env ] && source /root/mine.env
set +a

export VLLM_USE_DEEP_GEMM=0
export VLLM_MOE_USE_DEEP_GEMM=0

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
  export LIBRARY_PATH="${CUDA_HOME}/lib:${CUDA_HOME}/lib64:${LIBRARY_PATH:-}"
fi

HYP=h100
MERGE=/root/h100/merged
GPUS=4,5
UTIL=0.72
PIDF=/root/logs/vllm_chall.pid
CHALL_LOG=/root/logs/vllm_chall.log
LOG=/root/logs/h100_chall_cuda_p401.nohup
TCACHE=/root/.triton/isolated/h100_chall_p260_a1_1786227519_63229
TAG=h100_chall_p260_a1_1786227519_63229

log() { echo "[f4-cuda401] $(date -u +%Y-%m-%dT%H:%M:%SZ) $*" | tee -a "$LOG"; }

[[ -d "$TCACHE" ]] || { log "ABORT no TCACHE $TCACHE"; exit 1; }
[[ -f "$MERGE/config.json" ]] || { log "ABORT no merge $MERGE"; exit 1; }
[[ -n "${CUDA_HOME:-}" && -x "${CUDA_HOME}/bin/nvcc" ]] || {
  log "ABORT no nvcc CUDA_HOME=${CUDA_HOME:-unset}"
  exit 1
}
log "CUDA_HOME=$CUDA_HOME nvcc=$(command -v nvcc)"

[[ -s /root/affine_data/turns.jsonl ]] || { log "ABORT no turns.jsonl"; exit 1; }
log "turns.jsonl lines=$(wc -l </root/affine_data/turns.jsonl)"

# Stop prior frozen waiter if still polling
while read -r pid; do
  [[ -n "${pid:-}" ]] || continue
  arg0=$(tr '\0' '\n' </proc/"$pid"/cmdline 2>/dev/null | head -1 || true)
  case "$arg0" in
    *relaunch_chall_frozen_p397*) log "kill stale frozen waiter $pid"; kill "$pid" 2>/dev/null || true ;;
  esac
done < <(ps -eo pid,args | awk '/[r]elaunch_chall_frozen_p397/ {print $1}')

if [[ -f "$PIDF" ]]; then
  old=$(cat "$PIDF" || true)
  if [[ -n "${old:-}" ]] && kill -0 "$old" 2>/dev/null; then
    log "kill old chall pid=$old"
    kill "$old" 2>/dev/null || true
    sleep 2
    kill -9 "$old" 2>/dev/null || true
  fi
  rm -f "$PIDF"
fi
for p in $(ss -lptn 'sport = :8002' 2>/dev/null | awk -Fpid= 'NF>1{split($2,a,","); print a[1]}'); do
  kill -9 "$p" 2>/dev/null || true
done

python - <<'PY'
import os, signal, subprocess, time
want = {4, 5}
out = subprocess.check_output(
    ["nvidia-smi", "--query-gpu=index,uuid", "--format=csv,noheader,nounits"], text=True)
idx_to_uuid = {}
for line in out.strip().splitlines():
    parts = [p.strip() for p in line.split(",")]
    if len(parts) >= 2:
        idx_to_uuid[int(parts[0])] = parts[1]
uuids = {idx_to_uuid[i] for i in want if i in idx_to_uuid}
apps = subprocess.check_output(
    ["nvidia-smi", "--query-compute-apps=gpu_uuid,pid", "--format=csv,noheader,nounits"], text=True)
pids = set()
for line in apps.strip().splitlines():
    if not line.strip():
        continue
    parts = [p.strip() for p in line.split(",")]
    if len(parts) >= 2 and parts[0] in uuids:
        try: pids.add(int(parts[1]))
        except ValueError: pass
print(f"[f4-cuda401] reap gpus4,5 pids={sorted(pids)}")
for pid in pids:
    try: os.kill(pid, signal.SIGTERM)
    except OSError: pass
time.sleep(2)
for pid in pids:
    try: os.kill(pid, signal.SIGKILL)
    except OSError: pass
PY

for i in 1 2 3 4 5 6 7 8 9 10; do
  free_ok=$(nvidia-smi --query-gpu=index,memory.used --format=csv,noheader,nounits \
    | awk -F',' '($1+0==4 || $1+0==5) && ($2+0)<500 {n++} END{print n+0}')
  log "free-check gpus4,5 count=$free_ok/2 try=$i"
  [[ "$free_ok" -ge 2 ]] && break
  sleep 2
done

# Writable so missing kernels can JIT under CUDA_HOME; freeze after promptable
chmod -R u+w "$TCACHE" 2>/dev/null || true
chmod 755 "$TCACHE" 2>/dev/null || true
n_so=$(find "$TCACHE" -name '__triton_launcher*.so' 2>/dev/null | wc -l)
log "launch chall TCACHE=$TCACHE mode=$(stat -c %a "$TCACHE") n_so=$n_so CUDA_HOME=$CUDA_HOME"

export TORCHINDUCTOR_CACHE_DIR=/root/.cache/torchinductor_$TAG
export TRITON_CACHE_DIR=$TCACHE
mkdir -p "$TORCHINDUCTOR_CACHE_DIR"
chmod -R u+w "$TORCHINDUCTOR_CACHE_DIR" 2>/dev/null || true
: >"$CHALL_LOG"
CUDA_VISIBLE_DEVICES=$GPUS TRITON_CACHE_DIR=$TCACHE TORCHINDUCTOR_CACHE_DIR=$TORCHINDUCTOR_CACHE_DIR \
  CUDA_HOME=$CUDA_HOME CUDA_PATH=$CUDA_PATH PATH=$PATH \
  LD_LIBRARY_PATH=$LD_LIBRARY_PATH LIBRARY_PATH=$LIBRARY_PATH \
  nohup vllm serve "$MERGE" \
  --port 8002 \
  --tensor-parallel-size 2 \
  --max-model-len 32768 \
  --gpu-memory-utilization "$UTIL" \
  --max-num-batched-tokens 8192 \
  --attention-backend FLASH_ATTN \
  --attention-config.use_trtllm_attention 0 \
  --compilation-config.pass_config.fuse_allreduce_rms false \
  --moe-backend triton \
  --additional-config '{"gdn_prefill_backend": "triton"}' \
  >"$CHALL_LOG" 2>&1 &
echo $! >"$PIDF"
log "chall_pid=$(cat "$PIDF")"

for i in $(seq 1 180); do
  code=$(curl -s -o /dev/null -w "%{http_code}" --max-time 3 http://127.0.0.1:8002/v1/models || true)
  if [[ "$code" == "200" ]]; then
    mid=$(curl -s --max-time 5 http://127.0.0.1:8002/v1/models \
      | python3 -c 'import sys,json; d=json.load(sys.stdin); print(d["data"][0]["id"] if d.get("data") else "")' 2>/dev/null || true)
    if [[ -n "$mid" ]]; then
      pcode=$(curl -s -o /tmp/h100_p401_probe.json -w "%{http_code}" --max-time 90 \
        http://127.0.0.1:8002/v1/completions \
        -H 'Content-Type: application/json' \
        -d "{\"model\":\"${mid}\",\"prompt\":\"hi\",\"max_tokens\":2}" || true)
      if [[ "$pcode" == "200" ]]; then
        n_so=$(find "$TCACHE" -name '__triton_launcher*.so' 2>/dev/null | wc -l)
        chmod -R a-w "$TCACHE" 2>/dev/null || true
        log "CHALL PROMPTABLE mid=$mid poll=$i n_so=$n_so mode=$(stat -c %a "$TCACHE")"
        date -u +%Y-%m-%dT%H:%M:%SZ >/root/logs/h100_chall_serve.done
        echo "TCACHE=$TCACHE mode=$(stat -c %a "$TCACHE") n_so=$n_so cuda_relaunch_p401" \
          >/root/logs/h100_chall_freeze_pass264.done
        while read -r pid; do
          [[ -n "${pid:-}" ]] || continue
          cmd=$(tr '\0' ' ' </proc/"$pid"/cmdline 2>/dev/null || true)
          case "$cmd" in
            *watch_n80_retry.sh*) log "kill watcher $pid"; kill "$pid" 2>/dev/null || true ;;
          esac
        done < <(ps -eo pid,args | awk '/[w]atch_n80_retry\.sh/ && / h100 / {print $1}')
        while read -r pid; do
          [[ -n "${pid:-}" ]] || continue
          arg0=$(tr '\0' '\n' </proc/"$pid"/cmdline 2>/dev/null | head -1 || true)
          case "$arg0" in
            *retry_h100_n80*) log "kill retry $pid ($arg0)"; kill "$pid" 2>/dev/null || true ;;
          esac
        done < <(ps -eo pid,args | awk '/[r]etry_h100_n80/ {print $1}')
        sleep 2
        nohup bash /root/mining_src/s4-h2-merge/watch_n80_retry.sh h100 \
          /root/mining_src/s4-h100-f4-genesis-base/retry_h100_n80_longwait.sh \
          >/root/logs/h100_watch_retry.launch.nohup 2>&1 &
        echo $! >/root/logs/h100_watch_retry.pid
        log "rearmed longwait watcher pid=$(cat /root/logs/h100_watch_retry.pid)"
        log "DONE"
        exit 0
      fi
    fi
  fi
  if grep -q 'Could not find nvcc' "$CHALL_LOG" 2>/dev/null; then
    log "ABORT still missing nvcc despite CUDA_HOME=$CUDA_HOME"
    exit 3
  fi
  if grep -q '__triton_launcher.*cannot open shared object file' "$CHALL_LOG" 2>/dev/null; then
    log "ABORT Triton ENOENT — need full recover264"
    exit 2
  fi
  (( i % 6 == 0 )) && log "wait chall promptable poll=$i/180 health=$code"
  sleep 10
done
log "ABORT chall never promptable"
exit 1
