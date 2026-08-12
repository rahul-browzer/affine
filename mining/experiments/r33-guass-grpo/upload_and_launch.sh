#!/usr/bin/env bash
# Host → mine-r33-guass-grpo-1: R3 stack + R33 Guass-GRPO overlays, bootstrap.
# Axis R33: guass-init Reason-GRPO (≠ R3 Tok, ≠ R19–R23 other parents).
# p2233: n80 king = live guass + Reason writer + form-dec.
set -euo pipefail

ROOT=/home/const/subnet120
POD_NAME=${POD_NAME:-mine-r33-guass-grpo-1}
DST_HOST=${DST_HOST:?set DST_HOST}
DST_PORT=${DST_PORT:?set DST_PORT}
KNOWN=${KNOWN:-/tmp/${POD_NAME}.known_hosts}
SSH=(ssh -i "$HOME/.ssh/id_ed25519" -o UserKnownHostsFile="$KNOWN"
     -o StrictHostKeyChecking=accept-new -p "$DST_PORT" "root@$DST_HOST")
SCP=(scp -i "$HOME/.ssh/id_ed25519" -o UserKnownHostsFile="$KNOWN"
     -o StrictHostKeyChecking=accept-new -P "$DST_PORT")

STAGE=$(mktemp -d /tmp/mine-r33-stack.XXXXXX)
trap 'rm -rf "$STAGE"' EXIT

EXP=r3-reason-grpo
mkdir -p "$STAGE/affine_pkg/affine" "$STAGE/affine_pkg/evalsrv" \
         "$STAGE/s3-duel-sim" "$STAGE/s4-h2-merge" "$STAGE/s4-h1-sft" \
         "$STAGE/s4-h1v2-sft" "$STAGE/r1-reason-distill" \
         "$STAGE/$EXP" "$STAGE/r33-guass-grpo"

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
# p2233: form-dec / post_train Reason crown writer.
cp -a "$ROOT/mining/experiments/r1-reason-distill/write_reason_decision.py" \
      "$STAGE/r1-reason-distill/"
cp -a "$ROOT/mining/experiments/r1-reason-distill/graft_visual_weights.py" \
      "$STAGE/r1-reason-distill/" 2>/dev/null || true
cp -a "$ROOT/mining/experiments/s4-h1-sft/merge_lora.py" "$STAGE/s4-h1-sft/"
cp -a "$ROOT/mining/experiments/s4-h1-sft/salvage_adapter.py" "$STAGE/s4-h1-sft/"
cp -a "$ROOT/mining/experiments/s4-h1-sft/push_merged.py" "$STAGE/s4-h1-sft/"
cp -a "$ROOT/mining/experiments/s4-h1v2-sft/thought_mask.py" "$STAGE/s4-h1v2-sft/" 2>/dev/null || true
cp -a "$ROOT/mining/experiments/$EXP/"*.sh "$STAGE/$EXP/"
cp -a "$ROOT/mining/experiments/$EXP/"*.py "$STAGE/$EXP/"
cp -a "$ROOT/mining/experiments/$EXP/plan.md" "$STAGE/$EXP/"
cp -a "$ROOT/mining/experiments/r33-guass-grpo/plan.md" "$STAGE/r33-guass-grpo/"
cp -a "$ROOT/mining/experiments/r33-guass-grpo/start_r33.sh" "$STAGE/r33-guass-grpo/"
cp -a "$ROOT/mining/experiments/r33-guass-grpo/bootstrap_r33.sh" "$STAGE/r33-guass-grpo/"
# Overlay: bootstrap_r3 + start_r3 → R33 Guass Reason-GRPO.
cp -a "$ROOT/mining/experiments/r33-guass-grpo/start_r33.sh" "$STAGE/$EXP/start_r3.sh"
cp -a "$ROOT/mining/experiments/r33-guass-grpo/bootstrap_r33.sh" "$STAGE/$EXP/bootstrap_r3.sh"

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

TAR=/tmp/mine-r33-stack.tar.gz
tar -C "$STAGE" -czf "$TAR" .
ls -lh "$TAR"
test -n "$(tar -tzf "$TAR" | grep 'r1-reason-distill/write_reason_decision.py' || true)"
grep -q "DOWNLOAD guass-init" "$STAGE/$EXP/bootstrap_r3.sh"
grep -q "R33: Guass-GRPO" "$STAGE/$EXP/start_r3.sh"

ENV_TMP=$(mktemp /tmp/mine-r33.env.XXXXXX)
# shellcheck disable=SC1091
set -a
source "$ROOT/mining/.env"
set +a
umask 077
KING_REPO_DEFAULT=ttttxxxxsada/Affine-5guassq3tu
KING_REV_DEFAULT=e86758f5080d1e373e5fbbd7b4fbf6af327aeb44
KING_LOCAL_DEFAULT=/root/hf/hub/models--ttttxxxxsada--Affine-5guassq3tu/snapshots/e86758f5080d1e373e5fbbd7b4fbf6af327aeb44
{
  echo "export HF_TOKEN=${HF_TOKEN}"
  echo "export HF_HOME=/root/hf"
  echo "export HF_HUB_ENABLE_HF_TRANSFER=1"
  echo "export HF_XET_HIGH_PERFORMANCE=1"
  echo "export AFFINE_DATA_DIR=/root/affine_data"
  echo "export SOFT_DEADLINE_UTC=${SOFT}"
  echo "export DEADMAN_UTC=${DEAD}"
  echo "export HF_LORA_REPO=unconst/Affine-5czsc2fc98-r33-lora"
  echo "export HF_MERGED_REPO=unconst/Affine-5czsc2fc98-r33-merged"
  echo "export R33_AXIS=guass_grpo_reason"
  echo "export R33_LR=5e-6"
  echo "export R33_LORA_R=16"
  echo "export R33_LORA_ALPHA=32"
  echo "export R33_GROUP_SIZE=4"
  echo "export R33_MAX_STEPS=200"
  echo "export KING_REPO=${KING_REPO_DEFAULT}"
  echo "export KING_REV=${KING_REV_DEFAULT}"
  echo "export KING_LOCAL=${KING_LOCAL_DEFAULT}"
  echo "export BASE=${KING_LOCAL_DEFAULT}"
  echo "export RESTART_KING=1"
} >"$ENV_TMP"
chmod 600 "$ENV_TMP"

DATA="$ROOT/mining/experiments/s4-h27-clip-l1-shape/results/winner_za_high_l1.jsonl"
test -s "$DATA"
test "$(wc -l <"$DATA")" -ge 300

"${SSH[@]}" 'mkdir -p /root/mining_src /root/affine_data /root/logs /root/r3 /root/r33 /root/hf'
"${SCP[@]}" "$TAR" "root@${DST_HOST}:/tmp/mine-r33-stack.tar.gz"
"${SCP[@]}" "$ENV_TMP" "root@${DST_HOST}:/root/mine.env"
"${SCP[@]}" "$DATA" "root@${DST_HOST}:/root/r3/winner_za_high_l1.jsonl"
"${SCP[@]}" "$DATA" "root@${DST_HOST}:/root/r33/winner_za_high_l1.jsonl"
rm -f "$ENV_TMP"

python3 - <<'PY'
import os
from huggingface_hub import HfApi
api = HfApi(token=os.environ["HF_TOKEN"])
for repo in (
    "unconst/Affine-5czsc2fc98-r33-lora",
    "unconst/Affine-5czsc2fc98-r33-merged",
):
    try:
        api.create_repo(repo, private=False, exist_ok=True, repo_type="model")
        print("HF_OK", repo)
    except Exception as e:
        print("HF_ERR", repo, type(e).__name__, e)
PY

"${SSH[@]}" 'set -e
  tar -C /root/mining_src -xzf /tmp/mine-r33-stack.tar.gz
  chmod 600 /root/mine.env
  chmod +x /root/mining_src/s3-duel-sim/*.sh \
           /root/mining_src/s4-h2-merge/*.sh \
           /root/mining_src/r3-reason-grpo/*.sh \
           /root/mining_src/r33-guass-grpo/*.sh
  test -f /root/mining_src/affine_pkg/affine/score.py
  test -s /root/r3/winner_za_high_l1.jsonl
  test -x /root/mining_src/r3-reason-grpo/bootstrap_r3.sh
  test -x /root/mining_src/r3-reason-grpo/start_r3.sh
  # Prove overlay is R33; sim king = guass; Reason writer present.
  grep -q "R33: Guass-GRPO" /root/mining_src/r3-reason-grpo/start_r3.sh
  grep -q "DOWNLOAD guass-init" /root/mining_src/r3-reason-grpo/bootstrap_r3.sh
  test -f /root/mining_src/r1-reason-distill/write_reason_decision.py
  set -a; source /root/mine.env; set +a
  test "$KING_REPO" = "ttttxxxxsada/Affine-5guassq3tu"
  echo "R33_DEADLINES soft=$SOFT_DEADLINE_UTC dead=$DEADMAN_UTC axis=$R33_AXIS king=$KING_REPO@$KING_REV"
  echo "R33_KNOBS lr=${R33_LR} r=${R33_LORA_R} G=${R33_GROUP_SIZE}"
  echo STACK_UPLOAD_OK
  nohup bash /root/mining_src/r3-reason-grpo/bootstrap_r3.sh \
    >/root/logs/r33_pipeline.nohup 2>&1 &
  echo $! > /root/logs/r33_pipeline.pid
  cp -f /root/logs/r33_pipeline.pid /root/logs/r3_pipeline.pid
  nohup bash /root/mining_src/s4-h2-merge/watch_form_decision.sh r3 \
    /root/affine_data/r3_sim_result.json /root/affine_data/r3_decision.json \
    /root/logs/r33_form_decision.nohup \
    >/root/logs/r33_form_decision.launch.out 2>&1 &
  echo $! > /root/logs/r33_form_decision.pid
  echo PIPELINE_PID=$(cat /root/logs/r33_pipeline.pid)
  sleep 5
  head -n 40 /root/logs/bootstrap_r3.log 2>/dev/null || head -n 40 /root/logs/r33_pipeline.nohup || true
  ps -p "$(cat /root/logs/r33_pipeline.pid)" -o pid,etime,cmd || true
  nvidia-smi -L | wc -l
'

echo "UPLOAD_AND_LAUNCH_OK pod=$POD_NAME $(date -u +%Y-%m-%dT%H:%M:%SZ)"
