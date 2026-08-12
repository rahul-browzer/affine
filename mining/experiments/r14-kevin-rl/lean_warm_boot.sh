#!/usr/bin/env bash
# On-pod lean R14: teacher:8000 + king ckp333:8001 up → kevin DL → REINFORCE on GPUs 6,7 → post_train.
set -euo pipefail
exec > >(tee -a /root/logs/r14_lean_warm.log) 2>&1

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

echo "[r14-lean] $(date -u +%Y-%m-%dT%H:%M:%SZ) start"
curl -sf --max-time 5 http://127.0.0.1:8000/v1/models >/dev/null
curl -sf --max-time 5 http://127.0.0.1:8001/v1/models >/dev/null

test -s /root/h135/winner_za_high_l1.jsonl
test -x /root/mining_src/s4-h135-f40-kevin-rl-l2/start_h135.sh
grep -q "R14: kevin-REINFORCE" /root/mining_src/s4-h135-f40-kevin-rl-l2/start_h135.sh
test -f /root/mining_src/s4-h135-f40-kevin-rl-l2/train_rl_l2.py

# Kevin init required for train base (teacher already served).
python - <<'PY'
import os
from huggingface_hub import snapshot_download
token = os.environ["HF_TOKEN"]
repo = "kevin954/Affine-5dfqbbh8ev-sft"
rev = "6a5815fad8f4e34c983b1933c1fae5762fe25220"
print("[r14-lean] DOWNLOAD kevin-init start", repo, rev, flush=True)
path = snapshot_download(repo, revision=rev, token=token)
print(f"[r14-lean] DOWNLOAD kevin-init done -> {path}", flush=True)
open("/root/logs/kevin_init.done", "w").write(path + "\n")
PY

nvidia-smi --query-gpu=index,memory.used --format=csv,noheader | tee /root/logs/r14_gpu_before_train.txt
bash /root/mining_src/s4-h135-f40-kevin-rl-l2/start_h135.sh
touch /root/logs/r14_train_launched.stamp
touch /root/logs/h135_train_launched.stamp

TRAIN_DIR=/root/h135/train MERGED=/root/h135/merged \
  KING_REPO=tolegend/Affine-5fqbxvz29b-ckp333 \
  KING_REV=24c137e8a978aea1e2b4abeec594fb6ca943f03c \
  KING_LOCAL=/root/hf/hub/models--tolegend--Affine-5fqbxvz29b-ckp333/snapshots/24c137e8a978aea1e2b4abeec594fb6ca943f03c \
  RESTART_KING=0 \
  nohup bash /root/mining_src/s4-h135-f40-kevin-rl-l2/post_train_pipeline.sh \
  >/root/logs/r14_post_train.nohup 2>&1 &
echo $! >/root/logs/r14_post_train.pid
cp -f /root/logs/r14_post_train.pid /root/logs/h135_post_train.pid
cp -f /root/logs/h135_train.pid /root/logs/r14_train.pid 2>/dev/null || true

if [[ -x /root/mining_src/s4-h2-merge/watch_form_decision.sh ]]; then
  nohup bash /root/mining_src/s4-h2-merge/watch_form_decision.sh h135 \
    /root/affine_data/h135_sim_result.json /root/affine_data/h135_decision.json \
    /root/logs/r14_form_decision.nohup \
    >/root/logs/r14_form_decision.launch.out 2>&1 &
  echo $! >/root/logs/r14_form_decision.pid
fi

echo "[r14-lean] $(date -u +%Y-%m-%dT%H:%M:%SZ) DONE train=$(cat /root/logs/h135_train.pid 2>/dev/null || echo none) post=$(cat /root/logs/r14_post_train.pid)"
