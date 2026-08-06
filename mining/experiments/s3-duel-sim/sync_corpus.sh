#!/usr/bin/env bash
# Sync public turn corpus onto the pod (anonymous, fail-closed).
# Safe to run while HF model downloads continue.
set -euo pipefail

# shellcheck disable=SC1091
source /root/venv/bin/activate
if [[ -f /root/mine.env ]]; then
  # shellcheck disable=SC1091
  source /root/mine.env
fi

export PYTHONPATH=/root/mining_src/affine_pkg${PYTHONPATH:+:$PYTHONPATH}
export AFFINE_DATA_DIR=${AFFINE_DATA_DIR:-/root/affine_data}
mkdir -p "$AFFINE_DATA_DIR" /root/logs

echo "[corpus] $(date -u +%Y-%m-%dT%H:%M:%SZ) sync start"
python -m evalsrv.corpus --sync 2>&1 | tee /root/logs/corpus_sync.log
test -f "$AFFINE_DATA_DIR/turns.jsonl"
wc -l "$AFFINE_DATA_DIR/turns.jsonl"
echo "[corpus] $(date -u +%Y-%m-%dT%H:%M:%SZ) DONE"
touch /root/logs/corpus.done
