#!/usr/bin/env bash
# Pod/host-agnostic: after h139/R11 n80 sim result appears, write Reason v3 decision.
# Safe to run alongside a live post_train that lacks the writer (p2171).
set -euo pipefail
SIM=${SIM:-/root/affine_data/h139_sim_result.json}
DEC=${DEC:-/root/affine_data/h139_decision.json}
LOG=${LOG:-/root/logs/r11_decision_watch.nohup}
WRITER=${WRITER:-/root/mining_src/r1-reason-distill/write_reason_decision.py}
HYP=${HYP:-R11}
K_SIGMA=${K_SIGMA:-2.0}
MAX_ITERS=${MAX_ITERS:-7200}  # ~20h @ 10s

mkdir -p "$(dirname "$LOG")" /root/affine_data /root/logs
exec >>"$LOG" 2>&1
echo "[r11-dec] $(date -u +%Y-%m-%dT%H:%M:%SZ) start hyp=$HYP k=$K_SIGMA sim=$SIM"

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
  echo "[r11-dec] already have fresh $DEC — exit"
  exit 0
fi

for i in $(seq 1 "$MAX_ITERS"); do
  if [[ -f "$SIM" ]] \
    && python3 -c "import json,sys; d=json.load(open('$SIM')); sys.exit(0 if d.get('verdict') else 1)" 2>/dev/null; then
    if [[ -f /root/h139/train/train.done ]] && [[ /root/h139/train/train.done -nt "$SIM" ]]; then
      echo "[r11-dec] sim older than train.done — wait (iter=$i)"
    elif [[ ! -f /root/h139/train/train.done ]]; then
      echo "[r11-dec] train not done; ignore possible stale sim (iter=$i)"
    else
      echo "[r11-dec] $(date -u +%Y-%m-%dT%H:%M:%SZ) sim ready → write decision"
      # shellcheck disable=SC1091
      source /root/venv/bin/activate
      python "$WRITER" --sim-result "$SIM" --out "$DEC" --hyp "$HYP" --k-sigma "$K_SIGMA"
      cp -f "$DEC" /root/logs/h139_decision.json 2>/dev/null || true
      cp -f "$DEC" /root/affine_data/r11_decision.json 2>/dev/null || true
      echo "[r11-dec] DONE $(date -u +%Y-%m-%dT%H:%M:%SZ)"
      cat "$DEC"
      exit 0
    fi
  fi
  if (( i % 30 == 0 )); then
    echo "[r11-dec] wait iter=$i $(date -u +%Y-%m-%dT%H:%M:%SZ) have_sim=$([[ -f $SIM ]] && echo y || echo n)"
  fi
  sleep 10
done
echo "[r11-dec] TIMEOUT $(date -u +%Y-%m-%dT%H:%M:%SZ)" >&2
exit 1
