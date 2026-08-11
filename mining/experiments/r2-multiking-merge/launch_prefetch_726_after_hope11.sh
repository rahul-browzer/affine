#!/usr/bin/env bash
# Wait for hope11 prefetch DONE, then start 726 (chal-00492).
# CPU-only. Does not touch GPUs / engines / R2ap sim.
set -euo pipefail
LOG=/root/logs/r2_prefetch_726_after_hope11.log
PIDF=/root/logs/r2_prefetch_726_after_hope11.pid
HOPE_DONE=/root/logs/r2_prefetch_hope11.done
SCRIPT=/root/mining_src/r2-multiking-merge/launch_prefetch_726.sh
mkdir -p /root/logs
echo $$ >"$PIDF"
exec > >(tee -a "$LOG") 2>&1
echo "[r2-726-chain] $(date -u +%Y-%m-%dT%H:%M:%SZ) wait for $HOPE_DONE"
for i in $(seq 1 720); do
  if [[ -f "$HOPE_DONE" ]]; then
    echo "[r2-726-chain] hope11 done: $(cat "$HOPE_DONE")"
    break
  fi
  if (( i % 12 == 0 )); then
    echo "[r2-726-chain] wait-hope11 iter=$i still missing"
  fi
  sleep 10
done
if [[ ! -f "$HOPE_DONE" ]]; then
  echo "[r2-726-chain] TIMEOUT waiting for hope11"
  exit 2
fi
if [[ -f /root/logs/r2_prefetch_726.done ]]; then
  echo "[r2-726-chain] 726 already done: $(cat /root/logs/r2_prefetch_726.done)"
  exit 0
fi
if [[ -f /root/logs/r2_prefetch_726.pid ]]; then
  old=$(cat /root/logs/r2_prefetch_726.pid 2>/dev/null || true)
  if [[ -n "${old:-}" ]] && kill -0 "$old" 2>/dev/null; then
    echo "[r2-726-chain] 726 pid $old already running — exit"
    exit 0
  fi
fi
echo "[r2-726-chain] launching 726 prefetch"
nohup bash "$SCRIPT" >/root/logs/r2_prefetch_726_nohup.out 2>&1 &
echo $! >/root/logs/r2_prefetch_726_launcher.pid
echo "[r2-726-chain] 726 launcher pid=$(cat /root/logs/r2_prefetch_726_launcher.pid)"
