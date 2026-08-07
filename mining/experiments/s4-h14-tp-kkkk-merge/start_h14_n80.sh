#!/usr/bin/env bash
# After bootstrap_h14.done + engines up: run n80 sim vs TalentPigs.
set -euo pipefail

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

test -f /root/logs/h14_merge.done
test -d /root/merges/h14-tp75

TIMEOUT_S=2400 bash /root/mining_src/s3-duel-sim/wait_ready.sh

for attempt in 1 2 3; do
  echo "[h14-n80] attempt=$attempt $(date -u +%Y-%m-%dT%H:%M:%SZ)"
  set +e
  python /root/mining_src/s4-h2-merge/run_sim_duel.py \
    --king-repo TalentPigs/affine-5ekxlcg3fx-abc \
    --king-rev dbfbb3e2a17c7603e7fc68a3a15b343f42dfdef4 \
    --chall-repo /root/merges/h14-tp75 \
    --chall-rev local \
    --n-turns 80 \
    --hotkey local-h14 \
    --out /root/affine_data/h14_sim_result.json \
    --progress-out /root/affine_data/h14_sim_progress.json \
    --save-artifact \
    2>&1 | tee /root/logs/h14_n80.log
  rc=${PIPESTATUS[0]}
  set -e
  if [[ $rc -eq 0 && -f /root/affine_data/h14_sim_result.json ]]; then
    break
  fi
  echo "[h14-n80] attempt=$attempt failed rc=$rc; sleep 30"
  sleep 30
done

python3 /root/mining_src/s4-h2-merge/write_merge_decision.py \
  --hyp h14 \
  --sim-result /root/affine_data/h14_sim_result.json \
  --out /root/affine_data/h14_decision.json

date -u +%Y-%m-%dT%H:%M:%SZ > /root/logs/h14_n80.done
echo "[h14-n80] DONE"
