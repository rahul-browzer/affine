#!/usr/bin/env bash
# Pass 264/283: wait for chall serve, then if bare TCACHE run recover.
# p283: do NOT relaunch when already isolated (mode=755 mid-warmup is
# expected); do NOT launch if relaunch_chall already alive.
set -euo pipefail
H=h97
EXP=s4-h97-f3-r256
LOG=/root/logs/${H}_preempt_bare_pass264.log
RECOVER=/root/mining_src/${EXP}/relaunch_chall_pass264.sh
mkdir -p /root/logs
log(){ echo "[preempt264-${H}] $(date -u +%Y-%m-%dT%H:%M:%SZ) $*" | tee -a "$LOG"; }

recover_alive() {
  ps -eo args | awk '/[r]elaunch_chall_pass264\.sh/ {found=1} END{exit !found}'
}

log "START wait chall_serve/merged+8002 (p283 no double-launch)"
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
    if recover_alive; then
      log "recover already alive — exit without relaunch (p283)"
      exit 0
    fi
    if [[ -z "$tcache" || "$tcache" == "/root/.triton/cache/chall" || "$tcache" != /root/.triton/isolated/* ]]; then
      log "BARE/non-isolated — launch recover144"
      chmod +x "$RECOVER"
      nohup bash "$RECOVER" > /root/logs/${H}_chall_recover_pass264.nohup 2>&1 &
      echo $! > /root/logs/${H}_chall_recover_pass264.pid
      log "recover pid=$!"
      exit 0
    fi
    # already isolated: mid-warmup mode=755 is expected; recover freezes after w1.
    # Never relaunch here — that killed healthy chall at p283 10:14:49Z.
    mode=$(stat -c %a "$tcache" 2>/dev/null || echo 0)
    n_so=$(find "$tcache" -name '__triton_launcher*.so' 2>/dev/null | wc -l)
    log "already isolated mode=$mode n_so=$n_so — leave alone (p283)"
    exit 0
  fi
  (( i % 6 == 0 )) && log "wait poll=$i/240"
  sleep 10
done
log "TIMEOUT waiting for chall"
exit 1
