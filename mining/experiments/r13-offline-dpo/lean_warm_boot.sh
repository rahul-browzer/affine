#!/usr/bin/env bash
# On-pod lean R13: Tok cached, teacher:8000 + king ckp333:8001 up → offline-DPO on GPUs 6,7 → post_train.
set -euo pipefail
exec > >(tee -a /root/logs/r13_lean_warm.log) 2>&1

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

echo "[r13-lean] $(date -u +%Y-%m-%dT%H:%M:%SZ) start"
curl -sf --max-time 5 http://127.0.0.1:8000/v1/models >/dev/null
curl -sf --max-time 5 http://127.0.0.1:8001/v1/models >/dev/null

test -s /root/h138/dpo_duel_reason.jsonl || test -s /root/h138/dpo_duel_l2.jsonl
test -x /root/mining_src/s4-h138-f43-tok-dpo-l2/start_h138.sh
grep -q "R13: offline-DPO" /root/mining_src/s4-h138-f43-tok-dpo-l2/start_h138.sh
test -f /root/mining_src/s4-h138-f43-tok-dpo-l2/train_dpo.py

nvidia-smi --query-gpu=index,memory.used --format=csv,noheader | tee /root/logs/r13_gpu_before_train.txt
bash /root/mining_src/s4-h138-f43-tok-dpo-l2/start_h138.sh
touch /root/logs/r13_train_launched.stamp
touch /root/logs/h138_train_launched.stamp

TRAIN_DIR=/root/h138/train MERGED=/root/h138/merged \
  KING_REPO=tolegend/Affine-5fqbxvz29b-ckp333 \
  KING_REV=24c137e8a978aea1e2b4abeec594fb6ca943f03c \
  KING_LOCAL=/root/hf/hub/models--tolegend--Affine-5fqbxvz29b-ckp333/snapshots/24c137e8a978aea1e2b4abeec594fb6ca943f03c \
  nohup bash /root/mining_src/s4-h138-f43-tok-dpo-l2/post_train_pipeline.sh \
  >/root/logs/r13_post_train.nohup 2>&1 &
echo $! >/root/logs/r13_post_train.pid
cp -f /root/logs/r13_post_train.pid /root/logs/h138_post_train.pid
cp -f /root/logs/h138_train.pid /root/logs/r13_train.pid 2>/dev/null || true

if [[ -x /root/mining_src/s4-h2-merge/watch_form_decision.sh ]]; then
  nohup bash /root/mining_src/s4-h2-merge/watch_form_decision.sh h138 \
    /root/affine_data/h138_sim_result.json /root/affine_data/h138_decision.json \
    /root/logs/r13_form_decision.nohup \
    >/root/logs/r13_form_decision.launch.out 2>&1 &
  echo $! >/root/logs/r13_form_decision.pid
fi

echo "[r13-lean] $(date -u +%Y-%m-%dT%H:%M:%SZ) DONE train=$(cat /root/logs/h138_train.pid 2>/dev/null || echo none) post=$(cat /root/logs/r13_post_train.pid)"
