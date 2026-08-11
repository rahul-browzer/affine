#!/usr/bin/env bash
# Wait for asdf prefetch DONE (avoid HF/network contention), then start zeus.
# CPU-only. Does not touch GPUs / engines / R2g sim.
set -euo pipefail
LOG=/root/logs/r2_prefetch_zeus_after_asdf.log
PIDF=/root/logs/r2_prefetch_zeus_after_asdf.pid
ASDF_DONE=/root/logs/r2_prefetch_asdf.done
ZEUS_SCRIPT=/root/mining_src/r2-multiking-merge/launch_prefetch_zeus.sh
mkdir -p /root/logs
echo $$ >"$PIDF"
exec > >(tee -a "$LOG") 2>&1
echo "[r2-zeus-chain] $(date -u +%Y-%m-%dT%H:%M:%SZ) wait for $ASDF_DONE"
for i in $(seq 1 720); do  # ~2h @10s
  if [[ -f "$ASDF_DONE" ]]; then
    echo "[r2-zeus-chain] asdf done: $(cat "$ASDF_DONE")"
    break
  fi
  if (( i % 12 == 0 )); then
    echo "[r2-zeus-chain] wait-asdf iter=$i still missing"
  fi
  sleep 10
done
if [[ ! -f "$ASDF_DONE" ]]; then
  echo "[r2-zeus-chain] TIMEOUT waiting for asdf"
  exit 2
fi
if [[ -f /root/logs/r2_prefetch_zeus.done ]]; then
  echo "[r2-zeus-chain] zeus already done: $(cat /root/logs/r2_prefetch_zeus.done)"
  exit 0
fi
# Avoid double-launch if a prior zeus pid is live
if [[ -f /root/logs/r2_prefetch_zeus.pid ]]; then
  old=$(cat /root/logs/r2_prefetch_zeus.pid 2>/dev/null || true)
  if [[ -n "${old:-}" ]] && kill -0 "$old" 2>/dev/null; then
    echo "[r2-zeus-chain] zeus pid $old already running — exit"
    exit 0
  fi
fi
echo "[r2-zeus-chain] launching zeus prefetch"
nohup bash "$ZEUS_SCRIPT" >/root/logs/r2_prefetch_zeus_nohup.out 2>&1 &
echo $! >/root/logs/r2_prefetch_zeus_launcher.pid
echo "[r2-zeus-chain] zeus launcher pid=$(cat /root/logs/r2_prefetch_zeus_launcher.pid)"
echo "[r2-zeus-chain] DONE arm $(date -u +%Y-%m-%dT%H:%M:%SZ)"
