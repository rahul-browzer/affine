#!/usr/bin/env bash
# On-pod lean R21: teacher:8000 + guass:8001 up → pandora DL → GRPO on GPUs 6,7 → post_train.
set -euo pipefail
exec > >(tee -a /root/logs/r21_lean_warm.log) 2>&1

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

echo "[r21-lean] $(date -u +%Y-%m-%dT%H:%M:%SZ) start"
curl -sf --max-time 5 http://127.0.0.1:8000/v1/models >/dev/null
curl -sf --max-time 5 http://127.0.0.1:8001/v1/models >/dev/null

test -s /root/r3/winner_za_high_l1.jsonl
test -x /root/mining_src/r3-reason-grpo/start_r3.sh
grep -q "R21: Pandora-GRPO" /root/mining_src/r3-reason-grpo/start_r3.sh
test -f /root/mining_src/r3-reason-grpo/train_reason_grpo.py

# Pandora init (reign-1); write BASE into mine.env.
python - <<'PY'
import os
import re
from pathlib import Path
from huggingface_hub import snapshot_download
token = os.environ["HF_TOKEN"]
repo = "pandora-box/Affine-5eqdtdzqle-ckpt300-m4"
rev = "5218b1383952ff7a8d49b1d7b82acfe5e1bd448d"
print("[r21-lean] DOWNLOAD pandora-init start", repo, rev, flush=True)
path = snapshot_download(repo, revision=rev, token=token)
print(f"[r21-lean] DOWNLOAD pandora-init done -> {path}", flush=True)
Path("/root/logs/pandora.done").write_text(path + "\n")
Path("/root/r21/r21_base.path").write_text(path + "\n")
envp = Path("/root/mine.env")
txt = envp.read_text() if envp.is_file() else ""
line = f"export BASE={path}\n"
if "export BASE=" in txt:
    txt = re.sub(r"^export BASE=.*$", f"export BASE={path}", txt, count=1, flags=re.M)
    envp.write_text(txt)
else:
    envp.write_text(txt + ("" if txt.endswith("\n") or not txt else "\n") + line)
PY

# Free stale R20 chall on :8002 (train uses 6–7; keep T/K).
if [[ -f /root/logs/vllm_chall.pid ]]; then
  cpid=$(cat /root/logs/vllm_chall.pid 2>/dev/null || true)
  if [[ -n "${cpid:-}" ]] && [[ "$cpid" =~ ^[0-9]+$ ]] && kill -0 "$cpid" 2>/dev/null; then
    kill "$cpid" || true
    echo "[r21-lean] killed stale chall pid=$cpid"
    sleep 5
  fi
fi

nvidia-smi --query-gpu=index,memory.used --format=csv,noheader | tee /root/logs/r21_gpu_before_train.txt
bash /root/mining_src/r3-reason-grpo/start_r3.sh
touch /root/logs/r21_train_launched.stamp
touch /root/logs/r3_train_launched.stamp

# Live king = guass (post_train defaults); do not freeze ckp333.
TRAIN_DIR=/root/r3/train MERGED=/tmp/r3_merged \
  KING_REPO=ttttxxxxsada/Affine-5guassq3tu \
  KING_REV=e86758f5080d1e373e5fbbd7b4fbf6af327aeb44 \
  KING_LOCAL=/root/hf/hub/models--ttttxxxxsada--Affine-5guassq3tu/snapshots/e86758f5080d1e373e5fbbd7b4fbf6af327aeb44 \
  RESTART_KING=0 \
  nohup bash /root/mining_src/r3-reason-grpo/post_train_pipeline.sh \
  >/root/logs/r21_post_train.nohup 2>&1 &
echo $! >/root/logs/r21_post_train.pid
cp -f /root/logs/r21_post_train.pid /root/logs/r3_post_train.pid
cp -f /root/logs/r3_train.pid /root/logs/r21_train.pid 2>/dev/null || true

if [[ -x /root/mining_src/s4-h2-merge/watch_form_decision.sh ]]; then
  nohup bash /root/mining_src/s4-h2-merge/watch_form_decision.sh r3 \
    /root/affine_data/r3_sim_result.json /root/affine_data/r3_decision.json \
    /root/logs/r21_form_decision.nohup \
    >/root/logs/r21_form_decision.launch.out 2>&1 &
  echo $! >/root/logs/r21_form_decision.pid
fi

echo "[r21-lean] $(date -u +%Y-%m-%dT%H:%M:%SZ) DONE train=$(cat /root/logs/r3_train.pid 2>/dev/null || echo none) post=$(cat /root/logs/r21_post_train.pid)"
