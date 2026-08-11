#!/usr/bin/env bash
# Wait for h44 prefetch DONE (avoid HF/network contention), then start now.
# CPU-only. Does not touch GPUs / engines / R2am sim.
set -euo pipefail
LOG=/root/logs/r2_prefetch_now_after_h44.log
PIDF=/root/logs/r2_prefetch_now_after_h44.pid
H44_DONE=/root/logs/r2_prefetch_h44.done
NOW_SCRIPT=/root/mining_src/r2-multiking-merge/launch_prefetch_now.sh
mkdir -p /root/logs
echo $$ >"$PIDF"
exec > >(tee -a "$LOG") 2>&1
echo "[r2-now-chain] $(date -u +%Y-%m-%dT%H:%M:%SZ) wait for $H44_DONE"
for i in $(seq 1 720); do  # ~2h @10s
  if [[ -f "$H44_DONE" ]]; then
    echo "[r2-now-chain] h44 done: $(cat "$H44_DONE")"
    break
  fi
  if (( i % 12 == 0 )); then
    echo "[r2-now-chain] wait-h44 iter=$i still missing"
  fi
  sleep 10
done
if [[ ! -f "$H44_DONE" ]]; then
  echo "[r2-now-chain] TIMEOUT waiting for h44"
  exit 2
fi
if [[ -f /root/logs/r2_prefetch_now.done ]]; then
  echo "[r2-now-chain] now already done: $(cat /root/logs/r2_prefetch_now.done)"
  exit 0
fi
if [[ -f /root/logs/r2_prefetch_now.pid ]]; then
  old=$(cat /root/logs/r2_prefetch_now.pid 2>/dev/null || true)
  if [[ -n "${old:-}" ]] && kill -0 "$old" 2>/dev/null; then
    echo "[r2-now-chain] now pid $old already running — exit"
    exit 0
  fi
fi
echo "[r2-now-chain] launching now prefetch"
nohup bash "$NOW_SCRIPT" >/root/logs/r2_prefetch_now_nohup.out 2>&1 &
echo $! >/root/logs/r2_prefetch_now_launcher.pid
echo "[r2-now-chain] now launcher pid=$(cat /root/logs/r2_prefetch_now_launcher.pid)"
