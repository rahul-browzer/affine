#!/usr/bin/env bash
# Pass 332: H96 teacher dead — Triton ENOENT on bare cache/teacher
# (6YKNXZRS…/__triton_launcher.so @16:17:53Z → EngineDead; :8000=000).
# King also dead (separate king recover). Chall :8002=200 on isolated TCACHE —
# leave chall (GPUs 4,5) alone. Reap 0,1 → wipe teacher* → settle20 → unique TCACHE.
set -euo pipefail
HYPO=h96
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
LOG=/root/logs/${HYPO}_teacher_recover_pass332.log
TEACHER_LOG=/root/logs/vllm_teacher.log
PIDF=/root/logs/vllm_teacher.pid
export GPUS=0,1
UTIL=0.80
TEACHER_REPO=zai-org/GLM-4.5-Air-FP8
TAG=teacher_p332_$(date +%s)_$$
mkdir -p /root/logs
: >"$LOG"
log() { echo "[recover332-${HYPO}] $(date -u +%Y-%m-%dT%H:%M:%SZ) $*" | tee -a "$LOG"; }
log "START teacher relaunch (wipe→settle20→unique cache); leave chall alone"

if [[ -f "$PIDF" ]]; then
  old=$(cat "$PIDF" || true)
  if [[ -n "${old:-}" ]] && kill -0 "$old" 2>/dev/null; then
    kill "$old" 2>/dev/null || true; sleep 2; kill -9 "$old" 2>/dev/null || true
  fi
  rm -f "$PIDF"
fi
for p in $(ss -lptn 'sport = :8000' 2>/dev/null | awk -Fpid= 'NF>1{split($2,a,","); print a[1]}'); do
  kill -9 "$p" 2>/dev/null || true
done

python - <<'PY' | tee -a "$LOG"
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
print(f"[recover332] reap gpu={sorted(want)} workers={sorted(pids)} parents={sorted(parents)} grandparents={sorted(grandparents)}")
for pid in kill_set:
    try: os.kill(pid, signal.SIGTERM)
    except ProcessLookupError: pass
time.sleep(2)
for pid in kill_set:
    try: os.kill(pid, signal.SIGKILL)
    except ProcessLookupError: pass
PY

for i in 1 2 3 4 5 6 7 8 9 10; do
  free_ok=$(nvidia-smi --query-gpu=index,memory.used --format=csv,noheader,nounits \
    | awk -F',' -v g="$GPUS" 'BEGIN{split(g,a,","); for(i in a) want[a[i]+0]=1}
      {gsub(/ /,"",$1); gsub(/ /,"",$2); if(($1+0) in want && ($2+0)<500) n++}
      END{print n+0}')
  need=$(echo "$GPUS" | awk -F',' '{print NF}')
  log "free-check gpus$GPUS used<500MiB count=$free_ok/$need try=$i"
  [[ "$free_ok" -ge "$need" ]] && break
  sleep 2
done

log "wipe role teacher caches"
rm -rf /root/.triton/cache/teacher /root/.triton/cache/teacher_* || true
rm -rf /root/.cache/flashinfer/cached_ops/sampling || true
rm -rf /tmp/torchinductor_* /root/.cache/torch/inductor || true
log "settle 20s after wipe"
sleep 20
TCACHE=/root/.triton/cache/${TAG}
mkdir -p "$TCACHE" "/root/.cache/torchinductor_${TAG}"
export TORCHINDUCTOR_CACHE_DIR=/root/.cache/torchinductor_${TAG}
export TRITON_CACHE_DIR=$TCACHE
: >"$TEACHER_LOG"
log "launch teacher port=8000 gpus=$GPUS util=$UTIL TCACHE=$TCACHE"
CUDA_VISIBLE_DEVICES=$GPUS TRITON_CACHE_DIR=$TCACHE nohup vllm serve "$TEACHER_REPO" \
  --port 8000 --tensor-parallel-size 2 --max-model-len 32768 \
  --gpu-memory-utilization "$UTIL" --max-num-batched-tokens 8192 \
  --attention-backend FLASH_ATTN --attention-config.use_trtllm_attention 0 \
  --compilation-config.pass_config.fuse_allreduce_rms false --moe-backend triton \
  --additional-config '{"gdn_prefill_backend": "triton"}' \
  >"$TEACHER_LOG" 2>&1 &
echo $! >"$PIDF"
log "teacher_pid=$(cat "$PIDF")"
log "DONE_LAUNCH (chall stays; king recover separate)"
