#!/usr/bin/env bash
# R2x: CPU skew-α merge TalentPigs (reign-3) × 0pentensor/…-awesome-v8 (queue chal-00462).
# Gated on: awesome-v8 prefetch done + chal00462_reason.json Reason+ (hr>0) vs Tok.
# Do NOT blend a Reason− challenger. Layout donor = Talent (first --parent).
# Safe during R2l…R2r / R2w GPU work (CPU/RAM only). n80 bar later: ≥ 1.5×(3·SE).
# awesome-v6 was best DL near-miss (hr≈0.92×); v8 is the next lineage on the board.
set -euo pipefail
LOG=/root/logs/r2x_premerge.log
DONE=/root/logs/r2x_premerge.done
PIDF=/root/logs/r2x_premerge.pid
SKIP=/root/logs/r2x_premerge.skip
REASON_JSON=${REASON_JSON:-/root/affine_data/chal00462_reason.json}
REASON_DONE=${REASON_DONE:-/root/logs/watch_chal00462_reason.done}
PREFETCH_DONE=${PREFETCH_DONE:-/root/logs/r2_prefetch_awesome_v8.done}
MERGED=${MERGED:-/root/r2_out/alpha_talent_awesome_v8_skew}
mkdir -p /root/logs /root/r2_out /root/affine_data
echo $$ >"$PIDF"
exec > >(tee -a "$LOG") 2>&1

echo "[r2x-premerge] $(date -u +%Y-%m-%dT%H:%M:%SZ) start"
if [[ -f "$DONE" && -f "$MERGED/model.safetensors.index.json" ]]; then
  echo "[r2x-premerge] already done: $(cat "$DONE")"
  exit 0
fi
if [[ -f "$SKIP" ]]; then
  echo "[r2x-premerge] already skipped: $(cat "$SKIP")"
  exit 0
fi

echo "[r2x-premerge] waiting for awesome-v8 prefetch $PREFETCH_DONE"
for i in $(seq 1 2880); do
  if [[ -f "$PREFETCH_DONE" ]]; then
    echo "[r2x-premerge] prefetch ready: $(cat "$PREFETCH_DONE")"
    break
  fi
  if (( i % 12 == 0 )); then
    crumb=$(tail -n 2 /root/logs/r2_prefetch_awesome_v8.log 2>/dev/null | tr '\r' '\n' | tail -1 || true)
    echo "[r2x-premerge] wait-prefetch iter=$i crumb=${crumb:-none}"
  fi
  if (( i == 2880 )); then
    echo "SKIP $(date -u +%Y-%m-%dT%H:%M:%SZ) awesome-v8 prefetch TIMEOUT" | tee "$SKIP"
    exit 2
  fi
  sleep 10
done

echo "[r2x-premerge] waiting for Reason stamp $REASON_JSON (+ $REASON_DONE)"
for i in $(seq 1 2880); do
  if [[ -f "$REASON_JSON" && -f "$REASON_DONE" ]]; then
    break
  fi
  if (( i % 12 == 0 )); then
    echo "[r2x-premerge] wait-reason iter=$i still no chal-00462 Reason stamp"
  fi
  sleep 10
done
if [[ ! -f "$REASON_JSON" || ! -f "$REASON_DONE" ]]; then
  echo "[r2x-premerge] TIMEOUT waiting for chal-00462 Reason" | tee "$SKIP"
  exit 2
fi

# shellcheck disable=SC1091
source /root/venv/bin/activate

GATE_LINE=$(python - <<'PY'
import json
from pathlib import Path
d = json.loads(Path("/root/affine_data/chal00462_reason.json").read_text())
hr = d.get("headroom_vs_3se")
km = bool(d.get("king_match"))
ok = km and hr is not None and float(hr) > 0.0
print(
    f"hr={hr} king_match={km} margin={d.get('reason_margin')} "
    f"repo={d.get('challenger_repo')} rev={d.get('challenger_revision')} ok={ok}"
)
Path("/tmp/r2x_gate_ok").write_text("1\n" if ok else "0\n")
PY
)
echo "[r2x-premerge] gate: $GATE_LINE"
if [[ "$(cat /tmp/r2x_gate_ok)" != "1" ]]; then
  echo "SKIP $(date -u +%Y-%m-%dT%H:%M:%SZ) Reason-or-mismatch ${GATE_LINE} — no Talent×awesome-v8 merge" | tee "$SKIP"
  exit 0
fi

W_TALENT=${W_TALENT:-0.25}
W_V8=${W_V8:-0.75}
TALENT_REV=dbfbb3e2a17c7603e7fc68a3a15b343f42dfdef4
V8_REV=${V8_REV:-6c04b16d461d429f9e288508e92f9e42322baec6}

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
  echo "[r2x-premerge] FATAL missing TalentPigs" >&2
  exit 2
}
V8=$(resolve_snap 0pentensor/Affine-5dflhtkufw-awesome-v8 "$V8_REV") || {
  echo "[r2x-premerge] FATAL missing awesome-v8" >&2
  exit 2
}

rm -rf "$MERGED"
mkdir -p "$MERGED"
echo "[r2x-premerge] α-merge Talent:$W_TALENT awesome-v8:$W_V8 → $MERGED"
python /root/mining_src/r2-multiking-merge/merge_alpha.py \
  --parent "${TALENT}:${W_TALENT}" \
  --parent "${V8}:${W_V8}" \
  --out "$MERGED"

META=""
if [[ -f "$MERGED/merge_alpha_meta.json" ]]; then
  META=$(python - <<'PY'
import json
from pathlib import Path
d=json.loads(Path("/root/r2_out/alpha_talent_awesome_v8_skew/merge_alpha_meta.json").read_text())
print(f"max_abs_delta={d.get('max_abs_delta')} n_keys={d.get('n_keys')} identical_frac={d.get('identical_frac')}")
PY
)
  cp -f "$MERGED/merge_alpha_meta.json" /root/affine_data/r2x_talent_awesome_v8_merge_alpha_meta.json
fi
echo "OK $(date -u +%Y-%m-%dT%H:%M:%SZ) w_talent=$W_TALENT w_v8=$W_V8 ${META}" | tee "$DONE"
echo "[r2x-premerge] DONE $(date -u +%Y-%m-%dT%H:%M:%SZ)"
