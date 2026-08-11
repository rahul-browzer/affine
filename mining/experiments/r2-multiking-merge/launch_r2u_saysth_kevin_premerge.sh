#!/usr/bin/env bash
# R2u: CPU skew-α merge saysth/…-v9a (live Reason+ hr≈0.73×) ×
# kevin954 reign-2 SFT (layout donor = saysth). Safe during R2t GPU n80
# (CPU/RAM only). kevin×awesome was WEAK (Δ≪0.01); saysth is a real
# distinct parent (Talent×saysth Δ≈0.21) so expect Δ≫0.01.
# n80 bar later: ≥ 1.5×(3·SE). WEAK_SKIP if max_abs_delta ≪ 0.01.
set -euo pipefail
LOG=/root/logs/r2u_premerge.log
DONE=/root/logs/r2u_premerge.done
PIDF=/root/logs/r2u_premerge.pid
SKIP=/root/logs/r2u_premerge.skip
MERGED=${MERGED:-/root/r2_out/alpha_saysth_kevin_skew}
mkdir -p /root/logs /root/r2_out /root/affine_data
echo $$ >"$PIDF"
exec > >(tee -a "$LOG") 2>&1

echo "[r2u-premerge] $(date -u +%Y-%m-%dT%H:%M:%SZ) start"
if [[ -f "$DONE" && -f "$MERGED/model.safetensors.index.json" ]]; then
  echo "[r2u-premerge] already done: $(cat "$DONE")"
  exit 0
fi
if [[ -f "$SKIP" ]]; then
  echo "[r2u-premerge] already skipped: $(cat "$SKIP")"
  exit 0
fi

# shellcheck disable=SC1091
source /root/venv/bin/activate

W_SAYSTH=${W_SAYSTH:-0.75}
W_KEVIN=${W_KEVIN:-0.25}
SAYSTH_REV=${SAYSTH_REV:-6e13f365b36000cf631aad2fa9fb05fdabae0044}
KEVIN_REV=${KEVIN_REV:-6a5815fad8f4e34c983b1933c1fae5762fe25220}

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
  echo "[r2u-premerge] FATAL missing saysth v9a" >&2
  exit 2
}
KEVIN=$(resolve_snap kevin954/Affine-5dfqbbh8ev-sft "$KEVIN_REV") || {
  echo "[r2u-premerge] FATAL missing kevin954 sft" >&2
  exit 2
}

rm -rf "$MERGED"
mkdir -p "$MERGED"
echo "[r2u-premerge] α-merge saysth:$W_SAYSTH kevin:$W_KEVIN → $MERGED"
python /root/mining_src/r2-multiking-merge/merge_alpha.py \
  --parent "${SAYSTH}:${W_SAYSTH}" \
  --parent "${KEVIN}:${W_KEVIN}" \
  --out "$MERGED"

META=""
if [[ -f "$MERGED/merge_alpha_meta.json" ]]; then
  META=$(python - <<'PY'
import json
from pathlib import Path
d=json.loads(Path("/root/r2_out/alpha_saysth_kevin_skew/merge_alpha_meta.json").read_text())
print(f"max_abs_delta={d.get('max_abs_delta')} n_keys={d.get('n_keys')} identical_frac={d.get('identical_frac')}")
PY
)
  cp -f "$MERGED/merge_alpha_meta.json" /root/affine_data/r2u_saysth_kevin_merge_alpha_meta.json
fi
echo "OK $(date -u +%Y-%m-%dT%H:%M:%SZ) w_saysth=$W_SAYSTH w_kevin=$W_KEVIN ${META}" | tee "$DONE"
echo "[r2u-premerge] DONE $(date -u +%Y-%m-%dT%H:%M:%SZ)"
