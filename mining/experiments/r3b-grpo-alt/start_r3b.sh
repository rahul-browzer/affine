#!/usr/bin/env bash
# R3b: Tok-init GRPO on teacher Reason — alt LR/rank vs R3 (needs :8000 teacher).
# Overlay: upload_and_launch copies this to r3-reason-grpo/start_r3.sh.
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
export PYTHONPATH=/root/mining_src/affine_pkg:${PYTHONPATH:-}

SRC=${SRC:-/root/mining_src/r3-reason-grpo}
OUT=${OUT:-/root/r3}
DATA=${DATA:-$OUT/winner_za_high_l1.jsonl}
BASE=${BASE:-/root/hf/hub/models--Tok331102--affine-5EqYW8McUc-af10/snapshots/eb8bf9a356a254f71faaa439e8abc3cfba572c53}
TRAIN_DIR=$OUT/train
LOG=${LOG:-/root/logs/r3_train.nohup}
TEACHER_URL=${TEACHER_URL:-http://127.0.0.1:8000/v1}

# R3b knobs (≠ R3 lr=5e-6 r=16 G=4)
LR=${R3B_LR:-2e-5}
LORA_R=${R3B_LORA_R:-64}
LORA_ALPHA=${R3B_LORA_ALPHA:-128}
GROUP_SIZE=${R3B_GROUP_SIZE:-8}
MAX_STEPS=${R3B_MAX_STEPS:-200}

mkdir -p "$OUT" /root/logs "$TRAIN_DIR" /root/affine_data
test -d "$BASE"
test -s "$DATA"
test -f "$SRC/train_reason_grpo.py"
n=$(wc -l <"$DATA")
echo "[r3b] $(date -u +%Y-%m-%dT%H:%M:%SZ) examples=$n data=$DATA base=$BASE gpus=$CUDA_VISIBLE_DEVICES"
echo "[r3b] knobs lr=$LR r=$LORA_R α=$LORA_ALPHA G=$GROUP_SIZE max_steps=$MAX_STEPS"
test "$n" -ge 200

echo "[r3b] wait teacher at $TEACHER_URL"
for i in $(seq 1 240); do
  if curl -sf --max-time 5 "$TEACHER_URL/models" >/dev/null 2>&1; then
    echo "[r3b] teacher ready after ${i}×15s"
    break
  fi
  if (( i == 240 )); then
    echo "[r3b] FATAL: teacher never came up"
    exit 1
  fi
  sleep 15
done

python - <<'PY'
import importlib
for m in ("peft", "accelerate", "torch", "transformers", "httpx"):
    importlib.import_module(m)
print("deps OK")
PY

rm -f "$TRAIN_DIR/train.done" "$TRAIN_DIR/train_result.json"
echo "[r3b] $(date -u +%Y-%m-%dT%H:%M:%SZ) launch Reason-GRPO lr=$LR r=$LORA_R G=$GROUP_SIZE max_new=512 on GPUs $CUDA_VISIBLE_DEVICES"
nohup python3 "$SRC/train_reason_grpo.py" \
  --base "$BASE" \
  --data "$DATA" \
  --out-dir "$TRAIN_DIR" \
  --teacher-url "$TEACHER_URL" \
  --teacher-repo zai-org/GLM-4.5-Air-FP8 \
  --max-len 6144 \
  --max-new 512 \
  --epochs 1 \
  --lr "$LR" \
  --lora-r "$LORA_R" \
  --lora-alpha "$LORA_ALPHA" \
  --group-size "$GROUP_SIZE" \
  --temperature 0.8 \
  --max-steps "$MAX_STEPS" \
  >>"$LOG" 2>&1 &
echo $! | tee /root/logs/r3_train.pid >"$OUT/train.pid"
python3 - <<PY
import json, time
from pathlib import Path
meta = {
    "utc": time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime()),
    "axis": "R3b",
    "hypo": "R3b",
    "pid": int(Path("/root/logs/r3_train.pid").read_text().strip()),
    "base": "$BASE",
    "base_hub": "Tok331102/affine-5EqYW8McUc-af10",
    "base_rev": "eb8bf9a356a254f71faaa439e8abc3cfba572c53",
    "data": "$DATA",
    "examples": $n,
    "lr": float("$LR"),
    "method": "grpo_teacher_reason_alt_lr_rank",
    "lora_r": int("$LORA_R"),
    "lora_alpha": int("$LORA_ALPHA"),
    "group_size": int("$GROUP_SIZE"),
    "max_new": 512,
    "max_steps": int("$MAX_STEPS"),
    "gpus": "$CUDA_VISIBLE_DEVICES",
    "teacher_url": "$TEACHER_URL",
    "out": "$TRAIN_DIR",
    "log": "$LOG",
    "note": "R3b vs R3: lr=2e-5 r=64/α128 G=8 (R3 was lr=5e-6 r=16 G=4); same reward=Reason",
}
Path("/root/affine_data/r3_train_launched.json").write_text(json.dumps(meta, indent=2) + "\n")
Path("/root/affine_data/r3b_train_launched.json").write_text(json.dumps(meta, indent=2) + "\n")
print(json.dumps(meta, indent=2))
print("[r3b] TRAIN_LAUNCHED pid=%s" % meta["pid"])
PY
