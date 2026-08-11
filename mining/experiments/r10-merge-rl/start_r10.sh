#!/usr/bin/env bash
# R10: GRPO on teacher Reason with BASE = Tok×sbs-v2 α-merge (not raw Tok).
# R10: merge+RL hybrid — ≠ R3 Tok-init GRPO, ≠ R2 merge-only n80.
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

SRC=${SRC:-/root/mining_src/r10-merge-rl}
OUT=${OUT:-/root/r10}
DATA=${DATA:-$OUT/winner_za_high_l1.jsonl}
BASE=${BASE:-/root/r10/merge_base}
TRAIN_DIR=$OUT/train
LOG=${LOG:-/root/logs/r10_train.nohup}
TEACHER_URL=${TEACHER_URL:-http://127.0.0.1:8000/v1}
LR=${R10_LR:-5e-6}
LORA_R=${R10_LORA_R:-16}
LORA_A=${R10_LORA_A:-32}
GSIZE=${R10_GROUP_SIZE:-4}
MAX_STEPS=${R10_MAX_STEPS:-200}

mkdir -p "$OUT" /root/logs "$TRAIN_DIR" /root/affine_data
test -d "$BASE"
test -s "$DATA"
test -f "$SRC/train_reason_grpo.py"
n=$(wc -l <"$DATA")
echo "[r10] $(date -u +%Y-%m-%dT%H:%M:%SZ) examples=$n data=$DATA base=$BASE gpus=$CUDA_VISIBLE_DEVICES"
echo "[r10] knobs lr=$LR r=$LORA_R α=$LORA_A G=$GSIZE max_steps=$MAX_STEPS axis=${R10_AXIS:-merge_rl}"
test "$n" -ge 200

echo "[r10] wait teacher at $TEACHER_URL"
for i in $(seq 1 240); do
  if curl -sf --max-time 5 "$TEACHER_URL/models" >/dev/null 2>&1; then
    echo "[r10] teacher ready after ${i}×15s"
    break
  fi
  if (( i == 240 )); then
    echo "[r10] FATAL: teacher never came up"
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
echo "[r10] $(date -u +%Y-%m-%dT%H:%M:%SZ) launch Reason-GRPO on merge-base GPUs $CUDA_VISIBLE_DEVICES"
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
  --lora-alpha "$LORA_A" \
  --group-size "$GSIZE" \
  --temperature 0.8 \
  --max-steps "$MAX_STEPS" \
  >>"$LOG" 2>&1 &
echo $! | tee /root/logs/r10_train.pid >"$OUT/train.pid"
# Compat: post_train_pipeline (R3-derived) also probes r10_train.pid.
python3 - <<PY
import json, time
from pathlib import Path
meta = {
    "utc": time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime()),
    "axis": "R10",
    "hypo": "R10",
    "pid": int(Path("/root/logs/r10_train.pid").read_text().strip()),
    "base": "$BASE",
    "base_kind": "tok_x_sbs_v2_alpha_merge",
    "parents": [
        {"repo": "Tok331102/affine-5EqYW8McUc-af10", "rev": "eb8bf9a356a254f71faaa439e8abc3cfba572c53", "w": 0.5},
        {"repo": "ammazon/Affine-5dvqtektxx-sbs-v2", "rev": "6f1b8e682aea94a00d8387f4ab9bdef6da153944", "w": 0.5},
    ],
    "data": "$DATA",
    "examples": $n,
    "lr": float("$LR"),
    "method": "merge_then_grpo_teacher_reason",
    "lora_r": int("$LORA_R"),
    "group_size": int("$GSIZE"),
    "max_new": 512,
    "max_steps": int("$MAX_STEPS"),
    "gpus": "$CUDA_VISIBLE_DEVICES",
    "teacher_url": "$TEACHER_URL",
    "out": "$TRAIN_DIR",
    "log": "$LOG",
    "note": "R10: Tok×sbs-v2 α0.5 merge init → Reason-GRPO (≠ R3 Tok-init, ≠ R2 merge-only)",
}
Path("/root/affine_data/r10_train_launched.json").write_text(json.dumps(meta, indent=2) + "\n")
print(json.dumps(meta, indent=2))
print("[r10] TRAIN_LAUNCHED pid=%s" % meta["pid"])
PY
