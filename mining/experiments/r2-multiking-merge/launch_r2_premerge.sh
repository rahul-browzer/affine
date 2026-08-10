#!/usr/bin/env bash
# Overlap CPU α-merge with R1 train/n80: wait prefetch → merge → stamp.
# Does NOT touch GPUs, vLLM engines, or chall. Safe while R1 owns 6–7.
set -euo pipefail
LOG=/root/logs/r2_premerge.log
DONE=/root/logs/r2_premerge.done
PREFETCH_DONE=${PREFETCH_DONE:-/root/logs/r2_prefetch_parents.done}
MERGED=${MERGED:-/root/r2_out/alpha_tok_talent_kevin}
mkdir -p /root/logs /root/r2_out
exec > >(tee -a "$LOG") 2>&1

echo "[r2-premerge] $(date -u +%Y-%m-%dT%H:%M:%SZ) start"
if [[ -f "$DONE" && -f "$MERGED/model.safetensors.index.json" ]]; then
  echo "[r2-premerge] already done: $(cat "$DONE")"
  exit 0
fi

W_TOK=${W_TOK:-1}
W_TALENT=${W_TALENT:-1}
W_KEVIN=${W_KEVIN:-1}
TOK_REV=eb8bf9a356a254f71faaa439e8abc3cfba572c53
TALENT_REV=dbfbb3e2a17c7603e7fc68a3a15b343f42dfdef4
KEVIN_REV=6a5815fad8f4e34c983b1933c1fae5762fe25220

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
    echo "[r2-premerge] prefetch done at iter=$i $(date -u +%Y-%m-%dT%H:%M:%SZ)"
    break
  fi
  if (( i % 12 == 0 )); then
    crumb=$(tail -n 3 /root/logs/r2_prefetch_parents.log 2>/dev/null | tr '\r' '\n' | tail -1 || true)
    echo "[r2-premerge] wait-prefetch iter=$i crumb=${crumb:-none}"
  fi
  if (( i == 2160 )); then
    echo "[r2-premerge] TIMEOUT prefetch" >&2
    exit 2
  fi
  sleep 10
done

# shellcheck disable=SC1091
source /root/venv/bin/activate

TOK=$(resolve_snap Tok331102/affine-5EqYW8McUc-af10 "$TOK_REV") || {
  echo "[r2-premerge] FATAL missing Tok" >&2
  exit 2
}
TALENT=$(resolve_snap TalentPigs/affine-5ekxlcg3fx-abc "$TALENT_REV") || {
  echo "[r2-premerge] FATAL missing TalentPigs" >&2
  exit 2
}
KEVIN=$(resolve_snap kevin954/Affine-5dfqbbh8ev-sft "$KEVIN_REV") || {
  echo "[r2-premerge] FATAL missing kevin954" >&2
  exit 2
}

rm -rf "$MERGED"
mkdir -p "$MERGED"
echo "[r2-premerge] α-merge Tok:$W_TOK Talent:$W_TALENT Kevin:$W_KEVIN → $MERGED"
python /root/mining_src/r2-multiking-merge/merge_alpha.py \
  --parent "${TOK}:${W_TOK}" \
  --parent "${TALENT}:${W_TALENT}" \
  --parent "${KEVIN}:${W_KEVIN}" \
  --out "$MERGED"

META=""
if [[ -f "$MERGED/merge_meta.json" ]]; then
  META=$(python - <<'PY'
import json
from pathlib import Path
d=json.loads(Path("/root/r2_out/alpha_tok_talent_kevin/merge_meta.json").read_text())
print(f"max_abs_delta={d.get('max_abs_delta')} n_keys={d.get('n_keys')}")
PY
)
fi
echo "OK $(date -u +%Y-%m-%dT%H:%M:%SZ) ${META}" | tee "$DONE"
echo "[r2-premerge] DONE $(date -u +%Y-%m-%dT%H:%M:%SZ)"
