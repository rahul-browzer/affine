#!/usr/bin/env bash
# Pass 448: F21 chall zombie after Triton ENOENT
# (NODUTTS4…/__triton_launcher.so) @02:28Z → shm_broadcast hang.
# Reap GPUs 4,5; wipe bare chall TCACHE; seed from king (n_so≥16);
# relaunch util=0.72. Leave teacher (p447 load) + king alone.
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

MERGE_DIR=${MERGE_DIR:-/root/h116/chall}
UTIL=${UTIL:-0.72}
export GPUS=${GPUS:-4,5}
LOG=/root/logs/vllm_chall.log
PIDF=/root/logs/vllm_chall.pid
RLOG=/root/logs/h116_chall_recover_pass448.log
TCACHE=/root/.triton/cache/chall
KING_TC=/root/.triton/cache/king
mkdir -p /root/logs /root/affine_data
: >"$RLOG"

log() { echo "[recover448-h116-chall] $(date -u +%Y-%m-%dT%H:%M:%SZ) $*" | tee -a "$RLOG"; }

log "START chall relaunch MERGE=$MERGE_DIR util=$UTIL (wipe+king-seed TCACHE)"

# Quarantine any partial n80 artifacts (FALSE_PROBE path; not a verdict).
ts=$(date -u +%Y%m%dT%H%M%SZ)
QDIR=/root/affine_data/false_probes
mkdir -p "$QDIR"
for f in h116_decision.json h116_sim_result.json h116_sim_result_artifact.json \
         h116_sim_progress.json; do
  if [[ -f "/root/affine_data/$f" ]]; then
    mv "/root/affine_data/$f" "$QDIR/${f%.json}_pass448_${ts}.json"
    log "quarantine $f → $QDIR"
  fi
done
rm -f /root/logs/h116_chall_serve.done /root/logs/h116_n80.done \
  /root/logs/h116_sim_n80.done

# Stop APIServer by pidfile then reap GPU holders (never pkill -f over broad patterns).
if [[ -f "$PIDF" ]]; then
  old=$(cat "$PIDF" || true)
  if [[ -n "${old:-}" ]] && kill -0 "$old" 2>/dev/null; then
    log "kill chall api pid=$old"
    kill "$old" 2>/dev/null || true
    sleep 2
    kill -9 "$old" 2>/dev/null || true
  fi
  rm -f "$PIDF"
fi

# Also kill serve parent if still alive without pidfile.
while read -r pid; do
  [[ -n "${pid:-}" ]] || continue
  log "kill chall serve pid=$pid"
  kill "$pid" 2>/dev/null || true
  sleep 1
  kill -9 "$pid" 2>/dev/null || true
done < <(ps -eo pid,args | awk '/[v]llm serve .*--port 8002/ {print $1}')

export GPUS
python - <<'PY' | tee -a "$RLOG"
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
            try:
                with open(f"/proc/{ppid}/stat") as f:
                    body2 = f.read()
                r2 = body2.rfind(")")
                gppid = int(body2[r2 + 2 :].split()[1])
                if gppid > 1:
                    grandparents.add(gppid)
            except Exception:
                pass
    except Exception:
        pass
kill_set = pids | parents | grandparents
print(f"[recover448] reap gpu={sorted(want)} workers={sorted(pids)} parents={sorted(parents)} grandparents={sorted(grandparents)}")
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

# Wipe bare chall TCACHE (broken NODUTTS4 launcher.so) then seed from king.
log "wipe role chall caches"
rm -rf "$TCACHE"
mkdir -p "$TCACHE"
if [[ -d "$KING_TC" ]]; then
  n_king=$(find "$KING_TC" -name '*.so' 2>/dev/null | wc -l)
  log "seed chall TCACHE from king n_so=$n_king"
  rsync -a --delete "$KING_TC"/ "$TCACHE"/ || cp -a "$KING_TC"/. "$TCACHE"/
else
  log "WARN no king TCACHE at $KING_TC — cold chall cache"
fi
n_seed=$(find "$TCACHE" -name '*.so' 2>/dev/null | wc -l)
log "chall TCACHE seeded n_so=$n_seed (writable)"

: >"$LOG"
log "launch chall port=8002 gpus=$GPUS util=$UTIL TCACHE=$TCACHE"
CUDA_VISIBLE_DEVICES=$GPUS TRITON_CACHE_DIR=$TCACHE nohup vllm serve "$MERGE_DIR" \
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
  >"$LOG" 2>&1 &
echo $! >"$PIDF"
log "chall_pid=$(cat "$PIDF") log=$LOG"
log "DONE_LAUNCH (teacher+king left; n80 watcher will wait health+completions)"
