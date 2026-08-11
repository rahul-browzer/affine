#!/usr/bin/env bash
# R2t: CPU skew-α merge saysth/…-v9a (live Reason+ hr≈0.73×) ×
# TalentPigs reign-3 (layout donor = saysth). Inverse of R2g
# (Talent0.25×saysth0.75, Talent layout) which REFUTED at hr −0.89×.
# Hypothesis: saysth-native layout keeps the parent Reason+ signal that
# Talent-as-donor destroyed. Safe during R2q GPU n80 (CPU/RAM only).
# n80 bar later: ≥ 1.5×(3·SE). WEAK_SKIP if max_abs_delta ≪ 0.01.
set -euo pipefail
LOG=/root/logs/r2t_premerge.log
DONE=/root/logs/r2t_premerge.done
PIDF=/root/logs/r2t_premerge.pid
SKIP=/root/logs/r2t_premerge.skip
MERGED=${MERGED:-/root/r2_out/alpha_saysth_talent_skew}
mkdir -p /root/logs /root/r2_out /root/affine_data
echo $$ >"$PIDF"
exec > >(tee -a "$LOG") 2>&1

echo "[r2t-premerge] $(date -u +%Y-%m-%dT%H:%M:%SZ) start"
if [[ -f "$DONE" && -f "$MERGED/model.safetensors.index.json" ]]; then
  echo "[r2t-premerge] already done: $(cat "$DONE")"
  exit 0
fi
if [[ -f "$SKIP" ]]; then
  echo "[r2t-premerge] already skipped: $(cat "$SKIP")"
  exit 0
fi

# shellcheck disable=SC1091
source /root/venv/bin/activate

W_SAYSTH=${W_SAYSTH:-0.75}
W_TALENT=${W_TALENT:-0.25}
SAYSTH_REV=${SAYSTH_REV:-6e13f365b36000cf631aad2fa9fb05fdabae0044}
TALENT_REV=${TALENT_REV:-dbfbb3e2a17c7603e7fc68a3a15b343f42dfdef4}

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
  echo "[r2t-premerge] FATAL missing saysth v9a" >&2
  exit 2
}
TALENT=$(resolve_snap TalentPigs/affine-5ekxlcg3fx-abc "$TALENT_REV") || {
  echo "[r2t-premerge] FATAL missing TalentPigs" >&2
  exit 2
}

rm -rf "$MERGED"
mkdir -p "$MERGED"
echo "[r2t-premerge] α-merge saysth:$W_SAYSTH talent:$W_TALENT → $MERGED"
python /root/mining_src/r2-multiking-merge/merge_alpha.py \
  --parent "${SAYSTH}:${W_SAYSTH}" \
  --parent "${TALENT}:${W_TALENT}" \
  --out "$MERGED"

META=""
if [[ -f "$MERGED/merge_alpha_meta.json" ]]; then
  META=$(python - <<'PY'
import json
from pathlib import Path
d=json.loads(Path("/root/r2_out/alpha_saysth_talent_skew/merge_alpha_meta.json").read_text())
print(f"max_abs_delta={d.get('max_abs_delta')} n_keys={d.get('n_keys')} identical_frac={d.get('identical_frac')}")
PY
)
  cp -f "$MERGED/merge_alpha_meta.json" /root/affine_data/r2t_saysth_talent_merge_alpha_meta.json
fi
echo "OK $(date -u +%Y-%m-%dT%H:%M:%SZ) w_saysth=$W_SAYSTH w_talent=$W_TALENT ${META}" | tee "$DONE"
echo "[r2t-premerge] DONE $(date -u +%Y-%m-%dT%H:%M:%SZ)"
