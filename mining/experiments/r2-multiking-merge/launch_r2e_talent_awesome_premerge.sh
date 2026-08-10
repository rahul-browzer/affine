#!/usr/bin/env bash
# R2e: CPU skew-α merge TalentPigs (reign-3) × awesome-v6 (best Reason near-miss).
# Tok×awesome equal/skew only moved Δ≈0.006–0.009 (near-identical). Talent is a
# distinct crowned parent already cached — expect larger Δ and a non-Tok base.
# Layout donor = Talent (first --parent). Safe during R1c/R2*/GPU n80.
# Pre-registered n80 bar later: submit only if headroom ≥ 1.5×(3·SE).
set -euo pipefail
LOG=/root/logs/r2e_premerge.log
DONE=/root/logs/r2e_premerge.done
PIDF=/root/logs/r2e_premerge.pid
MERGED=${MERGED:-/root/r2_out/alpha_talent_awesome_v6_skew}
mkdir -p /root/logs /root/r2_out
echo $$ >"$PIDF"
exec > >(tee -a "$LOG") 2>&1

echo "[r2e-premerge] $(date -u +%Y-%m-%dT%H:%M:%SZ) start"
if [[ -f "$DONE" && -f "$MERGED/model.safetensors.index.json" ]]; then
  echo "[r2e-premerge] already done: $(cat "$DONE")"
  exit 0
fi

W_TALENT=${W_TALENT:-0.25}
W_AWESOME=${W_AWESOME:-0.75}
TALENT_REV=dbfbb3e2a17c7603e7fc68a3a15b343f42dfdef4
AWESOME_REV=f479a24d452f1ca312d828acd668a4b1d8de0d8f

resolve_snap() {
  local repo="$1" rev="$2"
  local d="/root/hf/hub/models--${repo//\//--}/snapshots/${rev}"
  if [[ -d "$d" && -f "$d/model.safetensors.index.json" ]]; then
    echo "$d"
    return 0
  fi
  return 1
}

# shellcheck disable=SC1091
source /root/venv/bin/activate

TALENT=$(resolve_snap TalentPigs/affine-5ekxlcg3fx-abc "$TALENT_REV") || {
  echo "[r2e-premerge] FATAL missing TalentPigs" >&2
  exit 2
}
AWESOME=$(resolve_snap 0pentensor/Affine-5dflhtkufw-awesome-v6 "$AWESOME_REV") || {
  echo "[r2e-premerge] FATAL missing awesome-v6" >&2
  exit 2
}

rm -rf "$MERGED"
mkdir -p "$MERGED"
echo "[r2e-premerge] α-merge Talent:$W_TALENT awesome-v6:$W_AWESOME → $MERGED"
python /root/mining_src/r2-multiking-merge/merge_alpha.py \
  --parent "${TALENT}:${W_TALENT}" \
  --parent "${AWESOME}:${W_AWESOME}" \
  --out "$MERGED"

META=""
if [[ -f "$MERGED/merge_alpha_meta.json" ]]; then
  META=$(python - <<'PY'
import json
from pathlib import Path
d=json.loads(Path("/root/r2_out/alpha_talent_awesome_v6_skew/merge_alpha_meta.json").read_text())
print(f"max_abs_delta={d.get('max_abs_delta')} n_keys={d.get('n_keys')} identical_frac={d.get('identical_frac')}")
PY
)
fi
echo "OK $(date -u +%Y-%m-%dT%H:%M:%SZ) w_talent=$W_TALENT w_awesome=$W_AWESOME ${META}" | tee "$DONE"
echo "[r2e-premerge] DONE $(date -u +%Y-%m-%dT%H:%M:%SZ)"
