#!/usr/bin/env bash
# R2ab: CPU skew-α merge TalentPigs (reign-3) × magicworld7/…-sky (queue chal-00469).
# p1974: wait R2aa eager (disk) + sky prefetch, then EAGER weights,
# gate r2ab_premerge.done on chal00469_reason.json Reason+ (hr>0).
# Do NOT stamp DONE before Reason+ (merge_reload would steal chall).
# On Reason− / mismatch: SKIP + purge blend. Layout donor = Talent (first --parent).
# Safe during R2p GPU work (CPU/RAM only). n80 bar later: ≥ 1.5×(3·SE).
set -euo pipefail
LOG=/root/logs/r2ab_premerge.log
DONE=/root/logs/r2ab_premerge.done
PIDF=/root/logs/r2ab_premerge.pid
SKIP=/root/logs/r2ab_premerge.skip
EAGER=/root/logs/r2ab_eager_weights.done
REASON_JSON=${REASON_JSON:-/root/affine_data/chal00469_reason.json}
REASON_DONE=${REASON_DONE:-/root/logs/watch_chal00469_reason.done}
PREFETCH_DONE=${PREFETCH_DONE:-/root/logs/r2_prefetch_sky.done}
R2AA_EAGER=${R2AA_EAGER:-/root/logs/r2aa_eager_weights.done}
MERGED=${MERGED:-/root/r2_out/alpha_talent_sky_skew}
mkdir -p /root/logs /root/r2_out /root/affine_data
echo $$ >"$PIDF"
exec > >(tee -a "$LOG") 2>&1

echo "[r2ab-premerge] $(date -u +%Y-%m-%dT%H:%M:%SZ) start (eager-weights after R2aa)"
if [[ -f "$DONE" && -f "$MERGED/model.safetensors.index.json" ]]; then
  echo "[r2ab-premerge] already done: $(cat "$DONE")"
  exit 0
fi
if [[ -f "$SKIP" ]]; then
  echo "[r2ab-premerge] already skipped: $(cat "$SKIP")"
  exit 0
fi

echo "[r2ab-premerge] waiting for sky prefetch $PREFETCH_DONE"
for i in $(seq 1 2880); do
  if [[ -f "$PREFETCH_DONE" ]]; then
    echo "[r2ab-premerge] prefetch ready: $(cat "$PREFETCH_DONE")"
    break
  fi
  if (( i % 12 == 0 )); then
    crumb=$(tail -n 2 /root/logs/r2_prefetch_sky.log 2>/dev/null | tr '\r' '\n' | tail -1 || true)
    echo "[r2ab-premerge] wait-prefetch iter=$i crumb=${crumb:-none}"
  fi
  if (( i == 2880 )); then
    echo "SKIP $(date -u +%Y-%m-%dT%H:%M:%SZ) sky prefetch TIMEOUT" | tee "$SKIP"
    exit 2
  fi
  sleep 10
done

# Serialize blends: R2aa must finish writing ~65 GiB before we claim another ~75 GiB.
echo "[r2ab-premerge] waiting for R2aa eager $R2AA_EAGER (disk serialize)"
for i in $(seq 1 2880); do
  if [[ -f "$R2AA_EAGER" ]]; then
    echo "[r2ab-premerge] R2aa eager ready: $(cat "$R2AA_EAGER")"
    break
  fi
  if (( i % 12 == 0 )); then
    crumb=$(tail -n 2 /root/logs/r2aa_premerge.log 2>/dev/null | tr '\r' '\n' | tail -1 || true)
    echo "[r2ab-premerge] wait-r2aa-eager iter=$i crumb=${crumb:-none}"
  fi
  if (( i == 2880 )); then
    echo "SKIP $(date -u +%Y-%m-%dT%H:%M:%SZ) R2aa eager TIMEOUT" | tee "$SKIP"
    exit 2
  fi
  sleep 10
done

W_TALENT=${W_TALENT:-0.25}
W_SKY=${W_SKY:-0.75}
TALENT_REV=dbfbb3e2a17c7603e7fc68a3a15b343f42dfdef4
SKY_REV=${SKY_REV:-a569e29bcab3a1f4ed3a99ee9e46c17dc40e8fdf}

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

if [[ -f "$EAGER" && -f "$MERGED/model.safetensors.index.json" ]]; then
  echo "[r2ab-premerge] eager weights already present: $(cat "$EAGER")"
else
  TALENT=$(resolve_snap TalentPigs/affine-5ekxlcg3fx-abc "$TALENT_REV") || {
    echo "[r2ab-premerge] FATAL missing TalentPigs" >&2
    exit 2
  }
  SKY=$(resolve_snap magicworld7/affine-5dtu4gucst-sky "$SKY_REV") || {
    echo "[r2ab-premerge] FATAL missing sky" >&2
    exit 2
  }

  # Never clobber a live chall symlink target.
  MERGED_REAL=$(readlink -f "$MERGED" 2>/dev/null || echo "$MERGED")
  for link in /tmp/r2*_merged /tmp/r2*_alpha_merged; do
    [[ -e "$link" || -L "$link" ]] || continue
    L=$(readlink -f "$link" 2>/dev/null || true)
    if [[ -n "${L:-}" && "$L" == "$MERGED_REAL" ]]; then
      echo "[r2ab-premerge] FATAL $MERGED is live chall target via $link ($L)" >&2
      exit 2
    fi
  done

  FREE_K=$(df -Pk /root | awk 'NR==2{print $4}')
  if (( FREE_K < 75000000 )); then
    echo "SKIP $(date -u +%Y-%m-%dT%H:%M:%SZ) low disk free_kb=$FREE_K need≥75GiB" | tee "$SKIP"
    exit 2
  fi

  rm -rf "$MERGED"
  mkdir -p "$MERGED"
  echo "[r2ab-premerge] EAGER α-merge Talent:$W_TALENT sky:$W_SKY → $MERGED"
  python /root/mining_src/r2-multiking-merge/merge_alpha.py \
    --parent "${TALENT}:${W_TALENT}" \
    --parent "${SKY}:${W_SKY}" \
    --out "$MERGED"

  META=""
  if [[ -f "$MERGED/merge_alpha_meta.json" ]]; then
    META=$(python - <<'PY'
import json
from pathlib import Path
d=json.loads(Path("/root/r2_out/alpha_talent_sky_skew/merge_alpha_meta.json").read_text())
print(f"max_abs_delta={d.get('max_abs_delta')} n_keys={d.get('n_keys')} identical_frac={d.get('identical_frac')}")
PY
)
    cp -f "$MERGED/merge_alpha_meta.json" /root/affine_data/r2ab_talent_sky_merge_alpha_meta.json
  fi
  echo "EAGER $(date -u +%Y-%m-%dT%H:%M:%SZ) w_talent=$W_TALENT w_sky=$W_SKY ${META}" | tee "$EAGER"
  cp -f "$EAGER" /root/affine_data/r2ab_eager_weights.done
fi

echo "[r2ab-premerge] waiting for Reason stamp $REASON_JSON (+ $REASON_DONE) before DONE"
for i in $(seq 1 2880); do
  if [[ -f "$REASON_JSON" && -f "$REASON_DONE" ]]; then
    break
  fi
  if (( i % 12 == 0 )); then
    echo "[r2ab-premerge] wait-reason iter=$i (weights ready; no DONE yet)"
  fi
  sleep 10
done
if [[ ! -f "$REASON_JSON" || ! -f "$REASON_DONE" ]]; then
  echo "SKIP $(date -u +%Y-%m-%dT%H:%M:%SZ) TIMEOUT waiting for chal-00469 Reason — purge eager blend" | tee "$SKIP"
  rm -rf "$MERGED"
  exit 2
fi

GATE_LINE=$(python - <<'PY'
import json
from pathlib import Path
d = json.loads(Path("/root/affine_data/chal00469_reason.json").read_text())
hr = d.get("headroom_vs_3se")
km = bool(d.get("king_match"))
ok = km and hr is not None and float(hr) > 0.0
print(
    f"hr={hr} king_match={km} margin={d.get('reason_margin')} "
    f"repo={d.get('challenger_repo')} rev={d.get('challenger_revision')} ok={ok}"
)
Path("/tmp/r2ab_gate_ok").write_text("1\n" if ok else "0\n")
PY
)
echo "[r2ab-premerge] gate: $GATE_LINE"
if [[ "$(cat /tmp/r2ab_gate_ok)" != "1" ]]; then
  echo "SKIP $(date -u +%Y-%m-%dT%H:%M:%SZ) Reason-or-mismatch ${GATE_LINE} — purge eager Talent×sky" | tee "$SKIP"
  rm -rf "$MERGED"
  exit 0
fi

META=""
if [[ -f "$MERGED/merge_alpha_meta.json" ]]; then
  META=$(python - <<'PY'
import json
from pathlib import Path
d=json.loads(Path("/root/r2_out/alpha_talent_sky_skew/merge_alpha_meta.json").read_text())
print(f"max_abs_delta={d.get('max_abs_delta')} n_keys={d.get('n_keys')} identical_frac={d.get('identical_frac')}")
PY
)
fi
echo "OK $(date -u +%Y-%m-%dT%H:%M:%SZ) w_talent=$W_TALENT w_sky=$W_SKY ${META} ${GATE_LINE}" | tee "$DONE"
cp -f "$DONE" /root/affine_data/r2ab_premerge.done
echo "[r2ab-premerge] DONE $(date -u +%Y-%m-%dT%H:%M:%SZ)"
