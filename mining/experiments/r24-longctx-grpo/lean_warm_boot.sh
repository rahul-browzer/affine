#!/usr/bin/env bash
# On-pod lean R24: teacher:8000 + king ckp333:8001 up → Tok (cached) → LongCtx-GRPO on GPUs 6,7 → post_train.
set -euo pipefail
exec > >(tee -a /root/logs/r24_lean_warm.log) 2>&1

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

echo "[r24-lean] $(date -u +%Y-%m-%dT%H:%M:%SZ) start"
curl -sf --max-time 5 http://127.0.0.1:8000/v1/models >/dev/null
curl -sf --max-time 5 http://127.0.0.1:8001/v1/models >/dev/null

test -s /root/r3/winner_za_high_l1.jsonl
test -x /root/mining_src/r3-reason-grpo/start_r3.sh
grep -q "R24: LongCtx-GRPO" /root/mining_src/r3-reason-grpo/start_r3.sh
test -f /root/mining_src/r3-reason-grpo/train_reason_grpo.py

# Tok af10 init (cached after R3); refresh snapshot path into mine.env.
python - <<'PY'
import os
from pathlib import Path
from huggingface_hub import snapshot_download
token = os.environ["HF_TOKEN"]
repo = "Tok331102/affine-5EqYW8McUc-af10"
rev = "eb8bf9a356a254f71faaa439e8abc3cfba572c53"
print("[r24-lean] DOWNLOAD tok-init start", repo, rev, flush=True)
path = snapshot_download(repo, revision=rev, token=token)
print(f"[r24-lean] DOWNLOAD tok-init done -> {path}", flush=True)
Path("/root/logs/tok.done").write_text(path + "\n")
Path("/root/r24/r24_base.path").write_text(path + "\n")
envp = Path("/root/mine.env")
txt = envp.read_text() if envp.is_file() else ""
line = f"export BASE={path}\n"
if "export BASE=" in txt:
    import re
    txt = re.sub(r"^export BASE=.*$", f"export BASE={path}", txt, count=1, flags=re.M)
    envp.write_text(txt)
else:
    envp.write_text(txt + ("" if txt.endswith("\n") or not txt else "\n") + line)
PY

# Free stale R15 chall on :8002 (train uses 6–7; keep T/K).
if [[ -f /root/logs/vllm_chall.pid ]]; then
  cpid=$(cat /root/logs/vllm_chall.pid 2>/dev/null || true)
  if [[ -n "${cpid:-}" ]] && [[ "$cpid" =~ ^[0-9]+$ ]] && kill -0 "$cpid" 2>/dev/null; then
    kill "$cpid" || true
    echo "[r24-lean] killed stale chall pid=$cpid"
    sleep 5
  fi
fi

# Drop REFUTED R15 merge weights to reclaim /tmp before later merge.
if [[ -d /tmp/r15_merged ]]; then
  rm -rf /tmp/r15_merged
  echo "[r24-lean] removed /tmp/r15_merged"
fi

# Clear prior R3/R15 train stamps so post_train waits on this run.
rm -f /root/r3/train/train.done /root/r3/train/train_result.json
rm -rf /root/r3/train/adapter /root/r3/train/checkpoints
mkdir -p /root/r3/train /root/r24

nvidia-smi --query-gpu=index,memory.used --format=csv,noheader | tee /root/logs/r24_gpu_before_train.txt
bash /root/mining_src/r3-reason-grpo/start_r3.sh
touch /root/logs/r24_train_launched.stamp
touch /root/logs/r3_train_launched.stamp

TRAIN_DIR=/root/r3/train MERGED=/tmp/r24_merged \
  KING_REPO=tolegend/Affine-5fqbxvz29b-ckp333 \
  KING_REV=24c137e8a978aea1e2b4abeec594fb6ca943f03c \
  KING_LOCAL=/root/hf/hub/models--tolegend--Affine-5fqbxvz29b-ckp333/snapshots/24c137e8a978aea1e2b4abeec594fb6ca943f03c \
  RESTART_KING=0 \
  nohup bash /root/mining_src/r3-reason-grpo/post_train_pipeline.sh \
  >/root/logs/r24_post_train.nohup 2>&1 &
echo $! >/root/logs/r24_post_train.pid
cp -f /root/logs/r24_post_train.pid /root/logs/r3_post_train.pid
cp -f /root/logs/r3_train.pid /root/logs/r24_train.pid 2>/dev/null || true

if [[ -x /root/mining_src/s4-h2-merge/watch_form_decision.sh ]]; then
  nohup bash /root/mining_src/s4-h2-merge/watch_form_decision.sh r3 \
    /root/affine_data/r3_sim_result.json /root/affine_data/r3_decision.json \
    /root/logs/r24_form_decision.nohup \
    >/root/logs/r24_form_decision.launch.out 2>&1 &
  echo $! >/root/logs/r24_form_decision.pid
fi

echo "[r24-lean] $(date -u +%Y-%m-%dT%H:%M:%SZ) DONE train=$(cat /root/logs/r3_train.pid 2>/dev/null || echo none) post=$(cat /root/logs/r24_post_train.pid)"
