#!/usr/bin/env bash
# R7: Tok-init thought-only full-FT on top-250 Reason (λ2) z_A, EPOCHS=2.
# Installed over s4-h121-f26-full-ft/start_h121.sh so bootstrap_h121 can call it.
# Axis ≠ R4: R4 uses clip_l1 n=406; R7 uses top Reason from h99 (min≈0.116).
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
export CUDA_VISIBLE_DEVICES=${CUDA_VISIBLE_DEVICES:-0,1,2,3,4,5,6,7}

SRC=${SRC:-/root/mining_src/s4-h121-f26-full-ft}
OUT=${OUT:-/root/h121}
DATA=${DATA:-$OUT/winner_za_high_l2.jsonl}
BASE=${BASE:-/root/hf/hub/models--Tok331102--affine-5EqYW8McUc-af10/snapshots/eb8bf9a356a254f71faaa439e8abc3cfba572c53}
TRAIN_DIR=$OUT/train
LOG=${LOG:-/root/logs/h121_train.nohup}
EPOCHS=${EPOCHS:-2}
LR=${LR:-1e-6}

mkdir -p "$OUT" /root/logs "$TRAIN_DIR" /root/affine_data /root/r7
test -d "$BASE"
test -s "$DATA"
test -f "$SRC/train_full.py"
test -f /root/mining_src/s4-h1v2-sft/thought_mask.py
n=$(wc -l <"$DATA")
echo "[r7/h121] $(date -u +%Y-%m-%dT%H:%M:%SZ) examples=$n data=$DATA base=$BASE gpus=$CUDA_VISIBLE_DEVICES epochs=$EPOCHS"
test "$n" -ge 200

echo "[r7/h121] verify thought cuts (CPU)"
python3 /root/mining_src/s4-h1v2-sft/verify_thought_mask.py \
  --data "$DATA" \
  --out "$OUT/thought_mask_verify.json"

rm -f "$TRAIN_DIR/train.done" "$TRAIN_DIR/train_result.json"
echo "[r7/h121] $(date -u +%Y-%m-%dT%H:%M:%SZ) launch full-FT lr=$LR epochs=$EPOCHS on GPUs $CUDA_VISIBLE_DEVICES"
nohup python3 "$SRC/train_full.py" \
  --base "$BASE" \
  --data "$DATA" \
  --out-dir "$TRAIN_DIR" \
  --max-len 8192 \
  --epochs "$EPOCHS" \
  --lr "$LR" \
  --batch 1 \
  --grad-accum 8 \
  --loss-on thought \
  >"$LOG" 2>&1 &
echo $! | tee /root/logs/h121_train.pid >"$OUT/train.pid"
cp -f /root/logs/h121_train.pid /root/logs/r7_train.pid
python3 - <<PY
import json, time
from pathlib import Path
meta = {
    "utc": time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime()),
    "hypo": "R7",
    "family": "data_filter_curriculum",
    "pid": int(Path("/root/logs/h121_train.pid").read_text().strip()),
    "base": "$BASE",
    "base_hub": "Tok331102/affine-5EqYW8McUc-af10",
    "base_rev": "eb8bf9a356a254f71faaa439e8abc3cfba572c53",
    "data": "$DATA",
    "examples": $n,
    "lr": float("$LR"),
    "epochs": int("$EPOCHS"),
    "loss_on": "thought",
    "recipe": "full_ft_top250_reason",
    "gpus": "$CUDA_VISIBLE_DEVICES",
    "out": "$TRAIN_DIR",
    "log": "$LOG",
    "note": "R7 top-250 Reason (λ2) curriculum full-FT EPOCHS=$EPOCHS — ≠ R4 clip_l1 n=406",
}
Path("/root/affine_data/h121_train_launched.json").write_text(json.dumps(meta, indent=2) + "\n")
Path("/root/affine_data/r7_train_launched.json").write_text(json.dumps(meta, indent=2) + "\n")
print(json.dumps(meta, indent=2))
PY
echo "[r7/h121] TRAIN_LAUNCHED pid=$(cat /root/logs/h121_train.pid)"
