#!/usr/bin/env bash
# p2155 R2bk: fresh n80 of saysth v9a vs live reign-5 king tolegend ckp333.
# No chall reload — :8002 already serves saysth; :8001 retargeted to ckp333.
# Pre-reg decision: ADVANCE iff margin >= 1.5 × (k_sigma·SE) with live k_sigma=2.0.
# Do not yank chall while this sim runs (R9 post_train must wait on DEC).
set -euo pipefail
LOG=/root/logs/r2bk_saysth_ckp333_reason_sim.log
DONE=/root/logs/r2bk_saysth_ckp333_reload.done
PIDF=/root/logs/r2bk_saysth_ckp333.pid
mkdir -p /root/logs /root/affine_data
echo $$ >"$PIDF"
exec > >(tee -a "$LOG") 2>&1

echo "[r2bk] $(date -u +%Y-%m-%dT%H:%M:%SZ) start p2155"

RETARGET_DONE=${RETARGET_DONE:-/root/logs/retarget_king_tolegend_ckp333.done}
KING_REPO=${KING_REPO:-tolegend/Affine-5fqbxvz29b-ckp333}
KING_REV=${KING_REV:-24c137e8a978aea1e2b4abeec594fb6ca943f03c}
SAYSTH_REPO=${SAYSTH_REPO:-saysth/Affine-5dtnxamt4t-v9a}
SAYSTH_REV=${SAYSTH_REV:-6e13f365b36000cf631aad2fa9fb05fdabae0044}

# shellcheck disable=SC1091
source /root/venv/bin/activate
if [[ -f /root/mine.env ]]; then
  set -a
  # shellcheck disable=SC1091
  source /root/mine.env
  set +a
fi
export PYTHONPATH=/root/mining_src/affine_pkg${PYTHONPATH:+:$PYTHONPATH}
export AFFINE_DATA_DIR=${AFFINE_DATA_DIR:-/root/affine_data}

if [[ ! -f "$RETARGET_DONE" ]]; then
  echo "[r2bk] FATAL missing retarget done $RETARGET_DONE" >&2
  exit 2
fi
echo "[r2bk] retarget: $(cat "$RETARGET_DONE")"

# Confirm live stack ids before gathering.
for i in $(seq 1 60); do
  c0=$(curl -s -o /dev/null -w "%{http_code}" --max-time 3 http://127.0.0.1:8000/v1/models || true)
  c1=$(curl -s -o /dev/null -w "%{http_code}" --max-time 3 http://127.0.0.1:8001/v1/models || true)
  c2=$(curl -s -o /dev/null -w "%{http_code}" --max-time 3 http://127.0.0.1:8002/v1/models || true)
  if [[ "$c0$c1$c2" == "200200200" ]]; then
    kid=$(curl -s --max-time 3 http://127.0.0.1:8001/v1/models | python3 -c 'import sys,json; print(json.load(sys.stdin)["data"][0]["id"])')
    cid=$(curl -s --max-time 3 http://127.0.0.1:8002/v1/models | python3 -c 'import sys,json; print(json.load(sys.stdin)["data"][0]["id"])')
    echo "[r2bk] engines ready king=$kid chall=$cid"
    if [[ "$kid" != *ckp333* && "$kid" != *tolegend* ]]; then
      echo "[r2bk] FATAL king id not ckp333: $kid" >&2
      exit 2
    fi
    if [[ "$cid" != *saysth* && "$cid" != *v9a* ]]; then
      echo "[r2bk] FATAL chall id not saysth: $cid" >&2
      exit 2
    fi
    break
  fi
  if (( i == 60 )); then
    echo "[r2bk] TIMEOUT engines codes=${c0}/${c1}/${c2}" >&2
    exit 2
  fi
  sleep 5
done

# Refuse to start if another reason sim is already gathering.
if pgrep -f 'run_reason_sim.py' >/dev/null 2>&1; then
  echo "[r2bk] FATAL another run_reason_sim.py already running" >&2
  pgrep -af 'run_reason_sim.py' || true
  exit 2
fi

OUT=/root/affine_data/r2bk_saysth_ckp333_reason_sim.json
DEC=/root/affine_data/r2bk_saysth_ckp333_decision.json
PROG=/root/affine_data/r2bk_saysth_ckp333_reason_progress.json
rm -f "$OUT" "$DEC" "$PROG" "$DONE" /root/logs/r2bk_saysth_ckp333_decision.json

BH=$(python - <<'PY'
import hashlib, time
print(hashlib.sha256(f"r2bk-saysth-ckp333-{time.time_ns()}".encode()).hexdigest())
PY
)

echo "[r2bk] launching n80 vs $KING_REPO@$KING_REV block_hash=${BH:0:16}…"
# Pre-reg: crown bar = live k_sigma=2.0; submit needs ~1.5× headroom on that bar.
python /root/mining_src/r1-reason-distill/run_reason_sim.py \
  --n-turns 80 \
  --block-hash "$BH" \
  --hotkey "local-r2bk-saysth-$(date -u +%Y%m%dT%H:%M:%SZ)" \
  --king-repo "$KING_REPO" \
  --king-rev "$KING_REV" \
  --chall-repo "$SAYSTH_REPO" \
  --chall-rev "$SAYSTH_REV" \
  --out "$OUT" \
  --progress-out "$PROG" \
  --save-artifact \
  2>&1 | tee -a "$LOG"

python /root/mining_src/r1-reason-distill/write_reason_decision.py \
  --sim-result "$OUT" --out "$DEC" --hyp R2bk \
  2>&1 | tee -a "$LOG"

# Re-stamp headroom vs live k_sigma=2.0 (writer defaults to sim stamp / 3.0).
python3 - <<'PY'
import json
from pathlib import Path
dec_path = Path("/root/affine_data/r2bk_saysth_ckp333_decision.json")
d = json.loads(dec_path.read_text())
m = d.get("margin")
se = d.get("se")
k = 2.0
if m is not None and se is not None and se > 0:
    thresh = k * se
    hr = m / thresh
    d["k_sigma_live"] = k
    d["threshold_live_2se"] = thresh
    d["headroom_vs_live_2se"] = hr
    d["submit_bar_1p5x_2se"] = 1.5 * thresh
    if hr >= 1.5:
        d["decision_live_k2"] = "ADVANCE_STAGE5_SUBMIT"
    elif d.get("challenger_wins") or (m is not None and m > thresh):
        d["decision_live_k2"] = "SIGNAL_CLEARS_2SE_NEED_HEADROOM"
    elif m is not None and m > 0:
        d["decision_live_k2"] = "SIGNAL_POS_BELOW_2SE"
    else:
        d["decision_live_k2"] = "REFUTE_R2bk"
dec_path.write_text(json.dumps(d, indent=2) + "\n")
Path("/root/logs/r2bk_saysth_ckp333_decision.json").write_text(json.dumps(d, indent=2) + "\n")
print(json.dumps(d, indent=2))
PY

echo "[r2bk] DONE $(date -u +%Y-%m-%dT%H:%M:%SZ)"
echo "OK $(date -u +%Y-%m-%dT%H:%M:%SZ)" >"$DONE"
cp -f "$DONE" /root/affine_data/r2bk_saysth_ckp333_reload.done 2>/dev/null || true
