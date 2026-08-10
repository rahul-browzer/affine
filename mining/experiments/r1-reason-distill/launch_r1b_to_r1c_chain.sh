#!/usr/bin/env bash
# After R1b merge+n80 writes r1b_lora_decision.json: if headroom < 1.5×(3·SE),
# launch R1c train (EPOCHS=6 on nsup100) and arm R1c merge→reload→n80 waiter.
# Does nothing if R1b already clears the submit bar. Idempotent via stamps.
set -euo pipefail
LOG=/root/logs/r1b_to_r1c_chain.log
STAMP=/root/logs/r1b_to_r1c_chain.done
DEC=/root/affine_data/r1b_lora_decision.json
MERGE_DONE=/root/logs/r1b_merge_reload.done
DATA=/root/r1_data/sft_high_reason_nsup100.jsonl
HEADROOM_BAR=${HEADROOM_BAR:-1.5}
mkdir -p /root/logs /root/affine_data
exec > >(tee -a "$LOG") 2>&1

echo "[r1b→r1c] $(date -u +%Y-%m-%dT%H:%M:%SZ) start (bar=${HEADROOM_BAR})"

if [[ -f "$STAMP" ]]; then
  echo "[r1b→r1c] already done ($(cat "$STAMP")); exit"
  exit 0
fi

# Wait for R1b n80 decision (must not confuse with older r1_lora_decision.json).
for i in $(seq 1 2160); do
  if [[ -f "$DEC" && -f "$MERGE_DONE" ]]; then
    echo "[r1b→r1c] decision ready at iter=$i $(date -u +%Y-%m-%dT%H:%M:%SZ)"
    break
  fi
  if (( i % 12 == 0 )); then
    crumb=$(tr '\r' '\n' < /root/logs/r1b_train.log 2>/dev/null | grep -E 'step=|/126' | tail -1 || true)
    echo "[r1b→r1c] wait-r1b iter=$i $(date -u +%Y-%m-%dT%H:%M:%SZ) crumb=${crumb:-none}"
  fi
  if (( i == 2160 )); then
    echo "[r1b→r1c] TIMEOUT waiting for $DEC" >&2
    exit 2
  fi
  sleep 10
done

# Parse decision (python — avoid jq dependency).
read -r decision headroom < <(python - <<'PY'
import json
from pathlib import Path
d = json.loads(Path("/root/affine_data/r1b_lora_decision.json").read_text())
h = d.get("headroom_vs_3se")
print(d.get("decision", "UNKNOWN"), h if h is not None else "nan")
PY
)

echo "[r1b→r1c] decision=$decision headroom_vs_3se=$headroom"

ACTION=$(python - <<PY
import sys
h = "$headroom"
bar = float("$HEADROOM_BAR")
try:
    hv = float(h)
except ValueError:
    print("FATAL", file=sys.stderr)
    sys.exit(2)
if hv >= bar:
    print(f"SKIP {hv:.6f}")
else:
    print(f"LAUNCH {hv:.6f}")
PY
)
echo "[r1b→r1c] action=$ACTION"
if [[ "$ACTION" == FATAL* ]]; then
  echo "[r1b→r1c] FATAL non-numeric headroom=$headroom" >&2
  exit 2
fi
if [[ "$ACTION" == SKIP* ]]; then
  echo "SKIP_R1C_R1B_CLEARS $ACTION decision=$decision $(date -u +%Y-%m-%dT%H:%M:%SZ)" | tee "$STAMP"
  exit 0
fi
echo "[r1b→r1c] R1b below bar; launching R1c"

if [[ ! -s "$DATA" ]]; then
  echo "[r1b→r1c] FATAL missing $DATA" >&2
  exit 2
fi

# GPUs 6–7 must be free (R1b train+merge finished). Brief settle.
sleep 5
if pgrep -af 'train_lora.py.*r1b|merge_lora.*r1b|lora_tok_high_reason_r1b' >/dev/null 2>&1; then
  echo "[r1b→r1c] waiting for leftover R1b python to exit…"
  for j in $(seq 1 120); do
    pgrep -af 'train_lora.py.*r1b|merge_lora' >/dev/null 2>&1 || break
    sleep 5
  done
fi

# Launch R1c train (nohup).
if [[ -f /root/logs/r1c_train.done ]]; then
  echo "[r1b→r1c] r1c_train.done already present — skip train relaunch"
else
  rm -f /root/logs/r1c_train.pid /root/logs/r1c_train.log
  nohup bash /root/mining_src/r1-reason-distill/launch_r1c_train.sh \
    >/root/logs/r1c_train_nohup.out 2>&1 &
  echo $! >/root/logs/r1c_train.pid
  echo "[r1b→r1c] R1c train pid=$(cat /root/logs/r1c_train.pid)"
fi

# Arm R1c merge→reload→n80 waiter (idempotent if already running).
if pgrep -af 'launch_r1c_merge_reload_sim.sh' >/dev/null 2>&1; then
  echo "[r1b→r1c] R1c merge waiter already running"
else
  nohup bash /root/mining_src/r1-reason-distill/launch_r1c_merge_reload_sim.sh \
    >/root/logs/r1c_merge_reload.nohup 2>&1 &
  echo $! >/root/logs/r1c_merge_reload.pid
  echo "[r1b→r1c] R1c merge waiter pid=$(cat /root/logs/r1c_merge_reload.pid)"
fi

echo "LAUNCHED_R1C decision=$decision headroom=$headroom $(date -u +%Y-%m-%dT%H:%M:%SZ)" >"$STAMP"
cat "$STAMP"
echo "[r1b→r1c] DONE $(date -u +%Y-%m-%dT%H:%M:%SZ)"
