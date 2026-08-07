#!/usr/bin/env bash
# H5b: TalentPigs-init thought-only LoRA on GPUs 6,7.
# Engines 0-5 stay up (teacher/king/chall).
set -euo pipefail

export PATH="/root/.local/bin:${PATH}"
# shellcheck disable=SC1091
source /root/venv/bin/activate
if [[ -f /root/mine.env ]]; then
  # shellcheck disable=SC1091
  source /root/mine.env
fi

export HF_HOME=${HF_HOME:-/root/hf}
export CUDA_VISIBLE_DEVICES=${CUDA_VISIBLE_DEVICES:-6,7}

SRC_H1V2=/root/mining_src/s4-h1v2-sft
OUT=/root/h5b
DATA=${DATA:-/root/h1/teacher_refs_sft.jsonl}
BASE=${BASE:-/root/hf/hub/models--TalentPigs--affine-5ekxlcg3fx-abc/snapshots/dbfbb3e2a17c7603e7fc68a3a15b343f42dfdef4}
TRAIN_DIR=$OUT/train
LOG=/root/logs/h5b_train.nohup

mkdir -p "$OUT" /root/logs "$TRAIN_DIR"
test -d "$BASE"
test -f "$DATA"
n=$(wc -l <"$DATA")
echo "[h5b] $(date -u +%Y-%m-%dT%H:%M:%SZ) examples=$n data=$DATA base=$BASE"
test "$n" -ge 50

echo "[h5b] verify thought cuts (CPU)"
python3 "$SRC_H1V2/verify_thought_mask.py" \
  --data "$DATA" \
  --out "$OUT/thought_mask_verify.json"

rm -f "$TRAIN_DIR/train.done"
echo "[h5b] $(date -u +%Y-%m-%dT%H:%M:%SZ) launch thought-only train lr=1e-5 on GPUs $CUDA_VISIBLE_DEVICES"
nohup python3 "$SRC_H1V2/train_lora.py" \
  --base "$BASE" \
  --data "$DATA" \
  --out-dir "$TRAIN_DIR" \
  --max-len 8192 \
  --epochs 1 \
  --lr 1e-5 \
  --lora-r 16 \
  --lora-alpha 32 \
  --batch 1 \
  --grad-accum 8 \
  --loss-on thought \
  >"$LOG" 2>&1 &
echo $! > /root/logs/h5b_train.pid
echo "[h5b] train pid=$(cat /root/logs/h5b_train.pid) log=$LOG"
echo "[h5b] $(date -u +%Y-%m-%dT%H:%M:%SZ) TRAIN_LAUNCHED"
