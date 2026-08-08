#!/usr/bin/env bash
# Pass 340: re-fire king after p339 ABORT early Triton launcher ENOENT
# (NODUTTS4…/__triton_launcher.so @17:08:26Z poll=12). Kill zombie :8001
# left by p339 abort. Fresh isolated TCACHE + util=0.72. Leave merge/post_train.
# No completions probe (H85).
set -euo pipefail
source /root/venv/bin/activate
set -a
# shellcheck disable=SC1091
[ -f /root/mine.env ] && source /root/mine.env
set +a
export HF_HOME=/root/hf
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
if [[ -x "${_CU13}/bin/nvcc" ]]; then
  export CUDA_HOME=${CUDA_HOME:-$_CU13}
  export CUDA_PATH=$CUDA_HOME
  export PATH="${CUDA_HOME}/bin:${PATH}"
  export LD_LIBRARY_PATH="${CUDA_HOME}/lib:${CUDA_HOME}/lib64:${LD_LIBRARY_PATH:-}"
fi

LOGN=/root/logs/h91_king_recover_pass340.nohup
log() { echo "[king340-h91] $(date -u +%Y-%m-%dT%H:%M:%SZ) $*" | tee -a "$LOGN"; }

log "START king-only recover (p340 re-fire after p339 Triton ENOENT NODUTTS4; leave merge/post_train/teacher)"

python - <<'PY'
import os, signal, subprocess, time
want = {2, 3}
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
print(f"[king340-h91] reap gpus2,3 pids={sorted(pids)}")
for pid in pids:
    try:
        os.kill(pid, signal.SIGTERM)
    except OSError:
        pass
time.sleep(2)
for pid in pids:
    try:
        os.kill(pid, signal.SIGKILL)
    except OSError:
        pass
PY

if [[ -f /root/logs/vllm_king.pid ]]; then
  old=$(cat /root/logs/vllm_king.pid)
  if kill -0 "$old" 2>/dev/null; then
    log "kill stale king APIServer pid=$old"
    kill "$old" 2>/dev/null || true
    sleep 2
    kill -9 "$old" 2>/dev/null || true
  fi
  rm -f /root/logs/vllm_king.pid
fi

python - <<'PY'
import os, signal, subprocess
for line in subprocess.check_output(["ps", "aux"], text=True).splitlines():
    if "vllm" in line and "serve" in line and "--port 8001" in line:
        pid = int(line.split()[1])
        print(f"[king340-h91] kill leftover :8001 pid={pid}")
        try:
            os.kill(pid, signal.SIGTERM)
        except OSError:
            pass
PY
sleep 3

# Second pass: only leftover :8001 APIServer (GPU 2,3 already reaped above).
# Do NOT sweep all EngineCore — that kills teacher on GPUs 0,1.
python - <<'PY'
import os, signal, subprocess
for line in subprocess.check_output(["ps", "aux"], text=True).splitlines():
    if "vllm" in line and "serve" in line and "--port 8001" in line:
        pid = int(line.split()[1])
        print(f"[king340-h91] kill -9 leftover :8001 pid={pid}")
        try:
            os.kill(pid, signal.SIGKILL)
        except OSError:
            pass
PY
sleep 3

rm -f /root/affine_data/h91_sim_result.json /root/affine_data/h91_sim_progress.json \
  /root/affine_data/h91_decision.json /root/logs/h91_n80.done /root/logs/h91_n80_retry.aborted \
  /root/logs/h91_king_recover_pass311.done /root/logs/h91_sim_n80.done \
  /root/logs/h91_king_recover_pass332.done /root/logs/h91_king_recover_pass339.done \
  /root/logs/h91_king_recover_pass340.done
log "cleared stale h91 sim progress/result"

log "wipe bare king cache + failed p339 isolated TCACHE"
rm -rf /root/.triton/cache/king
rm -rf /root/.triton/cache/king_* 2>/dev/null || true
rm -rf /root/.triton/isolated/h91_king_p339_* 2>/dev/null || true
TCACHE="/root/.triton/isolated/h91_king_p340_$(date +%s)_$$"
mkdir -p "$TCACHE"
echo "$TCACHE" >/root/logs/h91_king_tcache_pass340.path
log "isolated TCACHE=$TCACHE"
log "settle 30s"
sleep 30

python - <<'PY'
import subprocess, sys
out = subprocess.check_output(
    ["nvidia-smi", "--query-gpu=index,memory.used", "--format=csv,noheader,nounits"],
    text=True,
)
ok = 0
for line in out.strip().splitlines():
    idx, used = [p.strip() for p in line.split(",")]
    if int(idx) in (2, 3):
        print(f"[king340-h91] gpu{idx} used_mib={used}")
        if float(used) < 500:
            ok += 1
if ok < 2:
    print("[king340-h91] ABORT: gpus 2,3 not free")
    sys.exit(1)
PY

REPO=Tok331102/affine-5EqYW8McUc-af10
REV=eb8bf9a356a254f71faaa439e8abc3cfba572c53
LOG=/root/logs/vllm_king.log
: >"$LOG"
log "start $REPO@$REV port=8001 gpus=2,3 util=0.72 TCACHE=$TCACHE"
CUDA_VISIBLE_DEVICES=2,3 TRITON_CACHE_DIR=$TCACHE \
  nohup vllm serve "$REPO" \
  --port 8001 \
  --revision "$REV" \
  --tensor-parallel-size 2 \
  --max-model-len 32768 \
  --gpu-memory-utilization 0.72 \
  --max-num-batched-tokens 8192 \
  --attention-backend FLASH_ATTN \
  --attention-config.use_trtllm_attention 0 \
  --compilation-config.pass_config.fuse_allreduce_rms false \
  --moe-backend triton \
  --additional-config '{"gdn_prefill_backend": "triton"}' \
  >"$LOG" 2>&1 &
echo $! >/root/logs/vllm_king.pid
log "king pid=$(cat /root/logs/vllm_king.pid) log=$LOG"

for i in $(seq 1 180); do
  if grep -q '__triton_launcher.*cannot open shared object file' "$LOG" 2>/dev/null \
    || grep -q 'ImportError: .*/__triton_launcher' "$LOG" 2>/dev/null; then
    log "ABORT early: Triton launcher ENOENT in king log at poll=$i — next pass must re-fire"
    exit 2
  fi
  if grep -q 'CUDA out of memory' "$LOG" 2>/dev/null; then
    log "ABORT early: CUDA OOM in king log at poll=$i — next pass must re-fire (lower util?)"
    exit 3
  fi
  code=$(curl -s -o /dev/null -w "%{http_code}" --max-time 3 http://127.0.0.1:8001/health || true)
  if [[ "$code" == "200" ]]; then
    mid=$(curl -s --max-time 5 http://127.0.0.1:8001/v1/models \
      | python3 -c 'import sys,json; d=json.load(sys.stdin); print(d["data"][0]["id"] if d.get("data") else "")' 2>/dev/null || true)
    if [[ -n "$mid" ]]; then
      log "KING HEALTHY mid=$mid poll=$i TCACHE=$TCACHE util=0.72 (no completions probe)"
      date -u +%Y-%m-%dT%H:%M:%SZ >/root/logs/h91_king_recover_pass340.done
      echo "$REPO $REV $TCACHE util=0.72" >>/root/logs/h91_king_recover_pass340.done
      log "DONE — post_train/retry_h91_n80 can proceed once chall up"
      exit 0
    fi
  fi
  (( i % 6 == 0 )) && log "wait king health poll=$i/180 health=$code"
  sleep 10
done
log "ABORT: king never healthy"
exit 1
