#!/usr/bin/env bash
# Swap king/chall after merge: king=kevin, chall=local merge dir.
# Teacher (8000) left running. Run on mine-sim-1 after h2_merge.done.
set -euo pipefail

# shellcheck disable=SC1091
source /root/venv/bin/activate
if [[ -f /root/mine.env ]]; then
  # shellcheck disable=SC1091
  source /root/mine.env
fi

MERGE=${MERGE:-/root/merges/h2-kp50}
KEVIN_REPO=${KEVIN_REPO:-kevin954/Affine-5dfqbbh8ev-sft}
KEVIN_REV=${KEVIN_REV:-6a5815fad8f4e34c983b1933c1fae5762fe25220}

if [[ ! -f "$MERGE/model.safetensors.index.json" ]]; then
  echo "[h2-serve] missing merge at $MERGE" >&2
  exit 1
fi

echo "[h2-serve] $(date -u +%Y-%m-%dT%H:%M:%SZ) stop king+chall (keep teacher)"
for name in king chall; do
  pidf=/root/logs/vllm_${name}.pid
  if [[ -f "$pidf" ]]; then
    pid=$(cat "$pidf")
    if kill -0 "$pid" 2>/dev/null; then
      kill "$pid" || true
      # wait up to 60s
      for _ in $(seq 1 30); do
        kill -0 "$pid" 2>/dev/null || break
        sleep 2
      done
      kill -9 "$pid" 2>/dev/null || true
    fi
    rm -f "$pidf"
  fi
done
sleep 3

export TEACHER_REPO=${TEACHER_REPO:-zai-org/GLM-4.5-Air-FP8}
export TEACHER_REV=${TEACHER_REV:-}
export KING_REPO=$KEVIN_REPO
export KING_REV=$KEVIN_REV
export CHALL_REPO=$MERGE
export CHALL_REV=

# serve_three.sh skips already-running teacher via pid file
bash /root/mining_src/s3-duel-sim/serve_three.sh
echo "[h2-serve] waiting for king+chall readiness"
bash /root/mining_src/s3-duel-sim/wait_ready.sh
echo "[h2-serve] $(date -u +%Y-%m-%dT%H:%M:%SZ) READY king=$KEVIN_REPO chall=$MERGE"
