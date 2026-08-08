#!/usr/bin/env bash
# Host → mine-h85-1: upload stack + data, start bootstrap under nohup.
set -euo pipefail

ROOT=/home/const/subnet120
DST_HOST=${DST_HOST:?set DST_HOST}
DST_PORT=${DST_PORT:?set DST_PORT}
KNOWN=${KNOWN:-/tmp/mine-h85-1.known_hosts}
SSH=(ssh -i "$HOME/.ssh/id_ed25519" -o UserKnownHostsFile="$KNOWN"
     -o StrictHostKeyChecking=accept-new -p "$DST_PORT" "root@$DST_HOST")
SCP=(scp -i "$HOME/.ssh/id_ed25519" -o UserKnownHostsFile="$KNOWN"
     -o StrictHostKeyChecking=accept-new -P "$DST_PORT")

STAGE=$(mktemp -d /tmp/mine-h85-stack.XXXXXX)
trap 'rm -rf "$STAGE"' EXIT

EXP=s4-h85-tok-winner-za-r27
mkdir -p "$STAGE/affine_pkg/affine" "$STAGE/affine_pkg/evalsrv" \
         "$STAGE/s3-duel-sim" "$STAGE/s4-h2-merge" "$STAGE/s4-h1-sft" \
         "$STAGE/s4-h1v2-sft" "$STAGE/$EXP"

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

TAR=/tmp/mine-h85-stack.tar.gz
tar -C "$STAGE" -czf "$TAR" .
ls -lh "$TAR"

ENV_TMP=$(mktemp /tmp/mine-h85.env.XXXXXX)
# shellcheck disable=SC1091
set -a
source "$ROOT/mining/.env"
set +a
umask 077
{
  echo "HF_TOKEN=${HF_TOKEN}"
  echo "HF_HOME=/root/hf"
  echo "HF_HUB_ENABLE_HF_TRANSFER=1"
  echo "HF_XET_HIGH_PERFORMANCE=1"
  echo "AFFINE_DATA_DIR=/root/affine_data"
} >"$ENV_TMP"
chmod 600 "$ENV_TMP"

# H85 data = H29 king-self harvest (686 ex); init = m7 (same as H28).
DATA="$ROOT/mining/experiments/s4-h27-clip-l1-shape/results/winner_za_high_l1.jsonl"
test -s "$DATA"
test "$(wc -l <"$DATA")" -ge 300

"${SSH[@]}" 'mkdir -p /root/mining_src /root/affine_data /root/logs /root/h85 /root/hf'
"${SCP[@]}" "$TAR" "root@${DST_HOST}:/tmp/mine-h85-stack.tar.gz"
"${SCP[@]}" "$ENV_TMP" "root@${DST_HOST}:/root/mine.env"
"${SCP[@]}" "$DATA" "root@${DST_HOST}:/root/h85/winner_za_high_l1.jsonl"
rm -f "$ENV_TMP"

# Create public HF salvage repos (host-side).
python3 - <<'PY'
import os
from huggingface_hub import HfApi
api = HfApi(token=os.environ["HF_TOKEN"])
for repo in (
    "unconst/Affine-5czsc2fc98-h85-lora",
    "unconst/Affine-5czsc2fc98-h85-merged",
):
    try:
        api.create_repo(repo, private=False, exist_ok=True, repo_type="model")
        print("HF_OK", repo)
    except Exception as e:
        print("HF_ERR", repo, type(e).__name__, e)
PY

"${SSH[@]}" 'set -e
  tar -C /root/mining_src -xzf /tmp/mine-h85-stack.tar.gz
  chmod 600 /root/mine.env
  chmod +x /root/mining_src/s3-duel-sim/*.sh \
           /root/mining_src/s4-h2-merge/*.sh \
           /root/mining_src/s4-h85-tok-winner-za-r27/*.sh
  test -f /root/mining_src/affine_pkg/affine/score.py
  test -s /root/h85/winner_za_high_l1.jsonl
  test -x /root/mining_src/s4-h85-tok-winner-za-r27/bootstrap_h85.sh
  echo STACK_UPLOAD_OK
  nohup bash /root/mining_src/s4-h85-tok-winner-za-r27/bootstrap_h85.sh \
    >/root/logs/h85_pipeline.nohup 2>&1 &
  echo $! > /root/logs/h85_pipeline.pid
  nohup bash /root/mining_src/s4-h2-merge/watch_form_decision.sh h85 \
    /root/affine_data/h85_sim_result.json /root/affine_data/h85_decision.json \
    /root/logs/h85_form_decision.nohup \
    >/root/logs/h85_form_decision.launch.out 2>&1 &
  echo $! > /root/logs/h85_form_decision.pid
  nohup bash /root/mining_src/s4-h2-merge/watch_n80_retry.sh h85 \
    /root/mining_src/s4-h85-tok-winner-za-r27/retry_h85_n80.sh \
    >/root/logs/h85_watch_retry.launch.nohup 2>&1 &
  echo $! > /root/logs/h85_watch_retry.pid
  nohup bash /root/mining_src/s4-h85-tok-winner-za-r27/watch_preempt_bare_tcache_pass264.sh \
    >/root/logs/h85_preempt_bare_pass264.launch.nohup 2>&1 &
  echo $! > /root/logs/h85_preempt_bare_pass264.pid
  echo PREEMPT_PID=$(cat /root/logs/h85_preempt_bare_pass264.pid)
  echo PIPELINE_PID=$(cat /root/logs/h85_pipeline.pid)
  sleep 3
  head -n 40 /root/logs/bootstrap_h85.log 2>/dev/null || head -n 40 /root/logs/h85_pipeline.nohup || true
  ps -p "$(cat /root/logs/h85_pipeline.pid)" -o pid,etime,cmd || true
'

echo "UPLOAD_AND_LAUNCH_OK $(date -u +%Y-%m-%dT%H:%M:%SZ)"
