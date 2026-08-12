#!/usr/bin/env bash
# On-pod lean R27: teacher:8000 + guass:8001 up → Tok BigG-GRPO (G=16) on GPUs 6,7 → post_train.
# ≠ R3 G=4 / R3b G=8+lr/rank / R24 longctx / R25–R26 temp / R18–R23 parent-GRPO.
set -euo pipefail
exec > >(tee -a /root/logs/r27_lean_warm.log) 2>&1

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

echo "[r27-lean] $(date -u +%Y-%m-%dT%H:%M:%SZ) start"
curl -sf --max-time 5 http://127.0.0.1:8000/v1/models >/dev/null
curl -sf --max-time 5 http://127.0.0.1:8001/v1/models >/dev/null

test -s /root/r3/winner_za_high_l1.jsonl
test -x /root/mining_src/r3-reason-grpo/start_r3.sh
grep -q "R27: BigG-GRPO" /root/mining_src/r3-reason-grpo/start_r3.sh
grep -q "R27_GROUP_SIZE:-16" /root/mining_src/r3-reason-grpo/start_r3.sh
test -f /root/mining_src/r3-reason-grpo/train_reason_grpo.py

# Tok af10 init (stamp may exist after R19 purge; re-fetch if missing).
BASE_DEFAULT=/root/hf/hub/models--Tok331102--affine-5EqYW8McUc-af10/snapshots/eb8bf9a356a254f71faaa439e8abc3cfba572c53
BASE=${BASE:-$BASE_DEFAULT}
if [[ ! -d "$BASE" ]]; then
  echo "[r27-lean] DOWNLOAD tok-init (missing local $BASE)"
  python - <<'PY'
import os
from pathlib import Path
from huggingface_hub import snapshot_download
token = os.environ["HF_TOKEN"]
repo = "Tok331102/affine-5EqYW8McUc-af10"
rev = "eb8bf9a356a254f71faaa439e8abc3cfba572c53"
path = snapshot_download(repo, revision=rev, token=token)
Path("/root/logs/tok_init.done").write_text(path + "\n")
Path("/root/logs/tok331102.done").write_text(path + "\n")
Path("/root/r27/r27_base.path").write_text(path + "\n")
print("[r27-lean] DOWNLOAD tok-init done ->", path, flush=True)
PY
  BASE=$(cat /root/r27/r27_base.path)
fi
test -d "$BASE"
mkdir -p /root/r27
echo "$BASE" >/root/r27/r27_base.path
python3 - <<'PY'
from pathlib import Path
import re
path = Path("/root/r27/r27_base.path").read_text().strip()
envp = Path("/root/mine.env")
txt = envp.read_text() if envp.is_file() else ""
line = f"export BASE={path}\n"
if "export BASE=" in txt:
    txt = re.sub(r"^export BASE=.*$", f"export BASE={path}", txt, count=1, flags=re.M)
    envp.write_text(txt)
else:
    envp.write_text(txt + ("" if txt.endswith("\n") or not txt else "\n") + line)
print("[r27-lean] BASE", path, flush=True)
PY
export BASE

# Free stale chall on :8002 by pidfile / listener only (never pkill -f). Keep T/K.
if [[ -f /root/logs/vllm_chall.pid ]]; then
  cpid=$(cat /root/logs/vllm_chall.pid 2>/dev/null || true)
  if [[ -n "${cpid:-}" ]] && [[ "$cpid" =~ ^[0-9]+$ ]] && kill -0 "$cpid" 2>/dev/null; then
    kill "$cpid" || true
    echo "[r27-lean] killed stale chall pidfile=$cpid"
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
  echo "[r27-lean] killed :8002 pid=$CPID"
  sleep 8
fi

# Drop prior R19 merge weights to reclaim /tmp before later merge.
if [[ -d /tmp/r3_merged ]]; then
  rm -rf /tmp/r3_merged
  echo "[r27-lean] removed /tmp/r3_merged"
fi

# Clear prior R19 train stamps so start_r3 / post_train wait on this run.
rm -rf /root/r3/train
mkdir -p /root/r3/train
rm -f /root/r3/train/train.done /root/logs/r3_train.nohup

nvidia-smi --query-gpu=index,memory.used --format=csv,noheader | tee /root/logs/r27_gpu_before_train.txt
bash /root/mining_src/r3-reason-grpo/start_r3.sh
touch /root/logs/r27_train_launched.stamp
touch /root/logs/r3_train_launched.stamp

TRAIN_DIR=/root/r3/train MERGED=/tmp/r27_merged \
  KING_REPO=ttttxxxxsada/Affine-5guassq3tu \
  KING_REV=e86758f5080d1e373e5fbbd7b4fbf6af327aeb44 \
  KING_LOCAL=/root/hf/hub/models--ttttxxxxsada--Affine-5guassq3tu/snapshots/e86758f5080d1e373e5fbbd7b4fbf6af327aeb44 \
  RESTART_KING=0 \
  nohup bash /root/mining_src/r3-reason-grpo/post_train_pipeline.sh \
  >/root/logs/r27_post_train.nohup 2>&1 &
echo $! >/root/logs/r27_post_train.pid
cp -f /root/logs/r27_post_train.pid /root/logs/r3_post_train.pid
cp -f /root/logs/r3_train.pid /root/logs/r27_train.pid 2>/dev/null || true

# Archive prior R19 r3_* sim/decision so form-dec waits for THIS axis.
if [[ -s /root/affine_data/r3_sim_result.json || -s /root/affine_data/r3_decision.json ]]; then
  _stale=/root/affine_data/stale_pre_r27_$(date -u +%Y%m%dT%H%M%SZ)
  mkdir -p "$_stale"
  for _f in r3_sim_result.json r3_sim_result_artifact.json r3_sim_progress.json r3_decision.json r3b_decision.json; do
    [[ -e /root/affine_data/$_f ]] && mv -f /root/affine_data/$_f "$_stale/" || true
  done
  [[ -e /root/logs/r3_decision.json ]] && mv -f /root/logs/r3_decision.json "$_stale/" || true
  echo "[r27-lean] archived prior r3 sim/decision → $_stale"
fi
if [[ -x /root/mining_src/s4-h2-merge/watch_form_decision.sh ]]; then
  : >/root/logs/r27_form_decision.nohup
  nohup bash /root/mining_src/s4-h2-merge/watch_form_decision.sh r27 \
    /root/affine_data/r3_sim_result.json /root/affine_data/r3_decision.json \
    /root/logs/r27_form_decision.nohup \
    >/root/logs/r27_form_decision.launch.out 2>&1 &
  echo $! >/root/logs/r27_form_decision.pid
fi

python3 - <<'PY'
import json, time
from pathlib import Path
Path("/root/affine_data/r27_train_launched.json").write_text(json.dumps({
  "utc": time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime()),
  "axis": "R27",
  "hypo": "R27",
  "base_hub": "Tok331102/affine-5EqYW8McUc-af10",
  "base_rev": "eb8bf9a356a254f71faaa439e8abc3cfba572c53",
  "method": "grpo_teacher_reason_bigg",
  "group_size": 16,
  "note": "R27 Tok×teacher-Reason GRPO BigG G=16 on mine-r4-fullft-1 after R19 SIGNAL_POS_BELOW (p2253)",
}, indent=2) + "\n")
PY

echo "[r27-lean] $(date -u +%Y-%m-%dT%H:%M:%SZ) TRAIN_PID=$(cat /root/logs/r3_train.pid 2>/dev/null || echo none) POST_PID=$(cat /root/logs/r27_post_train.pid)"
echo "[r27-lean] DONE"
