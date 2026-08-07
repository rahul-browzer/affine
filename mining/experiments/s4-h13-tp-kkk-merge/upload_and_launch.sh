#!/usr/bin/env bash
# Host → mine-h13-1: upload harness + mine.env, start bootstrap+n80 under nohup.
set -euo pipefail

ROOT=/home/const/subnet120
DST_HOST=${DST_HOST:?set DST_HOST}
DST_PORT=${DST_PORT:?set DST_PORT}
KNOWN=${KNOWN:-/tmp/mine-h13-1.known_hosts}
SSH=(ssh -i "$HOME/.ssh/id_ed25519" -o UserKnownHostsFile="$KNOWN"
     -o StrictHostKeyChecking=accept-new -p "$DST_PORT" "root@$DST_HOST")
SCP=(scp -i "$HOME/.ssh/id_ed25519" -o UserKnownHostsFile="$KNOWN"
     -o StrictHostKeyChecking=accept-new -P "$DST_PORT")

STAGE=$(mktemp -d /tmp/mine-h13-stack.XXXXXX)
trap 'rm -rf "$STAGE"' EXIT

mkdir -p "$STAGE/affine_pkg/affine" "$STAGE/affine_pkg/evalsrv" \
         "$STAGE/s3-duel-sim" "$STAGE/s4-h2-merge" "$STAGE/s4-h13-tp-kkk-merge"

cp -a "$ROOT/affine/affine.toml" "$STAGE/affine_pkg/"
cp -a "$ROOT/affine/affine/." "$STAGE/affine_pkg/affine/"
cp -a "$ROOT/affine/evalsrv/." "$STAGE/affine_pkg/evalsrv/"
cp -a "$ROOT/mining/experiments/s3-duel-sim/"*.sh "$STAGE/s3-duel-sim/"
cp -a "$ROOT/mining/experiments/s3-duel-sim/"*.py "$STAGE/s3-duel-sim/" 2>/dev/null || true
cp -a "$ROOT/mining/experiments/s4-h2-merge/merge_linear.py" "$STAGE/s4-h2-merge/"
cp -a "$ROOT/mining/experiments/s4-h2-merge/run_sim_duel.py" "$STAGE/s4-h2-merge/"
cp -a "$ROOT/mining/experiments/s4-h2-merge/write_merge_decision.py" "$STAGE/s4-h2-merge/"
cp -a "$ROOT/mining/experiments/s4-h2-merge/watch_fix_decision.sh" "$STAGE/s4-h2-merge/"
cp -a "$ROOT/mining/experiments/s4-h2-merge/watch_n80_retry.sh" "$STAGE/s4-h2-merge/"
cp -a "$ROOT/mining/experiments/s4-h2-merge/download_parents.sh" "$STAGE/s4-h2-merge/" 2>/dev/null || true
cp -a "$ROOT/mining/experiments/s4-h13-tp-kkk-merge/bootstrap_h13.sh" "$STAGE/s4-h13-tp-kkk-merge/"
cp -a "$ROOT/mining/experiments/s4-h13-tp-kkk-merge/start_h13_n80.sh" "$STAGE/s4-h13-tp-kkk-merge/"
cp -a "$ROOT/mining/experiments/s4-h13-tp-kkk-merge/retry_h13_n80.sh" "$STAGE/s4-h13-tp-kkk-merge/"
cp -a "$ROOT/mining/experiments/s4-h13-tp-kkk-merge/plan.md" "$STAGE/s4-h13-tp-kkk-merge/"

TAR=/tmp/mine-h13-stack.tar.gz
tar -C "$STAGE" -czf "$TAR" .
ls -lh "$TAR"

ENV_TMP=$(mktemp /tmp/mine-h13.env.XXXXXX)
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
"${SCP[@]}" "$TAR" "root@${DST_HOST}:/tmp/mine-h13-stack.tar.gz"
"${SCP[@]}" "$ENV_TMP" "root@${DST_HOST}:/root/mine.env"
rm -f "$ENV_TMP"

"${SSH[@]}" 'set -e
  tar -C /root/mining_src -xzf /tmp/mine-h13-stack.tar.gz
  chmod 600 /root/mine.env
  chmod +x /root/mining_src/s3-duel-sim/*.sh \
           /root/mining_src/s4-h2-merge/watch_fix_decision.sh \
           /root/mining_src/s4-h2-merge/watch_n80_retry.sh \
           /root/mining_src/s4-h13-tp-kkk-merge/*.sh
  test -f /root/mining_src/affine_pkg/affine/score.py
  test -x /root/mining_src/s4-h13-tp-kkk-merge/bootstrap_h13.sh
  test -x /root/mining_src/s4-h13-tp-kkk-merge/start_h13_n80.sh
  test -x /root/mining_src/s4-h13-tp-kkk-merge/retry_h13_n80.sh
  echo STACK_UPLOAD_OK
  nohup bash -lc "
    set -euo pipefail
    bash /root/mining_src/s4-h13-tp-kkk-merge/bootstrap_h13.sh
    bash /root/mining_src/s4-h13-tp-kkk-merge/start_h13_n80.sh
  " >/root/logs/h13_pipeline.nohup 2>&1 &
  echo $! > /root/logs/h13_pipeline.pid
  nohup bash /root/mining_src/s4-h2-merge/watch_fix_decision.sh h13 \
    >/root/logs/h13_fix_decision.nohup 2>&1 &
  echo $! > /root/logs/h13_fix_decision.pid
  nohup bash /root/mining_src/s4-h2-merge/watch_n80_retry.sh h13 \
    /root/mining_src/s4-h13-tp-kkk-merge/retry_h13_n80.sh \
    >/root/logs/h13_watch_retry.nohup 2>&1 &
  echo $! > /root/logs/h13_watch_retry.pid
  echo PIPELINE_PID=$(cat /root/logs/h13_pipeline.pid)
  sleep 2
  head -n 20 /root/logs/h13_pipeline.nohup || true
  ps -p "$(cat /root/logs/h13_pipeline.pid)" -o pid,etime,cmd || true
'

echo "UPLOAD_AND_LAUNCH_OK $(date -u +%Y-%m-%dT%H:%M:%SZ)"
