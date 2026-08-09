#!/usr/bin/env bash
# Pass 454: F18 teacher+chall hung on shm_broadcast ~15m (:8000/:8002=000)
# while king :8001=200 on GPUs 2,3. Reap 0,1 + 4,5; leave king; wipe role
# caches; seed chall from king TCACHE; relaunch both with unique TCACHEs.
set -euo pipefail
HYPO=h113
CHALL=/root/h113/chall
source /root/venv/bin/activate
if [[ -f /root/mine.env ]]; then set -a; source /root/mine.env; set +a; fi
export HF_HOME=${HF_HOME:-/root/hf}
export VLLM_USE_FLASHINFER_SAMPLER=0 VLLM_ALLREDUCE_USE_FLASHINFER=0
export VLLM_USE_FLASHINFER_MOE_FP16=0 VLLM_USE_FLASHINFER_MOE_FP8=0 VLLM_USE_FLASHINFER_MOE_FP4=0
export VLLM_DEEP_GEMM=0 VLLM_USE_DEEP_GEMM=0 VLLM_MOE_USE_DEEP_GEMM=0
_SITE=$(python - <<'PY'
import site; print(site.getsitepackages()[0])
PY
)
_CU13="${_SITE}/nvidia/cu13"
if [[ -x "${_CU13}/bin/nvcc" && -f "${_CU13}/include/cuda_fp16.h" ]]; then
  export CUDA_HOME=${CUDA_HOME:-$_CU13} CUDA_PATH=${CUDA_HOME:-$_CU13}
  export PATH="${CUDA_HOME}/bin:${PATH}"
  export LD_LIBRARY_PATH="${CUDA_HOME}/lib:${CUDA_HOME}/lib64:${LD_LIBRARY_PATH:-}"
  export LIBRARY_PATH="${CUDA_HOME}/lib:${CUDA_HOME}/lib64:${LIBRARY_PATH:-}"
fi
LOG=/root/logs/${HYPO}_recover_pass454.log
mkdir -p /root/logs
: >"$LOG"
log() { echo "[recover454-${HYPO}] $(date -u +%Y-%m-%dT%H:%M:%SZ) $*" | tee -a "$LOG"; }
log "START teacher+chall recover; leave king GPUs 2,3 alone"

reap_gpus() {
  local gpus="$1"
  GPUS="$gpus" python - <<'PY' | tee -a "$LOG"
import subprocess, os, signal, time
gpus = os.environ.get("GPUS", "0,1")
want = {int(x) for x in gpus.split(",") if x.strip() != ""}
out = subprocess.check_output(["nvidia-smi","--query-gpu=index,uuid","--format=csv,noheader,nounits"], text=True)
idx_to_uuid = {}
for line in out.strip().splitlines():
    parts = [p.strip() for p in line.split(",")]
    if len(parts) >= 2: idx_to_uuid[int(parts[0])] = parts[1]
uuids = {idx_to_uuid[i] for i in want if i in idx_to_uuid}
apps = subprocess.check_output(["nvidia-smi","--query-compute-apps=gpu_uuid,pid","--format=csv,noheader,nounits"], text=True)
pids=set()
for line in apps.strip().splitlines():
    if not line.strip(): continue
    parts=[p.strip() for p in line.split(",")]
    if len(parts)>=2 and parts[0] in uuids:
        try: pids.add(int(parts[1]))
        except ValueError: pass
parents=set(); grandparents=set()
for pid in list(pids):
    try:
        body=open(f"/proc/{pid}/stat").read(); r=body.rfind(")"); ppid=int(body[r+2:].split()[1])
        if ppid>1: parents.add(ppid)
    except Exception: pass
for pid in list(parents):
    try:
        body=open(f"/proc/{pid}/stat").read(); r=body.rfind(")"); ppid=int(body[r+2:].split()[1])
        if ppid>1: grandparents.add(ppid)
    except Exception: pass
kill_set=pids|parents|grandparents
print(f"[recover454] reap gpu={sorted(want)} workers={sorted(pids)} parents={sorted(parents)} grandparents={sorted(grandparents)}")
for pid in kill_set:
    try: os.kill(pid, signal.SIGTERM)
    except ProcessLookupError: pass
time.sleep(2)
for pid in kill_set:
    try: os.kill(pid, signal.SIGKILL)
    except ProcessLookupError: pass
PY
}

# Kill hung APIServers by port (parent may outlive workers)
for port in 8000 8002; do
  for p in $(ss -lptn "sport = :$port" 2>/dev/null | awk -Fpid= 'NF>1{split($2,a,","); print a[1]}'); do
    log "kill port=$port pid=$p"
    kill -9 "$p" 2>/dev/null || true
  done
done
# Also kill known serve PIDs if still alive
for pidf in /root/logs/vllm_teacher.pid /root/logs/vllm_chall.pid; do
  if [[ -f "$pidf" ]]; then
    old=$(cat "$pidf" || true)
    if [[ -n "${old:-}" ]]; then kill -9 "$old" 2>/dev/null || true; fi
    rm -f "$pidf"
  fi
done
# Kill parent vllm serve for teacher/chall by cmdline (not king)
while read -r pid; do
  [[ -n "${pid:-}" ]] || continue
  cmd=$(tr '\0' ' ' <"/proc/$pid/cmdline" 2>/dev/null || true)
  case "$cmd" in
    *"--port 8001"*|*Tok331102*) continue ;;
  esac
  log "kill serve pid=$pid"
  kill -9 "$pid" 2>/dev/null || true
done < <(ps -eo pid,cmd | awk '/[v]llm serve/ && (/--port 8000/ || /--port 8002/ || /GLM-4.5-Air/ || /h113\/chall/) {print $1}')

reap_gpus 0,1
reap_gpus 4,5

for i in 1 2 3 4 5 6 7 8 9 10; do
  free_ok=$(nvidia-smi --query-gpu=index,memory.used --format=csv,noheader,nounits \
    | awk -F',' 'BEGIN{want[0]=1;want[1]=1;want[4]=1;want[5]=1}
      {gsub(/ /,"",$1); gsub(/ /,"",$2); if(($1+0) in want && ($2+0)<500) n++}
      END{print n+0}')
  log "free-check gpus0,1,4,5 used<500MiB count=$free_ok/4 try=$i"
  [[ "$free_ok" -ge 4 ]] && break
  sleep 2
done

log "wipe teacher+chall caches (keep king)"
rm -rf /root/.triton/cache/teacher /root/.triton/cache/teacher_* || true
rm -rf /root/.triton/cache/chall /root/.triton/cache/chall_* \
  /root/.triton/cache/isolated/*chall* 2>/dev/null || true
rm -rf /root/.cache/flashinfer/cached_ops/sampling || true
rm -rf /tmp/torchinductor_* || true
log "settle 20s"
sleep 20

# Seed chall TCACHE from live king if available
KING_TCACHE=""
if [[ -f /root/logs/h113_king_tcache_pass332.path ]]; then
  KING_TCACHE=$(cat /root/logs/h113_king_tcache_pass332.path || true)
fi
if [[ -z "${KING_TCACHE:-}" || ! -d "${KING_TCACHE:-}" ]]; then
  # from live king environ
  kpid=$(ps -eo pid,cmd | awk '/[v]llm serve/ && /--port 8001/ {print $1; exit}')
  if [[ -n "${kpid:-}" && -r "/proc/$kpid/environ" ]]; then
    KING_TCACHE=$(tr '\0' '\n' <"/proc/$kpid/environ" | awk -F= '/^TRITON_CACHE_DIR=/{print $2; exit}')
  fi
fi
if [[ -z "${KING_TCACHE:-}" || ! -d "${KING_TCACHE:-}" ]]; then
  KING_TCACHE=$(ls -d /root/.triton/cache/king /root/.triton/cache/king_* /root/.triton/cache/isolated/*king* 2>/dev/null | head -1 || true)
fi
TAG=p454_$(date +%s)_$$
CHALL_TCACHE=/root/.triton/cache/chall_${TAG}
TEACHER_TCACHE=/root/.triton/cache/teacher_${TAG}
mkdir -p "$CHALL_TCACHE" "$TEACHER_TCACHE" \
  "/root/.cache/torchinductor_chall_${TAG}" "/root/.cache/torchinductor_teacher_${TAG}"
if [[ -n "${KING_TCACHE:-}" && -d "$KING_TCACHE" ]]; then
  n_so=$(find "$KING_TCACHE" -name '__triton_launcher.so' 2>/dev/null | wc -l)
  log "seed chall from king TCACHE=$KING_TCACHE n_so=$n_so"
  rsync -a --delete "$KING_TCACHE"/ "$CHALL_TCACHE"/ || cp -a "$KING_TCACHE"/. "$CHALL_TCACHE"/ || true
  n_so2=$(find "$CHALL_TCACHE" -name '__triton_launcher.so' 2>/dev/null | wc -l)
  log "chall TCACHE seeded n_so=$n_so2"
else
  log "WARN no king TCACHE to seed; chall starts cold"
fi

TEACHER_LOG=/root/logs/vllm_teacher.log
CHALL_LOG=/root/logs/vllm_chall.log
: >"$TEACHER_LOG"
: >"$CHALL_LOG"

log "launch teacher :8000 gpus=0,1 util=0.72 TCACHE=$TEACHER_TCACHE"
CUDA_VISIBLE_DEVICES=0,1 \
  TRITON_CACHE_DIR=$TEACHER_TCACHE \
  TORCHINDUCTOR_CACHE_DIR=/root/.cache/torchinductor_teacher_${TAG} \
  nohup vllm serve zai-org/GLM-4.5-Air-FP8 \
  --port 8000 --tensor-parallel-size 2 --max-model-len 32768 \
  --gpu-memory-utilization 0.72 --max-num-batched-tokens 8192 \
  --attention-backend FLASH_ATTN --attention-config.use_trtllm_attention 0 \
  --compilation-config.pass_config.fuse_allreduce_rms false --moe-backend triton \
  --additional-config '{"gdn_prefill_backend": "triton"}' \
  >"$TEACHER_LOG" 2>&1 &
echo $! >/root/logs/vllm_teacher.pid
log "teacher_pid=$(cat /root/logs/vllm_teacher.pid)"

sleep 15
log "launch chall :8002 gpus=4,5 util=0.72 TCACHE=$CHALL_TCACHE repo=$CHALL"
CUDA_VISIBLE_DEVICES=4,5 \
  TRITON_CACHE_DIR=$CHALL_TCACHE \
  TORCHINDUCTOR_CACHE_DIR=/root/.cache/torchinductor_chall_${TAG} \
  nohup vllm serve "$CHALL" \
  --port 8002 --tensor-parallel-size 2 --max-model-len 32768 \
  --gpu-memory-utilization 0.72 --max-num-batched-tokens 8192 \
  --attention-backend FLASH_ATTN --attention-config.use_trtllm_attention 0 \
  --compilation-config.pass_config.fuse_allreduce_rms false --moe-backend triton \
  --additional-config '{"gdn_prefill_backend": "triton"}' \
  >"$CHALL_LOG" 2>&1 &
echo $! >/root/logs/vllm_chall.pid
log "chall_pid=$(cat /root/logs/vllm_chall.pid)"
echo "$CHALL_TCACHE" >/root/logs/h113_chall_tcache_pass454.path
echo "$TEACHER_TCACHE" >/root/logs/h113_teacher_tcache_pass454.path
log "DONE_LAUNCH king left on :8001; expect promptable ~10-15m"
