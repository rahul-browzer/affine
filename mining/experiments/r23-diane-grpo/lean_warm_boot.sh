#!/usr/bin/env bash
# On-pod lean R23: teacher:8000 + guass:8001 up → diane613-init GRPO on GPUs 6,7 → post_train.
# ≠ R3 Tok-init / R16/R22 golden / R19–R21 other parents.
set -euo pipefail
exec > >(tee -a /root/logs/r23_lean_warm.log) 2>&1

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

echo "[r23-lean] $(date -u +%Y-%m-%dT%H:%M:%SZ) start"
curl -sf --max-time 5 http://127.0.0.1:8000/v1/models >/dev/null
curl -sf --max-time 5 http://127.0.0.1:8001/v1/models >/dev/null

test -s /root/r3/winner_za_high_l1.jsonl
test -x /root/mining_src/r3-reason-grpo/start_r3.sh
grep -q "R23: Diane-GRPO" /root/mining_src/r3-reason-grpo/start_r3.sh
test -f /root/mining_src/r3-reason-grpo/train_reason_grpo.py

BASE_DEFAULT=/root/hf/hub/models--diane613--Affine-5CQLBK7Mmw1vsk7eQcBok9Qn44JNU5YVrfNmZpJHPxLV271B/snapshots/ad0f3f116e44dc5154ca3f72b933faaefc4905fa
BASE=${BASE:-$BASE_DEFAULT}
if [[ ! -d "$BASE" ]]; then
  echo "[r23-lean] DOWNLOAD diane613 (missing local $BASE)"
  python - <<'PY'
import os
from pathlib import Path
from huggingface_hub import snapshot_download
token = os.environ["HF_TOKEN"]
repo = "diane613/Affine-5CQLBK7Mmw1vsk7eQcBok9Qn44JNU5YVrfNmZpJHPxLV271B"
rev = "ad0f3f116e44dc5154ca3f72b933faaefc4905fa"
path = snapshot_download(repo, revision=rev, token=token)
Path("/root/r23/r23_base.path").write_text(path + "\n")
print("[r23-lean] DOWNLOAD diane613 done ->", path, flush=True)
PY
  BASE=$(cat /root/r23/r23_base.path)
fi
test -d "$BASE"
mkdir -p /root/r23
echo "$BASE" >/root/r23/r23_base.path
python3 - <<'PY'
from pathlib import Path
import re
path = Path("/root/r23/r23_base.path").read_text().strip()
envp = Path("/root/mine.env")
txt = envp.read_text() if envp.is_file() else ""
line = f"export BASE={path}\n"
if "export BASE=" in txt:
    txt = re.sub(r"^export BASE=.*$", f"export BASE={path}", txt, count=1, flags=re.M)
    envp.write_text(txt)
else:
    envp.write_text(txt + ("" if txt.endswith("\n") or not txt else "\n") + line)
print("[r23-lean] BASE", path, flush=True)
PY
export BASE

# Free stale chall on :8002 by pidfile / listener only (never pkill -f). Keep T/K.
if [[ -f /root/logs/vllm_chall.pid ]]; then
  cpid=$(cat /root/logs/vllm_chall.pid 2>/dev/null || true)
  if [[ -n "${cpid:-}" ]] && [[ "$cpid" =~ ^[0-9]+$ ]] && kill -0 "$cpid" 2>/dev/null; then
    kill "$cpid" || true
    echo "[r23-lean] killed stale chall pidfile=$cpid"
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
  echo "[r23-lean] killed :8002 pid=$CPID"
  sleep 8
fi

# Clear prior R25 train artifacts so start_r3 does not false-skip.
rm -rf /root/r3/train
mkdir -p /root/r3/train
rm -f /root/r3/train/train.done /root/logs/r3_train.nohup

nvidia-smi --query-gpu=index,memory.used --format=csv,noheader | tee /root/logs/r23_gpu_before_train.txt
bash /root/mining_src/r3-reason-grpo/start_r3.sh
touch /root/logs/r23_train_launched.stamp
touch /root/logs/r3_train_launched.stamp

TRAIN_DIR=/root/r3/train MERGED=/tmp/r3_merged \
  KING_REPO=ttttxxxxsada/Affine-5guassq3tu \
  KING_REV=e86758f5080d1e373e5fbbd7b4fbf6af327aeb44 \
  KING_LOCAL=/root/hf/hub/models--ttttxxxxsada--Affine-5guassq3tu/snapshots/e86758f5080d1e373e5fbbd7b4fbf6af327aeb44 \
  RESTART_KING=0 \
  nohup bash /root/mining_src/r3-reason-grpo/post_train_pipeline.sh \
  >/root/logs/r23_post_train.nohup 2>&1 &
echo $! >/root/logs/r23_post_train.pid
cp -f /root/logs/r23_post_train.pid /root/logs/r3_post_train.pid
cp -f /root/logs/r3_train.pid /root/logs/r23_train.pid 2>/dev/null || true

# Archive prior R25 r3_* sim/decision so form-dec waits for THIS axis.
if [[ -s /root/affine_data/r3_sim_result.json || -s /root/affine_data/r3_decision.json ]]; then
  _stale=/root/affine_data/stale_pre_r23_$(date -u +%Y%m%dT%H%M%SZ)
  mkdir -p "$_stale"
  for _f in r3_sim_result.json r3_sim_result_artifact.json r3_sim_progress.json r3_decision.json; do
    [[ -e /root/affine_data/$_f ]] && mv -f /root/affine_data/$_f "$_stale/" || true
  done
  [[ -e /root/logs/r3_decision.json ]] && mv -f /root/logs/r3_decision.json "$_stale/" || true
  echo "[r23-lean] archived prior r3 sim/decision → $_stale"
fi
if [[ -x /root/mining_src/s4-h2-merge/watch_form_decision.sh ]]; then
  : >/root/logs/r23_form_decision.nohup
  nohup bash /root/mining_src/s4-h2-merge/watch_form_decision.sh r23 \
    /root/affine_data/r3_sim_result.json /root/affine_data/r3_decision.json \
    /root/logs/r23_form_decision.nohup \
    >/root/logs/r23_form_decision.launch.out 2>&1 &
  echo $! >/root/logs/r23_form_decision.pid
fi

python3 - <<'PY'
import json, time
from pathlib import Path
Path("/root/affine_data/r23_train_launched.json").write_text(json.dumps({
  "utc": time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime()),
  "axis": "R23",
  "hypo": "R23",
  "base_hub": "diane613/Affine-5CQLBK7Mmw1vsk7eQcBok9Qn44JNU5YVrfNmZpJHPxLV271B",
  "base_rev": "ad0f3f116e44dc5154ca3f72b933faaefc4905fa",
  "method": "grpo_teacher_reason_diane_init",
  "note": "R23 Diane×teacher-Reason GRPO on mine-r3-grpo-1 after R25 REFUTE (p2252)",
}, indent=2) + "\n")
PY

echo "[r23-lean] $(date -u +%Y-%m-%dT%H:%M:%SZ) TRAIN_PID=$(cat /root/logs/r3_train.pid 2>/dev/null || echo none) POST_PID=$(cat /root/logs/r23_post_train.pid)"
echo "[r23-lean] DONE"
