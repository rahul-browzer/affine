#!/usr/bin/env bash
# Pass 264: wait for chall serve, then if bare TCACHE run p260/p264 diverse-freeze recover.
set -euo pipefail
H=h63
EXP=s4-h63-m7-winner-za-lr505e6
LOG=/root/logs/${H}_preempt_bare_pass264.log
RECOVER=/root/mining_src/${EXP}/relaunch_chall_pass264.sh
mkdir -p /root/logs
log(){ echo "[preempt264-${H}] $(date -u +%Y-%m-%dT%H:%M:%SZ) $*" | tee -a "$LOG"; }
log "START wait chall_serve/merged+8002"
for i in $(seq 1 240); do
  served=0
  [[ -f /root/logs/${H}_chall_serve.done ]] && served=1
  if [[ -f /root/h${H#h}/merged/config.json ]] || [[ -f /root/${H}/merged/config.json ]]; then
    code=$(curl -s -o /dev/null -w "%{http_code}" --max-time 3 http://127.0.0.1:8002/v1/models || true)
    [[ "$code" == "200" ]] && served=1
  fi
  if [[ "$served" -eq 1 ]]; then
    tcache=""
    for pid in $(ps -eo pid,cmd | awk '/vllm serve/ && /--port 8002/ {print $1}'); do
      tcache=$(tr '\0' '\n' < /proc/$pid/environ 2>/dev/null | awk -F= '/^TRITON_CACHE_DIR=/{print $2; exit}')
      [[ -n "$tcache" ]] && break
    done
    log "chall up TCACHE=${tcache:-none}"
    if [[ -z "$tcache" || "$tcache" == "/root/.triton/cache/chall" || "$tcache" != /root/.triton/isolated/* ]]; then
      log "BARE/non-isolated — launch recover264"
      chmod +x "$RECOVER"
      nohup bash "$RECOVER" > /root/logs/${H}_chall_recover_pass264.nohup 2>&1 &
      echo $! > /root/logs/${H}_chall_recover_pass264.pid
      log "recover pid=$!"
      exit 0
    fi
    # already isolated — check freeze mode
    mode=$(stat -c %a "$tcache" 2>/dev/null || echo 0)
    n_so=$(find "$tcache" -name '__triton_launcher*.so' 2>/dev/null | wc -l)
    log "already isolated mode=$mode n_so=$n_so — no recover"
    if [[ "$mode" != "555" || "$n_so" -lt 16 ]]; then
      log "isolated but not frozen enough — launch recover264"
      chmod +x "$RECOVER"
      nohup bash "$RECOVER" > /root/logs/${H}_chall_recover_pass264.nohup 2>&1 &
      echo $! > /root/logs/${H}_chall_recover_pass264.pid
      log "recover pid=$!"
    fi
    exit 0
  fi
  (( i % 6 == 0 )) && log "wait poll=$i/240"
  sleep 10
done
log "TIMEOUT waiting for chall"
exit 1
