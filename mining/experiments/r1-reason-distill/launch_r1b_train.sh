#!/usr/bin/env bash
# R1b: longer-ctx thought SFT (max_len=16384 → ~1006/1403 rows vs R1's 527).
set -euo pipefail
export MAX_LEN=16384
export OUT=/root/r1_out/lora_tok_high_reason_r1b
export LOG=/root/logs/r1b_train.log
export DONE_STAMP=/root/logs/r1b_train.done
export CUDA_VISIBLE_DEVICES="${CUDA_VISIBLE_DEVICES:-6,7}"
exec bash /root/mining_src/r1-reason-distill/launch_train.sh
