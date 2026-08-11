#!/usr/bin/env bash
# Host → mine-r4-fullft-1: upload H121 full-FT stack + high-Reason data, bootstrap.
# Reuses s4-h121-f26-full-ft train/finalize; R4 = Tok-init full-FT under Reason v3.
set -euo pipefail

ROOT=/home/const/subnet120
POD_NAME=${POD_NAME:-mine-r4-fullft-1}
DST_HOST=${DST_HOST:?set DST_HOST}
DST_PORT=${DST_PORT:?set DST_PORT}
KNOWN=${KNOWN:-/tmp/${POD_NAME}.known_hosts}
SSH=(ssh -i "$HOME/.ssh/id_ed25519" -o UserKnownHostsFile="$KNOWN"
     -o StrictHostKeyChecking=accept-new -p "$DST_PORT" "root@$DST_HOST")
SCP=(scp -i "$HOME/.ssh/id_ed25519" -o UserKnownHostsFile="$KNOWN"
     -o StrictHostKeyChecking=accept-new -P "$DST_PORT")

STAGE=$(mktemp -d /tmp/mine-r4-stack.XXXXXX)
trap 'rm -rf "$STAGE"' EXIT

EXP=s4-h121-f26-full-ft
mkdir -p "$STAGE/affine_pkg/affine" "$STAGE/affine_pkg/evalsrv" \
         "$STAGE/s3-duel-sim" "$STAGE/s4-h2-merge" "$STAGE/s4-h1-sft" \
         "$STAGE/s4-h1v2-sft" "$STAGE/$EXP" "$STAGE/r4-fullft-reason"

cp -a "$ROOT/affine/affine.toml" "$STAGE/affine_pkg/"
cp -a "$ROOT/affine/affine/." "$STAGE/affine_pkg/affine/"
cp -a "$ROOT/affine/evalsrv/." "$STAGE/affine_pkg/evalsrv/"
cp -a "$ROOT/mining/experiments/s3-duel-sim/"*.sh "$STAGE/s3-duel-sim/"
cp -a "$ROOT/mining/experiments/s3-duel-sim/"*.py "$STAGE/s3-duel-sim/" 2>/dev/null || true
cp -a "$ROOT/mining/experiments/s4-h2-merge/restart_for_h2.sh" "$STAGE/s4-h2-merge/"
cp -a "$ROOT/mining/experiments/s4-h2-merge/run_sim_duel.py" "$STAGE/s4-h2-merge/"
cp -a "$ROOT/mining/experiments/s4-h2-merge/write_merge_decision.py" "$STAGE/s4-h2-merge/"
cp -a "$ROOT/mining/experiments/s4-h2-merge/watch_form_decision.sh" "$STAGE/s4-h2-merge/"
cp -a "$ROOT/mining/experiments/s4-h2-merge/watch_n80_retry.sh" "$STAGE/s4-h2-merge/"
cp -a "$ROOT/mining/experiments/s4-h1-sft/push_merged.py" "$STAGE/s4-h1-sft/"
cp -a "$ROOT/mining/experiments/s4-h1v2-sft/thought_mask.py" "$STAGE/s4-h1v2-sft/"
cp -a "$ROOT/mining/experiments/s4-h1v2-sft/verify_thought_mask.py" "$STAGE/s4-h1v2-sft/"
cp -a "$ROOT/mining/experiments/$EXP/"*.sh "$STAGE/$EXP/"
cp -a "$ROOT/mining/experiments/$EXP/"*.py "$STAGE/$EXP/"
cp -a "$ROOT/mining/experiments/$EXP/plan.md" "$STAGE/$EXP/"
cp -a "$ROOT/mining/experiments/r4-fullft-reason/plan.md" "$STAGE/r4-fullft-reason/" 2>/dev/null || true

TAR=/tmp/mine-r4-stack.tar.gz
tar -C "$STAGE" -czf "$TAR" .
ls -lh "$TAR"

ENV_TMP=$(mktemp /tmp/mine-r4.env.XXXXXX)
# shellcheck disable=SC1091
set -a
source "$ROOT/mining/.env"
set +a
umask 077
# Soft deadline = now+23h; deadman = now+23.5h (TTL 24h).
SOFT=$(date -u -d '+23 hours' +%Y-%m-%dT%H:%M:%SZ)
DEAD=$(date -u -d '+23 hours 30 minutes' +%Y-%m-%dT%H:%M:%SZ)
{
  echo "export HF_TOKEN=${HF_TOKEN}"
  echo "export HF_HOME=/root/hf"
  echo "export HF_HUB_ENABLE_HF_TRANSFER=1"
  echo "export HF_XET_HIGH_PERFORMANCE=1"
  echo "export AFFINE_DATA_DIR=/root/affine_data"
  echo "export SOFT_DEADLINE_UTC=${SOFT}"
  echo "export DEADMAN_UTC=${DEAD}"
  echo "export HF_MERGED_REPO=unconst/Affine-5czsc2fc98-r4-fullft"
} >"$ENV_TMP"
chmod 600 "$ENV_TMP"

# Plan: high-Reason winner thoughts (same family as R3 GRPO data).
DATA="$ROOT/mining/experiments/s4-h27-clip-l1-shape/results/winner_za_high_l1.jsonl"
test -s "$DATA"
test "$(wc -l <"$DATA")" -ge 300

"${SSH[@]}" 'mkdir -p /root/mining_src /root/affine_data /root/logs /root/h121 /root/r4 /root/hf'
"${SCP[@]}" "$TAR" "root@${DST_HOST}:/tmp/mine-r4-stack.tar.gz"
"${SCP[@]}" "$ENV_TMP" "root@${DST_HOST}:/root/mine.env"
# H121 bootstrap expects this path/name; content is the Reason high-za set.
"${SCP[@]}" "$DATA" "root@${DST_HOST}:/root/h121/winner_za_high_l2.jsonl"
"${SCP[@]}" "$DATA" "root@${DST_HOST}:/root/r4/winner_za_high_l1.jsonl"
rm -f "$ENV_TMP"

python3 - <<'PY'
import os
from huggingface_hub import HfApi
api = HfApi(token=os.environ["HF_TOKEN"])
repo = "unconst/Affine-5czsc2fc98-r4-fullft"
try:
    api.create_repo(repo, private=False, exist_ok=True, repo_type="model")
    print("HF_OK", repo)
except Exception as e:
    print("HF_ERR", repo, type(e).__name__, e)
PY

"${SSH[@]}" 'set -e
  tar -C /root/mining_src -xzf /tmp/mine-r4-stack.tar.gz
  chmod 600 /root/mine.env
  chmod +x /root/mining_src/s3-duel-sim/*.sh \
           /root/mining_src/s4-h2-merge/*.sh \
           /root/mining_src/s4-h121-f26-full-ft/*.sh
  test -f /root/mining_src/affine_pkg/affine/score.py
  test -s /root/h121/winner_za_high_l2.jsonl
  test -x /root/mining_src/s4-h121-f26-full-ft/bootstrap_h121.sh
  set -a; source /root/mine.env; set +a
  echo "R4_DEADLINES soft=$SOFT_DEADLINE_UTC dead=$DEADMAN_UTC"
  echo STACK_UPLOAD_OK
  nohup bash /root/mining_src/s4-h121-f26-full-ft/bootstrap_h121.sh \
    >/root/logs/r4_pipeline.nohup 2>&1 &
  echo $! > /root/logs/r4_pipeline.pid
  # Also mirror h121 pid file names bootstrap expects for operators.
  cp -f /root/logs/r4_pipeline.pid /root/logs/h121_pipeline.pid
  nohup bash /root/mining_src/s4-h2-merge/watch_form_decision.sh h121 \
    /root/affine_data/h121_sim_result.json /root/affine_data/h121_decision.json \
    /root/logs/r4_form_decision.nohup \
    >/root/logs/r4_form_decision.launch.out 2>&1 &
  echo $! > /root/logs/r4_form_decision.pid
  echo PIPELINE_PID=$(cat /root/logs/r4_pipeline.pid)
  sleep 5
  head -n 40 /root/logs/bootstrap_h121.log 2>/dev/null || head -n 40 /root/logs/r4_pipeline.nohup || true
  ps -p "$(cat /root/logs/r4_pipeline.pid)" -o pid,etime,cmd || true
  nvidia-smi -L | wc -l
'

echo "UPLOAD_AND_LAUNCH_OK pod=$POD_NAME $(date -u +%Y-%m-%dT%H:%M:%SZ)"
