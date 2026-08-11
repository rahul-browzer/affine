#!/usr/bin/env bash
# p2124: reseat H122 chall at resolved path + max_model_len=65536.
# FALSE_PROBE was 404: sim uses /tmp/h122_merged, serve id was /root/h122/merged.
set -euo pipefail
exec >>/root/logs/p2124_reseat_chall.nohup 2>&1
log(){ echo "[p2124-r5] $(date -u +%Y-%m-%dT%H:%M:%SZ) $*"; }
log START
# shellcheck disable=SC1091
source /root/venv/bin/activate
if [[ -f /root/mine.env ]]; then set -a; source /root/mine.env; set +a; fi
export HF_HOME=${HF_HOME:-/root/hf}
export VLLM_USE_FLASHINFER_SAMPLER=0 VLLM_ALLREDUCE_USE_FLASHINFER=0
export VLLM_USE_FLASHINFER_MOE_FP16=0 VLLM_USE_FLASHINFER_MOE_FP8=0 VLLM_USE_FLASHINFER_MOE_FP4=0
export VLLM_USE_DEEP_GEMM=0 VLLM_MOE_USE_DEEP_GEMM=0
_SITE=$(python -c "import site; print(site.getsitepackages()[0])")
_CU13="${_SITE}/nvidia/cu13"
if [[ -x "${_CU13}/bin/nvcc" ]]; then
  export CUDA_HOME=$_CU13 CUDA_PATH=$_CU13
  export LD_LIBRARY_PATH="${CUDA_HOME}/lib:${CUDA_HOME}/lib64:${LD_LIBRARY_PATH:-}"
fi

SELF=$$
kill_match() {
  local pat=$1
  python3 - "$pat" "$SELF" <<'PY'
import os, signal, sys, subprocess
pat, self = sys.argv[1], int(sys.argv[2])
out = subprocess.check_output(["ps", "-eo", "pid,args"], text=True)
for line in out.splitlines():
    parts = line.split(None, 1)
    if len(parts) < 2: continue
    try: pid = int(parts[0])
    except ValueError: continue
    if pid in (self, os.getpid(), os.getppid()): continue
    cmd = parts[1]
    if pat not in cmd: continue
    # never kill our own wrapper / ssh parents
    if "p2124_reseat_chall" in cmd: continue
    if cmd.strip().startswith("bash -c"): continue
    try:
        os.kill(pid, signal.SIGTERM)
        print(f"TERM {pid} {cmd[:120]}")
    except ProcessLookupError:
        pass
PY
}

# Stop n80 / watchers (pattern without embedding serve argv)
for pat in \
  "retry_h122_n80_d203first" \
  "watch_n80_retry.sh h122" \
  "watch_form_decision.sh h122" \
  "run_sim_duel.py"; do
  kill_match "$pat" || true
done
sleep 2
for pat in \
  "retry_h122_n80_d203first" \
  "watch_n80_retry.sh h122" \
  "watch_form_decision.sh h122" \
  "run_sim_duel.py"; do
  python3 - "$pat" "$SELF" <<'PY' || true
import os, signal, sys, subprocess
pat, self = sys.argv[1], int(sys.argv[2])
out = subprocess.check_output(["ps", "-eo", "pid,args"], text=True)
for line in out.splitlines():
    parts = line.split(None, 1)
    if len(parts) < 2: continue
    try: pid = int(parts[0])
    except ValueError: continue
    if pid in (self, os.getpid(), os.getppid()): continue
    cmd = parts[1]
    if pat not in cmd or "p2124_reseat_chall" in cmd or cmd.strip().startswith("bash -c"): continue
    try: os.kill(pid, signal.SIGKILL)
    except ProcessLookupError: pass
PY
done
log "stopped n80/watchers"

# Kill chall via PID file + exact python argv (must start with venv python, contain port 8002)
PIDF=/root/logs/vllm_chall.pid
if [[ -f $PIDF ]]; then
  old=$(cat "$PIDF" || true)
  if [[ -n "${old:-}" ]] && kill -0 "$old" 2>/dev/null; then
    kill "$old" 2>/dev/null || true
    sleep 2
    kill -9 "$old" 2>/dev/null || true
    log "killed chall pidfile $old"
  fi
  rm -f "$PIDF"
fi
python3 - <<'PY'
import os, signal, subprocess, time
out = subprocess.check_output(["ps", "-eo", "pid,args"], text=True)
for line in out.splitlines():
    parts = line.split(None, 1)
    if len(parts) < 2: continue
    try: pid = int(parts[0])
    except ValueError: continue
    cmd = parts[1]
    # exact APIServer pattern only
    if "/venv/bin/vllm" in cmd and " serve " in cmd and "--port 8002" in cmd:
        try:
            os.kill(pid, signal.SIGTERM)
            print("TERM chall", pid)
        except ProcessLookupError:
            pass
time.sleep(2)
out = subprocess.check_output(["ps", "-eo", "pid,args"], text=True)
for line in out.splitlines():
    parts = line.split(None, 1)
    if len(parts) < 2: continue
    try: pid = int(parts[0])
    except ValueError: continue
    cmd = parts[1]
    if "/venv/bin/vllm" in cmd and " serve " in cmd and "--port 8002" in cmd:
        try:
            os.kill(pid, signal.SIGKILL)
            print("KILL chall", pid)
        except ProcessLookupError:
            pass
# reap GPU 4,5 orphans
want = {4, 5}
idx_to_uuid = {}
for line in subprocess.check_output(
    ["nvidia-smi", "--query-gpu=index,uuid", "--format=csv,noheader,nounits"], text=True
).strip().splitlines():
    a, b = [x.strip() for x in line.split(",", 1)]
    idx_to_uuid[int(a)] = b
uuids = {idx_to_uuid[i] for i in want if i in idx_to_uuid}
apps = subprocess.check_output(
    ["nvidia-smi", "--query-compute-apps=gpu_uuid,pid", "--format=csv,noheader,nounits"], text=True
)
pids = set()
for line in (apps.strip().splitlines() or []):
    parts = [p.strip() for p in line.split(",")]
    if len(parts) >= 2 and parts[0] in uuids:
        try: pids.add(int(parts[1]))
        except ValueError: pass
for pid in pids:
    try:
        os.kill(pid, signal.SIGKILL)
        print("reap gpu", pid)
    except ProcessLookupError:
        pass
PY
sleep 3
log "chall cleared"

# Patch helper for future relaunches
SRC=/root/mining_src/s3-duel-sim/relaunch_chall_072.sh
if [[ -f $SRC ]] && grep -q -- '--max-model-len 32768' "$SRC"; then
  cp -a "$SRC" "${SRC}.bak.p2124"
  sed 's/--max-model-len 32768/--max-model-len 65536/' "$SRC" > "${SRC}.new"
  mv "${SRC}.new" "$SRC"
  log "patched relaunch_chall_072.sh -> 65536"
fi

MERGE_DIR=/tmp/h122_merged
[[ -d $MERGE_DIR ]] || { log "FATAL missing $MERGE_DIR"; exit 1; }
UTIL=0.72
GPUS=4,5
TCACHE=/root/.triton/cache/chall
mkdir -p "$TCACHE" /root/logs
LOG=/root/logs/vllm_chall.log
: > "$LOG"
log "launch chall path=$MERGE_DIR max_model_len=65536"
CUDA_VISIBLE_DEVICES=$GPUS TRITON_CACHE_DIR=$TCACHE nohup vllm serve "$MERGE_DIR" \
  --port 8002 --gpu-memory-utilization "$UTIL" --tensor-parallel-size 2 \
  --max-model-len 65536 --max-num-batched-tokens 8192 \
  --attention-backend FLASH_ATTN --attention-config.use_trtllm_attention 0 \
  --compilation-config.pass_config.fuse_allreduce_rms false --moe-backend triton \
  --additional-config '{"gdn_prefill_backend": "triton"}' \
  >"$LOG" 2>&1 &
echo $! >"$PIDF"
log "chall pid=$(cat "$PIDF")"

ok=0
for i in $(seq 1 240); do
  code=$(curl -s -o /dev/null -w "%{http_code}" --max-time 3 http://127.0.0.1:8002/health || true)
  if [[ "$code" == "200" ]]; then
    mid=$(curl -s --max-time 5 http://127.0.0.1:8002/v1/models \
      | python3 -c 'import sys,json; d=json.load(sys.stdin); x=d["data"][0]; print(x["id"], x.get("max_model_len"))' 2>/dev/null || true)
    log "health200 mid/max=$mid poll=$i"
    code2=$(curl -s -o /tmp/_p2124_probe.json -w "%{http_code}" --max-time 90 \
      http://127.0.0.1:8002/v1/completions \
      -H 'Content-Type: application/json' \
      -d '{"model":"/tmp/h122_merged","prompt":"hi","max_tokens":2}' || true)
    log "completions_/tmp/h122_merged code=$code2"
    if [[ "$code2" == "200" ]]; then ok=1; break; fi
  fi
  (( i % 6 == 0 )) && log "wait chall poll=$i code=$code"
  sleep 10
done
[[ $ok -eq 1 ]] || { log "FATAL chall not promptable"; exit 2; }

# Arm watchers + direct retry
nohup bash /root/mining_src/s4-h2-merge/watch_form_decision.sh h122 \
  /root/affine_data/h122_sim_result.json /root/affine_data/h122_decision.json \
  /root/logs/h122_form_decision.nohup > /root/logs/h122_form_decision.launch.nohup 2>&1 &
echo $! > /root/logs/h122_form_decision.pid
nohup bash /root/mining_src/s4-h2-merge/watch_n80_retry.sh h122 \
  /root/mining_src/s4-h122-f27-genesis-full-ft/retry_h122_n80_d203first.sh \
  > /root/logs/h122_n80_retry.launch 2>&1 &
echo $! > /root/logs/h122_n80_retry.pid
nohup bash /root/mining_src/s4-h122-f27-genesis-full-ft/retry_h122_n80_d203first.sh \
  > /root/logs/h122_n80_retry.direct.nohup 2>&1 &
echo $! > /root/logs/h122_n80_retry.direct.pid
log "armed form=$(cat /root/logs/h122_form_decision.pid) watch=$(cat /root/logs/h122_n80_retry.pid) direct=$(cat /root/logs/h122_n80_retry.direct.pid)"
log DONE
