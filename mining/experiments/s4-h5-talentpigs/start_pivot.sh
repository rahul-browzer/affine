#!/usr/bin/env bash
# H5 first step on mine-sim-1: download TalentPigs → pivot king:8001.
# Merge + n80 are a later pass once /root/logs/h5_king_pivot.done exists.
set -euo pipefail

# shellcheck disable=SC1091
source /root/venv/bin/activate
if [[ -f /root/mine.env ]]; then
  # shellcheck disable=SC1091
  source /root/mine.env
fi

export HF_HOME=${HF_HOME:-/root/hf}
SRC=${SRC:-/root/mining_src/s4-h5-talentpigs}
LOG=/root/logs/h5_pivot_pipeline.log
DONE=/root/logs/h5_pivot_pipeline.done
mkdir -p /root/logs
rm -f "$DONE" /root/logs/h5_download.done /root/logs/h5_king_pivot.done

echo "[h5] $(date -u +%Y-%m-%dT%H:%M:%SZ) pivot pipeline start" | tee -a "$LOG"
bash "$SRC/download_talentpigs.sh" 2>&1 | tee -a "$LOG"
bash "$SRC/pivot_king.sh" 2>&1 | tee -a "$LOG"
date -u +%Y-%m-%dT%H:%M:%SZ >"$DONE"
echo "[h5] $(date -u +%Y-%m-%dT%H:%M:%SZ) PIVOT_PIPELINE_DONE" | tee -a "$LOG"
echo "[h5] next: merge kevin×TalentPigs α=0.65 → chall → n80 vs TalentPigs" | tee -a "$LOG"
