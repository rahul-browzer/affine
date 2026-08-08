#!/usr/bin/env bash
# Pass 304: continuous mid-n80 bare-TCACHE guard.
# One-shot watch_preempt_bare_tcache_pass264 exits once chall is isolated
# (or after recover launch). Mid-n80 bare flips (H61@21/80) then have no
# watcher. Loop while run_sim_duel for this hyp is alive; if chall TCACHE
# becomes bare /root/.triton/cache/chall, fire recover294 once.
set -euo pipefail
H="${1:?usage: $0 hNN}"
EXP="${2:?usage: $0 hNN exp-dir}"
HOTKEY="local-${H}"
LOG=/root/logs/${H}_mid_n80_bare_pass304.log
RECOVER=/root/mining_src/${EXP}/relaunch_chall_pass264.sh
mkdir -p /root/logs
log(){ echo "[mid304-${H}] $(date -u +%Y-%m-%dT%H:%M:%SZ) $*" | tee -a "$LOG"; }

sim_alive() {
  ps -eo args | awk -v hk="$HOTKEY" '/[r]un_sim_duel\.py/ && $0 ~ hk {found=1} END{exit !found}'
}

recover_alive() {
  ps -eo args | awk '/[r]elaunch_chall_pass264\.sh/ {found=1} END{exit !found}'
}

chall_tcache() {
  local pid tcache=""
  for pid in $(ps -eo pid,cmd | awk '/vllm serve/ && /--port 8002/ {print $1}'); do
    tcache=$(tr '\0' '\n' < /proc/$pid/environ 2>/dev/null | awk -F= '/^TRITON_CACHE_DIR=/{print $2; exit}')
    [[ -n "$tcache" ]] && break
  done
  echo "$tcache"
}

log "START continuous mid-n80 bare guard (hotkey=$HOTKEY)"
# Wait until sim appears (or timeout ~2h)
for i in $(seq 1 720); do
  if sim_alive; then
    log "sim alive — enter watch loop"
    break
  fi
  (( i % 30 == 0 )) && log "wait sim poll=$i/720"
  sleep 10
  if (( i == 720 )); then
    log "TIMEOUT waiting for sim — exit"
    exit 1
  fi
done

fired=0
while sim_alive; do
  code=$(curl -s -o /dev/null -w "%{http_code}" --max-time 3 http://127.0.0.1:8002/v1/models || true)
  tcache=$(chall_tcache)
  if [[ "$code" == "200" ]]; then
    if [[ -z "$tcache" || "$tcache" == "/root/.triton/cache/chall" ]]; then
      if recover_alive; then
        log "BARE TCACHE but recover already alive — skip"
      elif [[ "$fired" -eq 1 ]]; then
        log "BARE TCACHE but already fired this watch — skip"
      else
        log "BARE/non-isolated mid-n80 TCACHE=${tcache:-none} — launch recover294"
        chmod +x "$RECOVER"
        nohup bash "$RECOVER" > /root/logs/${H}_chall_recover_pass264.nohup 2>&1 &
        echo $! > /root/logs/${H}_chall_recover_pass264.pid
        log "recover pid=$!"
        fired=1
      fi
    fi
  fi
  sleep 15
done
log "sim gone — exit (fired=$fired)"
exit 0
