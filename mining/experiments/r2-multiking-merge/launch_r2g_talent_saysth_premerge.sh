#!/usr/bin/env bash
# R2g: CPU skew-α merge TalentPigs (reign-3) × saysth/…-v9a (live chal-00440).
# Gated on chal00440_reason.json Reason+ (headroom_vs_3se > 0) vs Tok af10 —
# do NOT blend a Reason− challenger. Layout donor = Talent (first --parent).
# Safe during R2e GPU n80 (CPU/RAM only). n80 bar later: ≥ 1.5×(3·SE).
set -euo pipefail
LOG=/root/logs/r2g_premerge.log
DONE=/root/logs/r2g_premerge.done
PIDF=/root/logs/r2g_premerge.pid
SKIP=/root/logs/r2g_premerge.skip
REASON_JSON=${REASON_JSON:-/root/affine_data/chal00440_reason.json}
REASON_DONE=${REASON_DONE:-/root/logs/watch_chal00440_reason.done}
MERGED=${MERGED:-/root/r2_out/alpha_talent_saysth_v9a_skew}
mkdir -p /root/logs /root/r2_out /root/affine_data
echo $$ >"$PIDF"
exec > >(tee -a "$LOG") 2>&1

echo "[r2g-premerge] $(date -u +%Y-%m-%dT%H:%M:%SZ) start"
if [[ -f "$DONE" && -f "$MERGED/model.safetensors.index.json" ]]; then
  echo "[r2g-premerge] already done: $(cat "$DONE")"
  exit 0
fi
if [[ -f "$SKIP" ]]; then
  echo "[r2g-premerge] already skipped: $(cat "$SKIP")"
  exit 0
fi

echo "[r2g-premerge] waiting for Reason stamp $REASON_JSON (+ $REASON_DONE)"
for i in $(seq 1 2880); do
  if [[ -f "$REASON_JSON" && -f "$REASON_DONE" ]]; then
    break
  fi
  if (( i % 12 == 0 )); then
    echo "[r2g-premerge] wait iter=$i still no Reason stamp"
  fi
  sleep 10
done
if [[ ! -f "$REASON_JSON" || ! -f "$REASON_DONE" ]]; then
  echo "[r2g-premerge] TIMEOUT waiting for chal-00440 Reason" | tee "$SKIP"
  exit 2
fi

# shellcheck disable=SC1091
source /root/venv/bin/activate

GATE_LINE=$(python - <<'PY'
import json
from pathlib import Path
d = json.loads(Path("/root/affine_data/chal00440_reason.json").read_text())
hr = d.get("headroom_vs_3se")
km = bool(d.get("king_match"))
ok = km and hr is not None and float(hr) > 0.0
print(
    f"hr={hr} king_match={km} margin={d.get('reason_margin')} "
    f"repo={d.get('challenger_repo')} rev={d.get('challenger_revision')} ok={ok}"
)
Path("/tmp/r2g_gate_ok").write_text("1\n" if ok else "0\n")
PY
)
echo "[r2g-premerge] gate: $GATE_LINE"
if [[ "$(cat /tmp/r2g_gate_ok)" != "1" ]]; then
  echo "SKIP $(date -u +%Y-%m-%dT%H:%M:%SZ) Reason-or-mismatch ${GATE_LINE} — no Talent×saysth merge" | tee "$SKIP"
  exit 0
fi

W_TALENT=${W_TALENT:-0.25}
W_SAYSTH=${W_SAYSTH:-0.75}
TALENT_REV=dbfbb3e2a17c7603e7fc68a3a15b343f42dfdef4
SAYSTH_REV=${SAYSTH_REV:-6e13f365b36000cf631aad2fa9fb05fdabae0044}

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
  echo "[r2g-premerge] FATAL missing TalentPigs" >&2
  exit 2
}
SAYSTH=$(resolve_snap saysth/Affine-5dtnxamt4t-v9a "$SAYSTH_REV") || {
  echo "[r2g-premerge] FATAL missing saysth v9a" >&2
  exit 2
}

rm -rf "$MERGED"
mkdir -p "$MERGED"
echo "[r2g-premerge] α-merge Talent:$W_TALENT saysth:$W_SAYSTH → $MERGED"
python /root/mining_src/r2-multiking-merge/merge_alpha.py \
  --parent "${TALENT}:${W_TALENT}" \
  --parent "${SAYSTH}:${W_SAYSTH}" \
  --out "$MERGED"

META=""
if [[ -f "$MERGED/merge_alpha_meta.json" ]]; then
  META=$(python - <<'PY'
import json
from pathlib import Path
d=json.loads(Path("/root/r2_out/alpha_talent_saysth_v9a_skew/merge_alpha_meta.json").read_text())
print(f"max_abs_delta={d.get('max_abs_delta')} n_keys={d.get('n_keys')} identical_frac={d.get('identical_frac')}")
PY
)
  cp -f "$MERGED/merge_alpha_meta.json" /root/affine_data/r2g_talent_saysth_merge_alpha_meta.json
fi
echo "OK $(date -u +%Y-%m-%dT%H:%M:%SZ) w_talent=$W_TALENT w_saysth=$W_SAYSTH ${META}" | tee "$DONE"
echo "[r2g-premerge] DONE $(date -u +%Y-%m-%dT%H:%M:%SZ)"
