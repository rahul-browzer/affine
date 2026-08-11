#!/usr/bin/env bash
# R9: Tok-init thought-only LoRA on expanded teacher z_C (format prior).
# Installed as start_h99.sh overlay — H99 bootstrap calls that name.
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
OUT=${OUT:-/root/h99}
# Bootstrap still tests /root/h99/winner_za_high_l2.jsonl — content is expanded teacher z_C.
DATA=${DATA:-$OUT/winner_za_high_l2.jsonl}
BASE=${BASE:-/root/hf/hub/models--Tok331102--affine-5EqYW8McUc-af10/snapshots/eb8bf9a356a254f71faaa439e8abc3cfba572c53}
TRAIN_DIR=$OUT/train
LOG=${LOG:-/root/logs/h99_train.nohup}
# Also mirror R9-named logs for operators.
R9_LOG=${R9_LOG:-/root/logs/r9_train.nohup}
EPOCHS=${EPOCHS:-3}
LR=${LR:-1e-5}
LORA_R=${LORA_R:-32}
LORA_ALPHA=${LORA_ALPHA:-64}
MAX_LEN=${MAX_LEN:-16384}

mkdir -p "$OUT" /root/logs "$TRAIN_DIR" /root/affine_data /root/r9
test -d "$BASE"
test -s "$DATA"
test -f "$SRC/train_lora.py"
n=$(wc -l <"$DATA")
echo "[r9] $(date -u +%Y-%m-%dT%H:%M:%SZ) examples=$n data=$DATA base=$BASE gpus=$CUDA_VISIBLE_DEVICES epochs=$EPOCHS lr=$LR r=$LORA_R max_len=$MAX_LEN"
test "$n" -ge 500

echo "[r9] verify thought cuts (CPU)"
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
echo "[r9] $(date -u +%Y-%m-%dT%H:%M:%SZ) launch thought-only LoRA on GPUs $CUDA_VISIBLE_DEVICES"
nohup python3 "$SRC/train_lora.py" \
  --base "$BASE" \
  --data "$DATA" \
  --out-dir "$TRAIN_DIR" \
  --max-len "$MAX_LEN" \
  --epochs "$EPOCHS" \
  --lr "$LR" \
  --lora-r "$LORA_R" \
  --lora-alpha "$LORA_ALPHA" \
  --batch 1 \
  --grad-accum 8 \
  --loss-on thought \
  >"$LOG" 2>&1 &
echo $! | tee /root/logs/h99_train.pid /root/logs/r9_train.pid >"$OUT/train.pid"
ln -sfn "$LOG" "$R9_LOG" 2>/dev/null || cp -f "$LOG" "$R9_LOG" 2>/dev/null || true
python3 - <<PY
import json, time
from pathlib import Path
meta = {
    "utc": time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime()),
    "hyp": "R9",
    "axis": "teacher_zc_expanded_tok_lora",
    "pid": int(Path("/root/logs/r9_train.pid").read_text().strip()),
    "base": "$BASE",
    "base_hub": "Tok331102/affine-5EqYW8McUc-af10",
    "base_rev": "eb8bf9a356a254f71faaa439e8abc3cfba572c53",
    "data": "$DATA",
    "examples": $n,
    "lr": float("$LR"),
    "lora_r": int("$LORA_R"),
    "lora_alpha": int("$LORA_ALPHA"),
    "epochs": int("$EPOCHS"),
    "max_len": int("$MAX_LEN"),
    "loss_on": "thought",
    "gpus": "$CUDA_VISIBLE_DEVICES",
    "out": "$TRAIN_DIR",
    "log": "$LOG",
    "note": "R9 Tok-LoRA × expanded teacher z_C (≠ H102 Genesis-shortz, ≠ H123 fullFT-shortz, ≠ R1 winner_za)",
    "decision": "Reason v3 paired margin vs Tok; submit if ≥1.5×(2·SE)",
}
Path("/root/affine_data/h99_train_launched.json").write_text(json.dumps(meta, indent=2) + "\n")
Path("/root/affine_data/r9_train_launched.json").write_text(json.dumps(meta, indent=2) + "\n")
Path("/root/r9/train_launched.json").write_text(json.dumps(meta, indent=2) + "\n")
print(json.dumps(meta, indent=2))
PY
echo "[r9] TRAIN_LAUNCHED pid=$(cat /root/logs/r9_train.pid)"
