#!/usr/bin/env bash
# Restart H1 n80 sim after httpx.ReadTimeout kill (observed ~16/80 @ 04:36Z).
# Bumps pod-local vllm_client timeout/retries, then relaunches n80.
# Engines 0-5 must already be healthy. Does not touch H1v2 train on 6,7.
set -euo pipefail

# shellcheck disable=SC1091
source /root/venv/bin/activate
if [[ -f /root/mine.env ]]; then
  # shellcheck disable=SC1091
  source /root/mine.env
fi

export HF_HOME=${HF_HOME:-/root/hf}
export PYTHONPATH=/root/mining_src/affine_pkg:${PYTHONPATH:-}

MERGED=${MERGED:-/root/h1/merged}
SIM_OUT=/root/affine_data/h1_sim_result.json
LOG=/root/logs/h1_sim.nohup
CLIENT=/root/mining_src/affine_pkg/evalsrv/vllm_client.py

mkdir -p /root/logs /root/affine_data

if pgrep -f "run_sim_duel.py.*h1_sim_result" >/dev/null 2>&1; then
  echo "[n80-restart] sim already running; refuse double-launch" >&2
  pgrep -af "run_sim_duel.py" || true
  exit 0
fi

for p in 8000 8001 8002; do
  code=$(curl -s -o /dev/null -w "%{http_code}" "http://127.0.0.1:${p}/health" || echo 000)
  if [[ "$code" != "200" ]]; then
    echo "[n80-restart] engine :${p} health=${code}; abort" >&2
    exit 1
  fi
done

# Lengthen timeout: 180s×3 failed under teacher load; 360s×5 next.
if [[ -f "$CLIENT" ]]; then
  python3 - <<'PY'
from pathlib import Path
p = Path("/root/mining_src/affine_pkg/evalsrv/vllm_client.py")
txt = p.read_text()
orig = txt
txt = txt.replace("httpx.Timeout(180.0, connect=10.0)", "httpx.Timeout(360.0, connect=10.0)")
txt = txt.replace("for attempt in range(3):", "for attempt in range(5):")
txt = txt.replace("if attempt == 2:", "if attempt == 4:")
if txt == orig:
    print("[n80-restart] client already patched or pattern miss", flush=True)
else:
    p.write_text(txt)
    print("[n80-restart] patched vllm_client timeout=360 retries=5", flush=True)
PY
fi

# Rotate log but keep crash evidence.
if [[ -f "$LOG" ]]; then
  cp -f "$LOG" "/root/logs/h1_sim.nohup.pre_restart_$(date -u +%Y%m%dT%H%M%SZ)"
fi

echo "[n80-restart] $(date -u +%Y-%m-%dT%H:%M:%SZ) launch n=80 → $SIM_OUT" | tee -a "$LOG"
nohup python /root/mining_src/s4-h2-merge/run_sim_duel.py \
  --chall-repo "$MERGED" \
  --out "$SIM_OUT" \
  --hotkey local-h1-sim \
  --n-turns 80 \
  --progress-out /root/affine_data/h1_sim_progress.json \
  --save-artifact \
  >>"$LOG" 2>&1 &
echo $! > /root/logs/h1_sim.pid
echo "[n80-restart] pid=$(cat /root/logs/h1_sim.pid) log=$LOG"
echo "[n80-restart] $(date -u +%Y-%m-%dT%H:%M:%SZ) N80_RESTARTED"
