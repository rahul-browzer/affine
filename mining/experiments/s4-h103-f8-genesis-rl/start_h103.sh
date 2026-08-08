#!/usr/bin/env bash
# H103/F8: Genesis-init REINFORCE on self-L1lift (F1 recipe × non-king base).
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

SRC=${SRC:-/root/mining_src/s4-h103-f8-genesis-rl}
OUT=${OUT:-/root/h103}
DATA=${DATA:-$OUT/winner_za_high_l1.jsonl}
BASE=${BASE:-/root/hf/hub/models--dendriteholdings--albedo-qwen3.6-35b-king-genesis/snapshots/abe89194d6addf82e71f3f1ba9fef94b05404abf}
TRAIN_DIR=$OUT/train
LOG=${LOG:-/root/logs/h103_train.nohup}

mkdir -p "$OUT" /root/logs "$TRAIN_DIR" /root/affine_data
test -d "$BASE"
test -s "$DATA"
test -f "$SRC/train_rl_l1.py"
n=$(wc -l <"$DATA")
echo "[h103] $(date -u +%Y-%m-%dT%H:%M:%SZ) examples=$n data=$DATA base=$BASE gpus=$CUDA_VISIBLE_DEVICES"
test "$n" -ge 200

python - <<'PY'
import importlib
for m in ("peft", "accelerate", "torch", "transformers"):
    importlib.import_module(m)
print("deps OK")
PY

rm -f "$TRAIN_DIR/train.done" "$TRAIN_DIR/train_result.json"
echo "[h103] $(date -u +%Y-%m-%dT%H:%M:%SZ) launch F8 Genesis-RL lr=5e-6 r=16 G=2 on GPUs $CUDA_VISIBLE_DEVICES"
nohup python3 "$SRC/train_rl_l1.py" \
  --base "$BASE" \
  --data "$DATA" \
  --out-dir "$TRAIN_DIR" \
  --max-len 6144 \
  --max-new 256 \
  --epochs 1 \
  --lr 5e-6 \
  --lora-r 16 \
  --lora-alpha 32 \
  --group-size 2 \
  --temperature 0.8 \
  --max-steps 200 \
  --clip 0.1 \
  >"$LOG" 2>&1 &
echo $! | tee /root/logs/h103_train.pid >"$OUT/train.pid"
python3 - <<PY
import json, time
from pathlib import Path
meta = {
    "utc": time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime()),
    "hypo": "H103",
    "family": "F8",
    "pid": int(Path("/root/logs/h103_train.pid").read_text().strip()),
    "base": "$BASE",
    "base_hub": "dendriteholdings/albedo-qwen3.6-35b-king-genesis",
    "base_rev": "abe89194d6addf82e71f3f1ba9fef94b05404abf",
    "data": "$DATA",
    "examples": $n,
    "lr": 5e-6,
    "method": "reinforce_self_l1lift",
    "lora_r": 16,
    "group_size": 2,
    "max_steps": 200,
    "gpus": "$CUDA_VISIBLE_DEVICES",
    "out": "$TRAIN_DIR",
    "log": "$LOG",
    "note": "F8 Genesis-init RL: REINFORCE thought tokens w/ reward=clip(self L1lift,±0.1); non-king base so Λ2 can move",
}
Path("/root/affine_data/h103_train_launched.json").write_text(json.dumps(meta, indent=2) + "\n")
print(json.dumps(meta, indent=2))
print("[h103] TRAIN_LAUNCHED pid=%s" % meta["pid"])
PY
