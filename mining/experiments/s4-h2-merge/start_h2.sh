#!/usr/bin/env bash
# H2 pipeline on mine-sim-1: download parents → linear merge α=0.5.
# Scoring / re-serve is a separate step (needs king/chall swap).
set -euo pipefail

# shellcheck disable=SC1091
source /root/venv/bin/activate
if [[ -f /root/mine.env ]]; then
  # shellcheck disable=SC1091
  source /root/mine.env
fi

export HF_HOME=${HF_HOME:-/root/hf}
SRC=${SRC:-/root/mining_src/s4-h2-merge}
OUT=${OUT:-/root/merges/h2-kp50}
ALPHA=${ALPHA:-0.5}
LOG=/root/logs/h2_pipeline.log
DONE=/root/logs/h2_merge.done
mkdir -p /root/logs /root/merges
rm -f "$DONE"

echo "[h2] $(date -u +%Y-%m-%dT%H:%M:%SZ) pipeline start alpha=$ALPHA out=$OUT" | tee -a "$LOG"

bash "$SRC/download_parents.sh" 2>&1 | tee -a "$LOG"

python "$SRC/merge_linear.py" \
  --a-repo kevin954/Affine-5dfqbbh8ev-sft \
  --a-rev 6a5815fad8f4e34c983b1933c1fae5762fe25220 \
  --b-repo pandora-box/Affine-5eqdtdzqle-ckpt300-m4 \
  --b-rev 5218b1383952ff7a8d49b1d7b82acfe5e1bd448d \
  --alpha "$ALPHA" \
  --out "$OUT" \
  --hf-home "$HF_HOME" \
  2>&1 | tee -a "$LOG"

date -u +%Y-%m-%dT%H:%M:%SZ >"$DONE"
echo "[h2] $(date -u +%Y-%m-%dT%H:%M:%SZ) MERGE_DONE -> $DONE out=$OUT" | tee -a "$LOG"
echo "[h2] next: restart king=kevin chall=merge, then run_sim_duel.py" | tee -a "$LOG"
