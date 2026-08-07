#!/usr/bin/env bash
# After bootstrap_h23.done + engines up: run n80 sim vs TalentPigs.
# Gate: /v1/models ready AND chall /v1/completions probe (H24: health≠alive).
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

test -f /root/logs/h23_merge.done
test -d /root/merges/h23-tp90

TIMEOUT_S=2400 bash /root/mining_src/s3-duel-sim/wait_ready.sh

# Health/models can be up while EngineCore is hung (shm_broadcast / Triton).
# Require a real completion before burning an n80 attempt (LESSON H24).
_probe_chall() {
  local ok
  sleep 30
  ok=$(curl -s --max-time 120 http://127.0.0.1:8002/v1/completions \
    -H "Content-Type: application/json" \
    -d '{"model":"/root/merges/h23-tp90","prompt":"hi","max_tokens":4,"temperature":0}' \
    | python3 -c 'import sys,json; d=json.load(sys.stdin); print("ok" if d.get("choices") else "bad")' \
    2>/dev/null || echo fail)
  echo "[h23-n80] chall_completions_probe=$ok $(date -u +%Y-%m-%dT%H:%M:%SZ)"
  [[ "$ok" == "ok" ]]
}

PROBE_OK=0
for pi in $(seq 1 8); do
  if _probe_chall; then
    PROBE_OK=1
    break
  fi
  echo "[h23-n80] probe retry $pi/8 — sleep 30"
  sleep 30
done
if [[ "$PROBE_OK" -ne 1 ]]; then
  echo "[h23-n80] ERROR: chall completions probe failed after wait_ready" \
    | tee /root/logs/h23_probe_failed
  exit 1
fi

for attempt in 1 2 3; do
  echo "[h23-n80] attempt=$attempt $(date -u +%Y-%m-%dT%H:%M:%SZ)"
  set +e
  python /root/mining_src/s4-h2-merge/run_sim_duel.py \
    --king-repo TalentPigs/affine-5ekxlcg3fx-abc \
    --king-rev dbfbb3e2a17c7603e7fc68a3a15b343f42dfdef4 \
    --chall-repo /root/merges/h23-tp90 \
    --chall-rev local \
    --n-turns 80 \
    --hotkey local-h23 \
    --out /root/affine_data/h23_sim_result.json \
    --progress-out /root/affine_data/h23_sim_progress.json \
    --save-artifact \
    2>&1 | tee /root/logs/h23_n80.log
  rc=${PIPESTATUS[0]}
  set -e
  if [[ $rc -eq 0 && -f /root/affine_data/h23_sim_result.json ]]; then
    python3 /root/mining_src/s4-h2-merge/write_merge_decision.py \
      --hyp h23 \
      --sim-result /root/affine_data/h23_sim_result.json \
      --out /root/affine_data/h23_decision.json
    date -u +%Y-%m-%dT%H:%M:%SZ > /root/logs/h23_n80.done
    echo "[h23-n80] DONE"
    exit 0
  fi
  echo "[h23-n80] attempt=$attempt failed rc=$rc; sleep 30"
  sleep 30
done

echo "[h23-n80] ERROR: all 3 attempts failed — watch_n80_retry will take over"
exit 1
