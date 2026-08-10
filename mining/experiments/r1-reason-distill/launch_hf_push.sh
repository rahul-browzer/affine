#!/usr/bin/env bash
# Crown-pod: push /tmp/r1_lora_merged → HF while n80 runs.
set -euo pipefail
set -a
source /root/mine.env
set +a
source /root/venv/bin/activate
exec python /root/mining_src/r1-reason-distill/push_r1_lora.py \
  --merged /tmp/r1_lora_merged \
  --repo unconst/Affine-5czsc2fc98-r1lora \
  --out-meta /root/affine_data/r1_lora_hf_push.json
