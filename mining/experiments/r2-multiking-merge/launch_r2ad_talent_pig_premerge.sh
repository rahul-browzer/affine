#!/usr/bin/env bash
# R2ad: CPU skew-α merge TalentPigs (reign-3) × diceofgod/…-pig (queue chal-00471).
# p1977: wait R2ac eager (disk) + pig prefetch, then EAGER weights,
# gate r2ad_premerge.done on chal00471_reason.json Reason+ (hr>0).
# Do NOT stamp DONE before Reason+ (merge_reload would steal chall).
# On Reason− / mismatch: SKIP + purge blend. Layout donor = Talent (first --parent).
# Safe during sibling GPU waiters (CPU/RAM only). n80 bar later: ≥ 1.5×(3·SE).
set -euo pipefail
LOG=/root/logs/r2ad_premerge.log
DONE=/root/logs/r2ad_premerge.done
PIDF=/root/logs/r2ad_premerge.pid
SKIP=/root/logs/r2ad_premerge.skip
EAGER=/root/logs/r2ad_eager_weights.done
REASON_JSON=${REASON_JSON:-/root/affine_data/chal00471_reason.json}
REASON_DONE=${REASON_DONE:-/root/logs/watch_chal00471_reason.done}
PREFETCH_DONE=${PREFETCH_DONE:-/root/logs/r2_prefetch_pig.done}
R2AC_EAGER=${R2AC_EAGER:-/root/logs/r2ac_eager_weights.done}
MERGED=${MERGED:-/root/r2_out/alpha_talent_pig_skew}
mkdir -p /root/logs /root/r2_out /root/affine_data
echo $$ >"$PIDF"
exec > >(tee -a "$LOG") 2>&1

echo "[r2ad-premerge] $(date -u +%Y-%m-%dT%H:%M:%SZ) start (eager-weights after R2ac)"
if [[ -f "$DONE" && -f "$MERGED/model.safetensors.index.json" ]]; then
  echo "[r2ad-premerge] already done: $(cat "$DONE")"
  exit 0
fi
if [[ -f "$SKIP" ]]; then
  echo "[r2ad-premerge] already skipped: $(cat "$SKIP")"
  exit 0
fi

echo "[r2ad-premerge] waiting for pig prefetch $PREFETCH_DONE"
for i in $(seq 1 2880); do
  if [[ -f "$PREFETCH_DONE" ]]; then
    echo "[r2ad-premerge] prefetch ready: $(cat "$PREFETCH_DONE")"
    break
  fi
  if (( i % 12 == 0 )); then
    crumb=$(tail -n 2 /root/logs/r2_prefetch_pig.log 2>/dev/null | tr '\r' '\n' | tail -1 || true)
    echo "[r2ad-premerge] wait-prefetch iter=$i crumb=${crumb:-none}"
  fi
  if (( i == 2880 )); then
    echo "SKIP $(date -u +%Y-%m-%dT%H:%M:%SZ) pig prefetch TIMEOUT" | tee "$SKIP"
    exit 2
  fi
  sleep 10
done

# Serialize blends: R2ac must finish writing ~65 GiB before we claim another ~75 GiB.
echo "[r2ad-premerge] waiting for R2ac eager $R2AC_EAGER (disk serialize)"
for i in $(seq 1 2880); do
  if [[ -f "$R2AC_EAGER" ]]; then
    echo "[r2ad-premerge] R2ac eager ready: $(cat "$R2AC_EAGER")"
    break
  fi
  if (( i % 12 == 0 )); then
    crumb=$(tail -n 2 /root/logs/r2ac_premerge.log 2>/dev/null | tr '\r' '\n' | tail -1 || true)
    echo "[r2ad-premerge] wait-r2ab-eager iter=$i crumb=${crumb:-none}"
  fi
  if (( i == 2880 )); then
    echo "SKIP $(date -u +%Y-%m-%dT%H:%M:%SZ) R2ac eager TIMEOUT" | tee "$SKIP"
    exit 2
  fi
  sleep 10
done

W_TALENT=${W_TALENT:-0.25}
W_PIG=${W_PIG:-0.75}
TALENT_REV=dbfbb3e2a17c7603e7fc68a3a15b343f42dfdef4
PIG_REV=${PIG_REV:-e4889db406e743bc878d75183aed79bc59915463}

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
  echo "[r2ad-premerge] eager weights already present: $(cat "$EAGER")"
else
  TALENT=$(resolve_snap TalentPigs/affine-5ekxlcg3fx-abc "$TALENT_REV") || {
    echo "[r2ad-premerge] FATAL missing TalentPigs" >&2
    exit 2
  }
  PIG=$(resolve_snap diceofgod/affine-5fjgc5jhxq-pig "$PIG_REV") || {
    echo "[r2ad-premerge] FATAL missing pig" >&2
    exit 2
  }

  # Never clobber a live chall symlink target.
  MERGED_REAL=$(readlink -f "$MERGED" 2>/dev/null || echo "$MERGED")
  for link in /tmp/r2*_merged /tmp/r2*_alpha_merged; do
    [[ -e "$link" || -L "$link" ]] || continue
    L=$(readlink -f "$link" 2>/dev/null || true)
    if [[ -n "${L:-}" && "$L" == "$MERGED_REAL" ]]; then
      echo "[r2ad-premerge] FATAL $MERGED is live chall target via $link ($L)" >&2
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
  echo "[r2ad-premerge] EAGER α-merge Talent:$W_TALENT pig:$W_PIG → $MERGED"
  python /root/mining_src/r2-multiking-merge/merge_alpha.py \
    --parent "${TALENT}:${W_TALENT}" \
    --parent "${PIG}:${W_PIG}" \
    --out "$MERGED"

  META=""
  if [[ -f "$MERGED/merge_alpha_meta.json" ]]; then
    META=$(python - <<'PY'
import json
from pathlib import Path
d=json.loads(Path("/root/r2_out/alpha_talent_pig_skew/merge_alpha_meta.json").read_text())
print(f"max_abs_delta={d.get('max_abs_delta')} n_keys={d.get('n_keys')} identical_frac={d.get('identical_frac')}")
PY
)
    cp -f "$MERGED/merge_alpha_meta.json" /root/affine_data/r2ad_talent_pig_merge_alpha_meta.json
  fi
  echo "EAGER $(date -u +%Y-%m-%dT%H:%M:%SZ) w_talent=$W_TALENT w_pig=$W_PIG ${META}" | tee "$EAGER"
  cp -f "$EAGER" /root/affine_data/r2ad_eager_weights.done
fi

echo "[r2ad-premerge] waiting for Reason stamp $REASON_JSON (+ $REASON_DONE) before DONE"
for i in $(seq 1 2880); do
  if [[ -f "$REASON_JSON" && -f "$REASON_DONE" ]]; then
    break
  fi
  if (( i % 12 == 0 )); then
    echo "[r2ad-premerge] wait-reason iter=$i (weights ready; no DONE yet)"
  fi
  sleep 10
done
if [[ ! -f "$REASON_JSON" || ! -f "$REASON_DONE" ]]; then
  echo "SKIP $(date -u +%Y-%m-%dT%H:%M:%SZ) TIMEOUT waiting for chal-00471 Reason — purge eager blend" | tee "$SKIP"
  rm -rf "$MERGED"
  exit 2
fi

GATE_LINE=$(python - <<'PY'
import json
from pathlib import Path
d = json.loads(Path("/root/affine_data/chal00471_reason.json").read_text())
hr = d.get("headroom_vs_3se")
km = bool(d.get("king_match"))
ok = km and hr is not None and float(hr) > 0.0
print(
    f"hr={hr} king_match={km} margin={d.get('reason_margin')} "
    f"repo={d.get('challenger_repo')} rev={d.get('challenger_revision')} ok={ok}"
)
Path("/tmp/r2ad_gate_ok").write_text("1\n" if ok else "0\n")
PY
)
echo "[r2ad-premerge] gate: $GATE_LINE"
if [[ "$(cat /tmp/r2ad_gate_ok)" != "1" ]]; then
  echo "SKIP $(date -u +%Y-%m-%dT%H:%M:%SZ) Reason-or-mismatch ${GATE_LINE} — purge eager Talent×pig" | tee "$SKIP"
  rm -rf "$MERGED"
  exit 0
fi

META=""
if [[ -f "$MERGED/merge_alpha_meta.json" ]]; then
  META=$(python - <<'PY'
import json
from pathlib import Path
d=json.loads(Path("/root/r2_out/alpha_talent_pig_skew/merge_alpha_meta.json").read_text())
print(f"max_abs_delta={d.get('max_abs_delta')} n_keys={d.get('n_keys')} identical_frac={d.get('identical_frac')}")
PY
)
fi
echo "OK $(date -u +%Y-%m-%dT%H:%M:%SZ) w_talent=$W_TALENT w_pig=$W_PIG ${META} ${GATE_LINE}" | tee "$DONE"
cp -f "$DONE" /root/affine_data/r2ad_premerge.done
echo "[r2ad-premerge] DONE $(date -u +%Y-%m-%dT%H:%M:%SZ)"
