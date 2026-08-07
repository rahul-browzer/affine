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

python3 - <<'PY'
import json
from pathlib import Path
p = Path("/root/affine_data/h8_sim_result.json")
d = json.loads(p.read_text())
margin = d.get("margin")
r = d.get("r_c")
valid = d.get("valid_c")
z = d.get("z")
dec = {
    "utc": __import__("datetime").datetime.utcnow().strftime("%Y-%m-%dT%H:%M:%SZ"),
    "margin": margin,
    "z": z,
    "r_c": r,
    "valid_c": valid,
    "S_c": d.get("S_c"),
    "S_k": d.get("S_k"),
    "decision": (
        "ADVANCE_STAGE5" if (margin is not None and margin > 0.04 and valid) else
        "TRY_ALPHA_085" if (margin is not None and margin >= 0.02) else
        "REFUTE_H8"
    ),
}
Path("/root/affine_data/h8_decision.json").write_text(json.dumps(dec, indent=2))
print(json.dumps(dec, indent=2))
PY

date -u +%Y-%m-%dT%H:%M:%SZ > /root/logs/h8_n80.done
echo "[h8-n80] DONE"
