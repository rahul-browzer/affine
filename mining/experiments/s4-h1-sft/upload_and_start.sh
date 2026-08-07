#!/usr/bin/env bash
# From validator host: upload H1 scripts + duel gz to mine-sim-1, install deps, start train.
# Does not touch validator processes or non-mine-* pods.
set -euo pipefail

ROOT=/home/const/subnet120
DST_HOST=${DST_HOST:-69.63.236.160}
DST_PORT=${DST_PORT:-40301}
KNOWN=/tmp/mine-sim-1.known_hosts
SSH=(ssh -i "$HOME/.ssh/id_ed25519" -o UserKnownHostsFile="$KNOWN"
     -o StrictHostKeyChecking=accept-new -p "$DST_PORT" "root@$DST_HOST")
SCP=(scp -i "$HOME/.ssh/id_ed25519" -o UserKnownHostsFile="$KNOWN"
     -o StrictHostKeyChecking=accept-new -P "$DST_PORT")

STAGE=$(mktemp -d /tmp/mine-h1.XXXXXX)
trap 'rm -rf "$STAGE"' EXIT

mkdir -p "$STAGE/s4-h1-sft" "$STAGE/duels"
cp -a "$ROOT/mining/experiments/s4-h1-sft/"*.py "$STAGE/s4-h1-sft/"
cp -a "$ROOT/mining/experiments/s4-h1-sft/"*.sh "$STAGE/s4-h1-sft/"
cp -a "$ROOT/mining/experiments/s4-h1-sft/plan.md" "$STAGE/s4-h1-sft/"

# Copy duel gz (dereference symlinks).
for f in "$ROOT/mining/experiments/s2-public-duel-mine"/chal-*.json.gz; do
  cp -L "$f" "$STAGE/duels/"
done

TAR=/tmp/mine-h1-upload.tar.gz
tar -C "$STAGE" -czf "$TAR" .
ls -lh "$TAR"

"${SSH[@]}" 'mkdir -p /root/mining_src /root/affine_data/duels /root/logs /root/h1'
"${SCP[@]}" "$TAR" "root@${DST_HOST}:/tmp/mine-h1-upload.tar.gz"
"${SSH[@]}" 'set -e
  rm -rf /root/mining_src/s4-h1-sft
  tar -C /tmp -xzf /tmp/mine-h1-upload.tar.gz
  mv /tmp/s4-h1-sft /root/mining_src/s4-h1-sft
  cp -a /tmp/duels/. /root/affine_data/duels/
  rm -rf /tmp/s4-h1-sft /tmp/duels
  chmod +x /root/mining_src/s4-h1-sft/*.sh /root/mining_src/s4-h1-sft/*.py
  ls /root/affine_data/duels | wc -l
  test -f /root/mining_src/s4-h1-sft/start_h1.sh
  test -f /root/affine_data/turns.jsonl
  echo UPLOAD_OK'

echo "[upload] install peft/accelerate (pod venv)"
"${SSH[@]}" 'set -e
  export PATH="/root/.local/bin:$PATH"
  source /root/venv/bin/activate
  uv pip install peft accelerate 2>&1 | tail -20
  python -c "import peft,accelerate; print(\"peft\", peft.__version__, \"accelerate\", accelerate.__version__)"'

echo "[upload] start H1 train"
"${SSH[@]}" 'bash /root/mining_src/s4-h1-sft/start_h1.sh'

echo "[upload] verify launch"
sleep 5
"${SSH[@]}" 'set -e
  test -f /root/logs/h1_train.pid
  pid=$(cat /root/logs/h1_train.pid)
  kill -0 "$pid"
  echo pid=$pid
  wc -l /root/h1/teacher_refs_sft.jsonl
  cat /root/h1/teacher_refs_sft.meta.json
  echo "--- train log head ---"
  head -40 /root/logs/h1_train.nohup
  echo "--- gpu ---"
  nvidia-smi --query-gpu=index,memory.used,utilization.gpu --format=csv,noheader
'

rm -f "$TAR"
echo "[upload] DONE"
