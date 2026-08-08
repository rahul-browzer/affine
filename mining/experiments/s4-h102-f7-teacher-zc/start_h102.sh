#!/usr/bin/env bash
# H102: Genesis-init thought-only LoRA on teacher z_C (F7 teacher-z_C on Genesis).
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
OUT=${OUT:-/root/h102}
DATA=${DATA:-$OUT/teacher_refs_shortz.jsonl}
BASE=${BASE:-/root/hf/hub/models--dendriteholdings--albedo-qwen3.6-35b-king-genesis/snapshots/abe89194d6addf82e71f3f1ba9fef94b05404abf}
TRAIN_DIR=$OUT/train
LOG=${LOG:-/root/logs/h102_train.nohup}

mkdir -p "$OUT" /root/logs "$TRAIN_DIR" /root/affine_data
test -d "$BASE"
test -s "$DATA"
test -f "$SRC/train_lora.py"
n=$(wc -l <"$DATA")
echo "[h102] $(date -u +%Y-%m-%dT%H:%M:%SZ) examples=$n data=$DATA base=$BASE gpus=$CUDA_VISIBLE_DEVICES"
test "$n" -ge 200

echo "[h102] verify thought cuts (CPU)"
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
echo "[h102] $(date -u +%Y-%m-%dT%H:%M:%SZ) launch thought-only train lr=5e-6 r=16 on GPUs $CUDA_VISIBLE_DEVICES"
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
echo $! | tee /root/logs/h102_train.pid >"$OUT/train.pid"
python3 - <<PY
import json, time
from pathlib import Path
meta = {
    "utc": time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime()),
    "hypo": "H102",
    "pid": int(Path("/root/logs/h102_train.pid").read_text().strip()),
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
    "note": "F7 Genesis-init × teacher z_C @r16/α32 (non-king base axis; frontier teacher z_C; leaves king-init distill basin) vs Tok331102",
}
Path("/root/affine_data/h102_train_launched.json").write_text(json.dumps(meta, indent=2) + "\n")
print(json.dumps(meta, indent=2))
PY
echo "[h102] TRAIN_LAUNCHED pid=$(cat /root/logs/h102_train.pid)"
