#!/usr/bin/env bash
# On-pod lean R12: Tok cached, teacher:8000 + king ckp333:8001 up → BoN-CE on GPUs 6,7 → post_train.
set -euo pipefail
exec > >(tee -a /root/logs/r12_lean_warm.log) 2>&1

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

echo "[r12-lean] $(date -u +%Y-%m-%dT%H:%M:%SZ) start"
curl -sf --max-time 5 http://127.0.0.1:8000/v1/models >/dev/null
curl -sf --max-time 5 http://127.0.0.1:8001/v1/models >/dev/null

test -s /root/h137/winner_za_high_l1.jsonl
test -x /root/mining_src/s4-h137-f42-tok-bon-l2/start_h137.sh
grep -q "R12: BoN-CE" /root/mining_src/s4-h137-f42-tok-bon-l2/start_h137.sh
test -f /root/mining_src/s4-h137-f42-tok-bon-l2/train_bon_l2.py

nvidia-smi --query-gpu=index,memory.used --format=csv,noheader | tee /root/logs/r12_gpu_before_train.txt
bash /root/mining_src/s4-h137-f42-tok-bon-l2/start_h137.sh
touch /root/logs/r12_train_launched.stamp
touch /root/logs/h137_train_launched.stamp

TRAIN_DIR=/root/h137/train MERGED=/root/h137/merged \
  KING_REPO=tolegend/Affine-5fqbxvz29b-ckp333 \
  KING_REV=24c137e8a978aea1e2b4abeec594fb6ca943f03c \
  KING_LOCAL=/root/hf/hub/models--tolegend--Affine-5fqbxvz29b-ckp333/snapshots/24c137e8a978aea1e2b4abeec594fb6ca943f03c \
  nohup bash /root/mining_src/s4-h137-f42-tok-bon-l2/post_train_pipeline.sh \
  >/root/logs/r12_post_train.nohup 2>&1 &
echo $! >/root/logs/r12_post_train.pid
cp -f /root/logs/r12_post_train.pid /root/logs/h137_post_train.pid
cp -f /root/logs/h137_train.pid /root/logs/r12_train.pid 2>/dev/null || true

# Decision watcher (kσ=2 write_reason_decision via form watch if present).
if [[ -x /root/mining_src/s4-h2-merge/watch_form_decision.sh ]]; then
  nohup bash /root/mining_src/s4-h2-merge/watch_form_decision.sh h137 \
    /root/affine_data/h137_sim_result.json /root/affine_data/h137_decision.json \
    /root/logs/r12_form_decision.nohup \
    >/root/logs/r12_form_decision.launch.out 2>&1 &
  echo $! >/root/logs/r12_form_decision.pid
fi

echo "[r12-lean] $(date -u +%Y-%m-%dT%H:%M:%SZ) DONE train=$(cat /root/logs/h137_train.pid 2>/dev/null || echo none) post=$(cat /root/logs/r12_post_train.pid)"
