#!/usr/bin/env bash
# R2f: CPU skew-α merge kevin954 (reign-2) × awesome-v6 (best Reason near-miss).
# Talent×awesome (R2e) is already queued after R2d; kevin is the other crowned
# parent already cached on crown — distinct base, expect large Δ like R2e (0.626).
# Layout donor = kevin (first --parent). Safe during R2d/R2e GPU n80.
# Pre-registered n80 bar later: submit only if headroom ≥ 1.5×(3·SE).
set -euo pipefail
LOG=/root/logs/r2f_premerge.log
DONE=/root/logs/r2f_premerge.done
PIDF=/root/logs/r2f_premerge.pid
MERGED=${MERGED:-/root/r2_out/alpha_kevin_awesome_v6_skew}
mkdir -p /root/logs /root/r2_out
echo $$ >"$PIDF"
exec > >(tee -a "$LOG") 2>&1

echo "[r2f-premerge] $(date -u +%Y-%m-%dT%H:%M:%SZ) start"
if [[ -f "$DONE" && -f "$MERGED/model.safetensors.index.json" ]]; then
  echo "[r2f-premerge] already done: $(cat "$DONE")"
  exit 0
fi

W_KEVIN=${W_KEVIN:-0.25}
W_AWESOME=${W_AWESOME:-0.75}
KEVIN_REV=6a5815fad8f4e34c983b1933c1fae5762fe25220
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

KEVIN=$(resolve_snap kevin954/Affine-5dfqbbh8ev-sft "$KEVIN_REV") || {
  echo "[r2f-premerge] FATAL missing kevin954" >&2
  exit 2
}
AWESOME=$(resolve_snap 0pentensor/Affine-5dflhtkufw-awesome-v6 "$AWESOME_REV") || {
  echo "[r2f-premerge] FATAL missing awesome-v6" >&2
  exit 2
}

rm -rf "$MERGED"
mkdir -p "$MERGED"
echo "[r2f-premerge] α-merge kevin:$W_KEVIN awesome-v6:$W_AWESOME → $MERGED"
python /root/mining_src/r2-multiking-merge/merge_alpha.py \
  --parent "${KEVIN}:${W_KEVIN}" \
  --parent "${AWESOME}:${W_AWESOME}" \
  --out "$MERGED"

META=""
if [[ -f "$MERGED/merge_alpha_meta.json" ]]; then
  META=$(python - <<'PY'
import json
from pathlib import Path
d=json.loads(Path("/root/r2_out/alpha_kevin_awesome_v6_skew/merge_alpha_meta.json").read_text())
print(f"max_abs_delta={d.get('max_abs_delta')} n_keys={d.get('n_keys')} identical_frac={d.get('identical_frac')}")
PY
)
fi
echo "OK $(date -u +%Y-%m-%dT%H:%M:%SZ) w_kevin=$W_KEVIN w_awesome=$W_AWESOME ${META}" | tee "$DONE"
# local mirror of meta for harvest
cp -f "$MERGED/merge_alpha_meta.json" /root/affine_data/r2f_kevin_awesome_merge_alpha_meta.json 2>/dev/null || true
echo "[r2f-premerge] DONE $(date -u +%Y-%m-%dT%H:%M:%SZ)"
