#!/usr/bin/env bash
# p2247 host watcher: wait for mine-r25 SSH after reboot, then arm post-reboot n80.
set -euo pipefail
ROOT=/home/const/subnet120/mining
LOG=$ROOT/experiments/r25-hitemp-grpo/artifacts/p2247_reboot_watch.log
mkdir -p "$(dirname "$LOG")"
exec >>"$LOG" 2>&1
log(){ echo "[p2247-watch] $(date -u +%Y-%m-%dT%H:%M:%SZ) $*"; }

HOST=150.136.71.147
PORT=20309
SSH=(ssh -o StrictHostKeyChecking=accept-new -o ConnectTimeout=10 -o BatchMode=yes -p "$PORT" "root@$HOST")

log "start waiting for SSH $HOST:$PORT"
for i in $(seq 1 180); do
  if "${SSH[@]}" 'echo OK; nvidia-smi -L 2>/dev/null | grep -c NVIDIA; test -f /root/r25_merged/config.json && echo MERGE_OK' 2>/dev/null; then
    log "SSH up on poll=$i"
    break
  fi
  sleep 20
  if (( i % 6 == 0 )); then log "still waiting poll=$i"; fi
  if (( i == 180 )); then log "FATAL timeout"; exit 1; fi
done

# refresh scripts if host copies newer
scp -o StrictHostKeyChecking=accept-new -P "$PORT" \
  "$ROOT/experiments/r25-hitemp-grpo/p2247_r25_post_reboot_n80.sh" \
  "$ROOT/experiments/r25-hitemp-grpo/p2246_chall_warm_n80.sh" \
  "root@$HOST:/root/" || true

log "launch post-reboot restore+n80"
"${SSH[@]}" 'bash -lc "
  chmod +x /root/p2247_r25_post_reboot_n80.sh /root/p2246_chall_warm_n80.sh
  # wait NVML healthy before restore
  for j in \$(seq 1 60); do
    n=\$(nvidia-smi -L 2>/dev/null | grep -c NVIDIA || true)
    err=\$(nvidia-smi -L 2>&1 | grep -c \"Unknown Error\" || true)
    echo \"[p2247-watch] gpu_ok=\$n err=\$err\"
    [[ \"\$n\" -ge 8 && \"\$err\" -eq 0 ]] && break
    sleep 5
  done
  nohup bash /root/p2247_r25_post_reboot_n80.sh >/root/logs/p2247_post_reboot.nohup 2>&1 &
  echo \$! >/root/logs/p2247_post_reboot.pid
  sleep 2
  kill -0 \$(cat /root/logs/p2247_post_reboot.pid) && echo POST_REBOOT_ARMED || { echo FAIL; tail -n 40 /root/logs/p2247_post_reboot.nohup; }
"'
log "DONE armed"
