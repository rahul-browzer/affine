#!/usr/bin/env bash
# Host → mine-r5-nonking-1: Genesis-init full-FT (H122 stack) + high-Reason data.
# Axis R5: non-king base vs R4 Tok-init; same winner_za_high_l1 family.
set -euo pipefail

ROOT=/home/const/subnet120
POD_NAME=${POD_NAME:-mine-r5-nonking-1}
DST_HOST=${DST_HOST:?set DST_HOST}
DST_PORT=${DST_PORT:?set DST_PORT}
KNOWN=${KNOWN:-/tmp/${POD_NAME}.known_hosts}
SSH=(ssh -i "$HOME/.ssh/id_ed25519" -o UserKnownHostsFile="$KNOWN"
     -o StrictHostKeyChecking=accept-new -p "$DST_PORT" "root@$DST_HOST")
SCP=(scp -i "$HOME/.ssh/id_ed25519" -o UserKnownHostsFile="$KNOWN"
     -o StrictHostKeyChecking=accept-new -P "$DST_PORT")

STAGE=$(mktemp -d /tmp/mine-r5-stack.XXXXXX)
trap 'rm -rf "$STAGE"' EXIT

EXP=s4-h122-f27-genesis-full-ft
mkdir -p "$STAGE/affine_pkg/affine" "$STAGE/affine_pkg/evalsrv" \
         "$STAGE/s3-duel-sim" "$STAGE/s4-h2-merge" "$STAGE/s4-h1-sft" \
         "$STAGE/s4-h1v2-sft" "$STAGE/$EXP" "$STAGE/r5-nonking-base"

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
cp -a "$ROOT/mining/experiments/r5-nonking-base/plan.md" "$STAGE/r5-nonking-base/" 2>/dev/null || true

TAR=/tmp/mine-r5-stack.tar.gz
tar -C "$STAGE" -czf "$TAR" .
ls -lh "$TAR"

ENV_TMP=$(mktemp /tmp/mine-r5.env.XXXXXX)
# shellcheck disable=SC1091
set -a
source "$ROOT/mining/.env"
set +a
umask 077
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
  echo "export HF_MERGED_REPO=unconst/Affine-5czsc2fc98-r5-nonking"
} >"$ENV_TMP"
chmod 600 "$ENV_TMP"

# Same Reason high-za set as R4 — isolate base (Genesis vs Tok).
DATA="$ROOT/mining/experiments/s4-h27-clip-l1-shape/results/winner_za_high_l1.jsonl"
test -s "$DATA"
test "$(wc -l <"$DATA")" -ge 300

"${SSH[@]}" 'mkdir -p /root/mining_src /root/affine_data /root/logs /root/h122 /root/r5 /root/hf'
"${SCP[@]}" "$TAR" "root@${DST_HOST}:/tmp/mine-r5-stack.tar.gz"
"${SCP[@]}" "$ENV_TMP" "root@${DST_HOST}:/root/mine.env"
# H122 bootstrap expects this path/name; content is the Reason high-za set.
"${SCP[@]}" "$DATA" "root@${DST_HOST}:/root/h122/winner_za_high_l2.jsonl"
"${SCP[@]}" "$DATA" "root@${DST_HOST}:/root/r5/winner_za_high_l1.jsonl"
rm -f "$ENV_TMP"

python3 - <<'PY'
import os
from huggingface_hub import HfApi
api = HfApi(token=os.environ["HF_TOKEN"])
repo = "unconst/Affine-5czsc2fc98-r5-nonking"
try:
    api.create_repo(repo, private=False, exist_ok=True, repo_type="model")
    print("HF_OK", repo)
except Exception as e:
    print("HF_ERR", repo, type(e).__name__, e)
PY

"${SSH[@]}" 'set -e
  tar -C /root/mining_src -xzf /tmp/mine-r5-stack.tar.gz
  chmod 600 /root/mine.env
  chmod +x /root/mining_src/s3-duel-sim/*.sh \
           /root/mining_src/s4-h2-merge/*.sh \
           /root/mining_src/s4-h122-f27-genesis-full-ft/*.sh
  test -f /root/mining_src/affine_pkg/affine/score.py
  test -s /root/h122/winner_za_high_l2.jsonl
  test -x /root/mining_src/s4-h122-f27-genesis-full-ft/bootstrap_h122.sh
  set -a; source /root/mine.env; set +a
  echo "R5_DEADLINES soft=$SOFT_DEADLINE_UTC dead=$DEADMAN_UTC"
  echo STACK_UPLOAD_OK
  nohup bash /root/mining_src/s4-h122-f27-genesis-full-ft/bootstrap_h122.sh \
    >/root/logs/r5_pipeline.nohup 2>&1 &
  echo $! > /root/logs/r5_pipeline.pid
  cp -f /root/logs/r5_pipeline.pid /root/logs/h122_pipeline.pid
  nohup bash /root/mining_src/s4-h2-merge/watch_form_decision.sh h122 \
    /root/affine_data/h122_sim_result.json /root/affine_data/h122_decision.json \
    /root/logs/r5_form_decision.nohup \
    >/root/logs/r5_form_decision.launch.out 2>&1 &
  echo $! > /root/logs/r5_form_decision.pid
  echo PIPELINE_PID=$(cat /root/logs/r5_pipeline.pid)
  sleep 5
  head -n 40 /root/logs/bootstrap_h122.log 2>/dev/null || head -n 40 /root/logs/r5_pipeline.nohup || true
  ps -p "$(cat /root/logs/r5_pipeline.pid)" -o pid,etime,cmd || true
  nvidia-smi -L | wc -l
'

echo "UPLOAD_AND_LAUNCH_OK pod=$POD_NAME $(date -u +%Y-%m-%dT%H:%M:%SZ)"
