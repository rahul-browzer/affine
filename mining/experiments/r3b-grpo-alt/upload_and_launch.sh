#!/usr/bin/env bash
# Host → mine-r3-grpo-2: R3 stack + R3b alt-LR/rank overlay, start bootstrap.
# Axis R3b: GRPO lr=2e-5 r=64 G=8 (≠ R3 lr=5e-6 r=16 G=4).
set -euo pipefail

ROOT=/home/const/subnet120
POD_NAME=${POD_NAME:-mine-r3-grpo-2}
DST_HOST=${DST_HOST:?set DST_HOST}
DST_PORT=${DST_PORT:?set DST_PORT}
KNOWN=${KNOWN:-/tmp/${POD_NAME}.known_hosts}
SSH=(ssh -i "$HOME/.ssh/id_ed25519" -o UserKnownHostsFile="$KNOWN"
     -o StrictHostKeyChecking=accept-new -p "$DST_PORT" "root@$DST_HOST")
SCP=(scp -i "$HOME/.ssh/id_ed25519" -o UserKnownHostsFile="$KNOWN"
     -o StrictHostKeyChecking=accept-new -P "$DST_PORT")

STAGE=$(mktemp -d /tmp/mine-r3b-stack.XXXXXX)
trap 'rm -rf "$STAGE"' EXIT

EXP=r3-reason-grpo
mkdir -p "$STAGE/affine_pkg/affine" "$STAGE/affine_pkg/evalsrv" \
         "$STAGE/s3-duel-sim" "$STAGE/s4-h2-merge" "$STAGE/s4-h1-sft" \
         "$STAGE/s4-h1v2-sft" "$STAGE/$EXP" "$STAGE/r3b-grpo-alt"

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
cp -a "$ROOT/mining/experiments/s4-h1v2-sft/train_lora.py" "$STAGE/s4-h1v2-sft/" 2>/dev/null || true
cp -a "$ROOT/mining/experiments/s4-h1v2-sft/thought_mask.py" "$STAGE/s4-h1v2-sft/" 2>/dev/null || true
cp -a "$ROOT/mining/experiments/$EXP/"*.sh "$STAGE/$EXP/"
cp -a "$ROOT/mining/experiments/$EXP/"*.py "$STAGE/$EXP/"
cp -a "$ROOT/mining/experiments/$EXP/plan.md" "$STAGE/$EXP/"
cp -a "$ROOT/mining/experiments/r3b-grpo-alt/plan.md" "$STAGE/r3b-grpo-alt/"
cp -a "$ROOT/mining/experiments/r3b-grpo-alt/start_r3b.sh" "$STAGE/r3b-grpo-alt/"
# Overlay: bootstrap_r3 calls start_r3.sh — replace with R3b knobs.
cp -a "$ROOT/mining/experiments/r3b-grpo-alt/start_r3b.sh" "$STAGE/$EXP/start_r3.sh"

TAR=/tmp/mine-r3b-stack.tar.gz
tar -C "$STAGE" -czf "$TAR" .
ls -lh "$TAR"

ENV_TMP=$(mktemp /tmp/mine-r3b.env.XXXXXX)
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
  echo "export HF_LORA_REPO=unconst/Affine-5czsc2fc98-r3b-lora"
  echo "export HF_MERGED_REPO=unconst/Affine-5czsc2fc98-r3b-merged"
  echo "export R3B_AXIS=grpo_alt_lr2e5_r64_g8"
  echo "export R3B_LR=2e-5"
  echo "export R3B_LORA_R=64"
  echo "export R3B_LORA_ALPHA=128"
  echo "export R3B_GROUP_SIZE=8"
  echo "export R3B_MAX_STEPS=200"
} >"$ENV_TMP"
chmod 600 "$ENV_TMP"

DATA="$ROOT/mining/experiments/s4-h27-clip-l1-shape/results/winner_za_high_l1.jsonl"
test -s "$DATA"
test "$(wc -l <"$DATA")" -ge 300

"${SSH[@]}" 'mkdir -p /root/mining_src /root/affine_data /root/logs /root/r3 /root/r3b /root/hf'
"${SCP[@]}" "$TAR" "root@${DST_HOST}:/tmp/mine-r3b-stack.tar.gz"
"${SCP[@]}" "$ENV_TMP" "root@${DST_HOST}:/root/mine.env"
"${SCP[@]}" "$DATA" "root@${DST_HOST}:/root/r3/winner_za_high_l1.jsonl"
"${SCP[@]}" "$DATA" "root@${DST_HOST}:/root/r3b/winner_za_high_l1.jsonl"
rm -f "$ENV_TMP"

python3 - <<'PY'
import os
from huggingface_hub import HfApi
api = HfApi(token=os.environ["HF_TOKEN"])
for repo in (
    "unconst/Affine-5czsc2fc98-r3b-lora",
    "unconst/Affine-5czsc2fc98-r3b-merged",
):
    try:
        api.create_repo(repo, private=False, exist_ok=True, repo_type="model")
        print("HF_OK", repo)
    except Exception as e:
        print("HF_ERR", repo, type(e).__name__, e)
PY

"${SSH[@]}" 'set -e
  tar -C /root/mining_src -xzf /tmp/mine-r3b-stack.tar.gz
  chmod 600 /root/mine.env
  chmod +x /root/mining_src/s3-duel-sim/*.sh \
           /root/mining_src/s4-h2-merge/*.sh \
           /root/mining_src/r3-reason-grpo/*.sh \
           /root/mining_src/r3b-grpo-alt/*.sh
  test -f /root/mining_src/affine_pkg/affine/score.py
  test -s /root/r3/winner_za_high_l1.jsonl
  test -x /root/mining_src/r3-reason-grpo/bootstrap_r3.sh
  test -x /root/mining_src/r3-reason-grpo/start_r3.sh
  grep -q "R3b" /root/mining_src/r3-reason-grpo/start_r3.sh
  set -a; source /root/mine.env; set +a
  echo "R3B_DEADLINES soft=$SOFT_DEADLINE_UTC dead=$DEADMAN_UTC"
  echo "R3B_KNOBS lr=${R3B_LR} r=${R3B_LORA_R} G=${R3B_GROUP_SIZE}"
  echo STACK_UPLOAD_OK
  nohup bash /root/mining_src/r3-reason-grpo/bootstrap_r3.sh \
    >/root/logs/r3b_pipeline.nohup 2>&1 &
  echo $! > /root/logs/r3b_pipeline.pid
  cp -f /root/logs/r3b_pipeline.pid /root/logs/r3_pipeline.pid
  echo PIPELINE_PID=$(cat /root/logs/r3b_pipeline.pid)
  sleep 5
  head -n 40 /root/logs/bootstrap_r3.log 2>/dev/null || head -n 40 /root/logs/r3b_pipeline.nohup || true
  ps -p "$(cat /root/logs/r3b_pipeline.pid)" -o pid,etime,cmd || true
  nvidia-smi -L | wc -l
'

echo "UPLOAD_AND_LAUNCH_OK pod=$POD_NAME $(date -u +%Y-%m-%dT%H:%M:%SZ)"
