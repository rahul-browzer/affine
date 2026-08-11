#!/usr/bin/env bash
# Wait for sky prefetch DONE (avoid HF/network contention), then start google.
# CPU-only. Does not touch GPUs / engines / R2p sim.
set -euo pipefail
LOG=/root/logs/r2_prefetch_google_after_sky.log
PIDF=/root/logs/r2_prefetch_google_after_sky.pid
SKY_DONE=/root/logs/r2_prefetch_sky.done
GOOGLE_SCRIPT=/root/mining_src/r2-multiking-merge/launch_prefetch_google.sh
mkdir -p /root/logs
echo $$ >"$PIDF"
exec > >(tee -a "$LOG") 2>&1
echo "[r2-google-chain] $(date -u +%Y-%m-%dT%H:%M:%SZ) wait for $SKY_DONE"
for i in $(seq 1 720); do  # ~2h @10s
  if [[ -f "$SKY_DONE" ]]; then
    echo "[r2-google-chain] sky done: $(cat "$SKY_DONE")"
    break
  fi
  if (( i % 12 == 0 )); then
    echo "[r2-google-chain] wait-sky iter=$i still missing"
  fi
  sleep 10
done
if [[ ! -f "$SKY_DONE" ]]; then
  echo "[r2-google-chain] TIMEOUT waiting for sky"
  exit 2
fi
if [[ -f /root/logs/r2_prefetch_google.done ]]; then
  echo "[r2-google-chain] google already done: $(cat /root/logs/r2_prefetch_google.done)"
  exit 0
fi
# Avoid double-launch if a prior google pid is live
if [[ -f /root/logs/r2_prefetch_google.pid ]]; then
  old=$(cat /root/logs/r2_prefetch_google.pid 2>/dev/null || true)
  if [[ -n "${old:-}" ]] && kill -0 "$old" 2>/dev/null; then
    echo "[r2-google-chain] google pid $old already running — exit"
    exit 0
  fi
fi
echo "[r2-google-chain] launching google prefetch"
nohup bash "$GOOGLE_SCRIPT" >/root/logs/r2_prefetch_google_nohup.out 2>&1 &
echo $! >/root/logs/r2_prefetch_google_launcher.pid
echo "[r2-google-chain] google launcher pid=$(cat /root/logs/r2_prefetch_google_launcher.pid)"
