#!/usr/bin/env bash
# H70: Radiant28/m7-init thought-only LoRA on winner-zA high clip-L1 z_A (406→fit-filter).
set -euo pipefail

export PATH="/root/.local/bin:${PATH}"
# shellcheck disable=SC1091
source /root/venv/bin/activate
if [[ -f /root/mine.env ]]; then
  set -a
  # shellcheck disable=SC1091
  source /root/mine.env
  set +a
fi
export HF_TOKEN="${HF_TOKEN:-}"
export HF_HOME=${HF_HOME:-/root/hf}
export CUDA_VISIBLE_DEVICES=${CUDA_VISIBLE_DEVICES:-6,7}

SRC=${SRC:-/root/mining_src/s4-h1v2-sft}
OUT=${OUT:-/root/h70}
DATA=${DATA:-$OUT/winner_za_high_l1.jsonl}
BASE=${BASE:-/root/hf/hub/models--Radiant28--5eqdtdzqle-ckpt1000-m7/snapshots/f766293ee878efef5f068a4053d6974017f11f26}
TRAIN_DIR=$OUT/train
LOG=${LOG:-/root/logs/h70_train.nohup}

mkdir -p "$OUT" /root/logs "$TRAIN_DIR" /root/affine_data
test -d "$BASE"
test -s "$DATA"
test -f "$SRC/train_lora.py"
n=$(wc -l <"$DATA")
echo "[h70] $(date -u +%Y-%m-%dT%H:%M:%SZ) examples=$n data=$DATA base=$BASE gpus=$CUDA_VISIBLE_DEVICES"
test "$n" -ge 200

echo "[h70] verify thought cuts (CPU)"
python3 "$SRC/verify_thought_mask.py" \
  --data "$DATA" \
  --out "$OUT/thought_mask_verify.json"

python - <<'PY'
import importlib
for m in ("peft", "accelerate"):
    importlib.import_module(m)
print("peft+accelerate OK")
PY

rm -f "$TRAIN_DIR/train.done" "$TRAIN_DIR/train_result.json"
echo "[h70] $(date -u +%Y-%m-%dT%H:%M:%SZ) launch thought-only train lr=5.01e-6 on GPUs $CUDA_VISIBLE_DEVICES"
nohup python3 "$SRC/train_lora.py" \
  --base "$BASE" \
  --data "$DATA" \
  --out-dir "$TRAIN_DIR" \
  --max-len 8192 \
  --epochs 1 \
  --lr 5.01e-6 \
  --lora-r 16 \
  --lora-alpha 32 \
  --batch 1 \
  --grad-accum 8 \
  --loss-on thought \
  >"$LOG" 2>&1 &
echo $! | tee /root/logs/h70_train.pid >"$OUT/train.pid"
python3 - <<PY
import json, time
from pathlib import Path
meta = {
    "utc": time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime()),
    "hypo": "H70",
    "pid": int(Path("/root/logs/h70_train.pid").read_text().strip()),
    "base": "$BASE",
    "base_hub": "Radiant28/5eqdtdzqle-ckpt1000-m7",
    "base_rev": "f766293ee878efef5f068a4053d6974017f11f26",
    "data": "$DATA",
    "examples": $n,
    "lr": 5.01e-6,
    "loss_on": "thought",
    "gpus": "$CUDA_VISIBLE_DEVICES",
    "out": "$TRAIN_DIR",
    "log": "$LOG",
    "note": "H28 cell @ lr=5.01e-6 (between H42@5e-6 +0.01613 and H65@5.02e-6 +0.01829 REFUTE); m7-init winner-zA",
}
Path("/root/affine_data/h70_train_launched.json").write_text(json.dumps(meta, indent=2) + "\n")
print(json.dumps(meta, indent=2))
PY
echo "[h70] TRAIN_LAUNCHED pid=$(cat /root/logs/h70_train.pid)"
