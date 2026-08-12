#!/usr/bin/env bash
# On-pod lean R11: Tok already cached, teacher:8000 up → online-DPO on GPUs 6,7 → post_train.
set -euo pipefail
exec > >(tee -a /root/logs/r11_lean_warm.log) 2>&1

set -a
# shellcheck disable=SC1091
source /root/mine.env
set +a
# shellcheck disable=SC1091
source /root/venv/bin/activate
export HF_HOME=/root/hf HF_TOKEN
export PATH="$HOME/.local/bin:$PATH"
export PYTHONPATH=/root/mining_src/affine_pkg:${PYTHONPATH:-}
export CUDA_VISIBLE_DEVICES=6,7

echo "[r11-lean] $(date -u +%Y-%m-%dT%H:%M:%SZ) start"
curl -sf --max-time 5 http://127.0.0.1:8000/v1/models >/dev/null
curl -sf --max-time 5 http://127.0.0.1:8001/v1/models >/dev/null

test -s /root/h139/winner_za_high_l1.jsonl
test -x /root/mining_src/s4-h139-f44-tok-online-dpo-l2/start_h139.sh
grep -q "R11: online-DPO" /root/mining_src/s4-h139-f44-tok-online-dpo-l2/start_h139.sh
grep -q "tolegend/Affine-5fqbxvz29b-ckp333" /root/mining_src/s4-h139-f44-tok-online-dpo-l2/post_train_pipeline.sh

nvidia-smi --query-gpu=index,memory.used --format=csv,noheader | tee /root/logs/r11_gpu_before_train.txt
bash /root/mining_src/s4-h139-f44-tok-online-dpo-l2/start_h139.sh
touch /root/logs/r11_train_launched.stamp

TRAIN_DIR=/root/h139/train MERGED=/root/h139/merged \
  KING_REPO=tolegend/Affine-5fqbxvz29b-ckp333 \
  KING_REV=24c137e8a978aea1e2b4abeec594fb6ca943f03c \
  nohup bash /root/mining_src/s4-h139-f44-tok-online-dpo-l2/post_train_pipeline.sh \
  >/root/logs/r11_post_train.nohup 2>&1 &
echo $! >/root/logs/r11_post_train.pid
# Compat pid name used by some watchers
cp -f /root/logs/h139_train.pid /root/logs/r11_train.pid 2>/dev/null || true

echo "[r11-lean] $(date -u +%Y-%m-%dT%H:%M:%SZ) DONE train=$(cat /root/logs/h139_train.pid 2>/dev/null || echo none) post=$(cat /root/logs/r11_post_train.pid)"
