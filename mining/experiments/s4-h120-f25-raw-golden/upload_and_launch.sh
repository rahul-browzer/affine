#!/usr/bin/env bash
# Host → mine-f25-1: upload lean stack (no train), start raw-golden bootstrap.
set -euo pipefail

ROOT=/home/const/subnet120
DST_HOST=${DST_HOST:?set DST_HOST}
DST_PORT=${DST_PORT:?set DST_PORT}
KNOWN=${KNOWN:-/tmp/mine-f25-1.known_hosts}
SSH=(ssh -i "$HOME/.ssh/id_ed25519" -o UserKnownHostsFile="$KNOWN"
     -o StrictHostKeyChecking=accept-new -p "$DST_PORT" "root@$DST_HOST")
SCP=(scp -i "$HOME/.ssh/id_ed25519" -o UserKnownHostsFile="$KNOWN"
     -o StrictHostKeyChecking=accept-new -P "$DST_PORT")

STAGE=$(mktemp -d /tmp/mine-h120-stack.XXXXXX)
trap 'rm -rf "$STAGE"' EXIT

EXP=s4-h120-f25-raw-golden
mkdir -p "$STAGE/affine_pkg/affine" "$STAGE/affine_pkg/evalsrv" \
         "$STAGE/s3-duel-sim" "$STAGE/s4-h2-merge" "$STAGE/$EXP"

cp -a "$ROOT/affine/affine.toml" "$STAGE/affine_pkg/"
cp -a "$ROOT/affine/affine/." "$STAGE/affine_pkg/affine/"
cp -a "$ROOT/affine/evalsrv/." "$STAGE/affine_pkg/evalsrv/"
cp -a "$ROOT/mining/experiments/s3-duel-sim/"*.sh "$STAGE/s3-duel-sim/"
cp -a "$ROOT/mining/experiments/s3-duel-sim/"*.py "$STAGE/s3-duel-sim/" 2>/dev/null || true
cp -a "$ROOT/mining/experiments/s4-h2-merge/run_sim_duel.py" "$STAGE/s4-h2-merge/"
cp -a "$ROOT/mining/experiments/s4-h2-merge/write_merge_decision.py" "$STAGE/s4-h2-merge/"
cp -a "$ROOT/mining/experiments/s4-h2-merge/watch_form_decision.sh" "$STAGE/s4-h2-merge/"
cp -a "$ROOT/mining/experiments/s4-h2-merge/watch_n80_retry.sh" "$STAGE/s4-h2-merge/"
cp -a "$ROOT/mining/experiments/$EXP/"*.sh "$STAGE/$EXP/"
cp -a "$ROOT/mining/experiments/$EXP/plan.md" "$STAGE/$EXP/"

TAR=/tmp/mine-h120-stack.tar.gz
tar -C "$STAGE" -czf "$TAR" .
ls -lh "$TAR"

ENV_TMP=$(mktemp /tmp/mine-h120.env.XXXXXX)
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

"${SSH[@]}" 'mkdir -p /root/mining_src /root/affine_data /root/logs /root/h120 /root/hf'
"${SCP[@]}" "$TAR" "root@${DST_HOST}:/tmp/mine-h120-stack.tar.gz"
"${SCP[@]}" "$ENV_TMP" "root@${DST_HOST}:/root/mine.env"
rm -f "$ENV_TMP"

"${SSH[@]}" 'set -e
  tar -C /root/mining_src -xzf /tmp/mine-h120-stack.tar.gz
  chmod 600 /root/mine.env
  chmod +x /root/mining_src/s3-duel-sim/*.sh \
           /root/mining_src/s4-h2-merge/*.sh \
           /root/mining_src/s4-h120-f25-raw-golden/*.sh
  test -f /root/mining_src/affine_pkg/affine/score.py
  test -x /root/mining_src/s4-h120-f25-raw-golden/bootstrap_h120.sh
  echo STACK_UPLOAD_OK
  nohup bash /root/mining_src/s4-h120-f25-raw-golden/bootstrap_h120.sh \
    >/root/logs/h120_pipeline.nohup 2>&1 &
  echo $! > /root/logs/h120_pipeline.pid
  nohup bash /root/mining_src/s4-h2-merge/watch_form_decision.sh h120 \
    /root/affine_data/h120_sim_result.json /root/affine_data/h120_decision.json \
    /root/logs/h120_form_decision.nohup \
    >/root/logs/h120_form_decision.launch.out 2>&1 &
  echo $! > /root/logs/h120_form_decision.pid
  nohup bash /root/mining_src/s4-h2-merge/watch_n80_retry.sh h120 \
    /root/mining_src/s4-h120-f25-raw-golden/retry_h120_n80_d203first.sh \
    >/root/logs/h120_watch_retry.launch.nohup 2>&1 &
  echo $! > /root/logs/h120_watch_retry.pid
  echo PIPELINE_PID=$(cat /root/logs/h120_pipeline.pid)
  sleep 3
  head -n 40 /root/logs/bootstrap_h120.log 2>/dev/null || head -n 40 /root/logs/h120_pipeline.nohup || true
  ps -p "$(cat /root/logs/h120_pipeline.pid)" -o pid,etime,cmd || true
  # COUNT=8 smoke
  nvidia-smi -L | wc -l
'

echo "UPLOAD_AND_LAUNCH_OK $(date -u +%Y-%m-%dT%H:%M:%SZ)"
