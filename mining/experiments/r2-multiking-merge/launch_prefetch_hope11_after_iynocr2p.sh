#!/usr/bin/env bash
# Wait for iynocr2p prefetch DONE, then start hope11 (chal-00491).
# CPU-only. Does not touch GPUs / engines / R2ap sim.
set -euo pipefail
LOG=/root/logs/r2_prefetch_hope11_after_iynocr2p.log
PIDF=/root/logs/r2_prefetch_hope11_after_iynocr2p.pid
IY_DONE=/root/logs/r2_prefetch_iynocr2p.done
HOPE_SCRIPT=/root/mining_src/r2-multiking-merge/launch_prefetch_hope11.sh
mkdir -p /root/logs
echo $$ >"$PIDF"
exec > >(tee -a "$LOG") 2>&1
echo "[r2-hope11-chain] $(date -u +%Y-%m-%dT%H:%M:%SZ) wait for $IY_DONE"
for i in $(seq 1 720); do
  if [[ -f "$IY_DONE" ]]; then
    echo "[r2-hope11-chain] iynocr2p done: $(cat "$IY_DONE")"
    break
  fi
  if (( i % 12 == 0 )); then
    echo "[r2-hope11-chain] wait-iynocr2p iter=$i still missing"
  fi
  sleep 10
done
if [[ ! -f "$IY_DONE" ]]; then
  echo "[r2-hope11-chain] TIMEOUT waiting for iynocr2p"
  exit 2
fi
if [[ -f /root/logs/r2_prefetch_hope11.done ]]; then
  echo "[r2-hope11-chain] hope11 already done: $(cat /root/logs/r2_prefetch_hope11.done)"
  exit 0
fi
if [[ -f /root/logs/r2_prefetch_hope11.pid ]]; then
  old=$(cat /root/logs/r2_prefetch_hope11.pid 2>/dev/null || true)
  if [[ -n "${old:-}" ]] && kill -0 "$old" 2>/dev/null; then
    echo "[r2-hope11-chain] hope11 pid $old already running — exit"
    exit 0
  fi
fi
echo "[r2-hope11-chain] launching hope11 prefetch"
nohup bash "$HOPE_SCRIPT" >/root/logs/r2_prefetch_hope11_nohup.out 2>&1 &
echo $! >/root/logs/r2_prefetch_hope11_launcher.pid
echo "[r2-hope11-chain] hope11 launcher pid=$(cat /root/logs/r2_prefetch_hope11_launcher.pid)"
