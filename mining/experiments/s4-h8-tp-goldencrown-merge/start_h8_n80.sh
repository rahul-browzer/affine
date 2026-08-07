#!/usr/bin/env bash
# After bootstrap_h8.done + engines up: run n80 sim vs TalentPigs.
set -euo pipefail

LOG=/root/logs/h8_n80.nohup
mkdir -p /root/logs /root/affine_data

if [[ -f /root/mine.env ]]; then
  set -a
  # shellcheck disable=SC1091
  source /root/mine.env
  set +a
fi
# shellcheck disable=SC1091
source /root/venv/bin/activate
export PYTHONPATH=/root/mining_src/affine_pkg${PYTHONPATH:+:$PYTHONPATH}
export HF_HOME=${HF_HOME:-/root/hf}

test -f /root/logs/h8_merge.done
test -d /root/merges/h8-tp75

TIMEOUT_S=2400 bash /root/mining_src/s3-duel-sim/wait_ready.sh

python /root/mining_src/s4-h2-merge/run_sim_duel.py \
  --king-repo TalentPigs/affine-5ekxlcg3fx-abc \
  --king-rev dbfbb3e2a17c7603e7fc68a3a15b343f42dfdef4 \
  --chall-repo /root/merges/h8-tp75 \
  --chall-rev local \
  --n-turns 80 \
  --hotkey local-h8 \
  --out /root/affine_data/h8_sim_result.json \
  --progress-out /root/affine_data/h8_sim_progress.json \
  --save-artifact \
  2>&1 | tee /root/logs/h8_n80.log

# Nested verdict fields — flat d.get("margin") is always None (false-REFUTE).
python3 /root/mining_src/s4-h2-merge/write_merge_decision.py \
  --hyp h8 \
  --sim-result /root/affine_data/h8_sim_result.json \
  --out /root/affine_data/h8_decision.json

date -u +%Y-%m-%dT%H:%M:%SZ > /root/logs/h8_n80.done
echo "[h8-n80] DONE"
