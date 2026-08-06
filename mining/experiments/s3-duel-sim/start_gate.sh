#!/usr/bin/env bash
# After bootstrap.done + corpus.done + serve ready: run Stage 3 gate.
set -euo pipefail

# shellcheck disable=SC1091
source /root/venv/bin/activate
if [[ -f /root/mine.env ]]; then
  # shellcheck disable=SC1091
  source /root/mine.env
fi

export PYTHONPATH=/root/mining_src/affine_pkg${PYTHONPATH:+:$PYTHONPATH}
export HF_HOME=${HF_HOME:-/root/hf}
export AFFINE_DATA_DIR=${AFFINE_DATA_DIR:-/root/affine_data}

test -f /root/logs/bootstrap.done
test -f /root/logs/corpus.done
test -f /root/affine_data/chal-00224.json.gz
test -f /root/affine_data/turns.jsonl

mkdir -p /root/logs
echo "[gate] $(date -u +%Y-%m-%dT%H:%M:%SZ) start"
python /root/mining_src/s3-duel-sim/run_gate.py \
  --artifact /root/affine_data/chal-00224.json.gz \
  --turns /root/affine_data/turns.jsonl \
  --out /root/affine_data/s3_gate_result.json \
  2>&1 | tee /root/logs/gate.log
echo "[gate] $(date -u +%Y-%m-%dT%H:%M:%SZ) exit=$?"
