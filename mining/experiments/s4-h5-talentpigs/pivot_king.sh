#!/usr/bin/env bash
# Swap king:8001 to live TalentPigs. Teacher:8000 left running.
# Challenger left alone unless STOP_CHALL=1 (default: keep H1v2 until merge).
set -euo pipefail

# shellcheck disable=SC1091
source /root/venv/bin/activate
if [[ -f /root/mine.env ]]; then
  # shellcheck disable=SC1091
  source /root/mine.env
fi

export HF_HOME=${HF_HOME:-/root/hf}
KING_REPO=${KING_REPO:-TalentPigs/affine-5ekxlcg3fx-abc}
KING_REV=${KING_REV:-dbfbb3e2a17c7603e7fc68a3a15b343f42dfdef4}
STOP_CHALL=${STOP_CHALL:-0}
DONE=/root/logs/h5_king_pivot.done
LOG=/root/logs/h5_king_pivot.log
mkdir -p /root/logs
rm -f "$DONE"

_stop_one() {
  local name=$1
  local pidf=/root/logs/vllm_${name}.pid
  if [[ -f "$pidf" ]]; then
    local pid
    pid=$(cat "$pidf")
    if kill -0 "$pid" 2>/dev/null; then
      echo "[h5-pivot] stop $name pid=$pid" | tee -a "$LOG"
      kill "$pid" || true
      for _ in $(seq 1 40); do
        kill -0 "$pid" 2>/dev/null || break
        sleep 2
      done
      kill -9 "$pid" 2>/dev/null || true
    fi
    rm -f "$pidf"
  else
    # Fallback: kill by port pattern if pidfile missing (kevin was started
    # before pidfiles were always written).
    echo "[h5-pivot] no pidfile for $name; trying pkill by port marker" | tee -a "$LOG"
  fi
}

echo "[h5-pivot] $(date -u +%Y-%m-%dT%H:%M:%SZ) stop old king (kevin)" | tee -a "$LOG"
_stop_one king
# Also kill any leftover vllm on :8001 that predates pidfile discipline.
pkill -f "vllm serve .*--port 8001" 2>/dev/null || true
sleep 5

if [[ "$STOP_CHALL" == "1" ]]; then
  _stop_one chall
  pkill -f "vllm serve .*--port 8002" 2>/dev/null || true
  sleep 3
fi

export TEACHER_REPO=${TEACHER_REPO:-zai-org/GLM-4.5-Air-FP8}
export TEACHER_REV=${TEACHER_REV:-}
export KING_REPO
export KING_REV
# Keep existing chall if still up; serve_three skips running engines.
# If chall is down, re-point at leftover H1v2 merged so GPUs 4-5 are warm.
if [[ ! -f /root/logs/vllm_chall.pid ]] || ! kill -0 "$(cat /root/logs/vllm_chall.pid 2>/dev/null)" 2>/dev/null; then
  if [[ -d /root/h1v2/merged ]]; then
    export CHALL_REPO=/root/h1v2/merged
    export CHALL_REV=local
  else
    export CHALL_REPO=kevin954/Affine-5dfqbbh8ev-sft
    export CHALL_REV=6a5815fad8f4e34c983b1933c1fae5762fe25220
  fi
fi

echo "[h5-pivot] $(date -u +%Y-%m-%dT%H:%M:%SZ) launch king=$KING_REPO@$KING_REV" | tee -a "$LOG"
bash /root/mining_src/s3-duel-sim/serve_three.sh
bash /root/mining_src/s3-duel-sim/wait_ready.sh
date -u +%Y-%m-%dT%H:%M:%SZ >"$DONE"
echo "[h5-pivot] $(date -u +%Y-%m-%dT%H:%M:%SZ) READY king=$KING_REPO@$KING_REV" | tee -a "$LOG"
