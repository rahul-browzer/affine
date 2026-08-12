#!/usr/bin/env bash
# On-pod lean R17: teacher:8000 + king ckp333:8001 up → coder DL → REINFORCE on GPUs 6,7 → post_train.
set -euo pipefail
exec > >(tee -a /root/logs/r17_lean_warm.log) 2>&1

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

echo "[r17-lean] $(date -u +%Y-%m-%dT%H:%M:%SZ) start"
curl -sf --max-time 5 http://127.0.0.1:8000/v1/models >/dev/null
curl -sf --max-time 5 http://127.0.0.1:8001/v1/models >/dev/null

test -s /root/h135/winner_za_high_l1.jsonl
test -x /root/mining_src/s4-h135-f40-kevin-rl-l2/start_h135.sh
grep -q "R17: coder-REINFORCE" /root/mining_src/s4-h135-f40-kevin-rl-l2/start_h135.sh
test -f /root/mining_src/s4-h135-f40-kevin-rl-l2/train_rl_l2.py

# Clear prior R16 sim artifacts so form watcher waits for fresh n80.
rm -f /root/affine_data/h135_sim_result.json \
      /root/affine_data/h135_decision.json \
      /root/affine_data/h135_sim_progress.json \
      /root/h135/train/train.done \
      /root/h135/train/train_result.json

# Qwen3-Coder init required for train base (teacher already served).
python - <<'PY'
import os
from huggingface_hub import snapshot_download
token = os.environ["HF_TOKEN"]
repo = "Qwen/Qwen3-Coder-30B-A3B-Instruct"
rev = "b2cff646eb4bb1d68355c01b18ae02e7cf42d120"
print("[r17-lean] DOWNLOAD coder-init start", repo, rev, flush=True)
path = snapshot_download(repo, revision=rev, token=token)
print(f"[r17-lean] DOWNLOAD coder-init done -> {path}", flush=True)
open("/root/logs/coder_init.done", "w").write(path + "\n")
open("/root/h135/r17_base.path", "w").write(path + "\n")
assert rev in path, path
PY

export BASE=$(cat /root/h135/r17_base.path)
if grep -q '^export BASE=' /root/mine.env 2>/dev/null; then
  sed -i "s|^export BASE=.*|export BASE=${BASE}|" /root/mine.env
else
  echo "export BASE=${BASE}" >>/root/mine.env
fi

nvidia-smi --query-gpu=index,memory.used --format=csv,noheader | tee /root/logs/r17_gpu_before_train.txt
bash /root/mining_src/s4-h135-f40-kevin-rl-l2/start_h135.sh
touch /root/logs/r17_train_launched.stamp
touch /root/logs/h135_train_launched.stamp

TRAIN_DIR=/root/h135/train MERGED=/root/h135/merged \
  KING_REPO=tolegend/Affine-5fqbxvz29b-ckp333 \
  KING_REV=24c137e8a978aea1e2b4abeec594fb6ca943f03c \
  KING_LOCAL=/root/hf/hub/models--tolegend--Affine-5fqbxvz29b-ckp333/snapshots/24c137e8a978aea1e2b4abeec594fb6ca943f03c \
  RESTART_KING=0 \
  nohup bash /root/mining_src/s4-h135-f40-kevin-rl-l2/post_train_pipeline.sh \
  >/root/logs/r17_post_train.nohup 2>&1 &
echo $! >/root/logs/r17_post_train.pid
cp -f /root/logs/r17_post_train.pid /root/logs/h135_post_train.pid
cp -f /root/logs/h135_train.pid /root/logs/r17_train.pid 2>/dev/null || true

if [[ -x /root/mining_src/s4-h2-merge/watch_form_decision.sh ]]; then
  nohup bash /root/mining_src/s4-h2-merge/watch_form_decision.sh h135 \
    /root/affine_data/h135_sim_result.json /root/affine_data/h135_decision.json \
    /root/logs/r17_form_decision.nohup \
    >/root/logs/r17_form_decision.launch.out 2>&1 &
  echo $! >/root/logs/r17_form_decision.pid
fi

echo "[r17-lean] $(date -u +%Y-%m-%dT%H:%M:%SZ) DONE train=$(cat /root/logs/h135_train.pid 2>/dev/null || echo none) post=$(cat /root/logs/r17_post_train.pid)"
