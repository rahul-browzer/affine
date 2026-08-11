#!/usr/bin/env bash
# Wait for sbs prefetch DONE (avoid HF/network contention), then start sky.
# CPU-only. Does not touch GPUs / engines / R2p sim.
set -euo pipefail
LOG=/root/logs/r2_prefetch_sky_after_sbs.log
PIDF=/root/logs/r2_prefetch_sky_after_sbs.pid
SBS_DONE=/root/logs/r2_prefetch_sbs.done
SKY_SCRIPT=/root/mining_src/r2-multiking-merge/launch_prefetch_sky.sh
mkdir -p /root/logs
echo $$ >"$PIDF"
exec > >(tee -a "$LOG") 2>&1
echo "[r2-sky-chain] $(date -u +%Y-%m-%dT%H:%M:%SZ) wait for $SBS_DONE"
for i in $(seq 1 720); do  # ~2h @10s
  if [[ -f "$SBS_DONE" ]]; then
    echo "[r2-sky-chain] sbs done: $(cat "$SBS_DONE")"
    break
  fi
  if (( i % 12 == 0 )); then
    echo "[r2-sky-chain] wait-sbs iter=$i still missing"
  fi
  sleep 10
done
if [[ ! -f "$SBS_DONE" ]]; then
  echo "[r2-sky-chain] TIMEOUT waiting for sbs"
  exit 2
fi
if [[ -f /root/logs/r2_prefetch_sky.done ]]; then
  echo "[r2-sky-chain] sky already done: $(cat /root/logs/r2_prefetch_sky.done)"
  exit 0
fi
# Avoid double-launch if a prior sky pid is live
if [[ -f /root/logs/r2_prefetch_sky.pid ]]; then
  old=$(cat /root/logs/r2_prefetch_sky.pid 2>/dev/null || true)
  if [[ -n "${old:-}" ]] && kill -0 "$old" 2>/dev/null; then
    echo "[r2-sky-chain] sky pid $old already running — exit"
    exit 0
  fi
fi
echo "[r2-sky-chain] launching sky prefetch"
nohup bash "$SKY_SCRIPT" >/root/logs/r2_prefetch_sky_nohup.out 2>&1 &
echo $! >/root/logs/r2_prefetch_sky_launcher.pid
echo "[r2-sky-chain] sky launcher pid=$(cat /root/logs/r2_prefetch_sky_launcher.pid)"
