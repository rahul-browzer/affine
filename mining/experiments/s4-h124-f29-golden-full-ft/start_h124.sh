#!/usr/bin/env bash
# H124: golden-crown-init thought-only full-FT on high-Λ2 z_A (F29; no LoRA).
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

SRC=${SRC:-/root/mining_src/s4-h124-f29-golden-full-ft}
OUT=${OUT:-/root/h124}
DATA=${DATA:-$OUT/winner_za_high_l2.jsonl}
BASE=${BASE:-/root/hf/hub/models--golden-crown--Affine-5EpvnXGu8jUAVc67oPGgJ3brR4JZqjBUSaTKhZuBoNAAzSJF/snapshots/ee37f4f0457df943d957435d7c9c24222a7ca93d}
TRAIN_DIR=$OUT/train
LOG=${LOG:-/root/logs/h124_train.nohup}

mkdir -p "$OUT" /root/logs "$TRAIN_DIR" /root/affine_data
test -d "$BASE"
test -s "$DATA"
test -f "$SRC/train_full.py"
test -f /root/mining_src/s4-h1v2-sft/thought_mask.py
n=$(wc -l <"$DATA")
echo "[h124] $(date -u +%Y-%m-%dT%H:%M:%SZ) examples=$n data=$DATA base=$BASE gpus=$CUDA_VISIBLE_DEVICES"
test "$n" -ge 200

echo "[h124] verify thought cuts (CPU)"
python3 /root/mining_src/s4-h1v2-sft/verify_thought_mask.py \
  --data "$DATA" \
  --out "$OUT/thought_mask_verify.json"

rm -f "$TRAIN_DIR/train.done" "$TRAIN_DIR/train_result.json"
echo "[h124] $(date -u +%Y-%m-%dT%H:%M:%SZ) launch full-FT lr=1e-6 on GPUs $CUDA_VISIBLE_DEVICES"
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
echo $! | tee /root/logs/h124_train.pid >"$OUT/train.pid"
python3 - <<PY
import json, time
from pathlib import Path
meta = {
    "utc": time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime()),
    "hypo": "H124",
    "family": "F29",
    "pid": int(Path("/root/logs/h124_train.pid").read_text().strip()),
    "base": "$BASE",
    "base_hub": "golden-crown/Affine-5EpvnXGu8jUAVc67oPGgJ3brR4JZqjBUSaTKhZuBoNAAzSJF",
    "base_rev": "ee37f4f0457df943d957435d7c9c24222a7ca93d",
    "data": "$DATA",
    "examples": $n,
    "lr": 1e-6,
    "loss_on": "thought",
    "recipe": "full_ft_no_lora",
    "gpus": "$CUDA_VISIBLE_DEVICES",
    "out": "$TRAIN_DIR",
    "log": "$LOG",
    "note": "F29 golden-crown-init dense full-FT × high-Λ2 z_A (no LoRA) vs Tok331102",
}
Path("/root/affine_data/h124_train_launched.json").write_text(json.dumps(meta, indent=2) + "\n")
print(json.dumps(meta, indent=2))
PY
echo "[h124] TRAIN_LAUNCHED pid=$(cat /root/logs/h124_train.pid)"
