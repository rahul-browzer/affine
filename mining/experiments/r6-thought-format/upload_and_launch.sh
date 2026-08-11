#!/usr/bin/env bash
# Host → mine-r6-fmt-1: Tok-init LoRA on *natural* short-z (≠ H101 ultrashort rewrite).
# Reuses s4-h101-f6-short-format bootstrap/train/merge/n80 stack; overlays start + data.
set -euo pipefail

ROOT=/home/const/subnet120
POD_NAME=${POD_NAME:-mine-r6-fmt-1}
DST_HOST=${DST_HOST:?set DST_HOST}
DST_PORT=${DST_PORT:?set DST_PORT}
KNOWN=${KNOWN:-/tmp/${POD_NAME}.known_hosts}
SSH=(ssh -i "$HOME/.ssh/id_ed25519" -o UserKnownHostsFile="$KNOWN"
     -o StrictHostKeyChecking=accept-new -p "$DST_PORT" "root@$DST_HOST")
SCP=(scp -i "$HOME/.ssh/id_ed25519" -o UserKnownHostsFile="$KNOWN"
     -o StrictHostKeyChecking=accept-new -P "$DST_PORT")

STAGE=$(mktemp -d /tmp/mine-r6-stack.XXXXXX)
trap 'rm -rf "$STAGE"' EXIT

EXP=s4-h101-f6-short-format
mkdir -p "$STAGE/affine_pkg/affine" "$STAGE/affine_pkg/evalsrv" \
         "$STAGE/s3-duel-sim" "$STAGE/s4-h2-merge" "$STAGE/s4-h1-sft" \
         "$STAGE/s4-h1v2-sft" "$STAGE/$EXP" "$STAGE/r6-thought-format"

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
cp -a "$ROOT/mining/experiments/s4-h1-sft/merge_lora.py" "$STAGE/s4-h1-sft/"
cp -a "$ROOT/mining/experiments/s4-h1-sft/salvage_adapter.py" "$STAGE/s4-h1-sft/"
cp -a "$ROOT/mining/experiments/s4-h1-sft/push_merged.py" "$STAGE/s4-h1-sft/"
cp -a "$ROOT/mining/experiments/s4-h1v2-sft/train_lora.py" "$STAGE/s4-h1v2-sft/"
cp -a "$ROOT/mining/experiments/s4-h1v2-sft/thought_mask.py" "$STAGE/s4-h1v2-sft/"
cp -a "$ROOT/mining/experiments/s4-h1v2-sft/verify_thought_mask.py" "$STAGE/s4-h1v2-sft/"
cp -a "$ROOT/mining/experiments/$EXP/"*.sh "$STAGE/$EXP/"
cp -a "$ROOT/mining/experiments/$EXP/plan.md" "$STAGE/$EXP/"
cp -a "$ROOT/mining/experiments/r6-thought-format/plan.md" "$STAGE/r6-thought-format/"
cp -a "$ROOT/mining/experiments/r6-thought-format/start_r6.sh" "$STAGE/r6-thought-format/"
# Overlay: H101 bootstrap calls start_h101.sh — replace with R6 epochs=6 natural-short train.
cp -a "$ROOT/mining/experiments/r6-thought-format/start_r6.sh" "$STAGE/$EXP/start_h101.sh"

TAR=/tmp/mine-r6-stack.tar.gz
tar -C "$STAGE" -czf "$TAR" .
ls -lh "$TAR"

ENV_TMP=$(mktemp /tmp/mine-r6.env.XXXXXX)
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
  echo "export HF_MERGED_REPO=unconst/Affine-5czsc2fc98-r6-fmt"
  echo "export R6_AXIS=natural_short_nonlisty_zle180"
} >"$ENV_TMP"
chmod 600 "$ENV_TMP"

DATA="$ROOT/mining/experiments/r6-thought-format/results/za_short_natural.jsonl"
test -s "$DATA"
test "$(wc -l <"$DATA")" -ge 200

"${SSH[@]}" 'mkdir -p /root/mining_src /root/affine_data /root/logs /root/h101 /root/r6 /root/hf'
"${SCP[@]}" "$TAR" "root@${DST_HOST}:/tmp/mine-r6-stack.tar.gz"
"${SCP[@]}" "$ENV_TMP" "root@${DST_HOST}:/root/mine.env"
# H101 bootstrap expects this path; content is R6 natural-short (not ultrashort rewrite).
"${SCP[@]}" "$DATA" "root@${DST_HOST}:/root/h101/za_ultrashort80.jsonl"
"${SCP[@]}" "$DATA" "root@${DST_HOST}:/root/r6/za_short_natural.jsonl"
rm -f "$ENV_TMP"

python3 - <<'PY'
import os
from huggingface_hub import HfApi
api = HfApi(token=os.environ["HF_TOKEN"])
for repo in (
    "unconst/Affine-5czsc2fc98-r6-fmt",
    "unconst/Affine-5czsc2fc98-r6-fmt-lora",
):
    try:
        api.create_repo(repo, private=False, exist_ok=True, repo_type="model")
        print("HF_OK", repo)
    except Exception as e:
        print("HF_ERR", repo, type(e).__name__, e)
PY

"${SSH[@]}" 'set -e
  tar -C /root/mining_src -xzf /tmp/mine-r6-stack.tar.gz
  chmod 600 /root/mine.env
  chmod +x /root/mining_src/s3-duel-sim/*.sh \
           /root/mining_src/s4-h2-merge/*.sh \
           /root/mining_src/s4-h101-f6-short-format/*.sh \
           /root/mining_src/r6-thought-format/*.sh
  test -f /root/mining_src/affine_pkg/affine/score.py
  test -s /root/h101/za_ultrashort80.jsonl
  test -x /root/mining_src/s4-h101-f6-short-format/bootstrap_h101.sh
  set -a; source /root/mine.env; set +a
  echo "R6_DEADLINES soft=$SOFT_DEADLINE_UTC dead=$DEADMAN_UTC axis=$R6_AXIS"
  echo STACK_UPLOAD_OK
  nohup bash /root/mining_src/s4-h101-f6-short-format/bootstrap_h101.sh \
    >/root/logs/r6_pipeline.nohup 2>&1 &
  echo $! > /root/logs/r6_pipeline.pid
  cp -f /root/logs/r6_pipeline.pid /root/logs/h101_pipeline.pid
  nohup bash /root/mining_src/s4-h2-merge/watch_form_decision.sh h101 \
    /root/affine_data/h101_sim_result.json /root/affine_data/h101_decision.json \
    /root/logs/r6_form_decision.nohup \
    >/root/logs/r6_form_decision.launch.out 2>&1 &
  echo $! > /root/logs/r6_form_decision.pid
  echo PIPELINE_PID=$(cat /root/logs/r6_pipeline.pid)
  sleep 5
  head -n 40 /root/logs/bootstrap_h101.log 2>/dev/null || head -n 40 /root/logs/r6_pipeline.nohup || true
  ps -p "$(cat /root/logs/r6_pipeline.pid)" -o pid,etime,cmd || true
  nvidia-smi -L | wc -l
'

echo "UPLOAD_AND_LAUNCH_OK pod=$POD_NAME $(date -u +%Y-%m-%dT%H:%M:%SZ)"
