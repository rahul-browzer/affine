#!/usr/bin/env bash
# R6b: Tok-init thought-only LoRA on natural long-z (z>180, non-listy), EPOCHS=6.
# Overlay: upload_and_launch copies this to s4-h101-f6-short-format/start_h101.sh.
# R6b: long-thought ablate (≠ R6 short≤180).
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
OUT=${OUT:-/root/h101}
DATA=${DATA:-$OUT/za_ultrashort80.jsonl}
BASE=${BASE:-/root/hf/hub/models--Tok331102--affine-5EqYW8McUc-af10/snapshots/eb8bf9a356a254f71faaa439e8abc3cfba572c53}
TRAIN_DIR=$OUT/train
LOG=${LOG:-/root/logs/h101_train.nohup}
EPOCHS=${EPOCHS:-6}

mkdir -p "$OUT" /root/logs "$TRAIN_DIR" /root/affine_data /root/r6b
test -d "$BASE"
test -s "$DATA"
test -f "$SRC/train_lora.py"
n=$(wc -l <"$DATA")
echo "[r6b/h101] $(date -u +%Y-%m-%dT%H:%M:%SZ) examples=$n data=$DATA base=$BASE gpus=$CUDA_VISIBLE_DEVICES epochs=$EPOCHS"
echo "[r6b/h101] axis=${R6B_AXIS:-natural_long_nonlisty_zgt180}"
test "$n" -ge 200

echo "[r6b/h101] verify thought cuts (CPU)"
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
echo "[r6b/h101] $(date -u +%Y-%m-%dT%H:%M:%SZ) launch thought-only train lr=5e-6 r=16 epochs=$EPOCHS on GPUs $CUDA_VISIBLE_DEVICES"
nohup python3 "$SRC/train_lora.py" \
  --base "$BASE" \
  --data "$DATA" \
  --out-dir "$TRAIN_DIR" \
  --max-len 8192 \
  --epochs "$EPOCHS" \
  --lr 5e-6 \
  --lora-r 16 \
  --lora-alpha 32 \
  --batch 1 \
  --grad-accum 8 \
  --loss-on thought \
  >"$LOG" 2>&1 &
echo $! | tee /root/logs/h101_train.pid >"$OUT/train.pid"
cp -f /root/logs/h101_train.pid /root/logs/r6b_train.pid
python3 - <<PY
import json, time
from pathlib import Path
meta = {
    "utc": time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime()),
    "hypo": "R6b",
    "family": "F6-long-z",
    "axis": "${R6B_AXIS:-natural_long_nonlisty_zgt180}",
    "pid": int(Path("/root/logs/h101_train.pid").read_text().strip()),
    "base": "$BASE",
    "base_hub": "Tok331102/affine-5EqYW8McUc-af10",
    "base_rev": "eb8bf9a356a254f71faaa439e8abc3cfba572c53",
    "data": "$DATA",
    "examples": $n,
    "lr": 5e-6,
    "epochs": $EPOCHS,
    "loss_on": "thought",
    "gpus": "$CUDA_VISIBLE_DEVICES",
    "out": "$TRAIN_DIR",
    "log": "$LOG",
    "note": "R6b natural long-z (z>180 non-listy) Tok-init LoRA @r16/a32 EPOCHS=$EPOCHS — ≠ R6 short≤180",
}
Path("/root/affine_data/h101_train_launched.json").write_text(json.dumps(meta, indent=2) + "\n")
Path("/root/affine_data/r6b_train_launched.json").write_text(json.dumps(meta, indent=2) + "\n")
print(json.dumps(meta, indent=2))
PY
echo "[r6b/h101] TRAIN_LAUNCHED pid=$(cat /root/logs/h101_train.pid)"
