#!/usr/bin/env bash
# p2187: chall :8002 already READY with /tmp/r9_merged; only gather n80.
set -euo pipefail

LOG=/root/logs/r9_post_train.nohup
DONE=/root/logs/r9_pipeline.done
ABORT=/root/logs/r9_pipeline.aborted
PIDF=/root/logs/r9_post_train.pid
mkdir -p /root/logs /root/affine_data
echo $$ >"$PIDF"
exec > >(tee -a "$LOG") 2>&1

echo "[r9-n80] $(date -u +%Y-%m-%dT%H:%M:%SZ) n80-only (chall assumed up)"

DEADMAN_UTC=${DEADMAN_UTC:-2026-08-13T02:05:59Z}
LINK=${LINK:-/tmp/r9_merged_link}
KING_REPO=${KING_REPO:-tolegend/Affine-5fqbxvz29b-ckp333}
KING_REV=${KING_REV:-24c137e8a978aea1e2b4abeec594fb6ca943f03c}
SIM_OUT=/root/affine_data/r9_reason_sim.json
SIM_PROG=/root/affine_data/r9_reason_progress.json
SIM_DEC=/root/affine_data/r9_decision.json

rm -f "$ABORT" "$DONE" /root/logs/r9_sim_n80.done

c0=$(curl -s -o /dev/null -w "%{http_code}" --max-time 3 http://127.0.0.1:8000/v1/models || true)
c1=$(curl -s -o /dev/null -w "%{http_code}" --max-time 3 http://127.0.0.1:8001/v1/models || true)
c2=$(curl -s -o /dev/null -w "%{http_code}" --max-time 3 http://127.0.0.1:8002/v1/models || true)
if [[ "$c0$c1$c2" != "200200200" ]]; then
  echo "[r9-n80] FATAL engines not ready codes=${c0}/${c1}/${c2}" >&2
  echo "aborted_engines_not_ready $(date -u +%Y-%m-%dT%H:%M:%SZ)" >"$ABORT"
  exit 2
fi

now=$(date -u +%s)
dead=$(date -u -d "$DEADMAN_UTC" +%s)
if (( dead - now < 2400 )); then
  echo "[r9-n80] ABORT: <40m to deadman"
  echo "aborted_no_n80_budget $(date -u +%Y-%m-%dT%H:%M:%SZ)" >"$ABORT"
  exit 1
fi

rm -f "$SIM_OUT" "$SIM_PROG" "$SIM_DEC"
set -a
# shellcheck disable=SC1091
[[ -f /root/mine.env ]] && source /root/mine.env
set +a
export PYTHONPATH=/root/mining_src/affine_pkg${PYTHONPATH:+:$PYTHONPATH}

BH=$(/root/venv/bin/python - <<'PY'
import hashlib, time
print(hashlib.sha256(f"r9-teacher-zc-{time.time_ns()}".encode()).hexdigest())
PY
)
echo "[r9-n80] launching vs $KING_REPO@$KING_REV block_hash=${BH:0:16} PYTHONPATH=$PYTHONPATH"
set +e
/root/venv/bin/python /root/mining_src/r1-reason-distill/run_reason_sim.py \
  --n-turns 80 \
  --block-hash "$BH" \
  --hotkey "local-r9-teacher-zc-$(date -u +%Y%m%dT%H%M%SZ)" \
  --king-repo "$KING_REPO" \
  --king-rev "$KING_REV" \
  --chall-repo "$LINK" \
  --chall-rev local \
  --out "$SIM_OUT" \
  --progress-out "$SIM_PROG" \
  --save-artifact \
  2>&1 | tee /root/logs/r9_reason_sim.log
sim_rc=${PIPESTATUS[0]}
set -e
if [[ "$sim_rc" -ne 0 || ! -f "$SIM_OUT" ]]; then
  echo "[r9-n80] ERROR n80 failed rc=$sim_rc"
  echo "aborted_n80_failed rc=$sim_rc $(date -u +%Y-%m-%dT%H:%M:%SZ)" >"$ABORT"
  exit 1
fi
date -u +%Y-%m-%dT%H:%M:%SZ > /root/logs/r9_sim_n80.done

/root/venv/bin/python /root/mining_src/r1-reason-distill/write_reason_decision.py \
  --sim-result "$SIM_OUT" --out "$SIM_DEC" \
  2>&1 | tee -a /root/logs/r9_reason_sim.log

python3 - <<PY
import json
from pathlib import Path
p = Path("$SIM_DEC")
d = json.loads(p.read_text())
dec = str(d.get("decision") or "")
dec = dec.replace("R1_H64_BASELINE", "R9").replace("R1", "R9")
if dec.startswith("REFUTE_R9"):
    dec = "REFUTE_R9"
elif "ADVANCE" in dec:
    dec = "ADVANCE_STAGE5_SUBMIT"
elif "SIGNAL_CLEARS" in dec:
    dec = "SIGNAL_CLEARS_KSIGMA_NEED_HEADROOM"
elif "SIGNAL_POS" in dec:
    dec = "SIGNAL_POS_BELOW_KSIGMA"
d["decision"] = dec
d["hyp"] = "R9"
d["king_repo"] = "$KING_REPO"
d["king_rev"] = "$KING_REV"
d["axis"] = "teacher_zc_expanded_tok_lora"
p.write_text(json.dumps(d, indent=2) + "\n")
print(json.dumps(d, indent=2))
PY

cp -f "$SIM_DEC" /root/logs/r9_decision.json
echo "OK R9 n80 $(date -u +%Y-%m-%dT%H:%M:%SZ)" | tee "$DONE"
echo "[r9-n80] PIPELINE_DONE"
cat "$SIM_DEC"
