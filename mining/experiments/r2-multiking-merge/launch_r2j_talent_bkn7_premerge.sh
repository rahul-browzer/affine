#!/usr/bin/env bash
# R2j: CPU skew-α merge TalentPigs (reign-3) × BKN1890/…-seven (live chal-00432).
# Gated on: BKN-seven prefetch done + chal00432_reason.json Reason+ (hr>0) vs Tok.
# Do NOT blend a Reason− challenger. Layout donor = Talent (first --parent).
# Safe during R2g GPU n80 (CPU/RAM only). n80 bar later: ≥ 1.5×(3·SE).
set -euo pipefail
LOG=/root/logs/r2j_premerge.log
DONE=/root/logs/r2j_premerge.done
PIDF=/root/logs/r2j_premerge.pid
SKIP=/root/logs/r2j_premerge.skip
REASON_JSON=${REASON_JSON:-/root/affine_data/chal00432_reason.json}
REASON_DONE=${REASON_DONE:-/root/logs/watch_chal00432_reason.done}
PREFETCH_DONE=${PREFETCH_DONE:-/root/logs/r2_prefetch_bkn_seven.done}
MERGED=${MERGED:-/root/r2_out/alpha_talent_bkn7_seven_skew}
mkdir -p /root/logs /root/r2_out /root/affine_data
echo $$ >"$PIDF"
exec > >(tee -a "$LOG") 2>&1

echo "[r2j-premerge] $(date -u +%Y-%m-%dT%H:%M:%SZ) start"
if [[ -f "$DONE" && -f "$MERGED/model.safetensors.index.json" ]]; then
  echo "[r2j-premerge] already done: $(cat "$DONE")"
  exit 0
fi
if [[ -f "$SKIP" ]]; then
  echo "[r2j-premerge] already skipped: $(cat "$SKIP")"
  exit 0
fi

echo "[r2j-premerge] waiting for BKN-seven prefetch $PREFETCH_DONE"
for i in $(seq 1 2880); do
  if [[ -f "$PREFETCH_DONE" ]]; then
    echo "[r2j-premerge] prefetch ready: $(cat "$PREFETCH_DONE")"
    break
  fi
  if (( i % 12 == 0 )); then
    crumb=$(tail -n 2 /root/logs/r2_prefetch_bkn_seven.log 2>/dev/null | tr '\r' '\n' | tail -1 || true)
    echo "[r2j-premerge] wait-prefetch iter=$i crumb=${crumb:-none}"
  fi
  if (( i == 2880 )); then
    echo "SKIP $(date -u +%Y-%m-%dT%H:%M:%SZ) bkn7 prefetch TIMEOUT" | tee "$SKIP"
    exit 2
  fi
  sleep 10
done

echo "[r2j-premerge] waiting for Reason stamp $REASON_JSON (+ $REASON_DONE)"
for i in $(seq 1 2880); do
  if [[ -f "$REASON_JSON" && -f "$REASON_DONE" ]]; then
    break
  fi
  if (( i % 12 == 0 )); then
    echo "[r2j-premerge] wait-reason iter=$i still no chal-00432 Reason stamp"
  fi
  sleep 10
done
if [[ ! -f "$REASON_JSON" || ! -f "$REASON_DONE" ]]; then
  echo "[r2j-premerge] TIMEOUT waiting for chal-00432 Reason" | tee "$SKIP"
  exit 2
fi

# shellcheck disable=SC1091
source /root/venv/bin/activate

GATE_LINE=$(python - <<'PY'
import json
from pathlib import Path
d = json.loads(Path("/root/affine_data/chal00432_reason.json").read_text())
hr = d.get("headroom_vs_3se")
km = bool(d.get("king_match"))
ok = km and hr is not None and float(hr) > 0.0
print(
    f"hr={hr} king_match={km} margin={d.get('reason_margin')} "
    f"repo={d.get('challenger_repo')} rev={d.get('challenger_revision')} ok={ok}"
)
Path("/tmp/r2j_gate_ok").write_text("1\n" if ok else "0\n")
PY
)
echo "[r2j-premerge] gate: $GATE_LINE"
if [[ "$(cat /tmp/r2j_gate_ok)" != "1" ]]; then
  echo "SKIP $(date -u +%Y-%m-%dT%H:%M:%SZ) Reason-or-mismatch ${GATE_LINE} — no Talent×BKN7 merge" | tee "$SKIP"
  exit 0
fi

W_TALENT=${W_TALENT:-0.25}
W_BKN=${W_BKN:-0.75}
TALENT_REV=dbfbb3e2a17c7603e7fc68a3a15b343f42dfdef4
BKN_REV=${BKN_REV:-11821bf3164ae9e35955012e2f88223e8734ab6f}

resolve_snap() {
  local repo="$1" rev="$2"
  local d="/root/hf/hub/models--${repo//\//--}/snapshots/${rev}"
  if [[ -d "$d" && -f "$d/model.safetensors.index.json" ]]; then
    echo "$d"
    return 0
  fi
  return 1
}

TALENT=$(resolve_snap TalentPigs/affine-5ekxlcg3fx-abc "$TALENT_REV") || {
  echo "[r2j-premerge] FATAL missing TalentPigs" >&2
  exit 2
}
BKN=$(resolve_snap BKN1890/Affine-5ghvq9a9g9-seven "$BKN_REV") || {
  echo "[r2j-premerge] FATAL missing BKN1890 seven" >&2
  exit 2
}

rm -rf "$MERGED"
mkdir -p "$MERGED"
echo "[r2j-premerge] α-merge Talent:$W_TALENT bkn7:$W_BKN → $MERGED"
python /root/mining_src/r2-multiking-merge/merge_alpha.py \
  --parent "${TALENT}:${W_TALENT}" \
  --parent "${BKN}:${W_BKN}" \
  --out "$MERGED"

META=""
if [[ -f "$MERGED/merge_alpha_meta.json" ]]; then
  META=$(python - <<'PY'
import json
from pathlib import Path
d=json.loads(Path("/root/r2_out/alpha_talent_bkn7_seven_skew/merge_alpha_meta.json").read_text())
print(f"max_abs_delta={d.get('max_abs_delta')} n_keys={d.get('n_keys')} identical_frac={d.get('identical_frac')}")
PY
)
  cp -f "$MERGED/merge_alpha_meta.json" /root/affine_data/r2j_talent_bkn7_merge_alpha_meta.json
fi
echo "OK $(date -u +%Y-%m-%dT%H:%M:%SZ) w_talent=$W_TALENT w_bkn=$W_BKN ${META}" | tee "$DONE"
echo "[r2j-premerge] DONE $(date -u +%Y-%m-%dT%H:%M:%SZ)"
