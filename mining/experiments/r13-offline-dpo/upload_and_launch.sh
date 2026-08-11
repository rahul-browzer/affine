#!/usr/bin/env bash
# Host → mine-r13-odpo-1: H138 offline-DPO stack + R13 Reason overlays, bootstrap.
# Axis R13: offline DPO on duel Reason prefs (≠ R3/R8/R11/R12).
set -euo pipefail

ROOT=/home/const/subnet120
POD_NAME=${POD_NAME:-mine-r13-odpo-1}
DST_HOST=${DST_HOST:?set DST_HOST}
DST_PORT=${DST_PORT:?set DST_PORT}
KNOWN=${KNOWN:-/tmp/${POD_NAME}.known_hosts}
SSH=(ssh -i "$HOME/.ssh/id_ed25519" -o UserKnownHostsFile="$KNOWN"
     -o StrictHostKeyChecking=accept-new -p "$DST_PORT" "root@$DST_HOST")
SCP=(scp -i "$HOME/.ssh/id_ed25519" -o UserKnownHostsFile="$KNOWN"
     -o StrictHostKeyChecking=accept-new -P "$DST_PORT")

STAGE=$(mktemp -d /tmp/mine-r13-stack.XXXXXX)
trap 'rm -rf "$STAGE"' EXIT

EXP=s4-h138-f43-tok-dpo-l2
mkdir -p "$STAGE/affine_pkg/affine" "$STAGE/affine_pkg/evalsrv" \
         "$STAGE/s3-duel-sim" "$STAGE/s4-h2-merge" "$STAGE/s4-h1-sft" \
         "$STAGE/s4-h1v2-sft" "$STAGE/$EXP" "$STAGE/r13-offline-dpo"

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
cp -a "$ROOT/mining/experiments/s4-h1v2-sft/thought_mask.py" "$STAGE/s4-h1v2-sft/" 2>/dev/null || true
cp -a "$ROOT/mining/experiments/s4-h1v2-sft/verify_thought_mask.py" "$STAGE/s4-h1v2-sft/" 2>/dev/null || true
cp -a "$ROOT/mining/experiments/$EXP/"*.sh "$STAGE/$EXP/"
cp -a "$ROOT/mining/experiments/$EXP/"*.py "$STAGE/$EXP/"
cp -a "$ROOT/mining/experiments/$EXP/plan.md" "$STAGE/$EXP/"
cp -a "$ROOT/mining/experiments/r13-offline-dpo/plan.md" "$STAGE/r13-offline-dpo/"
cp -a "$ROOT/mining/experiments/r13-offline-dpo/start_r13.sh" "$STAGE/r13-offline-dpo/"
cp -a "$ROOT/mining/experiments/r13-offline-dpo/bootstrap_r13.sh" "$STAGE/r13-offline-dpo/"
# Overlay: H138 bootstrap + start → R13 Reason offline-DPO.
cp -a "$ROOT/mining/experiments/r13-offline-dpo/start_r13.sh" "$STAGE/$EXP/start_h138.sh"
cp -a "$ROOT/mining/experiments/r13-offline-dpo/bootstrap_r13.sh" "$STAGE/$EXP/bootstrap_h138.sh"

SOFT=$(date -u -d '+23 hours' +%Y-%m-%dT%H:%M:%SZ)
DEAD=$(date -u -d '+23 hours 30 minutes' +%Y-%m-%dT%H:%M:%SZ)
export STAGE_EXP_POST="$STAGE/$EXP/post_train_pipeline.sh"
export SOFT
python3 - <<'PY'
from pathlib import Path
import re, os
soft = os.environ["SOFT"]
p = Path(os.environ["STAGE_EXP_POST"])
t = p.read_text()
t2, n = re.subn(
    r"SOFT_DEADLINE_UTC=\$\{SOFT_DEADLINE_UTC:-[^}]+\}",
    f"SOFT_DEADLINE_UTC=${{SOFT_DEADLINE_UTC:-{soft}}}",
    t,
    count=1,
)
if n != 1:
    print("SOFT_DEADLINE_PATTERN_MISS n=", n)
else:
    p.write_text(t2)
    print("SOFT_DEADLINE_SET", soft)
PY

TAR=/tmp/mine-r13-stack.tar.gz
tar -C "$STAGE" -czf "$TAR" .
ls -lh "$TAR"

ENV_TMP=$(mktemp /tmp/mine-r13.env.XXXXXX)
# shellcheck disable=SC1091
set -a
source "$ROOT/mining/.env"
set +a
umask 077
{
  echo "export HF_TOKEN=${HF_TOKEN}"
  echo "export HF_HOME=/root/hf"
  echo "export HF_HUB_ENABLE_HF_TRANSFER=1"
  echo "export HF_XET_HIGH_PERFORMANCE=1"
  echo "export AFFINE_DATA_DIR=/root/affine_data"
  echo "export SOFT_DEADLINE_UTC=${SOFT}"
  echo "export DEADMAN_UTC=${DEAD}"
  echo "export HF_MERGED_REPO=unconst/Affine-5czsc2fc98-r13-odpo"
  echo "export R13_AXIS=offline_dpo_reason"
  echo "export R13_LR=5e-6"
  echo "export R13_LORA_R=16"
  echo "export R13_LORA_ALPHA=32"
  echo "export R13_BETA=0.1"
  echo "export R13_MAX_STEPS=200"
} >"$ENV_TMP"
chmod 600 "$ENV_TMP"

DATA="$ROOT/mining/experiments/r13-offline-dpo/results/dpo_duel_reason.jsonl"
test -s "$DATA"
test "$(wc -l <"$DATA")" -ge 300

"${SSH[@]}" 'mkdir -p /root/mining_src /root/affine_data /root/logs /root/h138 /root/r13 /root/hf'
"${SCP[@]}" "$TAR" "root@${DST_HOST}:/tmp/mine-r13-stack.tar.gz"
"${SCP[@]}" "$ENV_TMP" "root@${DST_HOST}:/root/mine.env"
"${SCP[@]}" "$DATA" "root@${DST_HOST}:/root/h138/dpo_duel_reason.jsonl"
"${SCP[@]}" "$DATA" "root@${DST_HOST}:/root/h138/dpo_duel_l2.jsonl"
"${SCP[@]}" "$DATA" "root@${DST_HOST}:/root/r13/dpo_duel_reason.jsonl"
rm -f "$ENV_TMP"

python3 - <<'PY'
import os
from huggingface_hub import HfApi
api = HfApi(token=os.environ["HF_TOKEN"])
for repo in (
    "unconst/Affine-5czsc2fc98-r13-odpo",
    "unconst/Affine-5czsc2fc98-r13-odpo-lora",
):
    try:
        api.create_repo(repo, private=False, exist_ok=True, repo_type="model")
        print("HF_OK", repo)
    except Exception as e:
        print("HF_ERR", repo, type(e).__name__, e)
PY

"${SSH[@]}" 'set -e
  tar -C /root/mining_src -xzf /tmp/mine-r13-stack.tar.gz
  chmod 600 /root/mine.env
  chmod +x /root/mining_src/s3-duel-sim/*.sh \
           /root/mining_src/s4-h2-merge/*.sh \
           /root/mining_src/s4-h138-f43-tok-dpo-l2/*.sh \
           /root/mining_src/r13-offline-dpo/*.sh
  test -f /root/mining_src/affine_pkg/affine/score.py
  test -s /root/h138/dpo_duel_reason.jsonl
  test -x /root/mining_src/s4-h138-f43-tok-dpo-l2/bootstrap_h138.sh
  # Prove overlay is R13, not stock H138.
  grep -q "R13: offline-DPO" /root/mining_src/s4-h138-f43-tok-dpo-l2/start_h138.sh
  grep -q "DOWNLOAD tok-init" /root/mining_src/s4-h138-f43-tok-dpo-l2/bootstrap_h138.sh
  set -a; source /root/mine.env; set +a
  echo "R13_DEADLINES soft=$SOFT_DEADLINE_UTC dead=$DEADMAN_UTC axis=$R13_AXIS"
  echo STACK_UPLOAD_OK
  nohup bash /root/mining_src/s4-h138-f43-tok-dpo-l2/bootstrap_h138.sh \
    >/root/logs/r13_pipeline.nohup 2>&1 &
  echo $! > /root/logs/r13_pipeline.pid
  cp -f /root/logs/r13_pipeline.pid /root/logs/h138_pipeline.pid
  nohup bash /root/mining_src/s4-h2-merge/watch_form_decision.sh h138 \
    /root/affine_data/h138_sim_result.json /root/affine_data/h138_decision.json \
    /root/logs/r13_form_decision.nohup \
    >/root/logs/r13_form_decision.launch.out 2>&1 &
  echo $! > /root/logs/r13_form_decision.pid
  echo PIPELINE_PID=$(cat /root/logs/r13_pipeline.pid)
  sleep 5
  head -n 40 /root/logs/bootstrap_h138.log 2>/dev/null || head -n 40 /root/logs/r13_pipeline.nohup || true
  ps -p "$(cat /root/logs/r13_pipeline.pid)" -o pid,etime,cmd || true
  nvidia-smi -L | wc -l
'

echo "UPLOAD_AND_LAUNCH_OK pod=$POD_NAME $(date -u +%Y-%m-%dT%H:%M:%SZ)"
