#!/usr/bin/env bash
# Pass 212: H40 chall stuck mid-load on Triton ImportError
# `__triton_launcher.so: No such file` (Worker_TP1). Teacher+king OK.
# Reap GPUs 4,5 → wipe chall/chall_* FIRST → ≥20s settle → unique TCACHE.
# Kill post_train/wait_ready so bare n80 cannot race; rearm watch_n80_retry.
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

LOG=/root/logs/h40_chall_recover_pass212.log
CHALL_LOG=/root/logs/vllm_chall.log
PIDF=/root/logs/vllm_chall.pid
MERGE=/root/h40/merged
export GPUS=4,5
UTIL=0.72
TAG=chall_p212_$(date +%s)_$$
TCACHE=/root/.triton/cache/$TAG
QDIR=/root/affine_data/false_probes
mkdir -p /root/logs /root/affine_data "$QDIR"
: >"$LOG"

log() { echo "[recover212-h40-chall] $(date -u +%Y-%m-%dT%H:%M:%SZ) $*" | tee -a "$LOG"; }

log "START chall relaunch (triton __triton_launcher.so ImportError mid-load)"

ts=$(date -u +%Y%m%dT%H%M%SZ)
for f in h40_decision.json h40_sim_result.json h40_sim_result_artifact.json \
         h40_sim_progress.json; do
  if [[ -f "/root/affine_data/$f" ]]; then
    mv "/root/affine_data/$f" "$QDIR/${f%.json}_pass212_${ts}.json"
    log "quarantine $f → $QDIR"
  fi
done
rm -f /root/logs/h40_n80.done /root/logs/h40_n80_retry.aborted \
  /root/logs/h40_pipeline.aborted /root/logs/h40_chall_serve.done

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
  /[r]un_sim_duel\.py/ && /local-h40/ {print $1}
  /[r]etry_h40_n80\.sh/ {print $1}
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
print(f"[recover212-h40-chall] reap gpu={sorted(want)} workers={sorted(pids)} parents={sorted(parents)} grandparents={sorted(grandparents)}")
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
PY

for i in 1 2 3 4 5 6 7 8 9 10; do
  free_ok=$(nvidia-smi --query-gpu=index,memory.used --format=csv,noheader,nounits \
    | awk -F',' -v g="$GPUS" 'BEGIN{split(g,a,","); for(i in a) want[a[i]+0]=1}
      {gsub(/ /,"",$1); gsub(/ /,"",$2); if(($1+0) in want && ($2+0)<500) n++}
      END{print n+0}')
  need=$(echo "$GPUS" | awk -F',' '{print NF}')
  log "free-check gpus$GPUS used<500MiB count=$free_ok/$need try=$i"
  if [[ "$free_ok" -ge "$need" ]]; then
    break
  fi
  sleep 2
done

log "wipe role chall caches"
rm -rf /root/.triton/cache/chall /root/.triton/cache/chall_* || true
rm -rf /root/.cache/flashinfer/cached_ops/sampling || true
rm -rf /tmp/torchinductor_* /root/.cache/torch/inductor || true
log "settle 20s after wipe"
sleep 20
mkdir -p "$TCACHE" /root/.cache/torchinductor_$TAG
export TORCHINDUCTOR_CACHE_DIR=/root/.cache/torchinductor_$TAG
export TRITON_CACHE_DIR=$TCACHE

: >"$CHALL_LOG"
log "launch chall port=8002 gpus=$GPUS util=$UTIL TCACHE=$TCACHE merge=$MERGE"
CUDA_VISIBLE_DEVICES=$GPUS TRITON_CACHE_DIR=$TCACHE nohup vllm serve "$MERGE" \
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

# Rearm watcher (may have been mid-poll; clears aborted so fresh wait).
# Kill only the local watcher argv, not SSH.
while read -r pid; do
  [[ -n "${pid:-}" ]] || continue
  log "kill old watcher pid=$pid"
  kill "$pid" 2>/dev/null || true
  sleep 1
  kill -9 "$pid" 2>/dev/null || true
done < <(ps -eo pid,args | awk '/[w]atch_n80_retry\.sh/ && / h40 / {print $1}')
sleep 1
nohup bash /root/mining_src/s4-h2-merge/watch_n80_retry.sh h40 \
  /root/mining_src/s4-h40-m7-winner-za-ep3/retry_h40_n80.sh \
  >/root/logs/h40_watch_retry.launch.nohup 2>&1 &
echo $! >/root/logs/h40_watch_retry.pid
log "rearmed watcher pid=$(cat /root/logs/h40_watch_retry.pid)"
log "DONE_LAUNCH (n80 waits for health+completions×2 probe)"
