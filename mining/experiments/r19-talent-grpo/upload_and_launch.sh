#!/usr/bin/env bash
# Host → mine-r19-talent-grpo-1: R3 stack + R19 Talent-GRPO overlays, bootstrap.
# Axis R19: TalentPigs-init Reason-GRPO (≠ R3 Tok, ≠ R5b Talent FT, ≠ R18 sbs).
set -euo pipefail

ROOT=/home/const/subnet120
POD_NAME=${POD_NAME:-mine-r19-talent-grpo-1}
DST_HOST=${DST_HOST:?set DST_HOST}
DST_PORT=${DST_PORT:?set DST_PORT}
KNOWN=${KNOWN:-/tmp/${POD_NAME}.known_hosts}
SSH=(ssh -i "$HOME/.ssh/id_ed25519" -o UserKnownHostsFile="$KNOWN"
     -o StrictHostKeyChecking=accept-new -p "$DST_PORT" "root@$DST_HOST")
SCP=(scp -i "$HOME/.ssh/id_ed25519" -o UserKnownHostsFile="$KNOWN"
     -o StrictHostKeyChecking=accept-new -P "$DST_PORT")

STAGE=$(mktemp -d /tmp/mine-r19-stack.XXXXXX)
trap 'rm -rf "$STAGE"' EXIT

EXP=r3-reason-grpo
mkdir -p "$STAGE/affine_pkg/affine" "$STAGE/affine_pkg/evalsrv" \
         "$STAGE/s3-duel-sim" "$STAGE/s4-h2-merge" "$STAGE/s4-h1-sft" \
         "$STAGE/s4-h1v2-sft" "$STAGE/$EXP" "$STAGE/r19-talent-grpo"

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
cp -a "$ROOT/mining/experiments/$EXP/"*.sh "$STAGE/$EXP/"
cp -a "$ROOT/mining/experiments/$EXP/"*.py "$STAGE/$EXP/"
cp -a "$ROOT/mining/experiments/$EXP/plan.md" "$STAGE/$EXP/"
cp -a "$ROOT/mining/experiments/r19-talent-grpo/plan.md" "$STAGE/r19-talent-grpo/"
cp -a "$ROOT/mining/experiments/r19-talent-grpo/start_r19.sh" "$STAGE/r19-talent-grpo/"
cp -a "$ROOT/mining/experiments/r19-talent-grpo/bootstrap_r19.sh" "$STAGE/r19-talent-grpo/"
# Overlay: bootstrap_r3 + start_r3 → R19 Talent Reason-GRPO.
cp -a "$ROOT/mining/experiments/r19-talent-grpo/start_r19.sh" "$STAGE/$EXP/start_r3.sh"
cp -a "$ROOT/mining/experiments/r19-talent-grpo/bootstrap_r19.sh" "$STAGE/$EXP/bootstrap_r3.sh"

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

TAR=/tmp/mine-r19-stack.tar.gz
tar -C "$STAGE" -czf "$TAR" .
ls -lh "$TAR"

ENV_TMP=$(mktemp /tmp/mine-r19.env.XXXXXX)
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
  echo "export HF_LORA_REPO=unconst/Affine-5czsc2fc98-r19-lora"
  echo "export HF_MERGED_REPO=unconst/Affine-5czsc2fc98-r19-merged"
  echo "export R19_AXIS=talent_grpo_reason"
  echo "export R19_LR=5e-6"
  echo "export R19_LORA_R=16"
  echo "export R19_LORA_ALPHA=32"
  echo "export R19_GROUP_SIZE=4"
  echo "export R19_MAX_STEPS=200"
} >"$ENV_TMP"
chmod 600 "$ENV_TMP"

DATA="$ROOT/mining/experiments/s4-h27-clip-l1-shape/results/winner_za_high_l1.jsonl"
test -s "$DATA"
test "$(wc -l <"$DATA")" -ge 300

"${SSH[@]}" 'mkdir -p /root/mining_src /root/affine_data /root/logs /root/r3 /root/r19 /root/hf'
"${SCP[@]}" "$TAR" "root@${DST_HOST}:/tmp/mine-r19-stack.tar.gz"
"${SCP[@]}" "$ENV_TMP" "root@${DST_HOST}:/root/mine.env"
"${SCP[@]}" "$DATA" "root@${DST_HOST}:/root/r3/winner_za_high_l1.jsonl"
"${SCP[@]}" "$DATA" "root@${DST_HOST}:/root/r19/winner_za_high_l1.jsonl"
rm -f "$ENV_TMP"

python3 - <<'PY'
import os
from huggingface_hub import HfApi
api = HfApi(token=os.environ["HF_TOKEN"])
for repo in (
    "unconst/Affine-5czsc2fc98-r19-lora",
    "unconst/Affine-5czsc2fc98-r19-merged",
):
    try:
        api.create_repo(repo, private=False, exist_ok=True, repo_type="model")
        print("HF_OK", repo)
    except Exception as e:
        print("HF_ERR", repo, type(e).__name__, e)
PY

"${SSH[@]}" 'set -e
  tar -C /root/mining_src -xzf /tmp/mine-r19-stack.tar.gz
  chmod 600 /root/mine.env
  chmod +x /root/mining_src/s3-duel-sim/*.sh \
           /root/mining_src/s4-h2-merge/*.sh \
           /root/mining_src/r3-reason-grpo/*.sh \
           /root/mining_src/r19-talent-grpo/*.sh
  test -f /root/mining_src/affine_pkg/affine/score.py
  test -s /root/r3/winner_za_high_l1.jsonl
  test -x /root/mining_src/r3-reason-grpo/bootstrap_r3.sh
  test -x /root/mining_src/r3-reason-grpo/start_r3.sh
  # Prove overlay is R19, not stock R3 / R18.
  grep -q "R19: Talent-GRPO" /root/mining_src/r3-reason-grpo/start_r3.sh
  grep -q "DOWNLOAD talent-init" /root/mining_src/r3-reason-grpo/bootstrap_r3.sh
  set -a; source /root/mine.env; set +a
  echo "R19_DEADLINES soft=$SOFT_DEADLINE_UTC dead=$DEADMAN_UTC axis=$R19_AXIS"
  echo "R19_KNOBS lr=${R19_LR} r=${R19_LORA_R} G=${R19_GROUP_SIZE}"
  echo STACK_UPLOAD_OK
  nohup bash /root/mining_src/r3-reason-grpo/bootstrap_r3.sh \
    >/root/logs/r19_pipeline.nohup 2>&1 &
  echo $! > /root/logs/r19_pipeline.pid
  cp -f /root/logs/r19_pipeline.pid /root/logs/r3_pipeline.pid
  echo PIPELINE_PID=$(cat /root/logs/r19_pipeline.pid)
  sleep 5
  head -n 40 /root/logs/bootstrap_r3.log 2>/dev/null || head -n 40 /root/logs/r19_pipeline.nohup || true
  ps -p "$(cat /root/logs/r19_pipeline.pid)" -o pid,etime,cmd || true
  nvidia-smi -L | wc -l
'

echo "UPLOAD_AND_LAUNCH_OK pod=$POD_NAME $(date -u +%Y-%m-%dT%H:%M:%SZ)"
