#!/usr/bin/env bash
# R3: Tok-init GRPO on teacher Reason (needs :8000 teacher ready).
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

mkdir -p "$OUT" /root/logs "$TRAIN_DIR" /root/affine_data
test -d "$BASE"
test -s "$DATA"
test -f "$SRC/train_reason_grpo.py"
n=$(wc -l <"$DATA")
echo "[r3] $(date -u +%Y-%m-%dT%H:%M:%SZ) examples=$n data=$DATA base=$BASE gpus=$CUDA_VISIBLE_DEVICES"
test "$n" -ge 200

echo "[r3] wait teacher at $TEACHER_URL"
for i in $(seq 1 240); do
  if curl -sf --max-time 5 "$TEACHER_URL/models" >/dev/null 2>&1; then
    echo "[r3] teacher ready after ${i}×15s"
    break
  fi
  if (( i == 240 )); then
    echo "[r3] FATAL: teacher never came up"
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
echo "[r3] $(date -u +%Y-%m-%dT%H:%M:%SZ) launch Reason-GRPO lr=5e-6 r=16 G=4 max_new=512 on GPUs $CUDA_VISIBLE_DEVICES"
nohup python3 "$SRC/train_reason_grpo.py" \
  --base "$BASE" \
  --data "$DATA" \
  --out-dir "$TRAIN_DIR" \
  --teacher-url "$TEACHER_URL" \
  --teacher-repo zai-org/GLM-4.5-Air-FP8 \
  --max-len 6144 \
  --max-new 512 \
  --epochs 1 \
  --lr 5e-6 \
  --lora-r 16 \
  --lora-alpha 32 \
  --group-size 4 \
  --temperature 0.8 \
  --max-steps 200 \
  >>"$LOG" 2>&1 &
echo $! | tee /root/logs/r3_train.pid >"$OUT/train.pid"
python3 - <<PY
import json, time
from pathlib import Path
meta = {
    "utc": time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime()),
    "axis": "R3",
    "hypo": "R3",
    "pid": int(Path("/root/logs/r3_train.pid").read_text().strip()),
    "base": "$BASE",
    "base_hub": "Tok331102/affine-5EqYW8McUc-af10",
    "base_rev": "eb8bf9a356a254f71faaa439e8abc3cfba572c53",
    "data": "$DATA",
    "examples": $n,
    "lr": 5e-6,
    "method": "grpo_teacher_reason",
    "lora_r": 16,
    "group_size": 4,
    "max_new": 512,
    "max_steps": 200,
    "gpus": "$CUDA_VISIBLE_DEVICES",
    "teacher_url": "$TEACHER_URL",
    "out": "$TRAIN_DIR",
    "log": "$LOG",
    "note": "R3 Reason-GRPO: reward=lpC(y|z)-lpC(y|∅); group baseline G=4; no CE on harvested z",
}
Path("/root/affine_data/r3_train_launched.json").write_text(json.dumps(meta, indent=2) + "\n")
print(json.dumps(meta, indent=2))
print("[r3] TRAIN_LAUNCHED pid=%s" % meta["pid"])
PY
