#!/usr/bin/env bash
# Host → mine-r9-teacher-zc-1: H99 Tok-LoRA stack + expanded teacher z_C data.
# Axis R9: teacher-z_C format prior (≠ H102 Genesis-shortz, ≠ H123 fullFT-shortz, ≠ R1 winner_za).
set -euo pipefail

ROOT=/home/const/subnet120
POD_NAME=${POD_NAME:-mine-r9-teacher-zc-1}
DST_HOST=${DST_HOST:?set DST_HOST}
DST_PORT=${DST_PORT:?set DST_PORT}
KNOWN=${KNOWN:-/tmp/${POD_NAME}.known_hosts}
SSH=(ssh -i "$HOME/.ssh/id_ed25519" -o UserKnownHostsFile="$KNOWN"
     -o StrictHostKeyChecking=accept-new -p "$DST_PORT" "root@$DST_HOST")
SCP=(scp -i "$HOME/.ssh/id_ed25519" -o UserKnownHostsFile="$KNOWN"
     -o StrictHostKeyChecking=accept-new -P "$DST_PORT")

STAGE=$(mktemp -d /tmp/mine-r9-stack.XXXXXX)
trap 'rm -rf "$STAGE"' EXIT

EXP=s4-h99-f2-target-l2
mkdir -p "$STAGE/affine_pkg/affine" "$STAGE/affine_pkg/evalsrv" \
         "$STAGE/s3-duel-sim" "$STAGE/s4-h2-merge" "$STAGE/s4-h1-sft" \
         "$STAGE/s4-h1v2-sft" "$STAGE/$EXP" "$STAGE/r9-teacher-zc"

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
cp -a "$ROOT/mining/experiments/$EXP/plan.md" "$STAGE/$EXP/" 2>/dev/null || true
cp -a "$ROOT/mining/experiments/r9-teacher-zc/plan.md" "$STAGE/r9-teacher-zc/"
cp -a "$ROOT/mining/experiments/r9-teacher-zc/start_r9.sh" "$STAGE/r9-teacher-zc/"
# Overlay: H99 bootstrap calls start_h99.sh — replace with R9 expanded teacher-z_C train.
cp -a "$ROOT/mining/experiments/r9-teacher-zc/start_r9.sh" "$STAGE/$EXP/start_h99.sh"

TAR=/tmp/mine-r9-stack.tar.gz
tar -C "$STAGE" -czf "$TAR" .
ls -lh "$TAR"

ENV_TMP=$(mktemp /tmp/mine-r9.env.XXXXXX)
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
  echo "export HF_MERGED_REPO=unconst/Affine-5czsc2fc98-r9-teacher-zc"
  echo "export R9_AXIS=tok_lora_expanded_teacher_zc"
  echo "export EPOCHS=3"
  echo "export LR=1e-5"
  echo "export LORA_R=32"
  echo "export LORA_ALPHA=64"
  echo "export MAX_LEN=16384"
} >"$ENV_TMP"
chmod 600 "$ENV_TMP"

DATA="$ROOT/mining/experiments/s4-h5c-expand-refs/results/teacher_refs_expanded.jsonl"
test -s "$DATA"
test "$(wc -l <"$DATA")" -ge 1000

"${SSH[@]}" 'mkdir -p /root/mining_src /root/affine_data /root/logs /root/h99 /root/r9 /root/hf'
"${SCP[@]}" "$TAR" "root@${DST_HOST}:/tmp/mine-r9-stack.tar.gz"
"${SCP[@]}" "$ENV_TMP" "root@${DST_HOST}:/root/mine.env"
# H99 bootstrap expects this path/name; content is expanded teacher z_C.
"${SCP[@]}" "$DATA" "root@${DST_HOST}:/root/h99/winner_za_high_l2.jsonl"
"${SCP[@]}" "$DATA" "root@${DST_HOST}:/root/r9/teacher_refs_expanded.jsonl"
rm -f "$ENV_TMP"

python3 - <<'PY'
import os
from huggingface_hub import HfApi
api = HfApi(token=os.environ["HF_TOKEN"])
for repo in (
    "unconst/Affine-5czsc2fc98-r9-teacher-zc",
    "unconst/Affine-5czsc2fc98-r9-teacher-zc-lora",
):
    try:
        api.create_repo(repo, private=False, exist_ok=True, repo_type="model")
        print("HF_OK", repo)
    except Exception as e:
        print("HF_ERR", repo, type(e).__name__, e)
PY

"${SSH[@]}" 'set -e
  tar -C /root/mining_src -xzf /tmp/mine-r9-stack.tar.gz
  chmod 600 /root/mine.env
  chmod +x /root/mining_src/s3-duel-sim/*.sh \
           /root/mining_src/s4-h2-merge/*.sh \
           /root/mining_src/s4-h99-f2-target-l2/*.sh \
           /root/mining_src/r9-teacher-zc/*.sh
  test -f /root/mining_src/affine_pkg/affine/score.py
  test -s /root/h99/winner_za_high_l2.jsonl
  test -x /root/mining_src/s4-h99-f2-target-l2/bootstrap_h99.sh
  # Prove overlay is R9, not stock H99.
  grep -q "R9: Tok-init" /root/mining_src/s4-h99-f2-target-l2/start_h99.sh
  set -a; source /root/mine.env; set +a
  echo "R9_DEADLINES soft=$SOFT_DEADLINE_UTC dead=$DEADMAN_UTC axis=$R9_AXIS epochs=$EPOCHS r=$LORA_R"
  echo STACK_UPLOAD_OK
  nohup bash /root/mining_src/s4-h99-f2-target-l2/bootstrap_h99.sh \
    >/root/logs/r9_pipeline.nohup 2>&1 &
  echo $! > /root/logs/r9_pipeline.pid
  cp -f /root/logs/r9_pipeline.pid /root/logs/h99_pipeline.pid
  nohup bash /root/mining_src/s4-h2-merge/watch_form_decision.sh h99 \
    /root/affine_data/h99_sim_result.json /root/affine_data/h99_decision.json \
    /root/logs/r9_form_decision.nohup \
    >/root/logs/r9_form_decision.launch.out 2>&1 &
  echo $! > /root/logs/r9_form_decision.pid
  echo PIPELINE_PID=$(cat /root/logs/r9_pipeline.pid)
  sleep 5
  head -n 40 /root/logs/bootstrap_h99.log 2>/dev/null || head -n 40 /root/logs/r9_pipeline.nohup || true
  ps -p "$(cat /root/logs/r9_pipeline.pid)" -o pid,etime,cmd || true
  nvidia-smi -L | wc -l
'

echo "UPLOAD_AND_LAUNCH_OK pod=$POD_NAME $(date -u +%Y-%m-%dT%H:%M:%SZ)"
