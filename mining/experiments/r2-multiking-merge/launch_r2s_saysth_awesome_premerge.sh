#!/usr/bin/env bash
# R2s: CPU skew-α merge saysth/…-v9a (live Reason+ hr≈0.73×) ×
# 0pentensor/…-awesome-v6 (recomputed Reason hr≈0.74× vs Tok; R2d pure
# transfer was only 0.22×). Layout donor = saysth (first --parent).
# Safe during R2q GPU n80 (CPU/RAM only). n80 bar later: ≥ 1.5×(3·SE).
# Talent×saysth REFUTED (−0.89×); this blends the two best DL Reason+ parents.
set -euo pipefail
LOG=/root/logs/r2s_premerge.log
DONE=/root/logs/r2s_premerge.done
PIDF=/root/logs/r2s_premerge.pid
SKIP=/root/logs/r2s_premerge.skip
MERGED=${MERGED:-/root/r2_out/alpha_saysth_awesome_skew}
mkdir -p /root/logs /root/r2_out /root/affine_data
echo $$ >"$PIDF"
exec > >(tee -a "$LOG") 2>&1

echo "[r2s-premerge] $(date -u +%Y-%m-%dT%H:%M:%SZ) start"
if [[ -f "$DONE" && -f "$MERGED/model.safetensors.index.json" ]]; then
  echo "[r2s-premerge] already done: $(cat "$DONE")"
  exit 0
fi
if [[ -f "$SKIP" ]]; then
  echo "[r2s-premerge] already skipped: $(cat "$SKIP")"
  exit 0
fi

# shellcheck disable=SC1091
source /root/venv/bin/activate

W_SAYSTH=${W_SAYSTH:-0.75}
W_AWESOME=${W_AWESOME:-0.25}
SAYSTH_REV=${SAYSTH_REV:-6e13f365b36000cf631aad2fa9fb05fdabae0044}
AWESOME_REV=${AWESOME_REV:-f479a24d452f1ca312d828acd668a4b1d8de0d8f}

resolve_snap() {
  local repo="$1" rev="$2"
  local d="/root/hf/hub/models--${repo//\//--}/snapshots/${rev}"
  if [[ -d "$d" && -f "$d/model.safetensors.index.json" ]]; then
    echo "$d"
    return 0
  fi
  return 1
}

SAYSTH=$(resolve_snap saysth/Affine-5dtnxamt4t-v9a "$SAYSTH_REV") || {
  echo "[r2s-premerge] FATAL missing saysth v9a" >&2
  exit 2
}
AWESOME=$(resolve_snap 0pentensor/Affine-5dflhtkufw-awesome-v6 "$AWESOME_REV") || {
  echo "[r2s-premerge] FATAL missing awesome-v6" >&2
  exit 2
}

rm -rf "$MERGED"
mkdir -p "$MERGED"
echo "[r2s-premerge] α-merge saysth:$W_SAYSTH awesome:$W_AWESOME → $MERGED"
python /root/mining_src/r2-multiking-merge/merge_alpha.py \
  --parent "${SAYSTH}:${W_SAYSTH}" \
  --parent "${AWESOME}:${W_AWESOME}" \
  --out "$MERGED"

META=""
if [[ -f "$MERGED/merge_alpha_meta.json" ]]; then
  META=$(python - <<'PY'
import json
from pathlib import Path
d=json.loads(Path("/root/r2_out/alpha_saysth_awesome_skew/merge_alpha_meta.json").read_text())
print(f"max_abs_delta={d.get('max_abs_delta')} n_keys={d.get('n_keys')} identical_frac={d.get('identical_frac')}")
PY
)
  cp -f "$MERGED/merge_alpha_meta.json" /root/affine_data/r2s_saysth_awesome_merge_alpha_meta.json
fi
echo "OK $(date -u +%Y-%m-%dT%H:%M:%SZ) w_saysth=$W_SAYSTH w_awesome=$W_AWESOME ${META}" | tee "$DONE"
echo "[r2s-premerge] DONE $(date -u +%Y-%m-%dT%H:%M:%SZ)"
