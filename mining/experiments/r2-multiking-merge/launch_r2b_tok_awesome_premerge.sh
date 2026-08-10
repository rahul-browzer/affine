#!/usr/bin/env bash
# R2b: CPU equal-α merge Tok af10 × 0pentensor awesome-v6 (best Reason near-miss).
# Waits for nearmiss prefetch. Does NOT touch GPUs / vLLM / chall.
# Pre-registered decision (n80 later): submit only if headroom ≥ 1.5×(3·SE).
# Evidence: chal-00425 Reason m=+0.0108 z=+2.75 hr≈0.92× (p1885 lpC recompute).
set -euo pipefail
LOG=/root/logs/r2b_premerge.log
DONE=/root/logs/r2b_premerge.done
PIDF=/root/logs/r2b_premerge.pid
PREFETCH_DONE=${PREFETCH_DONE:-/root/logs/r2_prefetch_nearmiss.done}
MERGED=${MERGED:-/root/r2_out/alpha_tok_awesome_v6}
mkdir -p /root/logs /root/r2_out
echo $$ >"$PIDF"
exec > >(tee -a "$LOG") 2>&1

echo "[r2b-premerge] $(date -u +%Y-%m-%dT%H:%M:%SZ) start"
if [[ -f "$DONE" && -f "$MERGED/model.safetensors.index.json" ]]; then
  echo "[r2b-premerge] already done: $(cat "$DONE")"
  exit 0
fi

W_TOK=${W_TOK:-1}
W_AWESOME=${W_AWESOME:-1}
TOK_REV=eb8bf9a356a254f71faaa439e8abc3cfba572c53
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

for i in $(seq 1 2160); do
  if [[ -f "$PREFETCH_DONE" ]]; then
    echo "[r2b-premerge] prefetch done at iter=$i $(date -u +%Y-%m-%dT%H:%M:%SZ)"
    break
  fi
  if (( i % 12 == 0 )); then
    crumb=$(tail -n 3 /root/logs/r2_prefetch_nearmiss.log 2>/dev/null | tr '\r' '\n' | tail -1 || true)
    echo "[r2b-premerge] wait-prefetch iter=$i crumb=${crumb:-none}"
  fi
  if (( i == 2160 )); then
    echo "[r2b-premerge] TIMEOUT prefetch" >&2
    exit 2
  fi
  sleep 10
done

# shellcheck disable=SC1091
source /root/venv/bin/activate

TOK=$(resolve_snap Tok331102/affine-5EqYW8McUc-af10 "$TOK_REV") || {
  echo "[r2b-premerge] FATAL missing Tok" >&2
  exit 2
}
AWESOME=$(resolve_snap 0pentensor/Affine-5dflhtkufw-awesome-v6 "$AWESOME_REV") || {
  echo "[r2b-premerge] FATAL missing awesome-v6" >&2
  exit 2
}

rm -rf "$MERGED"
mkdir -p "$MERGED"
echo "[r2b-premerge] α-merge Tok:$W_TOK awesome-v6:$W_AWESOME → $MERGED"
python /root/mining_src/r2-multiking-merge/merge_alpha.py \
  --parent "${TOK}:${W_TOK}" \
  --parent "${AWESOME}:${W_AWESOME}" \
  --out "$MERGED"

META=""
if [[ -f "$MERGED/merge_alpha_meta.json" ]]; then
  META=$(python - <<'PY'
import json
from pathlib import Path
d=json.loads(Path("/root/r2_out/alpha_tok_awesome_v6/merge_alpha_meta.json").read_text())
print(f"max_abs_delta={d.get('max_abs_delta')} n_keys={d.get('n_keys')} identical_frac={d.get('identical_frac')}")
PY
)
fi
echo "OK $(date -u +%Y-%m-%dT%H:%M:%SZ) ${META}" | tee "$DONE"
echo "[r2b-premerge] DONE $(date -u +%Y-%m-%dT%H:%M:%SZ)"
