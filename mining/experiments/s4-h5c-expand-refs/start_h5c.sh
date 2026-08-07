#!/usr/bin/env bash
# H5c: kevin-init thought-only LoRA on expanded shortz teacher_refs (791).
# Run ON mine-h5c-1 after bootstrap has kevin + peft ready.
# Expects:
#   /root/h5c/teacher_refs_shortz.jsonl
#   /root/mining_src/s4-h1v2-sft/{train_lora.py,thought_mask.py,verify_thought_mask.py}
#   /root/mine.env with HF_TOKEN; /root/venv activated stack
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

SRC=${SRC:-/root/mining_src/s4-h1v2-sft}
OUT=${OUT:-/root/h5c}
DATA=${DATA:-$OUT/teacher_refs_shortz.jsonl}
BASE=${BASE:-/root/hf/hub/models--kevin954--Affine-5dfqbbh8ev-sft/snapshots/6a5815fad8f4e34c983b1933c1fae5762fe25220}
TRAIN_DIR=$OUT/train
LOG=${LOG:-/root/logs/h5c_train.nohup}

mkdir -p "$OUT" /root/logs "$TRAIN_DIR"
test -d "$BASE"
test -s "$DATA"
test -f "$SRC/train_lora.py"
n=$(wc -l <"$DATA")
echo "[h5c] $(date -u +%Y-%m-%dT%H:%M:%SZ) examples=$n data=$DATA base=$BASE gpus=$CUDA_VISIBLE_DEVICES"
test "$n" -ge 700

echo "[h5c] verify thought cuts (CPU)"
python3 "$SRC/verify_thought_mask.py" \
  --data "$DATA" \
  --out "$OUT/thought_mask_verify.json"

echo "[h5c] ensure peft/accelerate"
python - <<'PY'
import importlib
for m in ("peft", "accelerate"):
    importlib.import_module(m)
print("peft+accelerate OK")
PY

rm -f "$TRAIN_DIR/train.done"
echo "[h5c] $(date -u +%Y-%m-%dT%H:%M:%SZ) launch thought-only train lr=2e-5 on GPUs $CUDA_VISIBLE_DEVICES"
nohup python3 "$SRC/train_lora.py" \
  --base "$BASE" \
  --data "$DATA" \
  --out-dir "$TRAIN_DIR" \
  --max-len 8192 \
  --epochs 1 \
  --lr 2e-5 \
  --lora-r 16 \
  --lora-alpha 32 \
  --batch 1 \
  --grad-accum 8 \
  --loss-on thought \
  >"$LOG" 2>&1 &
echo $! | tee /root/logs/h5c_train.pid >"$OUT/train.pid"
echo "[h5c] train pid=$(cat /root/logs/h5c_train.pid) log=$LOG"
echo "[h5c] $(date -u +%Y-%m-%dT%H:%M:%SZ) TRAIN_LAUNCHED"
