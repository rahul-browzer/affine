#!/usr/bin/env bash
# R1c: thought SFT on nsup-filtered rows (nsup_thought>=100 @ max_len=16384).
# Use only after R1b n80 resolves (or if R1b train dies). Shares GPUs 6–7.
set -euo pipefail
export MAX_LEN=16384
export DATA=${DATA:-/root/r1_data/sft_high_reason_nsup100.jsonl}
export OUT=/root/r1_out/lora_tok_high_reason_r1c
export LOG=/root/logs/r1c_train.log
export DONE_STAMP=/root/logs/r1c_train.done
export CUDA_VISIBLE_DEVICES="${CUDA_VISIBLE_DEVICES:-6,7}"
if [[ ! -s "$DATA" ]]; then
  echo "[r1c-train] FATAL missing $DATA — run filter_nsup_sft.py first" >&2
  exit 2
fi
exec bash /root/mining_src/r1-reason-distill/launch_train.sh
