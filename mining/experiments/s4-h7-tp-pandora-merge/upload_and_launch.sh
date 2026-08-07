#!/usr/bin/env bash
# Host → mine-h7-1: upload harness + mine.env, start bootstrap+n80 under nohup.
set -euo pipefail

ROOT=/home/const/subnet120
DST_HOST=${DST_HOST:-152.236.142.232}
DST_PORT=${DST_PORT:-40299}
KNOWN=/tmp/mine-h7-1.known_hosts
SSH=(ssh -i "$HOME/.ssh/id_ed25519" -o UserKnownHostsFile="$KNOWN"
     -o StrictHostKeyChecking=accept-new -p "$DST_PORT" "root@$DST_HOST")
SCP=(scp -i "$HOME/.ssh/id_ed25519" -o UserKnownHostsFile="$KNOWN"
     -o StrictHostKeyChecking=accept-new -P "$DST_PORT")

STAGE=$(mktemp -d /tmp/mine-h7-stack.XXXXXX)
trap 'rm -rf "$STAGE"' EXIT

mkdir -p "$STAGE/affine_pkg/affine" "$STAGE/affine_pkg/evalsrv" \
         "$STAGE/s3-duel-sim" "$STAGE/s4-h2-merge" "$STAGE/s4-h7-tp-pandora-merge"

cp -a "$ROOT/affine/affine.toml" "$STAGE/affine_pkg/"
cp -a "$ROOT/affine/affine/." "$STAGE/affine_pkg/affine/"
cp -a "$ROOT/affine/evalsrv/." "$STAGE/affine_pkg/evalsrv/"
cp -a "$ROOT/mining/experiments/s3-duel-sim/"*.sh "$STAGE/s3-duel-sim/"
cp -a "$ROOT/mining/experiments/s3-duel-sim/"*.py "$STAGE/s3-duel-sim/" 2>/dev/null || true
cp -a "$ROOT/mining/experiments/s4-h2-merge/merge_linear.py" "$STAGE/s4-h2-merge/"
cp -a "$ROOT/mining/experiments/s4-h2-merge/run_sim_duel.py" "$STAGE/s4-h2-merge/"
cp -a "$ROOT/mining/experiments/s4-h2-merge/download_parents.sh" "$STAGE/s4-h2-merge/"
cp -a "$ROOT/mining/experiments/s4-h7-tp-pandora-merge/bootstrap_h7.sh" "$STAGE/s4-h7-tp-pandora-merge/"
cp -a "$ROOT/mining/experiments/s4-h7-tp-pandora-merge/start_h7_n80.sh" "$STAGE/s4-h7-tp-pandora-merge/"
cp -a "$ROOT/mining/experiments/s4-h7-tp-pandora-merge/plan.md" "$STAGE/s4-h7-tp-pandora-merge/"

TAR=/tmp/mine-h7-stack.tar.gz
tar -C "$STAGE" -czf "$TAR" .
ls -lh "$TAR"

# Build mine.env without printing secrets.
ENV_TMP=$(mktemp /tmp/mine-h7.env.XXXXXX)
# shellcheck disable=SC1091
set -a
source "$ROOT/mining/.env"
set +a
umask 077
{
  echo "HF_TOKEN=${HF_TOKEN}"
  echo "HF_HOME=/root/hf"
  echo "HF_HUB_ENABLE_HF_TRANSFER=1"
  echo "AFFINE_DATA_DIR=/root/affine_data"
} >"$ENV_TMP"
chmod 600 "$ENV_TMP"

"${SSH[@]}" 'mkdir -p /root/mining_src /root/affine_data /root/logs /root/merges /root/hf'
"${SCP[@]}" "$TAR" "root@${DST_HOST}:/tmp/mine-h7-stack.tar.gz"
"${SCP[@]}" "$ENV_TMP" "root@${DST_HOST}:/root/mine.env"
rm -f "$ENV_TMP"

"${SSH[@]}" 'set -e
  tar -C /root/mining_src -xzf /tmp/mine-h7-stack.tar.gz
  chmod 600 /root/mine.env
  chmod +x /root/mining_src/s3-duel-sim/*.sh \
           /root/mining_src/s4-h7-tp-pandora-merge/*.sh
  test -f /root/mining_src/affine_pkg/affine/score.py
  test -x /root/mining_src/s4-h7-tp-pandora-merge/bootstrap_h7.sh
  test -x /root/mining_src/s4-h7-tp-pandora-merge/start_h7_n80.sh
  echo STACK_UPLOAD_OK
  # Launch bootstrap → n80 chain under nohup (survives SSH).
  nohup bash -lc "
    set -euo pipefail
    bash /root/mining_src/s4-h7-tp-pandora-merge/bootstrap_h7.sh
    bash /root/mining_src/s4-h7-tp-pandora-merge/start_h7_n80.sh
  " >/root/logs/h7_pipeline.nohup 2>&1 &
  echo $! > /root/logs/h7_pipeline.pid
  echo PIPELINE_PID=$(cat /root/logs/h7_pipeline.pid)
  sleep 2
  head -n 20 /root/logs/h7_pipeline.nohup || true
  ps -p "$(cat /root/logs/h7_pipeline.pid)" -o pid,etime,cmd || true
'

echo "UPLOAD_AND_LAUNCH_OK $(date -u +%Y-%m-%dT%H:%M:%SZ)"
