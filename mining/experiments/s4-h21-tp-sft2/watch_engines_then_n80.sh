#!/usr/bin/env bash
# If wait_ready dies before engines ready, launch n80 once healthy.
# Used after Triton-cache crash recover (pass159).
set -euo pipefail
if [[ -f /root/mine.env ]]; then set -a; source /root/mine.env; set +a; fi
# shellcheck disable=SC1091
source /root/venv/bin/activate
export PYTHONPATH=/root/mining_src/affine_pkg${PYTHONPATH:+:$PYTHONPATH}
export HF_HOME=${HF_HOME:-/root/hf}
LOG=/root/logs/h21_watch_engines_n80.log
exec >>"$LOG" 2>&1
echo "[h21-watch] $(date -u +%Y-%m-%dT%H:%M:%SZ) armed"

for i in $(seq 1 120); do
  t=0; k=0; c=0
  curl -sf -m 3 http://127.0.0.1:8000/health >/dev/null && t=1 || true
  curl -sf -m 3 http://127.0.0.1:8001/health >/dev/null && k=1 || true
  curl -sf -m 3 http://127.0.0.1:8002/health >/dev/null && c=1 || true
  echo "[h21-watch] t=$t k=$k c=$c i=$i $(date -u +%Y-%m-%dT%H:%M:%SZ)"
  if [[ $t -eq 1 && $k -eq 1 && $c -eq 1 ]]; then
    sleep 90
    if [[ -f /root/affine_data/h21_decision.json ]]; then
      echo "[h21-watch] decision already present; exit"
      exit 0
    fi
    if pgrep -f "run_sim_duel.py.*local-h21" >/dev/null; then
      echo "[h21-watch] n80 already running; exit"
      exit 0
    fi
    echo "[h21-watch] engines healthy but no n80 — launching"
    for attempt in 1 2 3; do
      echo "[h21-watch] n80 attempt=$attempt $(date -u +%Y-%m-%dT%H:%M:%SZ)"
      set +e
      python /root/mining_src/s4-h2-merge/run_sim_duel.py \
        --king-repo TalentPigs/affine-5ekxlcg3fx-abc \
        --king-rev dbfbb3e2a17c7603e7fc68a3a15b343f42dfdef4 \
        --chall-repo /root/merges/h21-tp75 \
        --chall-rev local \
        --n-turns 80 \
        --hotkey local-h21 \
        --out /root/affine_data/h21_sim_result.json \
        --progress-out /root/affine_data/h21_sim_progress.json \
        --save-artifact \
        2>&1 | tee -a /root/logs/h21_n80.log
      rc=${PIPESTATUS[0]}
      set -e
      if [[ $rc -eq 0 && -f /root/affine_data/h21_sim_result.json ]]; then
        python3 /root/mining_src/s4-h2-merge/write_merge_decision.py \
          --hyp h21 \
          --sim-result /root/affine_data/h21_sim_result.json \
          --out /root/affine_data/h21_decision.json
        date -u +%Y-%m-%dT%H:%M:%SZ > /root/logs/h21_n80.done
        echo "[h21-watch] DONE"
        exit 0
      fi
      sleep 30
    done
    echo "[h21-watch] ERROR n80 failed; leaving for watch_n80_retry"
    exit 1
  fi
  sleep 30
done
echo "[h21-watch] TIMEOUT waiting for engines"
exit 1
