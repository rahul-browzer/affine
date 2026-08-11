#!/usr/bin/env bash
# R2aa: CPU skew-α merge TalentPigs (reign-3) × ammazon/…-sbs-v0 (queue chal-00468).
# p1973: EAGER weights while R2p n80 / pig prefetch — merge CPU now,
# then gate r2aa_premerge.done on chal00468_reason.json Reason+ (hr>0).
# Do NOT stamp DONE before Reason+ (merge_reload would steal chall).
# On Reason− / mismatch: SKIP + purge blend. Layout donor = Talent (first --parent).
# Safe during R2p GPU work (CPU/RAM only). n80 bar later: ≥ 1.5×(3·SE).
set -euo pipefail
LOG=/root/logs/r2aa_premerge.log
DONE=/root/logs/r2aa_premerge.done
PIDF=/root/logs/r2aa_premerge.pid
SKIP=/root/logs/r2aa_premerge.skip
EAGER=/root/logs/r2aa_eager_weights.done
REASON_JSON=${REASON_JSON:-/root/affine_data/chal00468_reason.json}
REASON_DONE=${REASON_DONE:-/root/logs/watch_chal00468_reason.done}
PREFETCH_DONE=${PREFETCH_DONE:-/root/logs/r2_prefetch_sbs.done}
MERGED=${MERGED:-/root/r2_out/alpha_talent_sbs_skew}
mkdir -p /root/logs /root/r2_out /root/affine_data
echo $$ >"$PIDF"
exec > >(tee -a "$LOG") 2>&1

echo "[r2aa-premerge] $(date -u +%Y-%m-%dT%H:%M:%SZ) start (eager-weights)"
if [[ -f "$DONE" && -f "$MERGED/model.safetensors.index.json" ]]; then
  echo "[r2aa-premerge] already done: $(cat "$DONE")"
  exit 0
fi
if [[ -f "$SKIP" ]]; then
  echo "[r2aa-premerge] already skipped: $(cat "$SKIP")"
  exit 0
fi

echo "[r2aa-premerge] waiting for sbs prefetch $PREFETCH_DONE"
for i in $(seq 1 2880); do
  if [[ -f "$PREFETCH_DONE" ]]; then
    echo "[r2aa-premerge] prefetch ready: $(cat "$PREFETCH_DONE")"
    break
  fi
  if (( i % 12 == 0 )); then
    crumb=$(tail -n 2 /root/logs/r2_prefetch_sbs.log 2>/dev/null | tr '\r' '\n' | tail -1 || true)
    echo "[r2aa-premerge] wait-prefetch iter=$i crumb=${crumb:-none}"
  fi
  if (( i == 2880 )); then
    echo "SKIP $(date -u +%Y-%m-%dT%H:%M:%SZ) sbs prefetch TIMEOUT" | tee "$SKIP"
    exit 2
  fi
  sleep 10
done

W_TALENT=${W_TALENT:-0.25}
W_SBS=${W_SBS:-0.75}
TALENT_REV=dbfbb3e2a17c7603e7fc68a3a15b343f42dfdef4
SBS_REV=${SBS_REV:-c175fe8b79a66a8de97953677f1a489cb386261d}

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
  echo "[r2aa-premerge] eager weights already present: $(cat "$EAGER")"
else
  TALENT=$(resolve_snap TalentPigs/affine-5ekxlcg3fx-abc "$TALENT_REV") || {
    echo "[r2aa-premerge] FATAL missing TalentPigs" >&2
    exit 2
  }
  SBS=$(resolve_snap ammazon/Affine-5dvqtektxx-sbs-v0 "$SBS_REV") || {
    echo "[r2aa-premerge] FATAL missing sbs-v0" >&2
    exit 2
  }

  # Never clobber a live chall symlink target.
  MERGED_REAL=$(readlink -f "$MERGED" 2>/dev/null || echo "$MERGED")
  for link in /tmp/r2*_merged /tmp/r2*_alpha_merged; do
    [[ -e "$link" || -L "$link" ]] || continue
    L=$(readlink -f "$link" 2>/dev/null || true)
    if [[ -n "${L:-}" && "$L" == "$MERGED_REAL" ]]; then
      echo "[r2aa-premerge] FATAL $MERGED is live chall target via $link ($L)" >&2
      exit 2
    fi
  done

  # Disk headroom: need ~75 GiB free for the blend (pig may still be downloading).
  FREE_K=$(df -Pk /root | awk 'NR==2{print $4}')
  if (( FREE_K < 75000000 )); then
    echo "SKIP $(date -u +%Y-%m-%dT%H:%M:%SZ) low disk free_kb=$FREE_K need≥75GiB" | tee "$SKIP"
    exit 2
  fi

  rm -rf "$MERGED"
  mkdir -p "$MERGED"
  echo "[r2aa-premerge] EAGER α-merge Talent:$W_TALENT sbs:$W_SBS → $MERGED"
  python /root/mining_src/r2-multiking-merge/merge_alpha.py \
    --parent "${TALENT}:${W_TALENT}" \
    --parent "${SBS}:${W_SBS}" \
    --out "$MERGED"

  META=""
  if [[ -f "$MERGED/merge_alpha_meta.json" ]]; then
    META=$(python - <<'PY'
import json
from pathlib import Path
d=json.loads(Path("/root/r2_out/alpha_talent_sbs_skew/merge_alpha_meta.json").read_text())
print(f"max_abs_delta={d.get('max_abs_delta')} n_keys={d.get('n_keys')} identical_frac={d.get('identical_frac')}")
PY
)
    cp -f "$MERGED/merge_alpha_meta.json" /root/affine_data/r2aa_talent_sbs_merge_alpha_meta.json
  fi
  echo "EAGER $(date -u +%Y-%m-%dT%H:%M:%SZ) w_talent=$W_TALENT w_sbs=$W_SBS ${META}" | tee "$EAGER"
  cp -f "$EAGER" /root/affine_data/r2aa_eager_weights.done
fi

echo "[r2aa-premerge] waiting for Reason stamp $REASON_JSON (+ $REASON_DONE) before DONE"
for i in $(seq 1 2880); do
  if [[ -f "$REASON_JSON" && -f "$REASON_DONE" ]]; then
    break
  fi
  if (( i % 12 == 0 )); then
    echo "[r2aa-premerge] wait-reason iter=$i (weights ready; no DONE yet)"
  fi
  sleep 10
done
if [[ ! -f "$REASON_JSON" || ! -f "$REASON_DONE" ]]; then
  echo "SKIP $(date -u +%Y-%m-%dT%H:%M:%SZ) TIMEOUT waiting for chal-00468 Reason — purge eager blend" | tee "$SKIP"
  rm -rf "$MERGED"
  exit 2
fi

GATE_LINE=$(python - <<'PY'
import json
from pathlib import Path
d = json.loads(Path("/root/affine_data/chal00468_reason.json").read_text())
hr = d.get("headroom_vs_3se")
km = bool(d.get("king_match"))
ok = km and hr is not None and float(hr) > 0.0
print(
    f"hr={hr} king_match={km} margin={d.get('reason_margin')} "
    f"repo={d.get('challenger_repo')} rev={d.get('challenger_revision')} ok={ok}"
)
Path("/tmp/r2aa_gate_ok").write_text("1\n" if ok else "0\n")
PY
)
echo "[r2aa-premerge] gate: $GATE_LINE"
if [[ "$(cat /tmp/r2aa_gate_ok)" != "1" ]]; then
  echo "SKIP $(date -u +%Y-%m-%dT%H:%M:%SZ) Reason-or-mismatch ${GATE_LINE} — purge eager Talent×sbs" | tee "$SKIP"
  rm -rf "$MERGED"
  exit 0
fi

META=""
if [[ -f "$MERGED/merge_alpha_meta.json" ]]; then
  META=$(python - <<'PY'
import json
from pathlib import Path
d=json.loads(Path("/root/r2_out/alpha_talent_sbs_skew/merge_alpha_meta.json").read_text())
print(f"max_abs_delta={d.get('max_abs_delta')} n_keys={d.get('n_keys')} identical_frac={d.get('identical_frac')}")
PY
)
fi
echo "OK $(date -u +%Y-%m-%dT%H:%M:%SZ) w_talent=$W_TALENT w_sbs=$W_SBS ${META} ${GATE_LINE}" | tee "$DONE"
cp -f "$DONE" /root/affine_data/r2aa_premerge.done
echo "[r2aa-premerge] DONE $(date -u +%Y-%m-%dT%H:%M:%SZ)"
