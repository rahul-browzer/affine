#!/usr/bin/env bash
# H98/F1: Tok-init REINFORCE on self-L1lift (not SFT on harvested z).
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

SRC=${SRC:-/root/mining_src/s4-h98-f1-rl-l1}
OUT=${OUT:-/root/h98}
DATA=${DATA:-$OUT/winner_za_high_l1.jsonl}
BASE=${BASE:-/root/hf/hub/models--Tok331102--affine-5EqYW8McUc-af10/snapshots/eb8bf9a356a254f71faaa439e8abc3cfba572c53}
TRAIN_DIR=$OUT/train
LOG=${LOG:-/root/logs/h98_train.nohup}

mkdir -p "$OUT" /root/logs "$TRAIN_DIR" /root/affine_data
test -d "$BASE"
test -s "$DATA"
test -f "$SRC/train_rl_l1.py"
n=$(wc -l <"$DATA")
echo "[h98] $(date -u +%Y-%m-%dT%H:%M:%SZ) examples=$n data=$DATA base=$BASE gpus=$CUDA_VISIBLE_DEVICES"
test "$n" -ge 200

python - <<'PY'
import importlib
for m in ("peft", "accelerate", "torch", "transformers"):
    importlib.import_module(m)
print("deps OK")
PY

rm -f "$TRAIN_DIR/train.done" "$TRAIN_DIR/train_result.json"
echo "[h98] $(date -u +%Y-%m-%dT%H:%M:%SZ) launch F1 REINFORCE-L1lift lr=5e-6 r=16 G=2 on GPUs $CUDA_VISIBLE_DEVICES"
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
echo $! | tee /root/logs/h98_train.pid >"$OUT/train.pid"
python3 - <<PY
import json, time
from pathlib import Path
meta = {
    "utc": time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime()),
    "hypo": "H98",
    "family": "F1",
    "pid": int(Path("/root/logs/h98_train.pid").read_text().strip()),
    "base": "$BASE",
    "base_hub": "Tok331102/affine-5EqYW8McUc-af10",
    "base_rev": "eb8bf9a356a254f71faaa439e8abc3cfba572c53",
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
    "note": "F1 Direct-RL-on-S screen: REINFORCE thought tokens w/ reward=clip(self L1lift,±0.1); no CE on harvested z",
}
Path("/root/affine_data/h98_train_launched.json").write_text(json.dumps(meta, indent=2) + "\n")
print(json.dumps(meta, indent=2))
print("[h98] TRAIN_LAUNCHED pid=%s" % meta["pid"])
PY
