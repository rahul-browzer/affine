#!/usr/bin/env bash
# R13: Tok-init offline DPO on duel Reason prefs (chosen=higher Reason z).
# Overlay: upload_and_launch copies this to s4-h138-f43-tok-dpo-l2/start_h138.sh.
# R13: offline-DPO Reason (≠ R3 GRPO, ≠ R8 REINFORCE, ≠ R11 online DPO, ≠ R12 BoN-CE).
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

SRC=${SRC:-/root/mining_src/s4-h138-f43-tok-dpo-l2}
OUT=${OUT:-/root/h138}
DATA=${DATA:-$OUT/dpo_duel_reason.jsonl}
# Accept legacy filename if overlay only copied that.
if [[ ! -s "$DATA" && -s "$OUT/dpo_duel_l2.jsonl" ]]; then
  DATA=$OUT/dpo_duel_l2.jsonl
fi
BASE=${BASE:-/root/hf/hub/models--Tok331102--affine-5EqYW8McUc-af10/snapshots/eb8bf9a356a254f71faaa439e8abc3cfba572c53}
TRAIN_DIR=$OUT/train
LOG=${LOG:-/root/logs/h138_train.nohup}

LR=${R13_LR:-5e-6}
LORA_R=${R13_LORA_R:-16}
LORA_ALPHA=${R13_LORA_ALPHA:-32}
BETA=${R13_BETA:-0.1}
MAX_STEPS=${R13_MAX_STEPS:-200}

mkdir -p "$OUT" /root/logs "$TRAIN_DIR" /root/affine_data /root/r13
test -d "$BASE"
test -s "$DATA"
test -f "$SRC/train_dpo.py"
n=$(wc -l <"$DATA")
echo "[r13] $(date -u +%Y-%m-%dT%H:%M:%SZ) examples=$n data=$DATA base=$BASE gpus=$CUDA_VISIBLE_DEVICES"
echo "[r13] knobs lr=$LR r=$LORA_R/α$LORA_ALPHA β=$BETA steps=$MAX_STEPS axis=${R13_AXIS:-offline_dpo_reason}"
test "$n" -ge 200

python - <<'PY'
import importlib
for m in ("peft", "accelerate", "torch", "transformers"):
    importlib.import_module(m)
print("deps OK")
PY

rm -f "$TRAIN_DIR/train.done" "$TRAIN_DIR/train_result.json"
echo "[r13] $(date -u +%Y-%m-%dT%H:%M:%SZ) launch offline-DPO-Reason lr=$LR r=$LORA_R β=$BETA on GPUs $CUDA_VISIBLE_DEVICES"
nohup python3 "$SRC/train_dpo.py" \
  --base "$BASE" \
  --data "$DATA" \
  --out-dir "$TRAIN_DIR" \
  --max-len 6144 \
  --epochs 1 \
  --lr "$LR" \
  --lora-r "$LORA_R" \
  --lora-alpha "$LORA_ALPHA" \
  --beta "$BETA" \
  --max-steps "$MAX_STEPS" \
  >"$LOG" 2>&1 &
echo $! | tee /root/logs/h138_train.pid >"$OUT/train.pid"
cp -f /root/logs/h138_train.pid /root/logs/r13_train.pid
python3 - <<PY
import json, time
from pathlib import Path
meta = {
    "utc": time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime()),
    "hypo": "R13",
    "family": "offline-dpo-reason",
    "axis": "${R13_AXIS:-offline_dpo_reason}",
    "pid": int(Path("/root/logs/h138_train.pid").read_text().strip()),
    "base": "$BASE",
    "base_hub": "Tok331102/affine-5EqYW8McUc-af10",
    "base_rev": "eb8bf9a356a254f71faaa439e8abc3cfba572c53",
    "data": "$DATA",
    "examples": $n,
    "lr": float("$LR"),
    "method": "offline_dpo_teacher_reason",
    "lora_r": int("$LORA_R"),
    "lora_alpha": int("$LORA_ALPHA"),
    "beta": float("$BETA"),
    "max_steps": int("$MAX_STEPS"),
    "gpus": "$CUDA_VISIBLE_DEVICES",
    "out": "$TRAIN_DIR",
    "log": "$LOG",
    "note": "R13 offline DPO: chosen=higher-Reason z, rejected=lower; no live teacher at train — ≠ R3/R8/R11/R12",
}
Path("/root/affine_data/h138_train_launched.json").write_text(json.dumps(meta, indent=2) + "\n")
Path("/root/affine_data/r13_train_launched.json").write_text(json.dumps(meta, indent=2) + "\n")
print(json.dumps(meta, indent=2))
print("[r13] TRAIN_LAUNCHED pid=%s" % meta["pid"])
PY
