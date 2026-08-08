#!/usr/bin/env bash
# Pass 249: H57 king :8001 hit __triton_launcher.so ENOENT mid-n80 (~4/80)
# while health still 200 (shm_broadcast hang). Kill stuck sim → reap GPUs 2,3 →
# outer×3 + seed from live chall TCACHE + PRE-FREEZE before w1. Teacher+chall stay.
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

LOG=/root/logs/h57_king_recover_pass249.log
KING_LOG=/root/logs/vllm_king.log
PIDF=/root/logs/vllm_king.pid
KING_REPO=TalentPigs/affine-5ekxlcg3fx-abc
KING_REV=dbfbb3e2a17c7603e7fc68a3a15b343f42dfdef4
export GPUS=2,3
UTIL=0.80
QDIR=/root/affine_data/false_probes
mkdir -p /root/logs /root/affine_data "$QDIR"
: >"$LOG"

log() { echo "[recover249-h57-king] $(date -u +%Y-%m-%dT%H:%M:%SZ) $*" | tee -a "$LOG"; }

log "START king relaunch (outer×3 + chall-seed + pre-freeze before w1; H57 mid-n80 king ENOENT)"

ts=$(date -u +%Y%m%dT%H%M%SZ)
for f in h57_decision.json h57_sim_result.json h57_sim_result_artifact.json \
         h57_sim_progress.json; do
  if [[ -f "/root/affine_data/$f" ]]; then
    mv "/root/affine_data/$f" "$QDIR/${f%.json}_pass249_${ts}.json"
    log "quarantine $f → $QDIR"
  fi
done
rm -f /root/logs/h57_n80.done /root/logs/h57_n80_retry.aborted \
  /root/logs/h57_pipeline.aborted /root/logs/h57_sim_n80.done \
  /root/logs/h57_king_freeze_pass249.done

# Stop post_train / wait_ready / bare sim — retry owns hashed n80.
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
  /[r]un_sim_duel\.py/ && /local-h57/ {print $1}
  /[r]etry_h57_n80\.sh/ {print $1}
')

reap_gpus() {
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
print(f"[recover249-h57-king] reap gpu={sorted(want)} workers={sorted(pids)} parents={sorted(parents)} grandparents={sorted(grandparents)}")
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
time.sleep(1)
PY
}

kill_king() {
  if [[ -f "$PIDF" ]]; then
    old=$(cat "$PIDF" || true)
    if [[ -n "${old:-}" ]] && kill -0 "$old" 2>/dev/null; then
      kill "$old" 2>/dev/null || true
      sleep 2
      kill -9 "$old" 2>/dev/null || true
    fi
    rm -f "$PIDF"
  fi
  for p in $(ss -lptn 'sport = :8001' 2>/dev/null | awk -Fpid= 'NF>1{split($2,a,","); print a[1]}'); do
    kill -9 "$p" 2>/dev/null || true
  done
  reap_gpus
}

wait_gpus_free() {
  for i in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15; do
    free_ok=$(nvidia-smi --query-gpu=index,memory.used --format=csv,noheader,nounits \
      | awk -F',' -v g="$GPUS" 'BEGIN{split(g,a,","); for(i in a) want[a[i]+0]=1}
        {gsub(/ /,"",$1); gsub(/ /,"",$2); if(($1+0) in want && ($2+0)<500) n++}
        END{print n+0}')
    need=$(echo "$GPUS" | awk -F',' '{print NF}')
    log "free-check gpus$GPUS used<500MiB count=$free_ok/$need try=$i"
    if [[ "$free_ok" -ge "$need" ]]; then
      return 0
    fi
    if [[ "$i" -eq 5 || "$i" -eq 10 ]]; then
      reap_gpus
    fi
    sleep 2
  done
  return 1
}

wipe_caches() {
  log "wipe role king caches (default + prior isolated)"
  chmod -R u+w /root/.triton/cache/king /root/.triton/cache/king_* 2>/dev/null || true
  chmod -R u+w /root/.triton/isolated/h57_king_* 2>/dev/null || true
  rm -rf /root/.triton/cache/king /root/.triton/cache/king_* || true
  rm -rf /root/.triton/isolated/h57_king_* || true
  rm -rf /root/.cache/flashinfer/cached_ops/sampling || true
  rm -rf /root/.cache/vllm/torch_compile_cache || true
  rm -rf /tmp/torchinductor_* /root/.cache/torch/inductor /root/.cache/torchinductor_king_* /root/.cache/torchinductor_h57_* || true
  log "settle 30s after wipe"
  sleep 30
}

_comp() {
  local label=$1 mid code
  mid=$(curl -s --max-time 5 http://127.0.0.1:8001/v1/models \
    | python3 -c 'import sys,json; d=json.load(sys.stdin); print(d["data"][0]["id"] if d.get("data") else "")' 2>/dev/null || true)
  [[ -n "$mid" ]] || { log "FAIL $label: no model id"; return 1; }
  code=$(curl -s -o "/tmp/h57_king_warmup_${label}.json" -w "%{http_code}" --max-time 120 \
    http://127.0.0.1:8001/v1/completions \
    -H 'Content-Type: application/json' \
    -d "{\"model\":\"${mid}\",\"prompt\":\"warmup ${label}\",\"max_tokens\":4,\"temperature\":0}" || true)
  log "comp $label code=$code"
  [[ "$code" == "200" ]]
}

# Initial cleanup
kill_king
wait_gpus_free || { log "ABORT gpus never free"; exit 1; }

TCACHE=""
TAG=""
KING_PID=""
ok=0
for attempt in 1 2 3; do
  log "=== attempt $attempt/3 ==="
  wipe_caches
  TAG=h57_king_p249_a${attempt}_$(date +%s)_$$
  TCACHE=/root/.triton/isolated/$TAG
  mkdir -p "$TCACHE" /root/.cache/torchinductor_$TAG
  # Seed from live chall (same Qwen3.5-MoE arch) so launcher.so exist before
  # any TP race on first completion. Do NOT touch chall's live cache dir.
  if [[ -d /root/.triton/cache/chall ]]; then
    n_seed=$(find /root/.triton/cache/chall -name '__triton_launcher*.so' 2>/dev/null | wc -l)
    log "seed TCACHE from /root/.triton/cache/chall (launcher.so=$n_seed)"
    cp -a /root/.triton/cache/chall/. "$TCACHE/" 2>/dev/null || true
  else
    log "no chall TCACHE to seed"
  fi
  export TORCHINDUCTOR_CACHE_DIR=/root/.cache/torchinductor_$TAG
  export TRITON_CACHE_DIR=$TCACHE

  : >"$KING_LOG"
  log "launch king port=8001 gpus=$GPUS util=$UTIL TCACHE=$TCACHE repo=$KING_REPO@$KING_REV"
  CUDA_VISIBLE_DEVICES=$GPUS TRITON_CACHE_DIR=$TCACHE TORCHINDUCTOR_CACHE_DIR=$TORCHINDUCTOR_CACHE_DIR \
    nohup vllm serve "$KING_REPO" \
    --port 8001 \
    --revision "$KING_REV" \
    --tensor-parallel-size 2 \
    --max-model-len 32768 \
    --gpu-memory-utilization "$UTIL" \
    --max-num-batched-tokens 8192 \
    --attention-backend FLASH_ATTN \
    --attention-config.use_trtllm_attention 0 \
    --compilation-config.pass_config.fuse_allreduce_rms false \
    --moe-backend triton \
    --additional-config '{"gdn_prefill_backend": "triton"}' \
    >"$KING_LOG" 2>&1 &
  echo $! >"$PIDF"
  KING_PID=$(cat "$PIDF")
  log "king_pid=$KING_PID"

  log "wait health=200 (max 120×10s)"
  health_ok=0
  for i in $(seq 1 120); do
    code=$(curl -s -o /dev/null -w "%{http_code}" --max-time 3 http://127.0.0.1:8001/v1/models || true)
    if [[ "$code" == "200" ]]; then
      log "health=200 at poll=$i"
      health_ok=1
      break
    fi
    if ! kill -0 "$KING_PID" 2>/dev/null; then
      log "king_pid=$KING_PID died before health (see $KING_LOG)"
      break
    fi
    (( i % 6 == 0 )) && log "health poll=$i/120 code=$code"
    sleep 10
  done
  if [[ "$health_ok" != "1" ]]; then
    log "attempt $attempt: health never 200 — reap and retry"
    kill_king
    wait_gpus_free || true
    continue
  fi

  # p240: 45s settle + n_pre=16 still ENOENT on w1 (TP race-deletes .so).
  # Pre-freeze when any launcher.so already present (seed and/or profile_run).
  log "settle 45s after health before warmup"
  sleep 45
  n_pre=$(find "$TCACHE" -name '__triton_launcher*.so' 2>/dev/null | wc -l)
  log "pre-warmup launcher.so count=$n_pre"
  pre_froze=0
  if [[ "$n_pre" -ge 1 ]]; then
    log "PRE-FREEZE TCACHE before w1 (n_pre=$n_pre) — blocks TP race-delete"
    chmod -R a-w "$TCACHE" || true
    chmod -R a-w "/root/.cache/torchinductor_$TAG" 2>/dev/null || true
    pre_froze=1
    log "pre-frozen mode=$(stat -c %a "$TCACHE")"
  else
    log "n_pre=0 — cannot pre-freeze; will freeze after w1 if it succeeds"
  fi

  log "warmup completion #1"
  if ! _comp "a${attempt}_w1"; then
    log "attempt $attempt: warmup #1 failed — king up? pid=$(kill -0 $KING_PID 2>/dev/null && echo yes || echo no) pre_froze=$pre_froze"
    tail -20 "$KING_LOG" | tee -a "$LOG" || true
    kill_king
    wait_gpus_free || true
    continue
  fi

  if [[ "$pre_froze" != "1" ]]; then
    log "FREEZE TCACHE chmod -R a-w $TCACHE (post-w1)"
    chmod -R a-w "$TCACHE" || true
    chmod -R a-w "/root/.cache/torchinductor_$TAG" 2>/dev/null || true
  else
    log "TCACHE already pre-frozen before w1"
  fi
  n_so=$(find "$TCACHE" -name '__triton_launcher*.so' 2>/dev/null | wc -l)
  log "frozen launcher.so count=$n_so mode=$(stat -c %a "$TCACHE")"

  sleep 5
  log "warmup completion #2 (must survive freeze)"
  if ! _comp "a${attempt}_w2"; then
    log "attempt $attempt: warmup #2 failed after freeze"
    tail -20 "$KING_LOG" | tee -a "$LOG" || true
    kill_king
    wait_gpus_free || true
    continue
  fi
  sleep 20
  if ! _comp "a${attempt}_w3"; then
    log "attempt $attempt: warmup #3 (post-settle) failed"
    tail -20 "$KING_LOG" | tee -a "$LOG" || true
    kill_king
    wait_gpus_free || true
    continue
  fi

  log "triple-promptable after freeze on attempt $attempt"
  ok=1
  break
done

if [[ "$ok" != "1" ]]; then
  log "ABORT all 3 attempts failed warmup/freeze"
  exit 1
fi

log "rearm watcher + form"

while read -r pid; do
  [[ -n "${pid:-}" ]] || continue
  log "kill old watcher pid=$pid"
  kill "$pid" 2>/dev/null || true
  sleep 1
  kill -9 "$pid" 2>/dev/null || true
done < <(ps -eo pid,args | awk '/[w]atch_n80_retry\.sh/ && / h57 / {print $1}')
while read -r pid; do
  [[ -n "${pid:-}" ]] || continue
  log "kill old retry pid=$pid"
  kill "$pid" 2>/dev/null || true
  sleep 1
  kill -9 "$pid" 2>/dev/null || true
done < <(ps -eo pid,args | awk '/[r]etry_h57_n80\.sh/ {print $1}')
while read -r pid; do
  [[ -n "${pid:-}" ]] || continue
  log "kill old form pid=$pid"
  kill "$pid" 2>/dev/null || true
  sleep 1
  kill -9 "$pid" 2>/dev/null || true
done < <(ps -eo pid,args | awk '/[w]atch_form_decision\.sh/ && / h57 / {print $1}')
sleep 1

nohup bash /root/mining_src/s4-h2-merge/watch_form_decision.sh h57 \
  /root/affine_data/h57_sim_result.json \
  /root/affine_data/h57_decision.json \
  /root/logs/h57_form_decision.nohup \
  >/root/logs/h57_form_decision.launch.nohup 2>&1 &
echo $! >/root/logs/h57_form_decision.pid
log "rearmed form pid=$(cat /root/logs/h57_form_decision.pid)"

nohup bash /root/mining_src/s4-h2-merge/watch_n80_retry.sh h57 \
  /root/mining_src/s4-h57-m7-winner-za-lr525e6/retry_h57_n80.sh \
  >/root/logs/h57_watch_retry.launch.nohup 2>&1 &
echo $! >/root/logs/h57_watch_retry.pid
log "rearmed watcher pid=$(cat /root/logs/h57_watch_retry.pid)"
date -u +%Y-%m-%dT%H:%M:%SZ > /root/logs/h57_king_serve.done
echo "TCACHE=$TCACHE mode=$(stat -c %a $TCACHE) probe=200 attempts_ok prefreeze=1 chall_seed=1" \
  > /root/logs/h57_king_freeze_pass249.done
log "DONE_LAUNCH (king TCACHE frozen; n80 should see double-promptable immediately)"
