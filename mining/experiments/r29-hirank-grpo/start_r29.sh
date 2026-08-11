#!/usr/bin/env bash
# R29: Tok-init GRPO on teacher Reason — high LoRA rank (≠ R3 r=16 / R3b r+lr+G).
# Overlay: upload_and_launch copies this to r3-reason-grpo/start_r3.sh.
# R29: HiRank-GRPO Reason (r=64; R3 is r=16; R3b is r=64 with lr=2e-5 G=8).
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

# R29 knobs (≠ R3 r=16; same lr/G/temp/len as R3; ≠ R3b lr/G swap)
LR=${R29_LR:-5e-6}
LORA_R=${R29_LORA_R:-64}
LORA_ALPHA=${R29_LORA_ALPHA:-128}
GROUP_SIZE=${R29_GROUP_SIZE:-4}
MAX_STEPS=${R29_MAX_STEPS:-200}
MAX_LEN=${R29_MAX_LEN:-6144}
MAX_NEW=${R29_MAX_NEW:-512}
TEMPERATURE=${R29_TEMPERATURE:-0.8}

mkdir -p "$OUT" /root/logs "$TRAIN_DIR" /root/affine_data /root/r29
test -d "$BASE"
test -s "$DATA"
test -f "$SRC/train_reason_grpo.py"
n=$(wc -l <"$DATA")
echo "[r29] $(date -u +%Y-%m-%dT%H:%M:%SZ) examples=$n data=$DATA base=$BASE gpus=$CUDA_VISIBLE_DEVICES"
echo "[r29] knobs lr=$LR r=$LORA_R/α$LORA_ALPHA G=$GROUP_SIZE steps=$MAX_STEPS max_len=$MAX_LEN max_new=$MAX_NEW temp=$TEMPERATURE axis=${R29_AXIS:-hirank_grpo_reason}"
test "$n" -ge 200

echo "[r29] wait teacher at $TEACHER_URL"
for i in $(seq 1 240); do
  if curl -sf --max-time 5 "$TEACHER_URL/models" >/dev/null 2>&1; then
    echo "[r29] teacher ready after ${i}×15s"
    break
  fi
  if (( i == 240 )); then
    echo "[r29] FATAL: teacher never came up"
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
echo "[r29] $(date -u +%Y-%m-%dT%H:%M:%SZ) launch HiRank Reason-GRPO r=$LORA_R on GPUs $CUDA_VISIBLE_DEVICES"
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
  --temperature "$TEMPERATURE" \
  --max-steps "$MAX_STEPS" \
  >>"$LOG" 2>&1 &
echo $! | tee /root/logs/r3_train.pid >"$OUT/train.pid"
cp -f /root/logs/r3_train.pid /root/logs/r29_train.pid
python3 - <<PY
import json, time
from pathlib import Path
meta = {
    "utc": time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime()),
    "axis": "R29",
    "hypo": "R29",
    "pid": int(Path("/root/logs/r3_train.pid").read_text().strip()),
    "base": "$BASE",
    "base_hub": "Tok331102/affine-5EqYW8McUc-af10",
    "base_rev": "eb8bf9a356a254f71faaa439e8abc3cfba572c53",
    "data": "$DATA",
    "examples": $n,
    "lr": float("$LR"),
    "method": "grpo_teacher_reason_hirank",
    "lora_r": int("$LORA_R"),
    "lora_alpha": int("$LORA_ALPHA"),
    "group_size": int("$GROUP_SIZE"),
    "max_len": int("$MAX_LEN"),
    "max_new": int("$MAX_NEW"),
    "temperature": float("$TEMPERATURE"),
    "max_steps": int("$MAX_STEPS"),
    "gpus": "$CUDA_VISIBLE_DEVICES",
    "teacher_url": "$TEACHER_URL",
    "out": "$TRAIN_DIR",
    "log": "$LOG",
    "note": "R29 Tok×teacher-Reason GRPO HiRank r=64 — ≠ R3 r=16, ≠ R3b r64+lr2e-5+G8, ≠ R28 HiLR, ≠ R24 longctx, ≠ R25/R26 temp, ≠ R27 BigG, ≠ R18–R23 parent-GRPO",
}
Path("/root/affine_data/r3_train_launched.json").write_text(json.dumps(meta, indent=2) + "\n")
Path("/root/affine_data/r29_train_launched.json").write_text(json.dumps(meta, indent=2) + "\n")
print(json.dumps(meta, indent=2))
print("[r29] TRAIN_LAUNCHED pid=%s" % meta["pid"])
PY
