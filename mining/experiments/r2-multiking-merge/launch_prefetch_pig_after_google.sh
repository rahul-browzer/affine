#!/usr/bin/env bash
# Wait for google prefetch DONE (avoid HF/network contention), then start pig.
# CPU-only. Does not touch GPUs / engines / R2p sim.
set -euo pipefail
LOG=/root/logs/r2_prefetch_pig_after_google.log
PIDF=/root/logs/r2_prefetch_pig_after_google.pid
GOOGLE_DONE=/root/logs/r2_prefetch_google.done
PIG_SCRIPT=/root/mining_src/r2-multiking-merge/launch_prefetch_pig.sh
mkdir -p /root/logs
echo $$ >"$PIDF"
exec > >(tee -a "$LOG") 2>&1
echo "[r2-pig-chain] $(date -u +%Y-%m-%dT%H:%M:%SZ) wait for $GOOGLE_DONE"
for i in $(seq 1 720); do  # ~2h @10s
  if [[ -f "$GOOGLE_DONE" ]]; then
    echo "[r2-pig-chain] google done: $(cat "$GOOGLE_DONE")"
    break
  fi
  if (( i % 12 == 0 )); then
    echo "[r2-pig-chain] wait-google iter=$i still missing"
  fi
  sleep 10
done
if [[ ! -f "$GOOGLE_DONE" ]]; then
  echo "[r2-pig-chain] TIMEOUT waiting for google"
  exit 2
fi
if [[ -f /root/logs/r2_prefetch_pig.done ]]; then
  echo "[r2-pig-chain] pig already done: $(cat /root/logs/r2_prefetch_pig.done)"
  exit 0
fi
# Avoid double-launch if a prior pig pid is live
if [[ -f /root/logs/r2_prefetch_pig.pid ]]; then
  old=$(cat /root/logs/r2_prefetch_pig.pid 2>/dev/null || true)
  if [[ -n "${old:-}" ]] && kill -0 "$old" 2>/dev/null; then
    echo "[r2-pig-chain] pig pid $old already running — exit"
    exit 0
  fi
fi
echo "[r2-pig-chain] launching pig prefetch"
nohup bash "$PIG_SCRIPT" >/root/logs/r2_prefetch_pig_nohup.out 2>&1 &
echo $! >/root/logs/r2_prefetch_pig_launcher.pid
echo "[r2-pig-chain] pig launcher pid=$(cat /root/logs/r2_prefetch_pig_launcher.pid)"
