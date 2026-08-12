#!/usr/bin/env bash
# On-pod lean R26: teacher:8000 + guass:8001 up → Tok LoTemp-GRPO on GPUs 6,7 → post_train.
set -euo pipefail
exec > >(tee -a /root/logs/r26_lean_warm.log) 2>&1

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

echo "[r26-lean] $(date -u +%Y-%m-%dT%H:%M:%SZ) start"
curl -sf --max-time 5 http://127.0.0.1:8000/v1/models >/dev/null
curl -sf --max-time 5 http://127.0.0.1:8001/v1/models >/dev/null

test -s /root/r3/winner_za_high_l1.jsonl
test -x /root/mining_src/r3-reason-grpo/start_r3.sh
grep -q "R26: LoTemp-GRPO" /root/mining_src/r3-reason-grpo/start_r3.sh
grep -q "temperature=0.5" /root/mining_src/r3-reason-grpo/start_r3.sh
test -f /root/mining_src/r3-reason-grpo/train_reason_grpo.py

BASE_DEFAULT=/root/hf/hub/models--Tok331102--affine-5EqYW8McUc-af10/snapshots/eb8bf9a356a254f71faaa439e8abc3cfba572c53
BASE=${BASE:-$BASE_DEFAULT}
test -d "$BASE"
mkdir -p /root/r26
echo "$BASE" >/root/r26/r26_base.path
python3 - <<'PY'
from pathlib import Path
import re
path = Path("/root/r26/r26_base.path").read_text().strip()
envp = Path("/root/mine.env")
txt = envp.read_text() if envp.is_file() else ""
line = f"export BASE={path}\n"
if "export BASE=" in txt:
    txt = re.sub(r"^export BASE=.*$", f"export BASE={path}", txt, count=1, flags=re.M)
    envp.write_text(txt)
else:
    envp.write_text(txt + ("" if txt.endswith("\n") or not txt else "\n") + line)
print("[r26-lean] BASE", path, flush=True)
PY
export BASE

# Free stale chall on :8002 by pidfile only (never pkill -f). Keep T/K.
if [[ -f /root/logs/vllm_chall.pid ]]; then
  cpid=$(cat /root/logs/vllm_chall.pid 2>/dev/null || true)
  if [[ -n "${cpid:-}" ]] && [[ "$cpid" =~ ^[0-9]+$ ]] && kill -0 "$cpid" 2>/dev/null; then
    kill "$cpid" || true
    echo "[r26-lean] killed stale chall pidfile=$cpid"
    sleep 5
  fi
fi
# R17 leftover had no pidfile — kill the single listener on :8002 if present.
CPID=$(
  python3 - <<'PY'
import os, re, subprocess
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
  echo "[r26-lean] killed :8002 pid=$CPID"
  sleep 5
fi

nvidia-smi --query-gpu=index,memory.used --format=csv,noheader | tee /root/logs/r26_gpu_before_train.txt
rm -f /root/logs/r3_train.nohup
bash /root/mining_src/r3-reason-grpo/start_r3.sh
touch /root/logs/r26_train_launched.stamp
touch /root/logs/r3_train_launched.stamp

TRAIN_DIR=/root/r3/train MERGED=/tmp/r3_merged \
  KING_REPO=ttttxxxxsada/Affine-5guassq3tu \
  KING_REV=e86758f5080d1e373e5fbbd7b4fbf6af327aeb44 \
  KING_LOCAL=/root/hf/hub/models--ttttxxxxsada--Affine-5guassq3tu/snapshots/e86758f5080d1e373e5fbbd7b4fbf6af327aeb44 \
  RESTART_KING=0 \
  nohup bash /root/mining_src/r3-reason-grpo/post_train_pipeline.sh \
  >/root/logs/r26_post_train.nohup 2>&1 &
echo $! >/root/logs/r26_post_train.pid
cp -f /root/logs/r26_post_train.pid /root/logs/r3_post_train.pid
cp -f /root/logs/r3_train.pid /root/logs/r26_train.pid 2>/dev/null || true

if [[ -x /root/mining_src/s4-h2-merge/watch_form_decision.sh ]]; then
  nohup bash /root/mining_src/s4-h2-merge/watch_form_decision.sh r3 \
    /root/affine_data/r3_sim_result.json /root/affine_data/r3_decision.json \
    /root/logs/r26_form_decision.nohup \
    >/root/logs/r26_form_decision.launch.out 2>&1 &
  echo $! >/root/logs/r26_form_decision.pid
fi

echo "[r26-lean] $(date -u +%Y-%m-%dT%H:%M:%SZ) TRAIN_PID=$(cat /root/logs/r3_train.pid) POST_PID=$(cat /root/logs/r26_post_train.pid)"
echo "[r26-lean] DONE"
