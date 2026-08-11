#!/usr/bin/env bash
# R5b: Talent-init thought-only full-FT — ≠ R5 Genesis, ≠ R4 Tok.
# Overlay: upload_and_launch copies this to s4-h122-f27-genesis-full-ft/start_h122.sh.
# R5b: TalentPigs reign-3 full-FT lr=1e-6 EPOCHS=1 on winner_za_high_l1.
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

SRC=${SRC:-/root/mining_src/s4-h122-f27-genesis-full-ft}
OUT=${OUT:-/root/h122}
DATA=${DATA:-$OUT/winner_za_high_l2.jsonl}
BASE=${BASE:-/root/hf/hub/models--TalentPigs--affine-5ekxlcg3fx-abc/snapshots/dbfbb3e2a17c7603e7fc68a3a15b343f42dfdef4}
TRAIN_DIR=$OUT/train
LOG=${LOG:-/root/logs/h122_train.nohup}

LR=${R5B_LR:-1e-6}
EPOCHS=${R5B_EPOCHS:-1}
MAX_LEN=${R5B_MAX_LEN:-8192}

mkdir -p "$OUT" /root/logs "$TRAIN_DIR" /root/affine_data
test -d "$BASE"
test -s "$DATA"
test -f "$SRC/train_full.py"
test -f /root/mining_src/s4-h1v2-sft/thought_mask.py
n=$(wc -l <"$DATA")
echo "[r5b] $(date -u +%Y-%m-%dT%H:%M:%SZ) examples=$n data=$DATA base=$BASE gpus=$CUDA_VISIBLE_DEVICES"
echo "[r5b] knobs lr=$LR epochs=$EPOCHS max_len=$MAX_LEN axis=${R5B_AXIS:-talent_fullft}"
test "$n" -ge 200

echo "[r5b] verify thought cuts (CPU)"
python3 /root/mining_src/s4-h1v2-sft/verify_thought_mask.py \
  --data "$DATA" \
  --out "$OUT/thought_mask_verify.json"

rm -f "$TRAIN_DIR/train.done" "$TRAIN_DIR/train_result.json"
echo "[r5b] $(date -u +%Y-%m-%dT%H:%M:%SZ) launch full-FT lr=$LR epochs=$EPOCHS on GPUs $CUDA_VISIBLE_DEVICES"
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
echo $! | tee /root/logs/h122_train.pid >"$OUT/train.pid"
python3 - <<PY
import json, time
from pathlib import Path
meta = {
    "utc": time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime()),
    "hypo": "R5b",
    "family": "F27-talent-base",
    "axis": "${R5B_AXIS:-talent_fullft}",
    "pid": int(Path("/root/logs/h122_train.pid").read_text().strip()),
    "base": "$BASE",
    "base_hub": "TalentPigs/affine-5ekxlcg3fx-abc",
    "base_rev": "dbfbb3e2a17c7603e7fc68a3a15b343f42dfdef4",
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
    "note": "R5b: TalentPigs reign-3 full-FT (≠ R5 Genesis, ≠ R4 Tok)",
}
Path("/root/affine_data/h122_train_launched.json").write_text(json.dumps(meta, indent=2) + "\n")
Path("/root/affine_data/r5b_train_launched.json").write_text(json.dumps(meta, indent=2) + "\n")
print(json.dumps(meta, indent=2))
PY
echo "[r5b] TRAIN_LAUNCHED pid=$(cat /root/logs/h122_train.pid)"
