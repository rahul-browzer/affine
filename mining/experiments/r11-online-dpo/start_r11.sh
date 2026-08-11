#!/usr/bin/env bash
# R11: Tok-init online-DPO on live teacher Reason (sample G=2, BT vs frozen base).
# Overlay: upload_and_launch copies this to s4-h139-f44-tok-online-dpo-l2/start_h139.sh.
# R11: online-DPO Reason (≠ R3 GRPO, ≠ R8 REINFORCE, ≠ H138 offline DPO).
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

SRC=${SRC:-/root/mining_src/s4-h139-f44-tok-online-dpo-l2}
OUT=${OUT:-/root/h139}
DATA=${DATA:-$OUT/winner_za_high_l1.jsonl}
BASE=${BASE:-/root/hf/hub/models--Tok331102--affine-5EqYW8McUc-af10/snapshots/eb8bf9a356a254f71faaa439e8abc3cfba572c53}
TRAIN_DIR=$OUT/train
LOG=${LOG:-/root/logs/h139_train.nohup}
TEACHER_URL=${TEACHER_URL:-http://127.0.0.1:8000/v1}

LR=${R11_LR:-5e-6}
LORA_R=${R11_LORA_R:-16}
LORA_ALPHA=${R11_LORA_ALPHA:-32}
BETA=${R11_BETA:-0.1}
GROUP=${R11_GROUP:-2}
MAX_STEPS=${R11_MAX_STEPS:-150}
MIN_GAP=${R11_MIN_GAP:-0.005}

mkdir -p "$OUT" /root/logs "$TRAIN_DIR" /root/affine_data /root/r11
test -d "$BASE"
test -s "$DATA"
test -f "$SRC/train_online_dpo.py"
n=$(wc -l <"$DATA")
echo "[r11] $(date -u +%Y-%m-%dT%H:%M:%SZ) examples=$n data=$DATA base=$BASE gpus=$CUDA_VISIBLE_DEVICES"
echo "[r11] knobs lr=$LR r=$LORA_R/α$LORA_ALPHA β=$BETA G=$GROUP steps=$MAX_STEPS min_gap=$MIN_GAP axis=${R11_AXIS:-online_dpo_reason}"
test "$n" -ge 200

echo "[r11] wait teacher at $TEACHER_URL"
for i in $(seq 1 240); do
  if curl -sf --max-time 5 "$TEACHER_URL/models" >/dev/null 2>&1; then
    echo "[r11] teacher ready after ${i}×15s"
    break
  fi
  if (( i == 240 )); then
    echo "[r11] FATAL: teacher never came up"
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
echo "[r11] $(date -u +%Y-%m-%dT%H:%M:%SZ) launch online-DPO-teacher-Reason lr=$LR r=$LORA_R G=$GROUP on GPUs $CUDA_VISIBLE_DEVICES"
nohup python3 "$SRC/train_online_dpo.py" \
  --base "$BASE" \
  --data "$DATA" \
  --out-dir "$TRAIN_DIR" \
  --teacher-url http://127.0.0.1:8000/v1 \
  --teacher-repo zai-org/GLM-4.5-Air-FP8 \
  --max-len 6144 \
  --max-new 256 \
  --epochs 1 \
  --lr "$LR" \
  --lora-r "$LORA_R" \
  --lora-alpha "$LORA_ALPHA" \
  --beta "$BETA" \
  --group-size "$GROUP" \
  --temperature 0.8 \
  --max-steps "$MAX_STEPS" \
  --min-gap "$MIN_GAP" \
  >"$LOG" 2>&1 &
echo $! | tee /root/logs/h139_train.pid >"$OUT/train.pid"
cp -f /root/logs/h139_train.pid /root/logs/r11_train.pid
python3 - <<PY
import json, time
from pathlib import Path
meta = {
    "utc": time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime()),
    "hypo": "R11",
    "family": "online-dpo-reason",
    "axis": "${R11_AXIS:-online_dpo_reason}",
    "pid": int(Path("/root/logs/h139_train.pid").read_text().strip()),
    "base": "$BASE",
    "base_hub": "Tok331102/affine-5EqYW8McUc-af10",
    "base_rev": "eb8bf9a356a254f71faaa439e8abc3cfba572c53",
    "data": "$DATA",
    "examples": $n,
    "lr": float("$LR"),
    "method": "online_dpo_teacher_reason",
    "lora_r": int("$LORA_R"),
    "lora_alpha": int("$LORA_ALPHA"),
    "beta": float("$BETA"),
    "group_size": int("$GROUP"),
    "max_steps": int("$MAX_STEPS"),
    "min_gap": float("$MIN_GAP"),
    "gpus": "$CUDA_VISIBLE_DEVICES",
    "teacher_url": "$TEACHER_URL",
    "out": "$TRAIN_DIR",
    "log": "$LOG",
    "note": "R11 online DPO: sample G=$GROUP, teacher-Reason labels, BT vs frozen base — ≠ R3/R8/H138",
}
Path("/root/affine_data/h139_train_launched.json").write_text(json.dumps(meta, indent=2) + "\n")
Path("/root/affine_data/r11_train_launched.json").write_text(json.dumps(meta, indent=2) + "\n")
print(json.dumps(meta, indent=2))
print("[r11] TRAIN_LAUNCHED pid=%s" % meta["pid"])
PY
