#!/usr/bin/env bash
# R1 / R1b LoRA SFT on GPUs 6–7 (vLLM keeps 0–5).
# Env overrides: DATA BASE OUT MAX_LEN LOG DONE_STAMP CUDA_VISIBLE_DEVICES
set -euo pipefail
LOG=${LOG:-/root/logs/r1_train.log}
DONE_STAMP=${DONE_STAMP:-/root/logs/r1_train.done}
mkdir -p /root/logs /root/r1_out
exec > >(tee -a "$LOG") 2>&1

echo "[r1-train] $(date -u +%Y-%m-%dT%H:%M:%SZ) start"
# shellcheck disable=SC1091
source /root/venv/bin/activate
if [[ -f /root/mine.env ]]; then
  # shellcheck disable=SC1091
  set -a
  source /root/mine.env
  set +a
fi
export PYTHONPATH=/root/mining_src/affine_pkg${PYTHONPATH:+:$PYTHONPATH}
export AFFINE_DATA_DIR=${AFFINE_DATA_DIR:-/root/affine_data}

DATA=${DATA:-/root/r1_data/sft_high_reason.jsonl}
BASE=${BASE:-/root/hf/hub/models--Tok331102--affine-5EqYW8McUc-af10/snapshots/eb8bf9a356a254f71faaa439e8abc3cfba572c53}
# Fallback: resolve latest Tok snapshot if pinned path missing.
if [[ ! -d "$BASE" ]]; then
  BASE=$(ls -d /root/hf/hub/models--Tok331102--affine-5EqYW8McUc-af10/snapshots/* 2>/dev/null | head -1 || true)
fi
OUT=${OUT:-/root/r1_out/lora_tok_high_reason}
MAX_LEN=${MAX_LEN:-8192}
if [[ ! -s "$DATA" ]]; then
  echo "[r1-train] FATAL missing $DATA — run build_sft_jsonl.py first" >&2
  exit 2
fi
if [[ -z "$BASE" || ! -d "$BASE" ]]; then
  echo "[r1-train] FATAL missing Tok base snapshot" >&2
  exit 2
fi

python - <<'PY'
import importlib.util as u
missing = [m for m in ("peft", "transformers", "torch") if u.find_spec(m) is None]
if missing:
    raise SystemExit(f"[r1-train] FATAL missing {missing}")
print("[r1-train] deps ok", flush=True)
PY

export CUDA_VISIBLE_DEVICES=${CUDA_VISIBLE_DEVICES:-6,7}
rm -f "$DONE_STAMP"
echo "[r1-train] CUDA_VISIBLE_DEVICES=$CUDA_VISIBLE_DEVICES base=$BASE data=$DATA out=$OUT max_len=$MAX_LEN"
python /root/mining_src/r1-reason-distill/train_lora.py \
  --base "$BASE" \
  --data "$DATA" \
  --out-dir "$OUT" \
  --max-len "$MAX_LEN" \
  --epochs "${EPOCHS:-1.0}" \
  --lr "${LR:-2e-5}" \
  --lora-r "${LORA_R:-16}" \
  --lora-alpha "${LORA_ALPHA:-32}" \
  --batch "${BATCH:-1}" \
  --grad-accum "${GRAD_ACCUM:-8}" \
  --loss-on "${LOSS_ON:-thought}" \
  --logging-steps 5 \
  --save-steps 50

echo "[r1-train] DONE $(date -u +%Y-%m-%dT%H:%M:%SZ)"
touch "$DONE_STAMP"
cat "$OUT/train_result.json"
