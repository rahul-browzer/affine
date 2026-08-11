#!/usr/bin/env bash
# Wait for `now` prefetch DONE (avoid HF/network contention), then start af17.
# CPU-only. Does not touch GPUs / engines / R2am sim.
set -euo pipefail
LOG=/root/logs/r2_prefetch_af17_after_now.log
PIDF=/root/logs/r2_prefetch_af17_after_now.pid
NOW_DONE=/root/logs/r2_prefetch_now.done
AF17_SCRIPT=/root/mining_src/r2-multiking-merge/launch_prefetch_af17.sh
mkdir -p /root/logs
echo $$ >"$PIDF"
exec > >(tee -a "$LOG") 2>&1
echo "[r2-af17-chain] $(date -u +%Y-%m-%dT%H:%M:%SZ) wait for $NOW_DONE"
for i in $(seq 1 720); do  # ~2h @10s
  if [[ -f "$NOW_DONE" ]]; then
    echo "[r2-af17-chain] now done: $(cat "$NOW_DONE")"
    break
  fi
  if (( i % 12 == 0 )); then
    echo "[r2-af17-chain] wait-now iter=$i still missing"
  fi
  sleep 10
done
if [[ ! -f "$NOW_DONE" ]]; then
  echo "[r2-af17-chain] TIMEOUT waiting for now"
  exit 2
fi
if [[ -f /root/logs/r2_prefetch_af17.done ]]; then
  echo "[r2-af17-chain] af17 already done: $(cat /root/logs/r2_prefetch_af17.done)"
  exit 0
fi
if [[ -f /root/logs/r2_prefetch_af17.pid ]]; then
  old=$(cat /root/logs/r2_prefetch_af17.pid 2>/dev/null || true)
  if [[ -n "${old:-}" ]] && kill -0 "$old" 2>/dev/null; then
    echo "[r2-af17-chain] af17 pid $old already running — exit"
    exit 0
  fi
fi
echo "[r2-af17-chain] launching af17 prefetch"
nohup bash "$AF17_SCRIPT" >/root/logs/r2_prefetch_af17_nohup.out 2>&1 &
echo $! >/root/logs/r2_prefetch_af17_launcher.pid
echo "[r2-af17-chain] af17 launcher pid=$(cat /root/logs/r2_prefetch_af17_launcher.pid)"
