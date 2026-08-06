#!/usr/bin/env bash
# From validator host: pack scoring code + upload to mine-sim-1.
# Read-only copies of affine/; never modifies the validator tree.
set -euo pipefail

ROOT=/home/const/subnet120
DST_HOST=${DST_HOST:-69.63.236.160}
DST_PORT=${DST_PORT:-40301}
KNOWN=/tmp/mine-sim-1.known_hosts
SSH=(ssh -i "$HOME/.ssh/id_ed25519" -o UserKnownHostsFile="$KNOWN"
     -o StrictHostKeyChecking=accept-new -p "$DST_PORT" "root@$DST_HOST")
SCP=(scp -i "$HOME/.ssh/id_ed25519" -o UserKnownHostsFile="$KNOWN"
     -o StrictHostKeyChecking=accept-new -P "$DST_PORT")

STAGE=$(mktemp -d /tmp/mine-harness.XXXXXX)
trap 'rm -rf "$STAGE"' EXIT

mkdir -p "$STAGE/affine_pkg/affine" "$STAGE/affine_pkg/evalsrv" \
         "$STAGE/s3-duel-sim" "$STAGE/data"

cp -a "$ROOT/affine/affine.toml" "$STAGE/affine_pkg/"
cp -a "$ROOT/affine/affine/." "$STAGE/affine_pkg/affine/"
cp -a "$ROOT/affine/evalsrv/." "$STAGE/affine_pkg/evalsrv/"
cp -a "$ROOT/mining/experiments/s3-duel-sim/"*.sh "$STAGE/s3-duel-sim/"
cp -a "$ROOT/mining/experiments/s3-duel-sim/"*.py "$STAGE/s3-duel-sim/" 2>/dev/null || true
cp -a "$ROOT/mining/experiments/s3-duel-sim/plan.md" "$STAGE/s3-duel-sim/"
cp -a "$ROOT/mining/experiments/s1-replay-chal00224/chal-00224.json.gz" "$STAGE/data/"

TAR=/tmp/mine-s3-harness.tar.gz
tar -C "$STAGE" -czf "$TAR" .
ls -lh "$TAR"

"${SSH[@]}" 'mkdir -p /root/mining_src /root/affine_data'
"${SCP[@]}" "$TAR" "root@${DST_HOST}:/tmp/mine-s3-harness.tar.gz"
"${SSH[@]}" 'set -e
  rm -rf /root/mining_src/affine_pkg /root/mining_src/s3-duel-sim
  tar -C /root/mining_src -xzf /tmp/mine-s3-harness.tar.gz
  mv /root/mining_src/data/chal-00224.json.gz /root/affine_data/
  rmdir /root/mining_src/data 2>/dev/null || true
  chmod +x /root/mining_src/s3-duel-sim/*.sh /root/mining_src/s3-duel-sim/*.py
  test -f /root/mining_src/affine_pkg/affine/score.py
  test -f /root/mining_src/affine_pkg/evalsrv/dueling.py
  test -f /root/mining_src/s3-duel-sim/serve_three.sh
  test -f /root/mining_src/s3-duel-sim/run_gate.py
  test -f /root/mining_src/s3-duel-sim/sync_corpus.sh
  test -f /root/affine_data/chal-00224.json.gz
  echo HARNESS_UPLOAD_OK
  ls -la /root/mining_src/affine_pkg /root/mining_src/s3-duel-sim /root/affine_data'

rm -f "$TAR"
echo "[upload] done"
