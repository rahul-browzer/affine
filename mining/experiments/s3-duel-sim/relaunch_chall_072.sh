#!/usr/bin/env bash
# Kill chall (:8002) including orphan EngineCore/Workers on GPUs 4,5, then
# relaunch at gpu_memory_utilization=0.72. Teacher/king stay up.
# Usage: MERGE_DIR=/root/merges/h22-tp90 bash relaunch_chall_072.sh
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

MERGE_DIR=${MERGE_DIR:?set MERGE_DIR to local merge path}
UTIL=${UTIL:-0.72}
export GPUS=${GPUS:-4,5}
LOG=/root/logs/vllm_chall.log
PIDF=/root/logs/vllm_chall.pid
TCACHE=/root/.triton/cache/chall
mkdir -p "$TCACHE" /root/logs

echo "[relaunch-chall] $(date -u +%Y-%m-%dT%H:%M:%SZ) stop chall merge=$MERGE_DIR util=$UTIL gpus=$GPUS"

if [[ -f "$PIDF" ]]; then
  old=$(cat "$PIDF" || true)
  if [[ -n "${old:-}" ]] && kill -0 "$old" 2>/dev/null; then
    kill "$old" 2>/dev/null || true
    sleep 2
    kill -9 "$old" 2>/dev/null || true
  fi
  rm -f "$PIDF"
fi
pkill -f 'vllm serve .*--port 8002' 2>/dev/null || true
sleep 2

# Reap orphan workers still holding the chall GPUs (APIServer kill leaves them).
# Map physical GPU index → uuid → compute-app pids; kill those pids + their EngineCore parents.
python - <<'PY'
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
# Also kill parent EngineCore of those workers (walk ppid once).
parents = set()
for pid in list(pids):
    try:
        with open(f"/proc/{pid}/stat") as f:
            # pid (comm) state ppid ...
            body = f.read()
        rparen = body.rfind(")")
        fields = body[rparen + 2 :].split()
        ppid = int(fields[1])
        if ppid > 1:
            parents.add(ppid)
    except Exception:
        pass
kill_set = pids | parents
print(f"[relaunch-chall] reap gpu={sorted(want)} worker_pids={sorted(pids)} parents={sorted(parents)}")
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

# Wait until chall GPUs report near-zero used memory.
for i in 1 2 3 4 5 6 7 8 9 10; do
  free_ok=$(nvidia-smi --query-gpu=index,memory.used --format=csv,noheader,nounits \
    | awk -F',' -v g="$GPUS" 'BEGIN{split(g,a,","); for(i in a) want[a[i]+0]=1}
      {gsub(/ /,"",$1); gsub(/ /,"",$2); if(($1+0) in want && ($2+0)<500) n++}
      END{print n+0}')
  need=$(echo "$GPUS" | awk -F',' '{print NF}')
  echo "[relaunch-chall] free-check used<500MiB on $free_ok/$need of gpus=$GPUS (try $i)"
  if [[ "$free_ok" -ge "$need" ]]; then
    break
  fi
  sleep 2
done

: >"$LOG"
echo "[relaunch-chall] $(date -u +%Y-%m-%dT%H:%M:%SZ) start chall port=8002 gpus=$GPUS util=$UTIL"
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
echo "[relaunch-chall] pid=$(cat "$PIDF") log=$LOG"
echo "[relaunch-chall] $(date -u +%Y-%m-%dT%H:%M:%SZ) DONE_LAUNCH"
