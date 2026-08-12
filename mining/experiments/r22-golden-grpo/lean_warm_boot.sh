#!/usr/bin/env bash
# On-pod lean R22: teacher:8000 + guass:8001 up → golden-crown-init GRPO on GPUs 6,7 → post_train.
# ≠ R3 Tok-init / R16 golden REINFORCE / R19–R21/R33 other parents.
set -euo pipefail
exec > >(tee -a /root/logs/r22_lean_warm.log) 2>&1

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

echo "[r22-lean] $(date -u +%Y-%m-%dT%H:%M:%SZ) start"
curl -sf --max-time 5 http://127.0.0.1:8000/v1/models >/dev/null
curl -sf --max-time 5 http://127.0.0.1:8001/v1/models >/dev/null

test -s /root/r3/winner_za_high_l1.jsonl
test -x /root/mining_src/r3-reason-grpo/start_r3.sh
grep -q "R22: Golden-GRPO" /root/mining_src/r3-reason-grpo/start_r3.sh
test -f /root/mining_src/r3-reason-grpo/train_reason_grpo.py

BASE_DEFAULT=/root/hf/hub/models--golden-crown--Affine-5EpvnXGu8jUAVc67oPGgJ3brR4JZqjBUSaTKhZuBoNAAzSJF/snapshots/ee37f4f0457df943d957435d7c9c24222a7ca93d
BASE=${BASE:-$BASE_DEFAULT}
if [[ ! -d "$BASE" ]]; then
  echo "[r22-lean] DOWNLOAD golden-crown (missing local $BASE)"
  python - <<'PY'
import os
from pathlib import Path
from huggingface_hub import snapshot_download
token = os.environ["HF_TOKEN"]
repo = "golden-crown/Affine-5EpvnXGu8jUAVc67oPGgJ3brR4JZqjBUSaTKhZuBoNAAzSJF"
rev = "ee37f4f0457df943d957435d7c9c24222a7ca93d"
path = snapshot_download(repo, revision=rev, token=token)
Path("/root/r22/r22_base.path").write_text(path + "\n")
print("[r22-lean] DOWNLOAD golden-crown done ->", path, flush=True)
PY
  BASE=$(cat /root/r22/r22_base.path)
fi
test -d "$BASE"
mkdir -p /root/r22
echo "$BASE" >/root/r22/r22_base.path
python3 - <<'PY'
from pathlib import Path
import re
path = Path("/root/r22/r22_base.path").read_text().strip()
envp = Path("/root/mine.env")
txt = envp.read_text() if envp.is_file() else ""
line = f"export BASE={path}\n"
if "export BASE=" in txt:
    txt = re.sub(r"^export BASE=.*$", f"export BASE={path}", txt, count=1, flags=re.M)
    envp.write_text(txt)
else:
    envp.write_text(txt + ("" if txt.endswith("\n") or not txt else "\n") + line)
print("[r22-lean] BASE", path, flush=True)
PY
export BASE

# Free stale chall on :8002 by pidfile / listener only (never pkill -f). Keep T/K.
if [[ -f /root/logs/vllm_chall.pid ]]; then
  cpid=$(cat /root/logs/vllm_chall.pid 2>/dev/null || true)
  if [[ -n "${cpid:-}" ]] && [[ "$cpid" =~ ^[0-9]+$ ]] && kill -0 "$cpid" 2>/dev/null; then
    kill "$cpid" || true
    echo "[r22-lean] killed stale chall pidfile=$cpid"
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
  echo "[r22-lean] killed :8002 pid=$CPID"
  sleep 8
fi

# Clear prior R33 train artifacts so start_r3 does not false-skip.
rm -rf /root/r3/train
mkdir -p /root/r3/train
rm -f /root/r3/train/train.done /root/logs/r3_train.nohup

nvidia-smi --query-gpu=index,memory.used --format=csv,noheader | tee /root/logs/r22_gpu_before_train.txt
bash /root/mining_src/r3-reason-grpo/start_r3.sh
touch /root/logs/r22_train_launched.stamp
touch /root/logs/r3_train_launched.stamp

TRAIN_DIR=/root/r3/train MERGED=/tmp/r3_merged \
  KING_REPO=ttttxxxxsada/Affine-5guassq3tu \
  KING_REV=e86758f5080d1e373e5fbbd7b4fbf6af327aeb44 \
  KING_LOCAL=/root/hf/hub/models--ttttxxxxsada--Affine-5guassq3tu/snapshots/e86758f5080d1e373e5fbbd7b4fbf6af327aeb44 \
  RESTART_KING=0 \
  nohup bash /root/mining_src/r3-reason-grpo/post_train_pipeline.sh \
  >/root/logs/r22_post_train.nohup 2>&1 &
echo $! >/root/logs/r22_post_train.pid
cp -f /root/logs/r22_post_train.pid /root/logs/r3_post_train.pid
cp -f /root/logs/r3_train.pid /root/logs/r22_train.pid 2>/dev/null || true

# Archive prior R33 r3_* sim/decision so form-dec waits for THIS axis.
if [[ -s /root/affine_data/r3_sim_result.json || -s /root/affine_data/r3_decision.json ]]; then
  _stale=/root/affine_data/stale_pre_r22_$(date -u +%Y%m%dT%H%M%SZ)
  mkdir -p "$_stale"
  for _f in r3_sim_result.json r3_sim_result_artifact.json r3_sim_progress.json r3_decision.json; do
    [[ -e /root/affine_data/$_f ]] && mv -f /root/affine_data/$_f "$_stale/" || true
  done
  [[ -e /root/logs/r3_decision.json ]] && mv -f /root/logs/r3_decision.json "$_stale/" || true
  echo "[r22-lean] archived prior r3 sim/decision → $_stale"
fi
if [[ -x /root/mining_src/s4-h2-merge/watch_form_decision.sh ]]; then
  : >/root/logs/r22_form_decision.nohup
  nohup bash /root/mining_src/s4-h2-merge/watch_form_decision.sh r22 \
    /root/affine_data/r3_sim_result.json /root/affine_data/r3_decision.json \
    /root/logs/r22_form_decision.nohup \
    >/root/logs/r22_form_decision.launch.out 2>&1 &
  echo $! >/root/logs/r22_form_decision.pid
fi

python3 - <<'PY'
import json, time
from pathlib import Path
Path("/root/affine_data/r22_train_launched.json").write_text(json.dumps({
  "utc": time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime()),
  "axis": "R22",
  "hypo": "R22",
  "base_hub": "golden-crown/Affine-5EpvnXGu8jUAVc67oPGgJ3brR4JZqjBUSaTKhZuBoNAAzSJF",
  "base_rev": "ee37f4f0457df943d957435d7c9c24222a7ca93d",
  "method": "grpo_teacher_reason_golden_init",
  "note": "R22 Golden×teacher-Reason GRPO on mine-crown-1 after R33 REFUTE (p2249)",
}, indent=2) + "\n")
PY

echo "[r22-lean] $(date -u +%Y-%m-%dT%H:%M:%SZ) TRAIN_PID=$(cat /root/logs/r3_train.pid 2>/dev/null || echo none) POST_PID=$(cat /root/logs/r22_post_train.pid)"
echo "[r22-lean] DONE"
