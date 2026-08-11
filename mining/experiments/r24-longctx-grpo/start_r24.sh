#!/usr/bin/env bash
# R24: Tok-init GRPO on teacher Reason — long ctx / full thought budget (≠ R3).
# Overlay: upload_and_launch copies this to r3-reason-grpo/start_r3.sh.
# R24: LongCtx-GRPO Reason (max_len=16384 max_new=1024; R3 is 6144/512).
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

# R24 knobs (≠ R3 max_len=6144 max_new=512; same lr/r/G as R3)
LR=${R24_LR:-5e-6}
LORA_R=${R24_LORA_R:-16}
LORA_ALPHA=${R24_LORA_ALPHA:-32}
GROUP_SIZE=${R24_GROUP_SIZE:-4}
MAX_STEPS=${R24_MAX_STEPS:-200}
MAX_LEN=${R24_MAX_LEN:-16384}
MAX_NEW=${R24_MAX_NEW:-1024}

mkdir -p "$OUT" /root/logs "$TRAIN_DIR" /root/affine_data /root/r24
test -d "$BASE"
test -s "$DATA"
test -f "$SRC/train_reason_grpo.py"
n=$(wc -l <"$DATA")
echo "[r24] $(date -u +%Y-%m-%dT%H:%M:%SZ) examples=$n data=$DATA base=$BASE gpus=$CUDA_VISIBLE_DEVICES"
echo "[r24] knobs lr=$LR r=$LORA_R/α$LORA_ALPHA G=$GROUP_SIZE steps=$MAX_STEPS max_len=$MAX_LEN max_new=$MAX_NEW axis=${R24_AXIS:-longctx_grpo_reason}"
test "$n" -ge 200

echo "[r24] wait teacher at $TEACHER_URL"
for i in $(seq 1 240); do
  if curl -sf --max-time 5 "$TEACHER_URL/models" >/dev/null 2>&1; then
    echo "[r24] teacher ready after ${i}×15s"
    break
  fi
  if (( i == 240 )); then
    echo "[r24] FATAL: teacher never came up"
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
echo "[r24] $(date -u +%Y-%m-%dT%H:%M:%SZ) launch LongCtx Reason-GRPO max_len=$MAX_LEN max_new=$MAX_NEW on GPUs $CUDA_VISIBLE_DEVICES"
nohup python3 "$SRC/train_reason_grpo.py" \
  --base "$BASE" \
  --data "$DATA" \
  --out-dir "$TRAIN_DIR" \
  --teacher-url "$TEACHER_URL" \
  --teacher-repo zai-org/GLM-4.5-Air-FP8 \
  --max-len "$MAX_LEN" \
  --max-new "$MAX_NEW" \
  --epochs 1 \
  --lr "$LR" \
  --lora-r "$LORA_R" \
  --lora-alpha "$LORA_ALPHA" \
  --group-size "$GROUP_SIZE" \
  --temperature 0.8 \
  --max-steps "$MAX_STEPS" \
  >>"$LOG" 2>&1 &
echo $! | tee /root/logs/r3_train.pid >"$OUT/train.pid"
cp -f /root/logs/r3_train.pid /root/logs/r24_train.pid
python3 - <<PY
import json, time
from pathlib import Path
meta = {
    "utc": time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime()),
    "axis": "R24",
    "hypo": "R24",
    "pid": int(Path("/root/logs/r3_train.pid").read_text().strip()),
    "base": "$BASE",
    "base_hub": "Tok331102/affine-5EqYW8McUc-af10",
    "base_rev": "eb8bf9a356a254f71faaa439e8abc3cfba572c53",
    "data": "$DATA",
    "examples": $n,
    "lr": float("$LR"),
    "method": "grpo_teacher_reason_longctx",
    "lora_r": int("$LORA_R"),
    "lora_alpha": int("$LORA_ALPHA"),
    "group_size": int("$GROUP_SIZE"),
    "max_len": int("$MAX_LEN"),
    "max_new": int("$MAX_NEW"),
    "max_steps": int("$MAX_STEPS"),
    "gpus": "$CUDA_VISIBLE_DEVICES",
    "teacher_url": "$TEACHER_URL",
    "out": "$TRAIN_DIR",
    "log": "$LOG",
    "note": "R24 Tok×teacher-Reason GRPO longctx — ≠ R3 6144/512, ≠ R3b lr/rank, ≠ R18–R23 parent-GRPO",
}
Path("/root/affine_data/r3_train_launched.json").write_text(json.dumps(meta, indent=2) + "\n")
Path("/root/affine_data/r24_train_launched.json").write_text(json.dumps(meta, indent=2) + "\n")
print(json.dumps(meta, indent=2))
print("[r24] TRAIN_LAUNCHED pid=%s" % meta["pid"])
PY
