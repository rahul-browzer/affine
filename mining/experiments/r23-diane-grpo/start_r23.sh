#!/usr/bin/env bash
# R23: diane613-init GRPO on teacher Reason (needs :8000 teacher ready).
# Overlay: upload_and_launch copies this to r3-reason-grpo/start_r3.sh.
# R23: Diane-GRPO Reason (≠ R3 Tok-init, ≠ R16/R22 golden, ≠ R18–R21 parent-GRPO).
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
# Prefer BASE from mine.env (bootstrap writes diane snapshot path).
BASE=${BASE:-/root/hf/hub/models--diane613--Affine-5CQLBK7Mmw1vsk7eQcBok9Qn44JNU5YVrfNmZpJHPxLV271B/snapshots/ad0f3f116e44dc5154ca3f72b933faaefc4905fa}
TRAIN_DIR=$OUT/train
LOG=${LOG:-/root/logs/r3_train.nohup}
TEACHER_URL=${TEACHER_URL:-http://127.0.0.1:8000/v1}

LR=${R23_LR:-5e-6}
LORA_R=${R23_LORA_R:-16}
LORA_ALPHA=${R23_LORA_ALPHA:-32}
GROUP_SIZE=${R23_GROUP_SIZE:-4}
MAX_STEPS=${R23_MAX_STEPS:-200}

mkdir -p "$OUT" /root/logs "$TRAIN_DIR" /root/affine_data /root/r23
test -d "$BASE"
test -s "$DATA"
test -f "$SRC/train_reason_grpo.py"
n=$(wc -l <"$DATA")
echo "[r23] $(date -u +%Y-%m-%dT%H:%M:%SZ) examples=$n data=$DATA base=$BASE gpus=$CUDA_VISIBLE_DEVICES"
echo "[r23] knobs lr=$LR r=$LORA_R/α$LORA_ALPHA G=$GROUP_SIZE steps=$MAX_STEPS axis=${R23_AXIS:-diane_grpo_reason}"
test "$n" -ge 200

echo "[r23] wait teacher at $TEACHER_URL"
for i in $(seq 1 240); do
  if curl -sf --max-time 5 "$TEACHER_URL/models" >/dev/null 2>&1; then
    echo "[r23] teacher ready after ${i}×15s"
    break
  fi
  if (( i == 240 )); then
    echo "[r23] FATAL: teacher never came up"
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
echo "[r23] $(date -u +%Y-%m-%dT%H:%M:%SZ) launch diane Reason-GRPO lr=$LR r=$LORA_R G=$GROUP_SIZE on GPUs $CUDA_VISIBLE_DEVICES"
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
cp -f /root/logs/r3_train.pid /root/logs/r23_train.pid
python3 - <<PY
import json, time
from pathlib import Path
meta = {
    "utc": time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime()),
    "axis": "R23",
    "hypo": "R23",
    "pid": int(Path("/root/logs/r3_train.pid").read_text().strip()),
    "base": "$BASE",
    "base_hub": "diane613/Affine-5CQLBK7Mmw1vsk7eQcBok9Qn44JNU5YVrfNmZpJHPxLV271B",
    "base_rev": "ad0f3f116e44dc5154ca3f72b933faaefc4905fa",
    "data": "$DATA",
    "examples": $n,
    "lr": float("$LR"),
    "method": "grpo_teacher_reason_diane_init",
    "lora_r": int("$LORA_R"),
    "lora_alpha": int("$LORA_ALPHA"),
    "group_size": int("$GROUP_SIZE"),
    "max_new": 512,
    "max_steps": int("$MAX_STEPS"),
    "gpus": "$CUDA_VISIBLE_DEVICES",
    "teacher_url": "$TEACHER_URL",
    "out": "$TRAIN_DIR",
    "log": "$LOG",
    "note": "R23 diane×teacher-Reason GRPO — ≠ R3 Tok-init, ≠ R16/R22 golden, ≠ R18–R21 parent-GRPO",
}
Path("/root/affine_data/r3_train_launched.json").write_text(json.dumps(meta, indent=2) + "\n")
Path("/root/affine_data/r23_train_launched.json").write_text(json.dumps(meta, indent=2) + "\n")
print(json.dumps(meta, indent=2))
print("[r23] TRAIN_LAUNCHED pid=%s" % meta["pid"])
PY
