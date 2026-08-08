#!/usr/bin/env bash
# Pass 404: cuda403 cleared CCCL check but flashinfer sampling link failed:
#   /usr/bin/ld: cannot find -lcudart
# cu13 ships libcudart.so.13 only — no unversioned .so for -lcudart.
# Fix: symlink libcudart.so → .so.13 (+ cuda stub), wipe sampling JIT,
# relaunch with CUDA_HOME=cu13, then diverse-warm before freeze.
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
LOG=/root/logs/h100_chall_cuda_p404.nohup
TCACHE=/root/.triton/isolated/h100_chall_p260_a1_1786227519_63229
TAG=h100_chall_p260_a1_1786227519_63229
HDR="${_SITE}/flashinfer/data/cccl/libcudacxx/include/cuda/std/__cccl/cuda_toolkit.h"

log() { echo "[f4-cuda404] $(date -u +%Y-%m-%dT%H:%M:%SZ) $*" | tee -a "$LOG"; }

[[ -d "$TCACHE" ]] || { log "ABORT no TCACHE $TCACHE"; exit 1; }
[[ -f "$MERGE/config.json" ]] || { log "ABORT no merge $MERGE"; exit 1; }
[[ -n "${CUDA_HOME:-}" && -x "${CUDA_HOME}/bin/nvcc" ]] || {
  log "ABORT no nvcc CUDA_HOME=${CUDA_HOME:-unset}"
  exit 1
}
log "CUDA_HOME=$CUDA_HOME nvcc=$(command -v nvcc) $($(command -v nvcc) --version 2>/dev/null | awk '/release/{print $5,$6}')"

# CCCL patch (idempotent)
if [[ -f "$HDR" ]]; then
  if grep -q 'mining p403 CCCL_DISABLE' "$HDR"; then
    log "CCCL patch already present"
  else
    python3 - <<PY
from pathlib import Path
p = Path("$HDR")
t = p.read_text()
needle = "#ifndef CCCL_DISABLE_CTK_COMPATIBILITY_CHECK"
if "mining p403 CCCL_DISABLE" in t:
    print("already")
elif needle in t:
    t = t.replace(
        needle,
        "#define CCCL_DISABLE_CTK_COMPATIBILITY_CHECK 1 /* mining p403 CCCL_DISABLE: nvcc13.3 vs CTK13.0 */\n"
        + needle,
        1,
    )
    p.write_text(t)
    print("patched")
else:
    raise SystemExit(f"needle missing in {p}")
PY
    log "patched $HDR"
  fi
fi

# Unversioned .so symlinks for ld -lcudart / -lcuda
for libdir in "${CUDA_HOME}/lib" "${CUDA_HOME}/lib64"; do
  [[ -d "$libdir" ]] || continue
  if [[ -f "$libdir/libcudart.so.13" && ! -e "$libdir/libcudart.so" ]]; then
    ln -sfn libcudart.so.13 "$libdir/libcudart.so"
    log "symlink $libdir/libcudart.so -> libcudart.so.13"
  fi
  if [[ -f "$libdir/stubs/libcuda.so" && ! -e "$libdir/libcuda.so" ]]; then
    ln -sfn stubs/libcuda.so "$libdir/libcuda.so"
    log "symlink $libdir/libcuda.so -> stubs/libcuda.so"
  elif [[ -f "${CUDA_HOME}/lib64/stubs/libcuda.so" && ! -e "$libdir/libcuda.so" ]]; then
    ln -sfn "${CUDA_HOME}/lib64/stubs/libcuda.so" "$libdir/libcuda.so"
    log "symlink $libdir/libcuda.so -> lib64/stubs"
  fi
done
# Verify linker can resolve
if ! echo 'int main(){return 0;}' | c++ -x c++ - -lcudart -L"${CUDA_HOME}/lib" -L"${CUDA_HOME}/lib64" \
    -Wl,-rpath,"${CUDA_HOME}/lib" -o /tmp/h100_p404_cudart_linktest 2>/tmp/h100_p404_cudart_linktest.err; then
  log "WARN cudart linktest failed: $(tr '\n' ' ' </tmp/h100_p404_cudart_linktest.err)"
else
  log "cudart linktest OK"
  rm -f /tmp/h100_p404_cudart_linktest
fi

# Wipe failed flashinfer sampling JIT
rm -rf /root/.cache/flashinfer/0.6.11.post2/103a/cached_ops/sampling
rm -rf /root/.cache/flashinfer/0.6.11.post2/103a/cached_ops/tmp
log "wiped flashinfer sampling JIT cache"

[[ -s /root/affine_data/turns.jsonl ]] || { log "ABORT no turns.jsonl"; exit 1; }
log "turns.jsonl lines=$(wc -l </root/affine_data/turns.jsonl)"

# Kill stale waiters (not self)
while read -r pid; do
  [[ -n "${pid:-}" ]] || continue
  arg0=$(tr '\0' '\n' </proc/"$pid"/cmdline 2>/dev/null | head -1 || true)
  case "$arg0" in
    *relaunch_chall_cuda_p401*|*relaunch_chall_frozen_p397*|*relaunch_chall_cuda_p403*|*wait_warm_freeze_p404*|*relaunch_chall_cuda_p404*)
      if [[ "$pid" != "$$" && "$pid" != "$PPID" ]]; then
        log "kill stale waiter $pid ($arg0)"
        kill "$pid" 2>/dev/null || true
      fi
      ;;
  esac
done < <(ps -eo pid,args | awk '/[r]elaunch_chall_(cuda_p401|frozen_p397|cuda_p403|cuda_p404)|[w]ait_warm_freeze_p404/ {print $1}')

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
print(f"[f4-cuda404] reap gpus4,5 pids={sorted(pids)}")
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

_comp() {
  local label=$1 prompt=$2 max_tok=$3
  local mid code
  mid=$(curl -s --max-time 5 http://127.0.0.1:8002/v1/models \
    | python3 -c 'import sys,json; d=json.load(sys.stdin); print(d["data"][0]["id"] if d.get("data") else "")' 2>/dev/null || true)
  [[ -n "$mid" ]] || { log "comp $label no mid"; return 1; }
  code=$(PROMPT="$prompt" MAXTOK="$max_tok" MID="$mid" LABEL="$label" python3 - <<'PY'
import json, os, urllib.request
label = os.environ["LABEL"]
req = urllib.request.Request(
    "http://127.0.0.1:8002/v1/completions",
    data=json.dumps({
        "model": os.environ["MID"],
        "prompt": os.environ["PROMPT"],
        "max_tokens": int(os.environ["MAXTOK"]),
        "temperature": 0,
    }).encode(),
    headers={"Content-Type": "application/json"},
    method="POST",
)
try:
    with urllib.request.urlopen(req, timeout=180) as r:
        open(f"/tmp/h100_p404_warmup_{label}.json", "wb").write(r.read())
        print(r.status)
except Exception as e:
    open(f"/tmp/h100_p404_warmup_{label}.err", "w").write(repr(e))
    print("000")
PY
)
  log "comp $label code=$code max_tok=$max_tok prompt_chars=${#prompt}"
  [[ "$code" == "200" ]]
}

_diverse_warm() {
  local longpad
  longpad=$(python3 - <<'PY'
print("def solve(x):\n    " + ("# pad\n    " * 80) + "return x\n")
PY
)
  log "diverse writable warmups d1–d4 before freeze"
  _comp "d1" "warmup short p404" 4 || return 1
  _comp "d2" "Write a Python function that merges two sorted lists into one sorted list and explain briefly." 32 || return 1
  _comp "d3" "$longpad" 16 || return 1
  _comp "d4" "$(python3 -c "print('x' * 4096)")" 8 || return 1
  return 0
}

for i in $(seq 1 180); do
  code=$(curl -s -o /dev/null -w "%{http_code}" --max-time 3 http://127.0.0.1:8002/v1/models || true)
  if [[ "$code" == "200" ]]; then
    mid=$(curl -s --max-time 5 http://127.0.0.1:8002/v1/models \
      | python3 -c 'import sys,json; d=json.load(sys.stdin); print(d["data"][0]["id"] if d.get("data") else "")' 2>/dev/null || true)
    if [[ -n "$mid" ]]; then
      pcode=$(curl -s -o /tmp/h100_p404_probe.json -w "%{http_code}" --max-time 90 \
        http://127.0.0.1:8002/v1/completions \
        -H 'Content-Type: application/json' \
        -d "{\"model\":\"${mid}\",\"prompt\":\"hi\",\"max_tokens\":2}" || true)
      if [[ "$pcode" == "200" ]]; then
        log "CHALL PROMPTABLE mid=$mid poll=$i — diverse warm (TCACHE writable)"
        chmod -R u+w "$TCACHE" 2>/dev/null || true
        chmod 755 "$TCACHE" 2>/dev/null || true
        if ! _diverse_warm; then
          log "ABORT diverse warm failed — leave writable"
          exit 5
        fi
        n_so=$(find "$TCACHE" -name '__triton_launcher*.so' 2>/dev/null | wc -l)
        chmod -R a-w "$TCACHE" 2>/dev/null || true
        log "FROZEN after diverse warm n_so=$n_so mode=$(stat -c %a "$TCACHE")"
        date -u +%Y-%m-%dT%H:%M:%SZ >/root/logs/h100_chall_serve.done
        echo "TCACHE=$TCACHE mode=$(stat -c %a "$TCACHE") n_so=$n_so cuda_relaunch_p404_cudart_symlink+diverse" \
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
  if grep -q 'cannot find -lcudart' "$CHALL_LOG" 2>/dev/null; then
    log "ABORT still cannot find -lcudart — symlink failed?"
    exit 6
  fi
  if grep -q 'CUDA compiler and CUDA toolkit headers are incompatible' "$CHALL_LOG" 2>/dev/null; then
    log "ABORT still CCCL CTK mismatch"
    exit 4
  fi
  if grep -q 'Could not find nvcc' "$CHALL_LOG" 2>/dev/null; then
    log "ABORT still missing nvcc"
    exit 3
  fi
  if grep -q 'Engine core initialization failed' "$CHALL_LOG" 2>/dev/null; then
    (( i % 6 == 0 )) && log "EngineCore failed seen poll=$i"
  fi
  (( i % 6 == 0 )) && log "wait chall promptable poll=$i/180 health=$code"
  sleep 10
done
log "ABORT chall never promptable"
exit 1
