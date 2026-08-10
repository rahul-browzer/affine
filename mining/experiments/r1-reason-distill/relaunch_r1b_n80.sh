#!/usr/bin/env bash
# Relaunch R1b Reason n80 after ReadTimeout; engines + merged chall already warm.
# Requires patched vllm_client timeout=600s × 5 attempts (65536 ctx teacher samples).
set -euo pipefail
LOG=/root/logs/r1b_lora_reason_sim.log
OUT=/root/affine_data/r1b_lora_reason_sim.json
DEC=/root/affine_data/r1b_lora_decision.json
PROG=/root/affine_data/r1b_lora_reason_progress.json
LINK=${LINK:-/tmp/r1b_lora_merged}
PY=/root/venv/bin/python
set -a
# shellcheck disable=SC1091
source /root/mine.env
set +a
export PYTHONPATH=/root/mining_src/affine_pkg:/root/mining_src:${PYTHONPATH:-}
export AFFINE_DATA_DIR=/root/affine_data
cd /root/mining_src/r1-reason-distill
rm -f "$OUT" "$DEC" "$PROG" /root/logs/r1b_merge_reload.done
BH=$("$PY" - <<'PY'
import hashlib, time
print(hashlib.sha256(f"r1b-lora-retry-{time.time_ns()}".encode()).hexdigest())
PY
)
HK="local-r1b-lora-$(date -u +%Y%m%dT%H%M%SZ)"
echo "[r1b-relaunch] $(date -u +%Y-%m-%dT%H:%M:%SZ) block_hash=${BH:0:16} hotkey=$HK timeout=600s×5 py=$PY"
"$PY" -c "import pyarrow; import evalsrv.vllm_client as vc; import inspect; src=inspect.getsource(vc.VllmModel._post); assert '600.0' in src; print('client_ok timeout=600 pyarrow', pyarrow.__version__)"
"$PY" /root/mining_src/r1-reason-distill/run_reason_sim.py \
  --n-turns 80 \
  --block-hash "$BH" \
  --hotkey "$HK" \
  --king-repo Tok331102/affine-5EqYW8McUc-af10 \
  --king-rev eb8bf9a356a254f71faaa439e8abc3cfba572c53 \
  --chall-repo "$LINK" \
  --out "$OUT" \
  --progress-out "$PROG" \
  --save-artifact \
  2>&1 | tee "$LOG"
"$PY" /root/mining_src/r1-reason-distill/write_reason_decision.py \
  --sim-result "$OUT" --out "$DEC" \
  2>&1 | tee -a "$LOG"
echo "[r1b-relaunch] DONE $(date -u +%Y-%m-%dT%H:%M:%SZ)"
cat "$DEC"
touch /root/logs/r1b_merge_reload.done
