#!/usr/bin/env bash
# Launch H1v2 thought-only LoRA train on mine-sim-1 (GPUs 6,7).
# Engines on 0-5 (teacher/king/chall + n80 sim) stay up.
# Run on the pod: bash /root/mining_src/s4-h1v2-sft/start_h1v2.sh
set -euo pipefail

export PATH="/root/.local/bin:${PATH}"
# shellcheck disable=SC1091
source /root/venv/bin/activate
if [[ -f /root/mine.env ]]; then
  # shellcheck disable=SC1091
  source /root/mine.env
fi

export HF_HOME=${HF_HOME:-/root/hf}
export CUDA_VISIBLE_DEVICES=${CUDA_VISIBLE_DEVICES:-6,7}

SRC=/root/mining_src/s4-h1v2-sft
OUT=/root/h1v2
# Reuse H1 harvest (440 rows) — same teacher_refs, different loss mask.
DATA=${DATA:-/root/h1/teacher_refs_sft.jsonl}
BASE=${BASE:-/root/hf/hub/models--kevin954--Affine-5dfqbbh8ev-sft/snapshots/6a5815fad8f4e34c983b1933c1fae5762fe25220}
TRAIN_DIR=$OUT/train
LOG=/root/logs/h1v2_train.nohup

mkdir -p "$OUT" /root/logs "$TRAIN_DIR"

test -f "$DATA"
n=$(wc -l <"$DATA")
echo "[h1v2] $(date -u +%Y-%m-%dT%H:%M:%SZ) examples=$n data=$DATA"
test "$n" -ge 50

echo "[h1v2] verify thought cuts (CPU)"
python3 "$SRC/verify_thought_mask.py" \
  --data "$DATA" \
  --out "$OUT/thought_mask_verify.json"

echo "[h1v2] $(date -u +%Y-%m-%dT%H:%M:%SZ) ensure peft/accelerate"
python - <<'PY'
import importlib
need = []
for m in ("peft", "accelerate"):
    try:
        importlib.import_module(m)
    except ImportError:
        need.append(m)
print("need", need)
if need:
    raise SystemExit(2)
PY

rm -f "$TRAIN_DIR/train.done"
echo "[h1v2] $(date -u +%Y-%m-%dT%H:%M:%SZ) launch thought-only train on GPUs $CUDA_VISIBLE_DEVICES"
nohup python3 "$SRC/train_lora.py" \
  --base "$BASE" \
  --data "$DATA" \
  --out-dir "$TRAIN_DIR" \
  --max-len 8192 \
  --epochs 1 \
  --lr 2e-5 \
  --lora-r 16 \
  --lora-alpha 32 \
  --batch 1 \
  --grad-accum 8 \
  --loss-on thought \
  >"$LOG" 2>&1 &
echo $! > /root/logs/h1v2_train.pid
echo "[h1v2] train pid=$(cat /root/logs/h1v2_train.pid) log=$LOG"
echo "[h1v2] $(date -u +%Y-%m-%dT%H:%M:%SZ) TRAIN_LAUNCHED"
