#!/usr/bin/env bash
# p2174: R11 n80 after p2173 Triton seed+relaunch died on missing run_reason_sim.py.
# Engines must already be double-promptable (teacher:8000 king:8001 chall:8002).
set -euo pipefail
LOG=/root/logs/h139_n80_retry.nohup
SIM=/root/affine_data/h139_sim_result.json
PROG=/root/affine_data/h139_sim_progress.json
DEC=/root/affine_data/h139_decision.json
PY=/root/venv/bin/python
set -a
# shellcheck disable=SC1091
source /root/mine.env
set +a
export PYTHONPATH=/root/mining_src/affine_pkg:/root/mining_src:${PYTHONPATH:-}
export AFFINE_DATA_DIR=/root/affine_data
log(){ echo "[h139-n80-retry] $(date -u +%Y-%m-%dT%H:%M:%SZ) $*" | tee -a "$LOG"; }
BH=$("$PY" - <<'PY'
import hashlib, time
print(hashlib.sha256(f"r11-h139-p2174-{time.time_ns()}".encode()).hexdigest())
PY
)
HK="local-h139-r11-$(date -u +%Y%m%dT%H%M%SZ)"
KING_REPO=${KING_REPO:-tolegend/Affine-5fqbxvz29b-ckp333}
KING_REV=${KING_REV:-24c137e8a978aea1e2b4abeec594fb6ca943f03c}
MERGED=${MERGED:-/root/h139/merged}
log "p2174 relaunch after missing run_reason_sim.py; king=$KING_REPO@${KING_REV:0:8} chall=$MERGED bh=${BH:0:16}"
test -f /root/mining_src/r1-reason-distill/run_reason_sim.py
"$PY" -c "import pyarrow, pathlib; p=pathlib.Path('/root/mining_src/r1-reason-distill/run_reason_sim.py'); assert p.is_file(), p; import evalsrv.vllm_client as vc, inspect; src=inspect.getsource(vc.VllmModel._post); print('ok pyarrow', pyarrow.__version__, 'timeout600', '600.0' in src)"
rm -f "$SIM" "$PROG" "$DEC"
"$PY" /root/mining_src/r1-reason-distill/run_reason_sim.py \
  --n-turns 80 \
  --block-hash "$BH" \
  --hotkey "$HK" \
  --king-repo "$KING_REPO" \
  --king-rev "$KING_REV" \
  --chall-repo "$MERGED" \
  --out "$SIM" \
  --progress-out "$PROG" \
  --save-artifact \
  2>&1 | tee /root/logs/h139_n80.log
"$PY" /root/mining_src/r1-reason-distill/write_reason_decision.py \
  --sim-result "$SIM" --out "$DEC" \
  2>&1 | tee -a /root/logs/h139_n80.log
cp -f "$DEC" /root/affine_data/r11_decision.json
date -u +%Y-%m-%dT%H:%M:%SZ > /root/logs/h139_n80.done
log "N80_DONE $(date -u +%Y-%m-%dT%H:%M:%SZ)"
cat "$DEC"
