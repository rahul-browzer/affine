#!/usr/bin/env bash
# H5c train launcher — run ON a mine-* pod after bootstrap.
# Expects:
#   /root/h5c/teacher_refs_shortz.jsonl
#   /root/h5c/src/{train_lora.py,thought_mask.py,merge_lora.py}  (from h1v2/h5b)
#   HF_TOKEN in env or /root/mine.env
#   kevin weights already cached or downloadable
set -euo pipefail
OUT=${OUT:-/root/h5c}
SRC=${SRC:-$OUT/src}
DATA=${DATA:-$OUT/teacher_refs_shortz.jsonl}
BASE=${BASE:-kevin954/Affine-5dfqbbh8ev-sft}
BASE_REV=${BASE_REV:-6a5815fad8f4e34c983b1933c1fae5762fe25220}
GPUS=${GPUS:-6,7}
LOG=${LOG:-/root/logs/h5c_train.nohup}

mkdir -p "$OUT/train" /root/logs
test -s "$DATA"
test -f "$SRC/train_lora.py"

# shellcheck disable=SC1091
[[ -f /root/mine.env ]] && source /root/mine.env

echo "[h5c] data=$(wc -l < "$DATA") lines base=$BASE@$BASE_REV gpus=$GPUS"
CUDA_VISIBLE_DEVICES=$GPUS nohup python3 "$SRC/train_lora.py" \
  --data "$DATA" \
  --base "$BASE" \
  --base-revision "$BASE_REV" \
  --out "$OUT/train" \
  --loss-on thought \
  --lr 2e-5 \
  --epochs 1 \
  >"$LOG" 2>&1 &
echo $! | tee "$OUT/train.pid"
echo "[h5c] train pid $(cat "$OUT/train.pid") log=$LOG"
