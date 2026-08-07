#!/usr/bin/env bash
# Sidecar: wait for sim result, then overwrite decision with nested-aware parse.
# Safe to run alongside a live start_h*_n80.sh (do not edit that script while running).
set -euo pipefail
HYP=${1:?hyp id e.g. h7}
SIM=${2:-/root/affine_data/${HYP}_sim_result.json}
OUT=${3:-/root/affine_data/${HYP}_decision.json}
LOG=${4:-/root/logs/${HYP}_form_decision.nohup}
WRITER=/root/mining_src/s4-h2-merge/write_merge_decision.py

log() { echo "[form-$HYP] $(date -u +%Y-%m-%dT%H:%M:%SZ) $*"; }
mkdir -p /root/logs /root/affine_data
exec >>"$LOG" 2>&1

log "waiting for $SIM"
while [[ ! -s "$SIM" ]]; do sleep 15; done
# wait until run_sim_duel for this hyp exits (awk avoids SSH cmdline false-match)
while ps -eo pid,cmd | awk -v h="$HYP" 'BEGIN{f=0} /[r]un_sim_duel\.py/ && $0 ~ h {f=1} END{exit !f}'; do sleep 10; done
# let the (possibly broken) inline writer finish first
sleep 8
if [[ ! -s "$SIM" ]]; then
  log "ERROR sim result missing after sim exit"
  exit 1
fi
# shellcheck disable=SC1091
source /root/venv/bin/activate
extra=()
if [[ "$HYP" == *mid50* ]]; then
  extra+=(--signal-only)
fi
python3 "$WRITER" --hyp "$HYP" --sim-result "$SIM" --out "$OUT" "${extra[@]}"
log "WROTE $OUT"
cat "$OUT"
