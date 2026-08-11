#!/usr/bin/env bash
# R15: pandora-init REINFORCE on teacher Reason (needs :8000 teacher ready).
# Overlay: upload_and_launch copies this to s4-h135-f40-kevin-rl-l2/start_h135.sh.
# R15: pandora-REINFORCE Reason (≠ R14 kevin, ≠ R3/R8 Tok RL, ≠ H128 pandora-FT).
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

SRC=${SRC:-/root/mining_src/s4-h135-f40-kevin-rl-l2}
OUT=${OUT:-/root/h135}
DATA=${DATA:-$OUT/winner_za_high_l1.jsonl}
BASE=${BASE:-/root/hf/hub/models--pandora-box--Affine-5eqdtdzqle-ckpt300-m4/snapshots/5218b1383952ff7a8d49b1d7b82acfe5e1bd448d}
TRAIN_DIR=$OUT/train
LOG=${LOG:-/root/logs/h135_train.nohup}
TEACHER_URL=${TEACHER_URL:-http://127.0.0.1:8000/v1}

LR=${R15_LR:-5e-6}
LORA_R=${R15_LORA_R:-16}
LORA_ALPHA=${R15_LORA_ALPHA:-32}
GROUP=${R15_GROUP_SIZE:-2}
MAX_STEPS=${R15_MAX_STEPS:-200}
MAX_NEW=${R15_MAX_NEW:-256}

mkdir -p "$OUT" /root/logs "$TRAIN_DIR" /root/affine_data /root/r15
test -d "$BASE"
test -s "$DATA"
test -f "$SRC/train_rl_l2.py"
n=$(wc -l <"$DATA")
echo "[r15] $(date -u +%Y-%m-%dT%H:%M:%SZ) examples=$n data=$DATA base=$BASE gpus=$CUDA_VISIBLE_DEVICES"
echo "[r15] knobs lr=$LR r=$LORA_R/α$LORA_ALPHA G=$GROUP steps=$MAX_STEPS axis=${R15_AXIS:-pandora_reinforce_reason}"
test "$n" -ge 200

echo "[r15] wait teacher at $TEACHER_URL"
for i in $(seq 1 240); do
  if curl -sf --max-time 5 "$TEACHER_URL/models" >/dev/null 2>&1; then
    echo "[r15] teacher ready after ${i}×15s"
    break
  fi
  if (( i == 240 )); then
    echo "[r15] FATAL: teacher never came up"
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
echo "[r15] $(date -u +%Y-%m-%dT%H:%M:%SZ) launch pandora-REINFORCE-Reason lr=$LR r=$LORA_R G=$GROUP on GPUs $CUDA_VISIBLE_DEVICES"
nohup python3 "$SRC/train_rl_l2.py" \
  --base "$BASE" \
  --data "$DATA" \
  --out-dir "$TRAIN_DIR" \
  --teacher-url "$TEACHER_URL" \
  --teacher-repo zai-org/GLM-4.5-Air-FP8 \
  --max-len 6144 \
  --max-new "$MAX_NEW" \
  --epochs 1 \
  --lr "$LR" \
  --lora-r "$LORA_R" \
  --lora-alpha "$LORA_ALPHA" \
  --group-size "$GROUP" \
  --temperature 0.8 \
  --max-steps "$MAX_STEPS" \
  >"$LOG" 2>&1 &
echo $! | tee /root/logs/h135_train.pid >"$OUT/train.pid"
cp -f /root/logs/h135_train.pid /root/logs/r15_train.pid
python3 - <<PY
import json, time
from pathlib import Path
meta = {
    "utc": time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime()),
    "hypo": "R15",
    "family": "pandora-reinforce-reason",
    "axis": "${R15_AXIS:-pandora_reinforce_reason}",
    "pid": int(Path("/root/logs/h135_train.pid").read_text().strip()),
    "base": "$BASE",
    "base_hub": "pandora-box/Affine-5eqdtdzqle-ckpt300-m4",
    "base_rev": "5218b1383952ff7a8d49b1d7b82acfe5e1bd448d",
    "data": "$DATA",
    "examples": $n,
    "lr": float("$LR"),
    "method": "reinforce_teacher_reason",
    "lora_r": int("$LORA_R"),
    "lora_alpha": int("$LORA_ALPHA"),
    "group_size": int("$GROUP"),
    "max_steps": int("$MAX_STEPS"),
    "max_new": int("$MAX_NEW"),
    "gpus": "$CUDA_VISIBLE_DEVICES",
    "teacher_url": "$TEACHER_URL",
    "out": "$TRAIN_DIR",
    "log": "$LOG",
    "note": "R15 pandora×teacher-Reason REINFORCE — ≠ R14 kevin, ≠ R3/R8 Tok RL, ≠ H128 FT",
}
Path("/root/affine_data/h135_train_launched.json").write_text(json.dumps(meta, indent=2) + "\n")
Path("/root/affine_data/r15_train_launched.json").write_text(json.dumps(meta, indent=2) + "\n")
print(json.dumps(meta, indent=2))
print("[r15] TRAIN_LAUNCHED pid=%s" % meta["pid"])
PY
