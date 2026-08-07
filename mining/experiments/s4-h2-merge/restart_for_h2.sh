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
# Default: only swap chall. King is already kevin for H1; reloading it costs
# several TTL minutes. Set RESTART_KING=1 only when king must change.
RESTART_KING=${RESTART_KING:-0}

if [[ ! -f "$MERGE/model.safetensors.index.json" ]]; then
  echo "[h2-serve] missing merge at $MERGE" >&2
  exit 1
fi

_stop_one() {
  local name=$1
  local pidf=/root/logs/vllm_${name}.pid
  if [[ -f "$pidf" ]]; then
    local pid
    pid=$(cat "$pidf")
    if kill -0 "$pid" 2>/dev/null; then
      kill "$pid" || true
      for _ in $(seq 1 30); do
        kill -0 "$pid" 2>/dev/null || break
        sleep 2
      done
      kill -9 "$pid" 2>/dev/null || true
    fi
    rm -f "$pidf"
  fi
}

if [[ "$RESTART_KING" == "1" ]]; then
  echo "[h2-serve] $(date -u +%Y-%m-%dT%H:%M:%SZ) stop king+chall (keep teacher)"
  _stop_one king
  _stop_one chall
else
  echo "[h2-serve] $(date -u +%Y-%m-%dT%H:%M:%SZ) stop chall only (keep teacher+king)"
  _stop_one chall
fi
sleep 3

export TEACHER_REPO=${TEACHER_REPO:-zai-org/GLM-4.5-Air-FP8}
export TEACHER_REV=${TEACHER_REV:-}
export KING_REPO=$KEVIN_REPO
export KING_REV=$KEVIN_REV
export CHALL_REPO=$MERGE
# serve_three.sh defaults empty CHALL_REV to kevin's sha; for a local path
# that is wrong. Pass a sentinel that _launch clears when repo is a directory,
# and also unset so we do not advertise a Hub revision in logs.
unset CHALL_REV
export CHALL_REV="local"

# serve_three.sh skips already-running teacher via pid file
bash /root/mining_src/s3-duel-sim/serve_three.sh
echo "[h2-serve] waiting for king+chall readiness"
bash /root/mining_src/s3-duel-sim/wait_ready.sh
echo "[h2-serve] $(date -u +%Y-%m-%dT%H:%M:%SZ) READY king=$KEVIN_REPO chall=$MERGE"
