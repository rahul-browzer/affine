#!/usr/bin/env bash
# Relaunch R2am Talent×sbs-v1 Reason n80 after ReadTimeout @~61/80.
# Engines + /tmp/r2am_alpha_merged chall already warm. Requires
# patch_vllm_timeout.py (600s × 5) before start.
set -euo pipefail
LOG=/root/logs/r2am_alpha_reason_sim.log
OUT=/root/affine_data/r2am_alpha_reason_sim.json
DEC=/root/affine_data/r2am_alpha_decision.json
PROG=/root/affine_data/r2am_alpha_reason_progress.json
DONE=/root/logs/r2am_merge_reload.done
HOLDING=/root/logs/r2am_talent_sbs_v1_holding.stamp
LINK=${LINK:-/tmp/r2am_alpha_merged}
PY=/root/venv/bin/python
set -a
# shellcheck disable=SC1091
source /root/mine.env
set +a
export PYTHONPATH=/root/mining_src/affine_pkg:/root/mining_src:${PYTHONPATH:-}
export AFFINE_DATA_DIR=/root/affine_data
cd /root/mining_src/r1-reason-distill

# Keep R2an lane-busy while we re-run (no decision until finished).
date -u +%Y-%m-%dT%H:%M:%SZ >"$HOLDING"
rm -f "$OUT" "$DEC" "$PROG" "$DONE"

BH=$("$PY" - <<'PY'
import hashlib, time
print(hashlib.sha256(f"r2am-talent-sbs-v1-retry-{time.time_ns()}".encode()).hexdigest())
PY
)
HK="local-r2am-talent-sbs-v1-$(date -u +%Y%m%dT%H:%M:%SZ)"
echo "[r2am-relaunch] $(date -u +%Y-%m-%dT%H:%M:%SZ) block_hash=${BH:0:16} hotkey=$HK timeout=600s×5 py=$PY link=$LINK"
"$PY" -c "import pyarrow; import evalsrv.vllm_client as vc; import inspect; src=inspect.getsource(vc.VllmModel._post); assert '600.0' in src and 'range(5)' in src; print('client_ok timeout=600×5 pyarrow', pyarrow.__version__)"
for p in 8000 8001 8002; do
  code=$(curl -s -o /dev/null -w '%{http_code}' -m 5 "http://127.0.0.1:$p/v1/models" || true)
  echo "[r2am-relaunch] engine :$p http=$code"
  [[ "$code" == "200" ]] || { echo "engine :$p not READY" >&2; exit 3; }
done

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
  --sim-result "$OUT" --out "$DEC" --hyp R2am \
  2>&1 | tee -a "$LOG"

rm -f "$HOLDING"
echo "[r2am-relaunch] DONE $(date -u +%Y-%m-%dT%H:%M:%SZ)"
cat "$DEC"
echo "OK $(date -u +%Y-%m-%dT%H:%M:%SZ)" >"$DONE"
cp -f "$DEC" /root/logs/r2am_alpha_decision.json 2>/dev/null || true
