#!/usr/bin/env bash
# H128: pandora-init thought-only full-FT on high-Λ2 z_A (F33; no LoRA).
# Uses all 8 GPUs (device_map=auto); no concurrent engine prewarm during train.
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
# Full FT shards across all GPUs.
export CUDA_VISIBLE_DEVICES=${CUDA_VISIBLE_DEVICES:-0,1,2,3,4,5,6,7}

SRC=${SRC:-/root/mining_src/s4-h128-f33-pandora-full-ft}
OUT=${OUT:-/root/h128}
DATA=${DATA:-$OUT/winner_za_high_l2.jsonl}
BASE=${BASE:-/root/hf/hub/models--pandora-box--Affine-5eqdtdzqle-ckpt300-m4/snapshots/5218b1383952ff7a8d49b1d7b82acfe5e1bd448d}
TRAIN_DIR=$OUT/train
LOG=${LOG:-/root/logs/h128_train.nohup}

mkdir -p "$OUT" /root/logs "$TRAIN_DIR" /root/affine_data
test -d "$BASE"
test -s "$DATA"
test -f "$SRC/train_full.py"
test -f /root/mining_src/s4-h1v2-sft/thought_mask.py
n=$(wc -l <"$DATA")
echo "[h128] $(date -u +%Y-%m-%dT%H:%M:%SZ) examples=$n data=$DATA base=$BASE gpus=$CUDA_VISIBLE_DEVICES"
test "$n" -ge 200

echo "[h128] verify thought cuts (CPU)"
python3 /root/mining_src/s4-h1v2-sft/verify_thought_mask.py \
  --data "$DATA" \
  --out "$OUT/thought_mask_verify.json"

rm -f "$TRAIN_DIR/train.done" "$TRAIN_DIR/train_result.json"
echo "[h128] $(date -u +%Y-%m-%dT%H:%M:%SZ) launch full-FT lr=1e-6 on GPUs $CUDA_VISIBLE_DEVICES"
nohup python3 "$SRC/train_full.py" \
  --base "$BASE" \
  --data "$DATA" \
  --out-dir "$TRAIN_DIR" \
  --max-len 8192 \
  --epochs 1 \
  --lr 1e-6 \
  --batch 1 \
  --grad-accum 8 \
  --loss-on thought \
  >"$LOG" 2>&1 &
echo $! | tee /root/logs/h128_train.pid >"$OUT/train.pid"
python3 - <<PY
import json, time
from pathlib import Path
meta = {
    "utc": time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime()),
    "hypo": "H128",
    "family": "F33",
    "pid": int(Path("/root/logs/h128_train.pid").read_text().strip()),
    "base": "$BASE",
    "base_hub": "pandora-box/Affine-5eqdtdzqle-ckpt300-m4",
    "base_rev": "5218b1383952ff7a8d49b1d7b82acfe5e1bd448d",
    "data": "$DATA",
    "examples": $n,
    "lr": 1e-6,
    "loss_on": "thought",
    "recipe": "full_ft_no_lora",
    "gpus": "$CUDA_VISIBLE_DEVICES",
    "out": "$TRAIN_DIR",
    "log": "$LOG",
    "note": "F33 pandora-init dense full-FT × high-Λ2 z_A (no LoRA) vs Tok331102",
}
Path("/root/affine_data/h128_train_launched.json").write_text(json.dumps(meta, indent=2) + "\n")
print(json.dumps(meta, indent=2))
PY
echo "[h128] TRAIN_LAUNCHED pid=$(cat /root/logs/h128_train.pid)"
