#!/usr/bin/env bash
# Arm R9 Tok-LoRA on free crown GPUs 6–7 while R2bh n80 holds TKC on 0–5.
# TRAIN ONLY — do not merge/reload chall until R2bh decision exists.
set -euo pipefail

ROOT=/home/const/subnet120
POD_NAME=${POD_NAME:-mine-crown-1}
DST_HOST=${DST_HOST:-95.133.253.90}
DST_PORT=${DST_PORT:-40099}
KNOWN=${KNOWN:-/tmp/${POD_NAME}.known_hosts}
SSH=(ssh -i "$HOME/.ssh/id_ed25519" -o UserKnownHostsFile="$KNOWN"
     -o StrictHostKeyChecking=accept-new -p "$DST_PORT" "root@$DST_HOST")
SCP=(scp -i "$HOME/.ssh/id_ed25519" -o UserKnownHostsFile="$KNOWN"
     -o StrictHostKeyChecking=accept-new -P "$DST_PORT")

DATA="$ROOT/mining/experiments/s4-h5c-expand-refs/results/teacher_refs_expanded.jsonl"
test -s "$DATA"
test "$(wc -l <"$DATA")" -ge 1000
test -f "$ROOT/mining/experiments/s4-h1v2-sft/train_lora.py"
test -f "$ROOT/mining/experiments/r9-teacher-zc/start_r9.sh"

SOFT=$(date -u -d '+23 hours' +%Y-%m-%dT%H:%M:%SZ)
DEAD=$(date -u -d '+23 hours 30 minutes' +%Y-%m-%dT%H:%M:%SZ)

"${SSH[@]}" 'mkdir -p /root/mining_src/s4-h1v2-sft /root/mining_src/r9-teacher-zc \
  /root/h99/train /root/r9 /root/affine_data /root/logs'

"${SCP[@]}" \
  "$ROOT/mining/experiments/s4-h1v2-sft/train_lora.py" \
  "$ROOT/mining/experiments/s4-h1v2-sft/thought_mask.py" \
  "$ROOT/mining/experiments/s4-h1v2-sft/verify_thought_mask.py" \
  "root@${DST_HOST}:/root/mining_src/s4-h1v2-sft/"

"${SCP[@]}" \
  "$ROOT/mining/experiments/r9-teacher-zc/start_r9.sh" \
  "root@${DST_HOST}:/root/mining_src/r9-teacher-zc/start_r9.sh"

"${SCP[@]}" "$DATA" "root@${DST_HOST}:/root/h99/winner_za_high_l2.jsonl"
"${SCP[@]}" "$DATA" "root@${DST_HOST}:/root/r9/teacher_refs_expanded.jsonl"

# shellcheck disable=SC1091
set -a
source "$ROOT/mining/.env"
set +a
ENV_TMP=$(mktemp /tmp/mine-r9.env.XXXXXX)
umask 077
{
  echo "export HF_TOKEN=${HF_TOKEN}"
  echo "export HF_HOME=/root/hf"
  echo "export HF_HUB_ENABLE_HF_TRANSFER=1"
  echo "export HF_XET_HIGH_PERFORMANCE=1"
  echo "export AFFINE_DATA_DIR=/root/affine_data"
  echo "export SOFT_DEADLINE_UTC=${SOFT}"
  echo "export DEADMAN_UTC=${DEAD}"
  echo "export HF_MERGED_REPO=unconst/Affine-5czsc2fc98-r9-teacher-zc"
  echo "export R9_AXIS=teacher_zc_expanded_tok_lora"
  echo "export EPOCHS=3"
  echo "export LORA_R=32"
  echo "export LORA_ALPHA=64"
  echo "export CUDA_VISIBLE_DEVICES=6,7"
} >"$ENV_TMP"
chmod 600 "$ENV_TMP"
"${SCP[@]}" "$ENV_TMP" "root@${DST_HOST}:/root/r9/mine.env"
rm -f "$ENV_TMP"

# Merge R9 env into /root/mine.env without clobbering existing HF_TOKEN lines blindly:
# start_r9 sources /root/mine.env; append R9 knobs + ensure token present.
"${SSH[@]}" "set -e
  chmod +x /root/mining_src/r9-teacher-zc/start_r9.sh
  # Keep existing mine.env; overlay R9 exports from /root/r9/mine.env
  if [[ -f /root/mine.env ]]; then
    grep -v -E '^(export )?(SOFT_DEADLINE_UTC|DEADMAN_UTC|HF_MERGED_REPO|R9_AXIS|EPOCHS|LORA_R|LORA_ALPHA|CUDA_VISIBLE_DEVICES)=' \
      /root/mine.env > /root/mine.env.r9bak || true
  else
    : > /root/mine.env.r9bak
  fi
  cat /root/mine.env.r9bak /root/r9/mine.env > /root/mine.env.new
  mv /root/mine.env.new /root/mine.env
  chmod 600 /root/mine.env
  export PATH=\"/root/.local/bin:\${PATH}\"
  source /root/venv/bin/activate
  uv pip install --python /root/venv/bin/python 'peft' 'accelerate' >/root/logs/r9_uv_peft.log 2>&1
  /root/venv/bin/python - <<'PY'
import peft, accelerate
print('peft', peft.__version__, 'accelerate', accelerate.__version__)
PY
  # Refuse if R2bh sim not alive (we only want free 6–7 while TKC held)
  if ! pgrep -f 'run_reason_sim.py .*r2bh_intolayer' >/dev/null 2>&1; then
    echo 'WARN: r2bh sim not matched; continuing train arm anyway'
  fi
  nvidia-smi --query-gpu=index,memory.free --format=csv,noheader | sed -n '7,8p'
  set -a; source /root/mine.env; set +a
  export CUDA_VISIBLE_DEVICES=6,7
  nohup bash /root/mining_src/r9-teacher-zc/start_r9.sh \
    >/root/logs/r9_start.nohup 2>&1 &
  echo \$! > /root/logs/r9_start.pid
  sleep 8
  echo START_OUT=
  tail -n 30 /root/logs/r9_start.nohup || true
  echo TRAIN_LOG=
  tail -n 20 /root/logs/h99_train.nohup || true
  test -s /root/logs/r9_train.pid
  kill -0 \"\$(cat /root/logs/r9_train.pid)\"
  echo R9_TRAIN_PID=\$(cat /root/logs/r9_train.pid)
  echo R9_WARM_ARM_OK
"

ART="$ROOT/mining/experiments/r9-teacher-zc/artifacts"
mkdir -p "$ART"
python3 - <<PY
import json, time
from pathlib import Path
meta = {
    "utc": time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime()),
    "pass": 2144,
    "hypo": "R9",
    "pod": "$POD_NAME",
    "ssh": "ssh root@$DST_HOST -p $DST_PORT",
    "axis": "teacher_zc_expanded_tok_lora",
    "examples": 1329,
    "gpus": "6,7",
    "note": "warm overlay on crown free GPUs; train-only until R2bh decision; no chall reload",
    "watch": {
        "train": "tail -f /root/logs/h99_train.nohup",
        "start": "tail -f /root/logs/r9_start.nohup",
        "launched": "/root/affine_data/r9_train_launched.json",
    },
    "gate_post_train": "wait for /root/affine_data/r2bh_intolayer_decision.json before merge/chall reload",
}
Path("$ART/p2144_armed_warm_crown.json").write_text(json.dumps(meta, indent=2) + "\n")
print(json.dumps(meta, indent=2))
PY
echo ARM_HOST_OK
