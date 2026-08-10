#!/usr/bin/env bash
# Host → mine-crown-1: upload read-only affine scoring pkg + Reason sim.
# Does not touch validator tree; copies only.
set -euo pipefail

ROOT=/home/const/subnet120
DST_HOST=${DST_HOST:-86.38.182.50}
DST_PORT=${DST_PORT:-40300}
KNOWN=${KNOWN:-/tmp/mine-crown-1.known_hosts}
SSH=(ssh -i "$HOME/.ssh/id_ed25519" -o UserKnownHostsFile="$KNOWN"
     -o StrictHostKeyChecking=accept-new -p "$DST_PORT" "root@$DST_HOST")
SCP=(scp -i "$HOME/.ssh/id_ed25519" -o UserKnownHostsFile="$KNOWN"
     -o StrictHostKeyChecking=accept-new -P "$DST_PORT")

STAGE=$(mktemp -d /tmp/mine-r1-harness.XXXXXX)
trap 'rm -rf "$STAGE"' EXIT

mkdir -p "$STAGE/affine_pkg/affine" "$STAGE/affine_pkg/evalsrv" \
         "$STAGE/s3-duel-sim" "$STAGE/r1-reason-distill"

cp -a "$ROOT/affine/affine.toml" "$STAGE/affine_pkg/"
cp -a "$ROOT/affine/affine/." "$STAGE/affine_pkg/affine/"
cp -a "$ROOT/affine/evalsrv/." "$STAGE/affine_pkg/evalsrv/"
cp -a "$ROOT/mining/experiments/s3-duel-sim/sync_corpus.sh" "$STAGE/s3-duel-sim/"
cp -a "$ROOT/mining/experiments/r1-reason-distill/run_reason_sim.py" \
      "$STAGE/r1-reason-distill/"
cp -a "$ROOT/mining/experiments/r1-reason-distill/write_reason_decision.py" \
      "$STAGE/r1-reason-distill/"
cp -a "$ROOT/mining/experiments/r1-reason-distill/plan.md" \
      "$STAGE/r1-reason-distill/" 2>/dev/null || true

TAR=/tmp/mine-r1-harness.tar.gz
tar -C "$STAGE" -czf "$TAR" .
ls -lh "$TAR"

"${SSH[@]}" 'mkdir -p /root/mining_src /root/affine_data /root/logs'
"${SCP[@]}" "$TAR" "root@${DST_HOST}:/tmp/mine-r1-harness.tar.gz"
"${SSH[@]}" 'set -e
  rm -rf /root/mining_src/affine_pkg /root/mining_src/s3-duel-sim \
         /root/mining_src/r1-reason-distill
  tar -C /root/mining_src -xzf /tmp/mine-r1-harness.tar.gz
  chmod +x /root/mining_src/s3-duel-sim/*.sh \
           /root/mining_src/r1-reason-distill/*.py
  test -f /root/mining_src/affine_pkg/affine/score.py
  test -f /root/mining_src/affine_pkg/evalsrv/dueling.py
  test -f /root/mining_src/affine_pkg/evalsrv/corpus.py
  test -f /root/mining_src/r1-reason-distill/run_reason_sim.py
  test -f /root/mining_src/s3-duel-sim/sync_corpus.sh
  # pyarrow needed for schema-v2 corpus; httpx already via vllm stack
  source /root/venv/bin/activate
  python -c "import pyarrow" 2>/dev/null || uv pip install pyarrow
  echo HARNESS_UPLOAD_OK
  ls -la /root/mining_src/affine_pkg /root/mining_src/r1-reason-distill \
         /root/mining_src/s3-duel-sim
'

rm -f "$TAR"
echo "[upload] done"
