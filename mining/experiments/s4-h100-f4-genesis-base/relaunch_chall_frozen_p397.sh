#!/usr/bin/env bash
# Pass 397: F4 chall died after successful post-diverse freeze (script error at
# salvage launch_chall / missing turns.jsonl). Relaunch SAME frozen TCACHE —
# no wipe — then rearm longwait n80. Corpus sync must finish first or race it.
set -euo pipefail
source /root/venv/bin/activate
set -a
# shellcheck disable=SC1091
[ -f /root/mine.env ] && source /root/mine.env
set +a

HYP=h100
MERGE=/root/h100/merged
GPUS=4,5
UTIL=0.72
PIDF=/root/logs/vllm_chall.pid
CHALL_LOG=/root/logs/vllm_chall.log
LOG=/root/logs/h100_chall_frozen_p397.nohup
TCACHE=/root/.triton/isolated/h100_chall_p260_a1_1786227519_63229
TAG=h100_chall_p260_a1_1786227519_63229

log() { echo "[f4-frozen397] $(date -u +%Y-%m-%dT%H:%M:%SZ) $*" | tee -a "$LOG"; }

[[ -d "$TCACHE" ]] || { log "ABORT no frozen TCACHE $TCACHE"; exit 1; }
[[ -f "$MERGE/config.json" ]] || { log "ABORT no merge $MERGE"; exit 1; }

# Wait for turns.jsonl (corpus sync may still be running)
for i in $(seq 1 90); do
  if [[ -s /root/affine_data/turns.jsonl ]]; then
    n=$(wc -l </root/affine_data/turns.jsonl)
    log "turns.jsonl ready lines=$n"
    break
  fi
  (( i % 6 == 0 )) && log "wait turns.jsonl poll=$i/90"
  sleep 10
done
[[ -s /root/affine_data/turns.jsonl ]] || { log "ABORT no turns.jsonl"; exit 1; }

# Kill any dead/orphan chall on :8002; leave teacher+king
if [[ -f "$PIDF" ]]; then
  old=$(cat "$PIDF" || true)
  if [[ -n "${old:-}" ]] && kill -0 "$old" 2>/dev/null; then
    log "kill old chall pid=$old"
    kill "$old" 2>/dev/null || true
    sleep 2
    kill -9 "$old" 2>/dev/null || true
  fi
  rm -f "$PIDF"
fi
for p in $(ss -lptn 'sport = :8002' 2>/dev/null | awk -Fpid= 'NF>1{split($2,a,","); print a[1]}'); do
  kill -9 "$p" 2>/dev/null || true
done

# Reap GPUs 4,5 only
python - <<'PY'
import os, signal, subprocess, time
want = {4, 5}
out = subprocess.check_output(
    ["nvidia-smi", "--query-gpu=index,uuid", "--format=csv,noheader,nounits"], text=True)
idx_to_uuid = {}
for line in out.strip().splitlines():
    parts = [p.strip() for p in line.split(",")]
    if len(parts) >= 2:
        idx_to_uuid[int(parts[0])] = parts[1]
uuids = {idx_to_uuid[i] for i in want if i in idx_to_uuid}
apps = subprocess.check_output(
    ["nvidia-smi", "--query-compute-apps=gpu_uuid,pid", "--format=csv,noheader,nounits"], text=True)
pids = set()
for line in apps.strip().splitlines():
    if not line.strip():
        continue
    parts = [p.strip() for p in line.split(",")]
    if len(parts) >= 2 and parts[0] in uuids:
        try: pids.add(int(parts[1]))
        except ValueError: pass
print(f"[f4-frozen397] reap gpus4,5 pids={sorted(pids)}")
for pid in pids:
    try: os.kill(pid, signal.SIGTERM)
    except OSError: pass
time.sleep(2)
for pid in pids:
    try: os.kill(pid, signal.SIGKILL)
    except OSError: pass
PY

for i in 1 2 3 4 5 6 7 8 9 10; do
  free_ok=$(nvidia-smi --query-gpu=index,memory.used --format=csv,noheader,nounits \
    | awk -F',' '($1+0==4 || $1+0==5) && ($2+0)<500 {n++} END{print n+0}')
  log "free-check gpus4,5 count=$free_ok/2 try=$i"
  [[ "$free_ok" -ge 2 ]] && break
  sleep 2
done

# Keep TCACHE frozen (555)
chmod -R a-w "$TCACHE" 2>/dev/null || true
n_so=$(find "$TCACHE" -name '__triton_launcher*.so' 2>/dev/null | wc -l)
log "launch chall frozen TCACHE=$TCACHE mode=$(stat -c %a "$TCACHE") n_so=$n_so"

export TORCHINDUCTOR_CACHE_DIR=/root/.cache/torchinductor_$TAG
export TRITON_CACHE_DIR=$TCACHE
mkdir -p "$TORCHINDUCTOR_CACHE_DIR"
: >"$CHALL_LOG"
CUDA_VISIBLE_DEVICES=$GPUS TRITON_CACHE_DIR=$TCACHE TORCHINDUCTOR_CACHE_DIR=$TORCHINDUCTOR_CACHE_DIR \
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
log "chall_pid=$(cat "$PIDF")"

for i in $(seq 1 120); do
  code=$(curl -s -o /dev/null -w "%{http_code}" --max-time 3 http://127.0.0.1:8002/v1/models || true)
  if [[ "$code" == "200" ]]; then
    mid=$(curl -s --max-time 5 http://127.0.0.1:8002/v1/models \
      | python3 -c 'import sys,json; d=json.load(sys.stdin); print(d["data"][0]["id"] if d.get("data") else "")' 2>/dev/null || true)
    if [[ -n "$mid" ]]; then
      pcode=$(curl -s -o /tmp/h100_p397_probe.json -w "%{http_code}" --max-time 90 \
        http://127.0.0.1:8002/v1/completions \
        -H 'Content-Type: application/json' \
        -d "{\"model\":\"${mid}\",\"prompt\":\"hi\",\"max_tokens\":2}" || true)
      if [[ "$pcode" == "200" ]]; then
        log "CHALL PROMPTABLE mid=$mid poll=$i"
        date -u +%Y-%m-%dT%H:%M:%SZ >/root/logs/h100_chall_serve.done
        echo "TCACHE=$TCACHE mode=$(stat -c %a "$TCACHE") n_so=$n_so frozen_relaunch_p397" \
          >/root/logs/h100_chall_freeze_pass264.done
        # Rearm longwait (kill only matching longwait/retry $0, not watcher argv)
        while read -r pid; do
          [[ -n "${pid:-}" ]] || continue
          cmd=$(tr '\0' ' ' </proc/"$pid"/cmdline 2>/dev/null || true)
          case "$cmd" in
            *watch_n80_retry.sh*) log "kill watcher $pid"; kill "$pid" 2>/dev/null || true ;;
          esac
        done < <(ps -eo pid,args | awk '/[w]atch_n80_retry\.sh/ && / h100 / {print $1}')
        while read -r pid; do
          [[ -n "${pid:-}" ]] || continue
          # kill retry $0 only
          arg0=$(tr '\0' '\n' </proc/"$pid"/cmdline 2>/dev/null | head -1 || true)
          case "$arg0" in
            *retry_h100_n80*) log "kill retry $pid ($arg0)"; kill "$pid" 2>/dev/null || true ;;
          esac
        done < <(ps -eo pid,args | awk '/[r]etry_h100_n80/ {print $1}')
        sleep 2
        nohup bash /root/mining_src/s4-h2-merge/watch_n80_retry.sh h100 \
          /root/mining_src/s4-h100-f4-genesis-base/retry_h100_n80_longwait.sh \
          >/root/logs/h100_watch_retry.launch.nohup 2>&1 &
        echo $! >/root/logs/h100_watch_retry.pid
        log "rearmed longwait watcher pid=$(cat /root/logs/h100_watch_retry.pid)"
        log "DONE"
        exit 0
      fi
    fi
  fi
  if grep -q '__triton_launcher.*cannot open shared object file' "$CHALL_LOG" 2>/dev/null; then
    log "ABORT Triton ENOENT — need full recover264 not frozen relaunch"
    exit 2
  fi
  (( i % 6 == 0 )) && log "wait chall promptable poll=$i/120 health=$code"
  sleep 10
done
log "ABORT chall never promptable"
exit 1
