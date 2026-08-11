#!/usr/bin/env bash
# R8: Tok-init REINFORCE on teacher Reason (needs :8000 teacher ready).
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

SRC=${SRC:-/root/mining_src/r8-reinforce-reason}
OUT=${OUT:-/root/r8}
DATA=${DATA:-$OUT/winner_za_high_l1.jsonl}
BASE=${BASE:-/root/hf/hub/models--Tok331102--affine-5EqYW8McUc-af10/snapshots/eb8bf9a356a254f71faaa439e8abc3cfba572c53}
TRAIN_DIR=$OUT/train
LOG=${LOG:-/root/logs/r8_train.nohup}
TEACHER_URL=${TEACHER_URL:-http://127.0.0.1:8000/v1}

mkdir -p "$OUT" /root/logs "$TRAIN_DIR" /root/affine_data
test -d "$BASE"
test -s "$DATA"
test -f "$SRC/train_reason_reinforce.py"
n=$(wc -l <"$DATA")
echo "[r8] $(date -u +%Y-%m-%dT%H:%M:%SZ) examples=$n data=$DATA base=$BASE gpus=$CUDA_VISIBLE_DEVICES"
test "$n" -ge 200

echo "[r8] wait teacher at $TEACHER_URL"
for i in $(seq 1 240); do
  if curl -sf --max-time 5 "$TEACHER_URL/models" >/dev/null 2>&1; then
    echo "[r8] teacher ready after ${i}×15s"
    break
  fi
  if (( i == 240 )); then
    echo "[r8] FATAL: teacher never came up"
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
echo "[r8] $(date -u +%Y-%m-%dT%H:%M:%SZ) launch Reason-REINFORCE lr=1e-5 r=64 EMA=0.9 max_new=512 on GPUs $CUDA_VISIBLE_DEVICES"
nohup python3 "$SRC/train_reason_reinforce.py" \
  --base "$BASE" \
  --data "$DATA" \
  --out-dir "$TRAIN_DIR" \
  --teacher-url "$TEACHER_URL" \
  --teacher-repo zai-org/GLM-4.5-Air-FP8 \
  --max-len 6144 \
  --max-new 512 \
  --epochs 1 \
  --lr 1e-5 \
  --lora-r 64 \
  --lora-alpha 128 \
  --samples-per-step 1 \
  --baseline-ema 0.9 \
  --temperature 0.8 \
  --max-steps 300 \
  >>"$LOG" 2>&1 &
echo $! | tee /root/logs/r8_train.pid >"$OUT/train.pid"
python3 - <<PY
import json, time
from pathlib import Path
meta = {
    "utc": time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime()),
    "axis": "R8",
    "hypo": "R8",
    "pid": int(Path("/root/logs/r8_train.pid").read_text().strip()),
    "base": "$BASE",
    "base_hub": "Tok331102/affine-5EqYW8McUc-af10",
    "base_rev": "eb8bf9a356a254f71faaa439e8abc3cfba572c53",
    "data": "$DATA",
    "examples": $n,
    "lr": 1e-5,
    "method": "reinforce_ema_teacher_reason",
    "lora_r": 64,
    "samples_per_step": 1,
    "baseline_ema": 0.9,
    "max_new": 512,
    "max_steps": 300,
    "gpus": "$CUDA_VISIBLE_DEVICES",
    "teacher_url": "$TEACHER_URL",
    "out": "$TRAIN_DIR",
    "log": "$LOG",
    "note": "R8 Reason-REINFORCE: reward=lpC(y|z)-lpC(y|∅); EMA baseline; LoRA r=64; no CE on harvested z",
}
Path("/root/affine_data/r8_train_launched.json").write_text(json.dumps(meta, indent=2) + "\n")
print(json.dumps(meta, indent=2))
print("[r8] TRAIN_LAUNCHED pid=%s" % meta["pid"])
PY
