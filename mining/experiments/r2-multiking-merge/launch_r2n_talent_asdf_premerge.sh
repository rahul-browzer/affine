#!/usr/bin/env bash
# R2n: CPU skew-α merge TalentPigs (reign-3) × adsbasd31badsf/…-asdf (queue chal-00451).
# Gated on: asdf prefetch done + chal00451_reason.json Reason+ (hr>0) vs Tok.
# Do NOT blend a Reason− challenger. Layout donor = Talent (first --parent).
# Safe during R2g…R2m GPU work (CPU/RAM only). n80 bar later: ≥ 1.5×(3·SE).
set -euo pipefail
LOG=/root/logs/r2n_premerge.log
DONE=/root/logs/r2n_premerge.done
PIDF=/root/logs/r2n_premerge.pid
SKIP=/root/logs/r2n_premerge.skip
REASON_JSON=${REASON_JSON:-/root/affine_data/chal00451_reason.json}
REASON_DONE=${REASON_DONE:-/root/logs/watch_chal00451_reason.done}
PREFETCH_DONE=${PREFETCH_DONE:-/root/logs/r2_prefetch_asdf.done}
MERGED=${MERGED:-/root/r2_out/alpha_talent_asdf_skew}
mkdir -p /root/logs /root/r2_out /root/affine_data
echo $$ >"$PIDF"
exec > >(tee -a "$LOG") 2>&1

echo "[r2n-premerge] $(date -u +%Y-%m-%dT%H:%M:%SZ) start"
if [[ -f "$DONE" && -f "$MERGED/model.safetensors.index.json" ]]; then
  echo "[r2n-premerge] already done: $(cat "$DONE")"
  exit 0
fi
if [[ -f "$SKIP" ]]; then
  echo "[r2n-premerge] already skipped: $(cat "$SKIP")"
  exit 0
fi

echo "[r2n-premerge] waiting for asdf prefetch $PREFETCH_DONE"
for i in $(seq 1 2880); do
  if [[ -f "$PREFETCH_DONE" ]]; then
    echo "[r2n-premerge] prefetch ready: $(cat "$PREFETCH_DONE")"
    break
  fi
  if (( i % 12 == 0 )); then
    crumb=$(tail -n 2 /root/logs/r2_prefetch_asdf.log 2>/dev/null | tr '\r' '\n' | tail -1 || true)
    echo "[r2n-premerge] wait-prefetch iter=$i crumb=${crumb:-none}"
  fi
  if (( i == 2880 )); then
    echo "SKIP $(date -u +%Y-%m-%dT%H:%M:%SZ) asdf prefetch TIMEOUT" | tee "$SKIP"
    exit 2
  fi
  sleep 10
done

echo "[r2n-premerge] waiting for Reason stamp $REASON_JSON (+ $REASON_DONE)"
for i in $(seq 1 2880); do
  if [[ -f "$REASON_JSON" && -f "$REASON_DONE" ]]; then
    break
  fi
  if (( i % 12 == 0 )); then
    echo "[r2n-premerge] wait-reason iter=$i still no chal-00451 Reason stamp"
  fi
  sleep 10
done
if [[ ! -f "$REASON_JSON" || ! -f "$REASON_DONE" ]]; then
  echo "[r2n-premerge] TIMEOUT waiting for chal-00451 Reason" | tee "$SKIP"
  exit 2
fi

# shellcheck disable=SC1091
source /root/venv/bin/activate

GATE_LINE=$(python - <<'PY'
import json
from pathlib import Path
d = json.loads(Path("/root/affine_data/chal00451_reason.json").read_text())
hr = d.get("headroom_vs_3se")
km = bool(d.get("king_match"))
ok = km and hr is not None and float(hr) > 0.0
print(
    f"hr={hr} king_match={km} margin={d.get('reason_margin')} "
    f"repo={d.get('challenger_repo')} rev={d.get('challenger_revision')} ok={ok}"
)
Path("/tmp/r2n_gate_ok").write_text("1\n" if ok else "0\n")
PY
)
echo "[r2n-premerge] gate: $GATE_LINE"
if [[ "$(cat /tmp/r2n_gate_ok)" != "1" ]]; then
  echo "SKIP $(date -u +%Y-%m-%dT%H:%M:%SZ) Reason-or-mismatch ${GATE_LINE} — no Talent×asdf merge" | tee "$SKIP"
  exit 0
fi

W_TALENT=${W_TALENT:-0.25}
W_ASDF=${W_ASDF:-0.75}
TALENT_REV=dbfbb3e2a17c7603e7fc68a3a15b343f42dfdef4
ASDF_REV=${ASDF_REV:-c23098154fd717e64f577cd863f0e1ba8e96ee84}

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
  echo "[r2n-premerge] FATAL missing TalentPigs" >&2
  exit 2
}
ASDF=$(resolve_snap adsbasd31badsf/affine-5ec3jw68ha-asdf "$ASDF_REV") || {
  echo "[r2n-premerge] FATAL missing asdf" >&2
  exit 2
}

rm -rf "$MERGED"
mkdir -p "$MERGED"
echo "[r2n-premerge] α-merge Talent:$W_TALENT asdf:$W_ASDF → $MERGED"
python /root/mining_src/r2-multiking-merge/merge_alpha.py \
  --parent "${TALENT}:${W_TALENT}" \
  --parent "${ASDF}:${W_ASDF}" \
  --out "$MERGED"

META=""
if [[ -f "$MERGED/merge_alpha_meta.json" ]]; then
  META=$(python - <<'PY'
import json
from pathlib import Path
d=json.loads(Path("/root/r2_out/alpha_talent_asdf_skew/merge_alpha_meta.json").read_text())
print(f"max_abs_delta={d.get('max_abs_delta')} n_keys={d.get('n_keys')} identical_frac={d.get('identical_frac')}")
PY
)
  cp -f "$MERGED/merge_alpha_meta.json" /root/affine_data/r2n_talent_asdf_merge_alpha_meta.json
fi
echo "OK $(date -u +%Y-%m-%dT%H:%M:%SZ) w_talent=$W_TALENT w_asdf=$W_ASDF ${META}" | tee "$DONE"
echo "[r2n-premerge] DONE $(date -u +%Y-%m-%dT%H:%M:%SZ)"
