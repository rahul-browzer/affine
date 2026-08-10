#!/usr/bin/env bash
# R1c: thought SFT on nsup-filtered rows (nsup_thought>=100 @ max_len=16384).
# Use only after R1b n80 resolves (or if R1b train dies). Shares GPUs 6–7.
#
# 176 rows × grad_accum=8 → ~22 steps/epoch. EPOCHS=6 ⇒ ~132 steps (≈ R1b's 126)
# so the high-nsup subset gets a comparable update budget, not a 20-step dab.
set -euo pipefail
export MAX_LEN=16384
export DATA=${DATA:-/root/r1_data/sft_high_reason_nsup100.jsonl}
export OUT=/root/r1_out/lora_tok_high_reason_r1c
export LOG=/root/logs/r1c_train.log
export DONE_STAMP=/root/logs/r1c_train.done
export CUDA_VISIBLE_DEVICES="${CUDA_VISIBLE_DEVICES:-6,7}"
export EPOCHS="${EPOCHS:-6.0}"
export LR="${LR:-2e-5}"
export LORA_R="${LORA_R:-16}"
export LORA_ALPHA="${LORA_ALPHA:-32}"
export BATCH="${BATCH:-1}"
export GRAD_ACCUM="${GRAD_ACCUM:-8}"
export LOSS_ON="${LOSS_ON:-thought}"
if [[ ! -s "$DATA" ]]; then
  echo "[r1c-train] FATAL missing $DATA — run filter_nsup_sft.py first" >&2
  exit 2
fi
n=$(wc -l <"$DATA" | tr -d ' ')
echo "[r1c-train] rows=$n epochs=$EPOCHS grad_accum=$GRAD_ACCUM (target ~132 opt-steps @176×6)"
exec bash /root/mining_src/r1-reason-distill/launch_train.sh
