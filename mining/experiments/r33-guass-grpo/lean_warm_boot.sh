#!/usr/bin/env bash
# On-pod lean R33: teacher:8000 + guass:8001 up → guass-init GRPO on GPUs 6,7 → post_train.
# ≠ R3 Tok-init / R19–R23 other parents / R2bm chall-only. Train FROM live reign-6.
set -euo pipefail
exec > >(tee -a /root/logs/r33_lean_warm.log) 2>&1

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

echo "[r33-lean] $(date -u +%Y-%m-%dT%H:%M:%SZ) start"
curl -sf --max-time 5 http://127.0.0.1:8000/v1/models >/dev/null
curl -sf --max-time 5 http://127.0.0.1:8001/v1/models >/dev/null

test -s /root/r3/winner_za_high_l1.jsonl
test -x /root/mining_src/r3-reason-grpo/start_r3.sh
grep -q "R33: Guass-GRPO" /root/mining_src/r3-reason-grpo/start_r3.sh
test -f /root/mining_src/r3-reason-grpo/train_reason_grpo.py

BASE_DEFAULT=/root/hf/hub/models--ttttxxxxsada--Affine-5guassq3tu/snapshots/e86758f5080d1e373e5fbbd7b4fbf6af327aeb44
BASE=${BASE:-$BASE_DEFAULT}
# Prefer live king snapshot if present; else download guass-init.
if [[ ! -d "$BASE" ]]; then
  echo "[r33-lean] DOWNLOAD guass-init (missing local $BASE)"
  python - <<'PY'
import os
from pathlib import Path
from huggingface_hub import snapshot_download
token = os.environ["HF_TOKEN"]
repo = "ttttxxxxsada/Affine-5guassq3tu"
rev = "e86758f5080d1e373e5fbbd7b4fbf6af327aeb44"
path = snapshot_download(repo, revision=rev, token=token)
Path("/root/r33/r33_base.path").write_text(path + "\n")
print("[r33-lean] DOWNLOAD guass-init done ->", path, flush=True)
PY
  BASE=$(cat /root/r33/r33_base.path)
fi
test -d "$BASE"
mkdir -p /root/r33
echo "$BASE" >/root/r33/r33_base.path
python3 - <<'PY'
from pathlib import Path
import re
path = Path("/root/r33/r33_base.path").read_text().strip()
envp = Path("/root/mine.env")
txt = envp.read_text() if envp.is_file() else ""
line = f"export BASE={path}\n"
if "export BASE=" in txt:
    txt = re.sub(r"^export BASE=.*$", f"export BASE={path}", txt, count=1, flags=re.M)
    envp.write_text(txt)
else:
    envp.write_text(txt + ("" if txt.endswith("\n") or not txt else "\n") + line)
print("[r33-lean] BASE", path, flush=True)
PY
export BASE

# Free stale chall on :8002 by pidfile / listener only (never pkill -f). Keep T/K.
if [[ -f /root/logs/vllm_chall.pid ]]; then
  cpid=$(cat /root/logs/vllm_chall.pid 2>/dev/null || true)
  if [[ -n "${cpid:-}" ]] && [[ "$cpid" =~ ^[0-9]+$ ]] && kill -0 "$cpid" 2>/dev/null; then
    kill "$cpid" || true
    echo "[r33-lean] killed stale chall pidfile=$cpid"
    sleep 5
  fi
fi
CPID=$(
  python3 - <<'PY'
import re, subprocess
try:
    out = subprocess.check_output(["ss", "-ltnp"], text=True, stderr=subprocess.DEVNULL)
except Exception:
    raise SystemExit(0)
for line in out.splitlines():
    if ":8002" not in line:
        continue
    m = re.search(r"pid=(\d+)", line)
    if m:
        print(m.group(1))
        break
PY
)
if [[ -n "${CPID:-}" ]] && kill -0 "$CPID" 2>/dev/null; then
  kill "$CPID" || true
  echo "[r33-lean] killed :8002 pid=$CPID"
  sleep 8
fi

# Clear prior R26 train artifacts so start_r3 does not false-skip.
rm -rf /root/r3/train
mkdir -p /root/r3/train
rm -f /root/r3/train/train.done /root/logs/r3_train.nohup

nvidia-smi --query-gpu=index,memory.used --format=csv,noheader | tee /root/logs/r33_gpu_before_train.txt
bash /root/mining_src/r3-reason-grpo/start_r3.sh
touch /root/logs/r33_train_launched.stamp
touch /root/logs/r3_train_launched.stamp

TRAIN_DIR=/root/r3/train MERGED=/tmp/r3_merged \
  KING_REPO=ttttxxxxsada/Affine-5guassq3tu \
  KING_REV=e86758f5080d1e373e5fbbd7b4fbf6af327aeb44 \
  KING_LOCAL=/root/hf/hub/models--ttttxxxxsada--Affine-5guassq3tu/snapshots/e86758f5080d1e373e5fbbd7b4fbf6af327aeb44 \
  RESTART_KING=0 \
  nohup bash /root/mining_src/r3-reason-grpo/post_train_pipeline.sh \
  >/root/logs/r33_post_train.nohup 2>&1 &
echo $! >/root/logs/r33_post_train.pid
cp -f /root/logs/r33_post_train.pid /root/logs/r3_post_train.pid
cp -f /root/logs/r3_train.pid /root/logs/r33_train.pid 2>/dev/null || true

if [[ -x /root/mining_src/s4-h2-merge/watch_form_decision.sh ]]; then
  nohup bash /root/mining_src/s4-h2-merge/watch_form_decision.sh r3 \
    /root/affine_data/r3_sim_result.json /root/affine_data/r3_decision.json \
    /root/logs/r33_form_decision.nohup \
    >/root/logs/r33_form_decision.launch.out 2>&1 &
  echo $! >/root/logs/r33_form_decision.pid
fi

echo "[r33-lean] $(date -u +%Y-%m-%dT%H:%M:%SZ) TRAIN_PID=$(cat /root/logs/r3_train.pid 2>/dev/null || echo none) POST_PID=$(cat /root/logs/r33_post_train.pid)"
echo "[r33-lean] DONE"
