#!/usr/bin/env bash
# Sidecar: wait for sim result, then write decision with the live Reason crown rule.
# p2227: was write_merge_decision.py (absolute margin>0.04 / S*-era). That overwrote
# post_train's write_reason_decision.py and would REFUTE a live clear at
# margin > k_sigma·SE when margin ≤ 0.04. Operator 2026-08-12: submit = crown.
set -euo pipefail
HYP=${1:?hyp id e.g. h7}
SIM=${2:-/root/affine_data/${HYP}_sim_result.json}
OUT=${3:-/root/affine_data/${HYP}_decision.json}
LOG=${4:-/root/logs/${HYP}_form_decision.nohup}
# Reason-v3 writer (default headroom_bar=1.0 = live crown). Legacy absolute-margin
# merge writer kept only for mid50 signal-only probes.
REASON_WRITER=/root/mining_src/r1-reason-distill/write_reason_decision.py
MERGE_WRITER=/root/mining_src/s4-h2-merge/write_merge_decision.py
K_SIGMA=${K_SIGMA:-2.0}
HEADROOM_BAR=${HEADROOM_BAR:-1.0}

log() { echo "[form-$HYP] $(date -u +%Y-%m-%dT%H:%M:%SZ) $*"; }
mkdir -p /root/logs /root/affine_data
exec >>"$LOG" 2>&1

log "waiting for $SIM (writer=reason k=$K_SIGMA bar=$HEADROOM_BAR)"
while [[ ! -s "$SIM" ]]; do sleep 15; done
# wait until sim process exits (awk avoids SSH cmdline false-match)
while ps -eo pid,cmd | awk -v h="$HYP" '
  BEGIN{f=0}
  (/[r]un_sim_duel\.py/ || /[r]un_reason_sim\.py/) && $0 ~ h {f=1}
  END{exit !f}
'; do sleep 10; done
# let post_train's inline writer finish first; we re-stamp with the same rule
sleep 8
if [[ ! -s "$SIM" ]]; then
  log "ERROR sim result missing after sim exit"
  exit 1
fi
# shellcheck disable=SC1091
source /root/venv/bin/activate
if [[ "$HYP" == *mid50* ]]; then
  python3 "$MERGE_WRITER" --hyp "$HYP" --sim-result "$SIM" --out "$OUT" --signal-only
else
  python3 "$REASON_WRITER" \
    --sim-result "$SIM" --out "$OUT" --hyp "$HYP" \
    --k-sigma "$K_SIGMA" --headroom-bar "$HEADROOM_BAR"
fi
# Keep the copies post_train also stamps
cp -f "$OUT" /root/logs/${HYP}_decision.json 2>/dev/null || true
log "WROTE $OUT"
cat "$OUT"
