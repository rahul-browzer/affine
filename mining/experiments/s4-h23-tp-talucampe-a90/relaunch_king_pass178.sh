#!/usr/bin/env bash
# Pass 178: king died again on Triton __triton_launcher.so race after health=200.
# Wipe caches, unique TRITON_CACHE_DIR, relaunch king on GPUs 2,3; then wait+probe+n80.
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

LOG=/root/logs/h23_king_recover_pass178.log
KING_LOG=/root/logs/vllm_king.log
PIDF=/root/logs/vllm_king.pid
export GPUS=2,3
UTIL=0.80
KING_REPO=TalentPigs/affine-5ekxlcg3fx-abc
KING_REV=dbfbb3e2a17c7603e7fc68a3a15b343f42dfdef4
TCACHE=/root/.triton/cache/king_$(date +%s)_$$
mkdir -p "$TCACHE" /root/logs
: >"$LOG"

log() { echo "[recover178] $(date -u +%Y-%m-%dT%H:%M:%SZ) $*" | tee -a "$LOG"; }

log "START king Triton relaunch TCACHE=$TCACHE"

# Stop stuck recover-waits / start_h23 from pass176 (by PID file + narrow argv).
if [[ -f /root/logs/h23_recover_wait.pid ]]; then
  old=$(cat /root/logs/h23_recover_wait.pid || true)
  if [[ -n "${old:-}" ]] && kill -0 "$old" 2>/dev/null; then
    kill -9 "$old" 2>/dev/null || true
    log "killed old recover_wait pid=$old"
  fi
fi
for p in $(ps -eo pid,cmd | awk '/bash -c .*waiting king health\+probe/ {print $1}'); do
  kill -9 "$p" 2>/dev/null || true
  log "killed recover-wait pid=$p"
done
for p in $(ps -eo pid,cmd | awk '/[s]tart_h23_n80\.sh/ {print $1}'); do
  kill -9 "$p" 2>/dev/null || true
  log "killed start_h23_n80 pid=$p"
done

# Stop dead APIServer residue on :8001
if [[ -f "$PIDF" ]]; then
  old=$(cat "$PIDF" || true)
  if [[ -n "${old:-}" ]] && kill -0 "$old" 2>/dev/null; then
    kill "$old" 2>/dev/null || true
    sleep 2
    kill -9 "$old" 2>/dev/null || true
  fi
  rm -f "$PIDF"
fi
# Narrow port-based kill — never pkill -f the full serve string (SSH cmdline hazard).
for p in $(ss -lptn 'sport = :8001' 2>/dev/null | awk -Fpid= 'NF>1{split($2,a,","); print a[1]}'); do
  kill -9 "$p" 2>/dev/null || true
done

# Reap orphans on GPUs 2,3 by index→uuid→pid (LESSON).
python - <<'PY' | tee -a "$LOG"
import subprocess, os, signal, time
gpus = os.environ.get("GPUS", "2,3")
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
kill_set = pids | parents
print(f"[recover178] reap gpu={sorted(want)} workers={sorted(pids)} parents={sorted(parents)}")
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

# Re-apply B300 FA patch (may have been lost across venv).
if [[ -x /root/mining_src/s3-duel-sim/patch_b300_sm103_flash_attn.sh ]]; then
  bash /root/mining_src/s3-duel-sim/patch_b300_sm103_flash_attn.sh >>"$LOG" 2>&1 || true
  log "FA patch attempted"
fi

# Wipe half-written Triton / flashinfer / inductor for king role (pass178: died mid CUDA-graph).
rm -rf /root/.triton/cache/king_* || true
rm -rf /root/.cache/flashinfer/cached_ops/sampling || true
rm -rf /root/.cache/flashinfer/cached_ops || true
rm -rf /tmp/torchinductor_* /root/.cache/torch/inductor || true
mkdir -p "$TCACHE" /root/.cache/torchinductor_king_$$
export TORCHINDUCTOR_CACHE_DIR=/root/.cache/torchinductor_king_$$

: >"$KING_LOG"
log "launch king port=8001 gpus=$GPUS util=$UTIL TCACHE=$TCACHE"
CUDA_VISIBLE_DEVICES=$GPUS TRITON_CACHE_DIR=$TCACHE nohup vllm serve "$KING_REPO" \
  --port 8001 \
  --tensor-parallel-size 2 \
  --max-model-len 32768 \
  --gpu-memory-utilization "$UTIL" \
  --max-num-batched-tokens 8192 \
  --attention-backend FLASH_ATTN \
  --attention-config.use_trtllm_attention 0 \
  --compilation-config.pass_config.fuse_allreduce_rms false \
  --moe-backend triton \
  --additional-config '{"gdn_prefill_backend": "triton"}' \
  --revision "$KING_REV" \
  >"$KING_LOG" 2>&1 &
echo $! >"$PIDF"
log "king_pid=$(cat "$PIDF")"

# Background wait+probe+n80 (fresh wait clock).
nohup bash -c '
set -euo pipefail
LOG=/root/logs/h23_king_recover_pass178.log
echo "[recover-wait178] $(date -u +%Y-%m-%dT%H:%M:%SZ) waiting king health+probe" >>"$LOG"
ok=0
for i in $(seq 1 160); do
  k=$(curl -s -o /dev/null -w "%{http_code}" --max-time 3 http://127.0.0.1:8001/health || true)
  t=$(curl -s -o /dev/null -w "%{http_code}" --max-time 3 http://127.0.0.1:8000/health || true)
  c=$(curl -s -o /dev/null -w "%{http_code}" --max-time 3 http://127.0.0.1:8002/health || true)
  if [[ "$k" == "200" && "$t" == "200" && "$c" == "200" ]]; then
    echo "[recover-wait178] health t=$t k=$k c=$c at i=$i $(date -u +%Y-%m-%dT%H:%M:%SZ)" >>"$LOG"
    # brief settle after health before first completions (LESSON: health≠alive)
    sleep 20
    probe=$(curl -s --max-time 180 http://127.0.0.1:8001/v1/completions \
      -H "Content-Type: application/json" \
      -d "{\"model\":\"TalentPigs/affine-5ekxlcg3fx-abc\",\"prompt\":\"hi\",\"max_tokens\":4,\"temperature\":0}" \
      | python3 -c "import sys,json; d=json.load(sys.stdin); print(\"ok\" if d.get(\"choices\") else \"bad\")" 2>/dev/null || echo fail)
    echo "[recover-wait178] king_completions_probe=$probe i=$i" >>"$LOG"
    if [[ "$probe" == "ok" ]]; then
      ok=1
      break
    fi
  fi
  # bail early if APIServer pid died (else wait spins for ~40m on empty GPUs)
  if [[ -f /root/logs/vllm_king.pid ]]; then
    kpid=$(cat /root/logs/vllm_king.pid || true)
    if [[ -n "${kpid:-}" ]] && ! kill -0 "$kpid" 2>/dev/null; then
      echo "[recover-wait178] ERROR king pid=$kpid dead at i=$i $(date -u +%Y-%m-%dT%H:%M:%SZ)" >>"$LOG"
      exit 1
    fi
  fi
  if (( i % 10 == 0 )); then
    echo "[recover-wait178] i=$i t=$t k=$k c=$c $(date -u +%Y-%m-%dT%H:%M:%SZ)" >>"$LOG"
  fi
  sleep 15
done
if [[ "$ok" != "1" ]]; then
  echo "[recover-wait178] ERROR king never became promptable" >>"$LOG"
  exit 1
fi
for p in $(ps -eo pid,cmd | awk "/[s]tart_h23_n80\\.sh/ {print \$1}"); do
  kill -9 "$p" 2>/dev/null || true
done
source /root/venv/bin/activate
set -a; source /root/mine.env; set +a
export PYTHONPATH=/root/mining_src/affine_pkg${PYTHONPATH:+:$PYTHONPATH}
export HF_HOME=${HF_HOME:-/root/hf}
nohup bash /root/mining_src/s4-h23-tp-talucampe-a90/start_h23_n80.sh \
  >/root/logs/h23_n80_relaunch_pass178.nohup 2>&1 &
echo $! >/root/logs/h23_n80_relaunch_pass178.pid
echo "[recover-wait178] relaunched start_h23_n80 pid=$(cat /root/logs/h23_n80_relaunch_pass178.pid) $(date -u +%Y-%m-%dT%H:%M:%SZ)" >>"$LOG"
' >/root/logs/h23_recover_wait178.nohup 2>&1 &
echo $! >/root/logs/h23_recover_wait.pid
log "wait_pid=$(cat /root/logs/h23_recover_wait.pid)"
log "DONE_LAUNCH"
