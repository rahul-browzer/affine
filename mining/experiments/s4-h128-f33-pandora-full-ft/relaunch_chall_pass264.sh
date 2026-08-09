#!/usr/bin/env bash
# Pass 251: p247 king-seed+PRE-FREEZE before w1 ABORT×3 — warmup needs NEW
# Triton hashes not in king cache (a3: 4UYR2LE4… ENOENT under mode=555).
# Prefreeze blocks JIT writes → 500. Fix: seed king, leave WRITABLE for w1,
# FREEZE only after w1 succeeds; on w1 fail if n_so>n_seed, relaunch SAME
# TCACHE pre-frozen (no wipe). Outer×3 kept. FALSE_PROBE, not REFUTE.
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

LOG=/root/logs/h128_chall_recover_pass264.log
CHALL_LOG=/root/logs/vllm_chall.log
PIDF=/root/logs/vllm_chall.pid
MERGE=/root/h128/merged
export HYP=h128
export GPUS=4,5
UTIL=0.72
QDIR=/root/affine_data/false_probes
mkdir -p /root/logs /root/affine_data "$QDIR"
: >"$LOG"

log() { echo "[recover144-h128-chall] $(date -u +%Y-%m-%dT%H:%M:%SZ) $*" | tee -a "$LOG"; }

log "START chall relaunch (outer×3 + king-seed WRITABLE diverse-warm + post-diverse freeze; p247 prefreeze-before-w1 dead)"

ts=$(date -u +%Y%m%dT%H%M%SZ)
for f in h128_decision.json h128_sim_result.json h128_sim_result_artifact.json \
         h128_sim_progress.json; do
  if [[ -f "/root/affine_data/$f" ]]; then
    mv "/root/affine_data/$f" "$QDIR/${f%.json}_pass264_${ts}.json"
    log "quarantine $f → $QDIR"
  fi
done
rm -f /root/logs/h128_n80.done /root/logs/h128_n80_retry.aborted \
  /root/logs/h128_pipeline.aborted /root/logs/h128_chall_serve.done \
  /root/logs/h128_sim_n80.done /root/logs/h128_chall_freeze_pass247.done \
  /root/logs/h128_chall_freeze_pass251.done \
  /root/logs/h128_chall_freeze_pass237.done \
  /root/logs/h128_chall_freeze_pass239.done \
  /root/logs/h128_chall_freeze_pass240.done

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
  /[r]un_sim_duel\.py/ && /local-h128/ {print $1}
  /[r]etry_h128_n80\.sh/ {print $1}
')

reap_gpus() {
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
print(f"[recover144-h128-chall] reap gpu={sorted(want)} workers={sorted(pids)} parents={sorted(parents)} grandparents={sorted(grandparents)}")
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

kill_chall() {
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
  log "wipe role chall caches (default + prior isolated)"
  chmod -R u+w /root/.triton/cache/chall /root/.triton/cache/chall_* 2>/dev/null || true
  chmod -R u+w /root/.triton/isolated/h128_chall_* 2>/dev/null || true
  rm -rf /root/.triton/cache/chall /root/.triton/cache/chall_* || true
  rm -rf /root/.triton/isolated/h128_chall_* || true
  rm -rf /root/.cache/flashinfer/cached_ops/sampling || true
  rm -rf /root/.cache/vllm/torch_compile_cache || true
  rm -rf /tmp/torchinductor_* /root/.cache/torch/inductor /root/.cache/torchinductor_chall_* /root/.cache/torchinductor_h128_* || true
  log "settle 30s after wipe"
  sleep 30
}

_comp() {
  local label=$1 mid code prompt max_tok
  prompt=${2:-"warmup ${label}"}
  max_tok=${3:-4}
  mid=$(curl -s --max-time 5 http://127.0.0.1:8002/v1/models \
    | python3 -c 'import sys,json; d=json.load(sys.stdin); print(d["data"][0]["id"] if d.get("data") else "")' 2>/dev/null || true)
  [[ -n "$mid" ]] || { log "FAIL $label: no model id"; return 1; }
  code=$(PROMPT="$prompt" MAXTOK="$max_tok" MID="$mid" LABEL="$label" HYP="$HYP" python3 - <<'PY'
import json, os, urllib.request
hyp = os.environ.get("HYP", "hXX")
label = os.environ["LABEL"]
req = urllib.request.Request(
    "http://127.0.0.1:8002/v1/completions",
    data=json.dumps({
        "model": os.environ["MID"],
        "prompt": os.environ["PROMPT"],
        "max_tokens": int(os.environ["MAXTOK"]),
        "temperature": 0,
    }).encode(),
    headers={"Content-Type": "application/json"},
    method="POST",
)
try:
    with urllib.request.urlopen(req, timeout=180) as r:
        open(f"/tmp/{hyp}_warmup_{label}.json", "wb").write(r.read())
        print(r.status)
except Exception as e:
    open(f"/tmp/{hyp}_warmup_{label}.err", "w").write(repr(e))
    print("000")
PY
)
  log "comp $label code=$code max_tok=$max_tok prompt_chars=${#prompt}"
  [[ "$code" == "200" ]]
}

_diverse_warm_writable() {
  # Populate Triton hashes n80 needs before freeze (p251 short-only → OV4T43 ENOENT).
  local a=$1
  local longpad
  longpad=$(python3 - <<'PY'
print("def solve(x):\n    " + ("# pad\n    " * 80) + "return x\n")
PY
)
  log "diverse writable warmups (short/med/long) before freeze"
  _comp "a${a}_d1" "warmup short ${a}" 4 || return 1
  _comp "a${a}_d2" "Write a Python function that merges two sorted lists into one sorted list and explain briefly." 32 || return 1
  _comp "a${a}_d3" "$longpad" 16 || return 1
  _comp "a${a}_d4" "$(python3 -c "print('x' * 4096)")" 8 || return 1
  return 0
}


# Initial cleanup
kill_chall
wait_gpus_free || { log "ABORT gpus never free"; exit 1; }

launch_chall() {
  local tcache=$1 tag=$2
  export TORCHINDUCTOR_CACHE_DIR=/root/.cache/torchinductor_$tag
  export TRITON_CACHE_DIR=$tcache
  mkdir -p "$TORCHINDUCTOR_CACHE_DIR"
  : >"$CHALL_LOG"
  log "launch chall port=8002 gpus=$GPUS util=$UTIL TCACHE=$tcache merge=$MERGE"
  CUDA_VISIBLE_DEVICES=$GPUS TRITON_CACHE_DIR=$tcache TORCHINDUCTOR_CACHE_DIR=$TORCHINDUCTOR_CACHE_DIR \
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
}

wait_health() {
  log "wait health=200 (max 120×10s)"
  local i code
  for i in $(seq 1 120); do
    code=$(curl -s -o /dev/null -w "%{http_code}" --max-time 3 http://127.0.0.1:8002/v1/models || true)
    if [[ "$code" == "200" ]]; then
      log "health=200 at poll=$i"
      return 0
    fi
    if ! kill -0 "$CHALL_PID" 2>/dev/null; then
      log "chall_pid=$CHALL_PID died before health (see $CHALL_LOG)"
      return 1
    fi
    (( i % 6 == 0 )) && log "health poll=$i/120 code=$code"
    sleep 10
  done
  return 1
}

finish_warmups() {
  local label=$1
  n_so=$(find "$TCACHE" -name '__triton_launcher*.so' 2>/dev/null | wc -l)
  log "frozen launcher.so count=$n_so mode=$(stat -c %a "$TCACHE")"
  sleep 5
  log "warmup completion #2 (must survive freeze)"
  if ! _comp "${label}_w2"; then
    log "$label: warmup #2 failed after freeze"
    tail -20 "$CHALL_LOG" | tee -a "$LOG" || true
    return 1
  fi
  sleep 20
  if ! _comp "${label}_w3"; then
    log "$label: warmup #3 (post-settle) failed"
    tail -20 "$CHALL_LOG" | tee -a "$LOG" || true
    return 1
  fi
  return 0
}

TCACHE=""
TAG=""
CHALL_PID=""
ok=0
for attempt in 1 2 3; do
  log "=== attempt $attempt/3 (writable w1; freeze only post-w1) ==="
  wipe_caches
  TAG=h128_chall_p260_a${attempt}_$(date +%s)_$$
  TCACHE=/root/.triton/isolated/$TAG
  mkdir -p "$TCACHE" /root/.cache/torchinductor_$TAG
  # Prefer live king isolated TCACHE (:8001 env). Bare cache/king is often
  # absent after king_recover_pass332 — H91/p382/p384 "no king TCACHE" → cold JIT.
  n_seed=0
  SEED_SRC=""
  # Prefer pathfile written by king_recover_pass332 (ps/environ race missed it p395).
  # Glob hyp-agnostic: h100/h128/…_king_tcache_pass332.path (p396).
  for _pf in /root/logs/*_king_tcache_pass332.path; do
    [[ -f "$_pf" ]] || continue
    SEED_SRC=$(cat "$_pf" 2>/dev/null || true)
    [[ -n "$SEED_SRC" && -d "$SEED_SRC" ]] && break
    SEED_SRC=""
  done
  if [[ -z "$SEED_SRC" ]]; then
    # Use args (not cmd) + split match — ps truncation can drop "--port 8001".
    for pid in $(ps -eo pid,args | awk '/\/vllm/ && /serve/ && /--port 8001/ {print $1}'); do
      SEED_SRC=$(tr '\0' '\n' < /proc/$pid/environ 2>/dev/null | awk -F= '/^TRITON_CACHE_DIR=/{print $2; exit}')
      [[ -n "$SEED_SRC" && -d "$SEED_SRC" ]] && break
      SEED_SRC=""
    done
  fi
  if [[ -z "$SEED_SRC" ]]; then
    SEED_SRC=$(ls -1dt /root/.triton/isolated/*king* 2>/dev/null | head -1 || true)
  fi
  if [[ -z "$SEED_SRC" && -d /root/.triton/cache/king ]]; then
    SEED_SRC=/root/.triton/cache/king
  fi
  if [[ -n "$SEED_SRC" && -d "$SEED_SRC" ]]; then
    n_seed=$(find "$SEED_SRC" -name '__triton_launcher*.so' 2>/dev/null | wc -l)
    log "seed TCACHE from $SEED_SRC (launcher.so=$n_seed) — leave WRITABLE"
    cp -a "$SEED_SRC"/. "$TCACHE/" 2>/dev/null || true
  else
    log "no king TCACHE to seed"
  fi

  launch_chall "$TCACHE" "$TAG"
  if ! wait_health; then
    log "attempt $attempt: health never 200 — reap and retry"
    kill_chall
    wait_gpus_free || true
    continue
  fi

  log "settle 60s after health before writable w1 (p247 used 45s+prefreeze → dead)"
  sleep 60
  n_pre=$(find "$TCACHE" -name '__triton_launcher*.so' 2>/dev/null | wc -l)
  log "pre-warmup launcher.so count=$n_pre mode=$(stat -c %a "$TCACHE") — NOT pre-freezing"

  log "writable diverse warmups (allows JIT of non-king hashes incl. n80 shapes)"
  if _diverse_warm_writable "$attempt"; then
    n_pre_freeze=$(find "$TCACHE" -name '__triton_launcher*.so' 2>/dev/null | wc -l)
    log "FREEZE TCACHE chmod -R a-w $TCACHE (post-diverse n_so=$n_pre_freeze)"
    chmod -R a-w "$TCACHE" || true
    chmod -R a-w "/root/.cache/torchinductor_$TAG" 2>/dev/null || true
    if finish_warmups "a${attempt}"; then
      log "triple-promptable after post-diverse freeze on attempt $attempt n_so=$n_pre_freeze"
      ok=1
      break
    fi
    kill_chall
    wait_gpus_free || true
    continue
  fi

  n_after=$(find "$TCACHE" -name '__triton_launcher*.so' 2>/dev/null | wc -l)
  log "attempt $attempt: w1 failed writable — n_so $n_seed→$n_after pid=$(kill -0 $CHALL_PID 2>/dev/null && echo yes || echo no)"
  tail -20 "$CHALL_LOG" | tee -a "$LOG" || true
  kill_chall
  wait_gpus_free || true

  # Salvage: if JIT grew the cache, relaunch SAME TCACHE pre-frozen (no wipe).
  if [[ "$n_after" -gt "$n_seed" ]]; then
    log "SALVAGE: n_so grew ($n_seed→$n_after) — relaunch same TCACHE pre-frozen"
    chmod -R a-w "$TCACHE" || true
    chmod -R a-w "/root/.cache/torchinductor_$TAG" 2>/dev/null || true
    log "salvage pre-frozen mode=$(stat -c %a "$TCACHE")"
    launch_chall "$TCACHE" "$TAG"
    if wait_health; then
      log "settle 45s after salvage health"
      sleep 45
      log "salvage warmup #1 (pre-frozen grown cache)"
      if _comp "a${attempt}_salv_w1"; then
        if finish_warmups "a${attempt}_salv"; then
          log "triple-promptable after salvage prefreeze on attempt $attempt"
          ok=1
          break
        fi
      else
        log "salvage w1 failed"
        tail -20 "$CHALL_LOG" | tee -a "$LOG" || true
      fi
    fi
    kill_chall
    wait_gpus_free || true
  else
    log "no salvage (n_so did not grow past seed)"
  fi
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
done < <(ps -eo pid,args | awk '/[w]atch_n80_retry\.sh/ && / h128 / {print $1}')
while read -r pid; do
  [[ -n "${pid:-}" ]] || continue
  log "kill old retry pid=$pid"
  kill "$pid" 2>/dev/null || true
  sleep 1
  kill -9 "$pid" 2>/dev/null || true
done < <(ps -eo pid,args | awk '/[r]etry_h128_n80\.sh/ {print $1}')
while read -r pid; do
  [[ -n "${pid:-}" ]] || continue
  log "kill old form pid=$pid"
  kill "$pid" 2>/dev/null || true
  sleep 1
  kill -9 "$pid" 2>/dev/null || true
done < <(ps -eo pid,args | awk '/[w]atch_form_decision\.sh/ && / h128 / {print $1}')
# Also kill any leftover p247 recover (should already be dead)
while read -r pid; do
  [[ -n "${pid:-}" ]] || continue
  log "kill old p247 recover pid=$pid"
  kill "$pid" 2>/dev/null || true
  sleep 1
  kill -9 "$pid" 2>/dev/null || true
done < <(ps -eo pid,args | awk '/[r]elaunch_chall_pass247\.sh/ {print $1}')
while read -r pid; do
  [[ -n "${pid:-}" ]] || continue
  log "kill old p251 recover pid=$pid"
  kill "$pid" 2>/dev/null || true
  sleep 1
  kill -9 "$pid" 2>/dev/null || true
done < <(ps -eo pid,args | awk '/[r]elaunch_chall_pass251\.sh/ {print $1}')
sleep 1

nohup bash /root/mining_src/s4-h2-merge/watch_form_decision.sh h128 \
  /root/affine_data/h128_sim_result.json \
  /root/affine_data/h128_decision.json \
  /root/logs/h128_form_decision.nohup \
  >/root/logs/h128_form_decision.launch.nohup 2>&1 &
echo $! >/root/logs/h128_form_decision.pid
log "rearmed form pid=$(cat /root/logs/h128_form_decision.pid)"

# After recover264 DONE always re-point to d203first (bare a203 overflows; LESSON p425/p436)
nohup bash /root/mining_src/s4-h2-merge/watch_n80_retry.sh h128 \
  /root/mining_src/s4-h128-f33-pandora-full-ft/retry_h128_n80_d203first.sh \
  >/root/logs/h128_watch_retry.launch.nohup 2>&1 &
echo $! >/root/logs/h128_watch_retry.pid
log "rearmed watcher pid=$(cat /root/logs/h128_watch_retry.pid)"
date -u +%Y-%m-%dT%H:%M:%SZ > /root/logs/h128_chall_serve.done
echo "TCACHE=$TCACHE mode=$(stat -c %a $TCACHE) probe=200 attempts_ok post_diverse_freeze=1 king_seed=1" \
  > /root/logs/h128_chall_freeze_pass264.done
log "DONE_LAUNCH (TCACHE frozen post-diverse; n80 should see double-promptable immediately)"
