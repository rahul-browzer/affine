#!/usr/bin/env bash
# H100: Genesis-init thought-only LoRA on high-Λ2 z_A (F4 non-king base).
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
OUT=${OUT:-/root/h100}
DATA=${DATA:-$OUT/winner_za_high_l2.jsonl}
BASE=${BASE:-/root/hf/hub/models--dendriteholdings--albedo-qwen3.6-35b-king-genesis/snapshots/abe89194d6addf82e71f3f1ba9fef94b05404abf}
TRAIN_DIR=$OUT/train
LOG=${LOG:-/root/logs/h100_train.nohup}

mkdir -p "$OUT" /root/logs "$TRAIN_DIR" /root/affine_data
test -d "$BASE"
test -s "$DATA"
test -f "$SRC/train_lora.py"
n=$(wc -l <"$DATA")
echo "[h100] $(date -u +%Y-%m-%dT%H:%M:%SZ) examples=$n data=$DATA base=$BASE gpus=$CUDA_VISIBLE_DEVICES"
test "$n" -ge 200

echo "[h100] verify thought cuts (CPU)"
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
echo "[h100] $(date -u +%Y-%m-%dT%H:%M:%SZ) launch thought-only train lr=5e-6 r=16 on GPUs $CUDA_VISIBLE_DEVICES"
nohup python3 "$SRC/train_lora.py" \
  --base "$BASE" \
  --data "$DATA" \
  --out-dir "$TRAIN_DIR" \
  --max-len 8192 \
  --epochs 1 \
  --lr 5e-6 \
  --lora-r 16 \
  --lora-alpha 32 \
  --batch 1 \
  --grad-accum 8 \
  --loss-on thought \
  >"$LOG" 2>&1 &
echo $! | tee /root/logs/h100_train.pid >"$OUT/train.pid"
python3 - <<PY
import json, time
from pathlib import Path
meta = {
    "utc": time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime()),
    "hypo": "H100",
    "pid": int(Path("/root/logs/h100_train.pid").read_text().strip()),
    "base": "$BASE",
    "base_hub": "dendriteholdings/albedo-qwen3.6-35b-king-genesis",
    "base_rev": "abe89194d6addf82e71f3f1ba9fef94b05404abf",
    "data": "$DATA",
    "examples": $n,
    "lr": 5e-6,
    "loss_on": "thought",
    "gpus": "$CUDA_VISIBLE_DEVICES",
    "out": "$TRAIN_DIR",
    "log": "$LOG",
    "note": "F4 Genesis-init × high-Λ2 z_A @r16/α32 (non-king base axis; same high-Λ2 data as F2) vs Tok331102",
}
Path("/root/affine_data/h100_train_launched.json").write_text(json.dumps(meta, indent=2) + "\n")
print(json.dumps(meta, indent=2))
PY
echo "[h100] TRAIN_LAUNCHED pid=$(cat /root/logs/h100_train.pid)"
