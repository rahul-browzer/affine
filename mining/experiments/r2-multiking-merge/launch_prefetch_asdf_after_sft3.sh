#!/usr/bin/env bash
# Wait for sft3 prefetch DONE (avoid HF/network contention), then start asdf.
# CPU-only. Does not touch GPUs / engines / R2g sim.
set -euo pipefail
LOG=/root/logs/r2_prefetch_asdf_after_sft3.log
PIDF=/root/logs/r2_prefetch_asdf_after_sft3.pid
SFT3_DONE=/root/logs/r2_prefetch_sft3.done
ASDF_SCRIPT=/root/mining_src/r2-multiking-merge/launch_prefetch_asdf.sh
mkdir -p /root/logs
echo $$ >"$PIDF"
exec > >(tee -a "$LOG") 2>&1
echo "[r2-asdf-chain] $(date -u +%Y-%m-%dT%H:%M:%SZ) wait for $SFT3_DONE"
for i in $(seq 1 720); do  # ~2h @10s
  if [[ -f "$SFT3_DONE" ]]; then
    echo "[r2-asdf-chain] sft3 done: $(cat "$SFT3_DONE")"
    break
  fi
  if (( i % 12 == 0 )); then
    echo "[r2-asdf-chain] wait-sft3 iter=$i still missing"
  fi
  sleep 10
done
if [[ ! -f "$SFT3_DONE" ]]; then
  echo "[r2-asdf-chain] TIMEOUT waiting for sft3"
  exit 2
fi
if [[ -f /root/logs/r2_prefetch_asdf.done ]]; then
  echo "[r2-asdf-chain] asdf already done: $(cat /root/logs/r2_prefetch_asdf.done)"
  exit 0
fi
# Avoid double-launch if a prior asdf pid is live
if [[ -f /root/logs/r2_prefetch_asdf.pid ]]; then
  old=$(cat /root/logs/r2_prefetch_asdf.pid 2>/dev/null || true)
  if [[ -n "${old:-}" ]] && kill -0 "$old" 2>/dev/null; then
    echo "[r2-asdf-chain] asdf pid $old already running — exit"
    exit 0
  fi
fi
echo "[r2-asdf-chain] launching asdf prefetch"
nohup bash "$ASDF_SCRIPT" >/root/logs/r2_prefetch_asdf_nohup.out 2>&1 &
echo $! >/root/logs/r2_prefetch_asdf_launcher.pid
echo "[r2-asdf-chain] asdf launcher pid=$(cat /root/logs/r2_prefetch_asdf_launcher.pid)"
echo "[r2-asdf-chain] DONE arm $(date -u +%Y-%m-%dT%H:%M:%SZ)"
