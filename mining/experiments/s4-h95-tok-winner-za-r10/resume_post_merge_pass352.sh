#!/usr/bin/env bash
# Resume H95 post_train after pass352 CPU merge recover (SKIP_MERGE=1).
set -euo pipefail
export SKIP_MERGE=1
export MERGE_DEVICE_MAP=${MERGE_DEVICE_MAP:-cpu}
export CUDA_VISIBLE_DEVICES=${CUDA_VISIBLE_DEVICES:-6,7}
exec bash /root/mining_src/s4-h95-tok-winner-za-r10/post_train_pipeline.sh
