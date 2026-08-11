#!/usr/bin/env bash
# Wait for zeus prefetch DONE (avoid HF/network contention), then start sth.
# CPU-only. Does not touch GPUs / engines / R2g sim.
set -euo pipefail
LOG=/root/logs/r2_prefetch_sth_after_zeus.log
PIDF=/root/logs/r2_prefetch_sth_after_zeus.pid
ZEUS_DONE=/root/logs/r2_prefetch_zeus.done
STH_SCRIPT=/root/mining_src/r2-multiking-merge/launch_prefetch_sth.sh
mkdir -p /root/logs
echo $$ >"$PIDF"
exec > >(tee -a "$LOG") 2>&1
echo "[r2-sth-chain] $(date -u +%Y-%m-%dT%H:%M:%SZ) wait for $ZEUS_DONE"
for i in $(seq 1 720); do  # ~2h @10s
  if [[ -f "$ZEUS_DONE" ]]; then
    echo "[r2-sth-chain] zeus done: $(cat "$ZEUS_DONE")"
    break
  fi
  if (( i % 12 == 0 )); then
    echo "[r2-sth-chain] wait-zeus iter=$i still missing"
  fi
  sleep 10
done
if [[ ! -f "$ZEUS_DONE" ]]; then
  echo "[r2-sth-chain] TIMEOUT waiting for zeus"
  exit 2
fi
if [[ -f /root/logs/r2_prefetch_sth.done ]]; then
  echo "[r2-sth-chain] sth already done: $(cat /root/logs/r2_prefetch_sth.done)"
  exit 0
fi
# Avoid double-launch if a prior sth pid is live
if [[ -f /root/logs/r2_prefetch_sth.pid ]]; then
  old=$(cat /root/logs/r2_prefetch_sth.pid 2>/dev/null || true)
  if [[ -n "${old:-}" ]] && kill -0 "$old" 2>/dev/null; then
    echo "[r2-sth-chain] sth pid $old already running — exit"
    exit 0
  fi
fi
echo "[r2-sth-chain] launching sth prefetch"
nohup bash "$STH_SCRIPT" >/root/logs/r2_prefetch_sth_nohup.out 2>&1 &
echo $! >/root/logs/r2_prefetch_sth_launcher.pid
echo "[r2-sth-chain] sth launcher pid=$(cat /root/logs/r2_prefetch_sth_launcher.pid)"
echo "[r2-sth-chain] DONE arm $(date -u +%Y-%m-%dT%H:%M:%SZ)"
