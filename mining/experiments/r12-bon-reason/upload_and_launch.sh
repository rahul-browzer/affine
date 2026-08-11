#!/usr/bin/env bash
# Host → mine-r12-bon-1: H137 BoN stack + R12 Reason overlays, bootstrap.
# Axis R12: Best-of-N CE on live teacher Reason (≠ R3/R8/R11).
set -euo pipefail

ROOT=/home/const/subnet120
POD_NAME=${POD_NAME:-mine-r12-bon-1}
DST_HOST=${DST_HOST:?set DST_HOST}
DST_PORT=${DST_PORT:?set DST_PORT}
KNOWN=${KNOWN:-/tmp/${POD_NAME}.known_hosts}
SSH=(ssh -i "$HOME/.ssh/id_ed25519" -o UserKnownHostsFile="$KNOWN"
     -o StrictHostKeyChecking=accept-new -p "$DST_PORT" "root@$DST_HOST")
SCP=(scp -i "$HOME/.ssh/id_ed25519" -o UserKnownHostsFile="$KNOWN"
     -o StrictHostKeyChecking=accept-new -P "$DST_PORT")

STAGE=$(mktemp -d /tmp/mine-r12-stack.XXXXXX)
trap 'rm -rf "$STAGE"' EXIT

EXP=s4-h137-f42-tok-bon-l2
mkdir -p "$STAGE/affine_pkg/affine" "$STAGE/affine_pkg/evalsrv" \
         "$STAGE/s3-duel-sim" "$STAGE/s4-h2-merge" "$STAGE/s4-h1-sft" \
         "$STAGE/s4-h1v2-sft" "$STAGE/$EXP" "$STAGE/r12-bon-reason"

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
cp -a "$ROOT/mining/experiments/r12-bon-reason/plan.md" "$STAGE/r12-bon-reason/"
cp -a "$ROOT/mining/experiments/r12-bon-reason/start_r12.sh" "$STAGE/r12-bon-reason/"
cp -a "$ROOT/mining/experiments/r12-bon-reason/bootstrap_r12.sh" "$STAGE/r12-bon-reason/"
# Overlay: H137 bootstrap + start → R12 Reason BoN-CE.
cp -a "$ROOT/mining/experiments/r12-bon-reason/start_r12.sh" "$STAGE/$EXP/start_h137.sh"
cp -a "$ROOT/mining/experiments/r12-bon-reason/bootstrap_r12.sh" "$STAGE/$EXP/bootstrap_h137.sh"

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

TAR=/tmp/mine-r12-stack.tar.gz
tar -C "$STAGE" -czf "$TAR" .
ls -lh "$TAR"

ENV_TMP=$(mktemp /tmp/mine-r12.env.XXXXXX)
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
  echo "export HF_MERGED_REPO=unconst/Affine-5czsc2fc98-r12-bon"
  echo "export R12_AXIS=bon_reason"
  echo "export R12_LR=5e-6"
  echo "export R12_LORA_R=16"
  echo "export R12_LORA_ALPHA=32"
  echo "export R12_GROUP=4"
  echo "export R12_MAX_STEPS=150"
  echo "export R12_TEMP=0.8"
} >"$ENV_TMP"
chmod 600 "$ENV_TMP"

DATA="$ROOT/mining/experiments/s4-h27-clip-l1-shape/results/winner_za_high_l1.jsonl"
test -s "$DATA"
test "$(wc -l <"$DATA")" -ge 300

"${SSH[@]}" 'mkdir -p /root/mining_src /root/affine_data /root/logs /root/h137 /root/r12 /root/hf'
"${SCP[@]}" "$TAR" "root@${DST_HOST}:/tmp/mine-r12-stack.tar.gz"
"${SCP[@]}" "$ENV_TMP" "root@${DST_HOST}:/root/mine.env"
"${SCP[@]}" "$DATA" "root@${DST_HOST}:/root/h137/winner_za_high_l1.jsonl"
"${SCP[@]}" "$DATA" "root@${DST_HOST}:/root/r12/winner_za_high_l1.jsonl"
rm -f "$ENV_TMP"

python3 - <<'PY'
import os
from huggingface_hub import HfApi
api = HfApi(token=os.environ["HF_TOKEN"])
for repo in (
    "unconst/Affine-5czsc2fc98-r12-bon",
    "unconst/Affine-5czsc2fc98-r12-bon-lora",
):
    try:
        api.create_repo(repo, private=False, exist_ok=True, repo_type="model")
        print("HF_OK", repo)
    except Exception as e:
        print("HF_ERR", repo, type(e).__name__, e)
PY

"${SSH[@]}" 'set -e
  tar -C /root/mining_src -xzf /tmp/mine-r12-stack.tar.gz
  chmod 600 /root/mine.env
  chmod +x /root/mining_src/s3-duel-sim/*.sh \
           /root/mining_src/s4-h2-merge/*.sh \
           /root/mining_src/s4-h137-f42-tok-bon-l2/*.sh \
           /root/mining_src/r12-bon-reason/*.sh
  test -f /root/mining_src/affine_pkg/affine/score.py
  test -s /root/h137/winner_za_high_l1.jsonl
  test -x /root/mining_src/s4-h137-f42-tok-bon-l2/bootstrap_h137.sh
  # Prove overlay is R12, not stock H137.
  grep -q "R12: BoN-CE" /root/mining_src/s4-h137-f42-tok-bon-l2/start_h137.sh
  grep -q "DOWNLOAD tok-init" /root/mining_src/s4-h137-f42-tok-bon-l2/bootstrap_h137.sh
  set -a; source /root/mine.env; set +a
  echo "R12_DEADLINES soft=$SOFT_DEADLINE_UTC dead=$DEADMAN_UTC axis=$R12_AXIS"
  echo STACK_UPLOAD_OK
  nohup bash /root/mining_src/s4-h137-f42-tok-bon-l2/bootstrap_h137.sh \
    >/root/logs/r12_pipeline.nohup 2>&1 &
  echo $! > /root/logs/r12_pipeline.pid
  cp -f /root/logs/r12_pipeline.pid /root/logs/h137_pipeline.pid
  nohup bash /root/mining_src/s4-h2-merge/watch_form_decision.sh h137 \
    /root/affine_data/h137_sim_result.json /root/affine_data/h137_decision.json \
    /root/logs/r12_form_decision.nohup \
    >/root/logs/r12_form_decision.launch.out 2>&1 &
  echo $! > /root/logs/r12_form_decision.pid
  echo PIPELINE_PID=$(cat /root/logs/r12_pipeline.pid)
  sleep 5
  head -n 40 /root/logs/bootstrap_h137.log 2>/dev/null || head -n 40 /root/logs/r12_pipeline.nohup || true
  ps -p "$(cat /root/logs/r12_pipeline.pid)" -o pid,etime,cmd || true
  nvidia-smi -L | wc -l
'

echo "UPLOAD_AND_LAUNCH_OK pod=$POD_NAME $(date -u +%Y-%m-%dT%H:%M:%SZ)"
