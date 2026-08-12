#!/usr/bin/env bash
# Pod: after R3/R3b n80 sim result appears, write Reason v3 decision (k_sigma=2.0).
# Safety net when post_train lacks the writer (p2171). Hyp stamped R3b.
# Skip only if DEC is fresh for THIS sim (hyp=R3b and mtime >= sim).
set -euo pipefail
SIM=${SIM:-/root/affine_data/r3_sim_result.json}
DEC=${DEC:-/root/affine_data/r3_decision.json}
LOG=${LOG:-/root/logs/r3b_decision_watch.nohup}
WRITER=${WRITER:-/root/mining_src/r1-reason-distill/write_reason_decision.py}
HYP=${HYP:-R3b}
K_SIGMA=${K_SIGMA:-2.0}
MAX_ITERS=${MAX_ITERS:-7200}

mkdir -p "$(dirname "$LOG")" /root/affine_data /root/logs
exec >>"$LOG" 2>&1
echo "[r3b-dec] $(date -u +%Y-%m-%dT%H:%M:%SZ) start hyp=$HYP k=$K_SIGMA sim=$SIM"

_fresh_dec() {
  [[ -f "$DEC" && -f "$SIM" ]] || return 1
  python3 - <<PY
import json, os, sys
sim, dec, hyp = "$SIM", "$DEC", "$HYP"
try:
    d = json.load(open(dec))
except Exception:
    sys.exit(1)
if d.get("hyp") != hyp:
    sys.exit(1)
if os.path.getmtime(dec) + 0.5 < os.path.getmtime(sim):
    sys.exit(1)
sys.exit(0)
PY
}

if _fresh_dec; then
  echo "[r3b-dec] already have fresh $DEC — exit"
  exit 0
fi

for i in $(seq 1 "$MAX_ITERS"); do
  if [[ -f "$SIM" ]] \
    && python3 -c "import json,sys; d=json.load(open('$SIM')); sys.exit(0 if d.get('verdict') else 1)" 2>/dev/null; then
    if [[ ! -f /root/r3/train/train.done ]]; then
      echo "[r3b-dec] train not done; ignore possible stale sim (iter=$i)"
    elif [[ /root/r3/train/train.done -nt "$SIM" ]]; then
      echo "[r3b-dec] sim older than train.done — wait for new n80 (iter=$i)"
    else
      echo "[r3b-dec] $(date -u +%Y-%m-%dT%H:%M:%SZ) sim ready → write decision"
      # shellcheck disable=SC1091
      source /root/venv/bin/activate
      python "$WRITER" --sim-result "$SIM" --out "$DEC" --hyp "$HYP" --k-sigma "$K_SIGMA"
      cp -f "$DEC" /root/logs/r3_decision.json 2>/dev/null || true
      cp -f "$DEC" /root/affine_data/r3b_decision.json 2>/dev/null || true
      echo "[r3b-dec] DONE $(date -u +%Y-%m-%dT%H:%M:%SZ)"
      cat "$DEC"
      exit 0
    fi
  fi
  if (( i % 30 == 0 )); then
    echo "[r3b-dec] wait iter=$i $(date -u +%Y-%m-%dT%H:%M:%SZ) have_sim=$([[ -f $SIM ]] && echo y || echo n) train_done=$([[ -f /root/r3/train/train.done ]] && echo y || echo n)"
  fi
  sleep 10
done
echo "[r3b-dec] TIMEOUT $(date -u +%Y-%m-%dT%H:%M:%SZ)" >&2
exit 1
