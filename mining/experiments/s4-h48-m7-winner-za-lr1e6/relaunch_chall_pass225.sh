#!/usr/bin/env bash
# Pass 218: H46 p216 came up on isolated TCACHE, first completions 200,
# then EngineDead ~40s later — `__triton_launcher.so` deleted mid-settle
# (TP race). Same reap/wipe/isolated launch as p216, PLUS: after health,
# warmup one completion, chmod -R a-w the live TCACHE (freeze .so), then
# second completion before rearming n80 watcher.
set -euo pipefail

# shellcheck disable=SC1091
source /root/venv/bin/activate
if [[ -f /root/mine.env ]]; then
  set -a
  # shellcheck disable=SC1091
  source /root/mine.env
  set +a
fi

export HF_HOME=${HF_HOME:-/root/hf}
export VLLM_USE_FLASHINFER_SAMPLER=0
export VLLM_ALLREDUCE_USE_FLASHINFER=0
export VLLM_USE_FLASHINFER_MOE_FP16=0
export VLLM_USE_FLASHINFER_MOE_FP8=0
export VLLM_USE_FLASHINFER_MOE_FP4=0
export VLLM_DEEP_GEMM=0
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

LOG=/root/logs/h48_chall_recover_pass225.log
CHALL_LOG=/root/logs/vllm_chall.log
PIDF=/root/logs/vllm_chall.pid
MERGE=/root/h48/merged
export GPUS=4,5
UTIL=0.72
TAG=h48_chall_p225_$(date +%s)_$$
TCACHE=/root/.triton/isolated/$TAG
QDIR=/root/affine_data/false_probes
mkdir -p /root/logs /root/affine_data "$QDIR"
: >"$LOG"

log() { echo "[recover225-h48-chall] $(date -u +%Y-%m-%dT%H:%M:%SZ) $*" | tee -a "$LOG"; }

log "START chall relaunch (freeze TCACHE after warmup — p217 mid-load ImportError + shm_broadcast hang; clear torch_compile_cache .so race)"

ts=$(date -u +%Y%m%dT%H%M%SZ)
for f in h48_decision.json h48_sim_result.json h48_sim_result_artifact.json \
         h48_sim_progress.json; do
  if [[ -f "/root/affine_data/$f" ]]; then
    mv "/root/affine_data/$f" "$QDIR/${f%.json}_pass225_${ts}.json"
    log "quarantine $f → $QDIR"
  fi
done
rm -f /root/logs/h48_n80.done /root/logs/h48_n80_retry.aborted \
  /root/logs/h48_pipeline.aborted /root/logs/h48_chall_serve.done

# Stop post_train / wait_ready / restart / any bare sim — retry owns hashed n80.
while read -r pid; do
  [[ -n "${pid:-}" ]] || continue
  log "kill leftover pid=$pid"
  kill "$pid" 2>/dev/null || true
  sleep 1
  kill -9 "$pid" 2>/dev/null || true
done < <(ps -eo pid,cmd | awk '
  /[p]ost_train_pipeline\.sh/ {print $1}
  /[w]ait_ready\.sh/ {print $1}
  /[r]estart_for_h2\.sh/ {print $1}
  /[r]un_sim_duel\.py/ && /local-h48/ {print $1}
  /[r]etry_h48_n80\.sh/ {print $1}
')

if [[ -f "$PIDF" ]]; then
  old=$(cat "$PIDF" || true)
  if [[ -n "${old:-}" ]] && kill -0 "$old" 2>/dev/null; then
    kill "$old" 2>/dev/null || true
    sleep 2
    kill -9 "$old" 2>/dev/null || true
  fi
  rm -f "$PIDF"
fi
for p in $(ss -lptn 'sport = :8002' 2>/dev/null | awk -Fpid= 'NF>1{split($2,a,","); print a[1]}'); do
  kill -9 "$p" 2>/dev/null || true
done

python - <<'PY' | tee -a "$LOG"
import subprocess, os, signal, time
gpus = os.environ.get("GPUS", "4,5")
want = {int(x) for x in gpus.split(",") if x.strip() != ""}
out = subprocess.check_output(
    ["nvidia-smi", "--query-gpu=index,uuid", "--format=csv,noheader,nounits"],
    text=True,
)
idx_to_uuid = {}
for line in out.strip().splitlines():
    parts = [p.strip() for p in line.split(",")]
    if len(parts) >= 2:
        idx_to_uuid[int(parts[0])] = parts[1]
uuids = {idx_to_uuid[i] for i in want if i in idx_to_uuid}
apps = subprocess.check_output(
    ["nvidia-smi", "--query-compute-apps=gpu_uuid,pid", "--format=csv,noheader,nounits"],
    text=True,
)
pids = set()
for line in apps.strip().splitlines():
    if not line.strip():
        continue
    parts = [p.strip() for p in line.split(",")]
    if len(parts) >= 2 and parts[0] in uuids:
        try:
            pids.add(int(parts[1]))
        except ValueError:
            pass
parents = set()
grandparents = set()
for pid in list(pids):
    try:
        with open(f"/proc/{pid}/stat") as f:
            body = f.read()
        rparen = body.rfind(")")
        fields = body[rparen + 2 :].split()
        ppid = int(fields[1])
        if ppid > 1:
            parents.add(ppid)
    except Exception:
        pass
for pid in list(parents):
    try:
        with open(f"/proc/{pid}/stat") as f:
            body = f.read()
        rparen = body.rfind(")")
        fields = body[rparen + 2 :].split()
        ppid = int(fields[1])
        if ppid > 1:
            grandparents.add(ppid)
    except Exception:
        pass
kill_set = pids | parents | grandparents
print(f"[recover225-h48-chall] reap gpu={sorted(want)} workers={sorted(pids)} parents={sorted(parents)} grandparents={sorted(grandparents)}")
for pid in kill_set:
    try:
        os.kill(pid, signal.SIGTERM)
    except ProcessLookupError:
        pass
time.sleep(2)
for pid in kill_set:
    try:
        os.kill(pid, signal.SIGKILL)
    except ProcessLookupError:
        pass
# also SIGKILL any leftover VLLM::Worker with no parent on our GPUs
time.sleep(1)
PY

for i in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15; do
  free_ok=$(nvidia-smi --query-gpu=index,memory.used --format=csv,noheader,nounits \
    | awk -F',' -v g="$GPUS" 'BEGIN{split(g,a,","); for(i in a) want[a[i]+0]=1}
      {gsub(/ /,"",$1); gsub(/ /,"",$2); if(($1+0) in want && ($2+0)<500) n++}
      END{print n+0}')
  need=$(echo "$GPUS" | awk -F',' '{print NF}')
  log "free-check gpus$GPUS used<500MiB count=$free_ok/$need try=$i"
  if [[ "$free_ok" -ge "$need" ]]; then
    break
  fi
  # force-kill again if stuck
  if [[ "$i" -eq 5 || "$i" -eq 10 ]]; then
    python - <<'PY'
import subprocess, os, signal
gpus = {4, 5}
out = subprocess.check_output(
    ["nvidia-smi", "--query-gpu=index,uuid", "--format=csv,noheader,nounits"], text=True)
idx_to_uuid = {}
for line in out.strip().splitlines():
    parts = [p.strip() for p in line.split(",")]
    if len(parts) >= 2:
        idx_to_uuid[int(parts[0])] = parts[1]
uuids = {idx_to_uuid[i] for i in gpus if i in idx_to_uuid}
apps = subprocess.check_output(
    ["nvidia-smi", "--query-compute-apps=gpu_uuid,pid", "--format=csv,noheader,nounits"], text=True)
for line in apps.strip().splitlines():
    parts = [p.strip() for p in line.split(",")]
    if len(parts) >= 2 and parts[0] in uuids:
        try:
            os.kill(int(parts[1]), signal.SIGKILL)
        except Exception:
            pass
PY
  fi
  sleep 2
done

log "wipe role chall caches (default + prior isolated)"
rm -rf /root/.triton/cache/chall /root/.triton/cache/chall_* || true
rm -rf /root/.triton/isolated/h48_chall_* || true
rm -rf /root/.cache/flashinfer/cached_ops/sampling || true
# p217 hung at shm_broadcast after mid-load .so ImportError — LESSONS: clear compile cache
rm -rf /root/.cache/vllm/torch_compile_cache || true
rm -rf /tmp/torchinductor_* /root/.cache/torch/inductor /root/.cache/torchinductor_chall_* /root/.cache/torchinductor_h48_* || true
log "settle 30s after wipe"
sleep 30
mkdir -p "$TCACHE" /root/.cache/torchinductor_$TAG
export TORCHINDUCTOR_CACHE_DIR=/root/.cache/torchinductor_$TAG
export TRITON_CACHE_DIR=$TCACHE
# Keep TRITON_CACHE_DIR outside chall_* glob so a concurrent wipe cannot delete live .so

: >"$CHALL_LOG"
log "launch chall port=8002 gpus=$GPUS util=$UTIL TCACHE=$TCACHE merge=$MERGE"
CUDA_VISIBLE_DEVICES=$GPUS TRITON_CACHE_DIR=$TCACHE TORCHINDUCTOR_CACHE_DIR=$TORCHINDUCTOR_CACHE_DIR \
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
CHALL_PID=$(cat "$PIDF")
log "chall_pid=$CHALL_PID"

# Wait MoE health (up to ~20m), then warmup+freeze before watcher can probe.
log "wait health=200 (max 120×10s)"
health_ok=0
for i in $(seq 1 120); do
  code=$(curl -s -o /dev/null -w "%{http_code}" --max-time 3 http://127.0.0.1:8002/v1/models || true)
  if [[ "$code" == "200" ]]; then
    log "health=200 at poll=$i"
    health_ok=1
    break
  fi
  if ! kill -0 "$CHALL_PID" 2>/dev/null; then
    log "ABORT chall_pid=$CHALL_PID died before health (see $CHALL_LOG)"
    exit 1
  fi
  (( i % 6 == 0 )) && log "health poll=$i/120 code=$code"
  sleep 10
done
if [[ "$health_ok" != "1" ]]; then
  log "ABORT health never 200"
  exit 1
fi

_comp() {
  local label=$1 mid code
  mid=$(curl -s --max-time 5 http://127.0.0.1:8002/v1/models \
    | python3 -c 'import sys,json; d=json.load(sys.stdin); print(d["data"][0]["id"] if d.get("data") else "")' 2>/dev/null || true)
  [[ -n "$mid" ]] || { log "FAIL $label: no model id"; return 1; }
  code=$(curl -s -o "/tmp/h48_warmup_${label}.json" -w "%{http_code}" --max-time 120 \
    http://127.0.0.1:8002/v1/completions \
    -H 'Content-Type: application/json' \
    -d "{\"model\":\"${mid}\",\"prompt\":\"warmup ${label}\",\"max_tokens\":4,\"temperature\":0}" || true)
  log "comp $label code=$code"
  [[ "$code" == "200" ]]
}

log "warmup completion #1 (JIT kernels into TCACHE)"
if ! _comp w1; then
  log "ABORT warmup #1 failed — chall still up? pid=$(kill -0 $CHALL_PID 2>/dev/null && echo yes || echo no)"
  tail -30 "$CHALL_LOG" | tee -a "$LOG" || true
  exit 1
fi

# Freeze: TP workers race-delete __triton_launcher.so during settle/n80.
# After first successful JIT, make cache immutable so deletes fail closed.
log "FREEZE TCACHE chmod -R a-w $TCACHE"
chmod -R a-w "$TCACHE" || true
# also freeze inductor cache used by this role
chmod -R a-w "/root/.cache/torchinductor_$TAG" 2>/dev/null || true
n_so=$(find "$TCACHE" -name '__triton_launcher*.so' 2>/dev/null | wc -l)
log "frozen launcher.so count=$n_so"

sleep 5
log "warmup completion #2 (must survive freeze)"
if ! _comp w2; then
  log "ABORT warmup #2 failed after freeze"
  tail -40 "$CHALL_LOG" | tee -a "$LOG" || true
  exit 1
fi
sleep 20
if ! _comp w3; then
  log "ABORT warmup #3 (post-settle) failed — freeze insufficient"
  tail -40 "$CHALL_LOG" | tee -a "$LOG" || true
  exit 1
fi
log "triple-promptable after freeze — rearm watcher"

# Rearm watcher (may have been mid-poll; clears aborted so fresh wait).
while read -r pid; do
  [[ -n "${pid:-}" ]] || continue
  log "kill old watcher pid=$pid"
  kill "$pid" 2>/dev/null || true
  sleep 1
  kill -9 "$pid" 2>/dev/null || true
done < <(ps -eo pid,args | awk '/[w]atch_n80_retry\.sh/ && / h48 / {print $1}')
# also stop any in-flight retry so it picks up patched script fresh
while read -r pid; do
  [[ -n "${pid:-}" ]] || continue
  log "kill old retry pid=$pid"
  kill "$pid" 2>/dev/null || true
  sleep 1
  kill -9 "$pid" 2>/dev/null || true
done < <(ps -eo pid,args | awk '/[r]etry_h48_n80\.sh/ {print $1}')
sleep 1
nohup bash /root/mining_src/s4-h2-merge/watch_n80_retry.sh h48 \
  /root/mining_src/s4-h48-m7-winner-za-lr1e6/retry_h48_n80.sh \
  >/root/logs/h48_watch_retry.launch.nohup 2>&1 &
echo $! >/root/logs/h48_watch_retry.pid
log "rearmed watcher pid=$(cat /root/logs/h48_watch_retry.pid)"
log "DONE_LAUNCH (TCACHE frozen; n80 should see double-promptable immediately)"
