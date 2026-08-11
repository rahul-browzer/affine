#!/usr/bin/env bash
# R4b: Tok-init thought-only full-FT — alt LR/epochs vs R4 (H121 stock).
# Overlay: upload_and_launch copies this to s4-h121-f26-full-ft/start_h121.sh.
# R4b: Tok-init full-FT lr=5e-6 EPOCHS=2 (≠ R4 lr=1e-6 epochs=1).
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

# R4b knobs (≠ R4 lr=1e-6 epochs=1)
LR=${R4B_LR:-5e-6}
EPOCHS=${R4B_EPOCHS:-2}
MAX_LEN=${R4B_MAX_LEN:-8192}

mkdir -p "$OUT" /root/logs "$TRAIN_DIR" /root/affine_data
test -d "$BASE"
test -s "$DATA"
test -f "$SRC/train_full.py"
test -f /root/mining_src/s4-h1v2-sft/thought_mask.py
n=$(wc -l <"$DATA")
echo "[r4b] $(date -u +%Y-%m-%dT%H:%M:%SZ) examples=$n data=$DATA base=$BASE gpus=$CUDA_VISIBLE_DEVICES"
echo "[r4b] knobs lr=$LR epochs=$EPOCHS max_len=$MAX_LEN axis=${R4B_AXIS:-fullft_lr5e6_ep2}"
test "$n" -ge 200

echo "[r4b] verify thought cuts (CPU)"
python3 /root/mining_src/s4-h1v2-sft/verify_thought_mask.py \
  --data "$DATA" \
  --out "$OUT/thought_mask_verify.json"

rm -f "$TRAIN_DIR/train.done" "$TRAIN_DIR/train_result.json"
echo "[r4b] $(date -u +%Y-%m-%dT%H:%M:%SZ) launch full-FT lr=$LR epochs=$EPOCHS on GPUs $CUDA_VISIBLE_DEVICES"
nohup python3 "$SRC/train_full.py" \
  --base "$BASE" \
  --data "$DATA" \
  --out-dir "$TRAIN_DIR" \
  --max-len "$MAX_LEN" \
  --epochs "$EPOCHS" \
  --lr "$LR" \
  --batch 1 \
  --grad-accum 8 \
  --loss-on thought \
  >"$LOG" 2>&1 &
echo $! | tee /root/logs/h121_train.pid >"$OUT/train.pid"
python3 - <<PY
import json, time
from pathlib import Path
meta = {
    "utc": time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime()),
    "hypo": "R4b",
    "family": "F26-lr-epoch",
    "axis": "${R4B_AXIS:-fullft_lr5e6_ep2}",
    "pid": int(Path("/root/logs/h121_train.pid").read_text().strip()),
    "base": "$BASE",
    "base_hub": "Tok331102/affine-5EqYW8McUc-af10",
    "base_rev": "eb8bf9a356a254f71faaa439e8abc3cfba572c53",
    "data": "$DATA",
    "examples": $n,
    "lr": float("$LR"),
    "epochs": float("$EPOCHS"),
    "max_len": int("$MAX_LEN"),
    "loss_on": "thought",
    "recipe": "full_ft_no_lora",
    "gpus": "$CUDA_VISIBLE_DEVICES",
    "out": "$TRAIN_DIR",
    "log": "$LOG",
    "note": "R4b Tok-init full-FT lr=5e-6 EPOCHS=2 (≠ R4 lr=1e-6 ep1)",
}
Path("/root/affine_data/h121_train_launched.json").write_text(json.dumps(meta, indent=2) + "\n")
Path("/root/affine_data/r4b_train_launched.json").write_text(json.dumps(meta, indent=2) + "\n")
print(json.dumps(meta, indent=2))
PY
echo "[r4b] TRAIN_LAUNCHED pid=$(cat /root/logs/h121_train.pid)"
