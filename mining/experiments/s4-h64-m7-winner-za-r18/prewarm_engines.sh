#!/usr/bin/env bash
# Pre-warm teacher:8000 + TalentPigs king:8001 while H64 trains on GPUs 6,7.
# Also sync public turn corpus for n80. Does NOT start chall (post-merge).
set -euo pipefail

# shellcheck disable=SC1091
source /root/venv/bin/activate
if [[ -f /root/mine.env ]]; then
  set -a
  # shellcheck disable=SC1091
  source /root/mine.env
  set +a
fi
export HF_TOKEN="${HF_TOKEN:-}"
export HF_HOME=${HF_HOME:-/root/hf}
export PYTHONPATH=/root/mining_src/affine_pkg:${PYTHONPATH:-}

LOG=/root/logs/h64_prewarm.nohup
mkdir -p /root/logs /root/affine_data

log() { echo "[h64-prewarm] $(date -u +%Y-%m-%dT%H:%M:%SZ) $*" | tee -a "$LOG"; }

log "sync corpus"
bash /root/mining_src/s3-duel-sim/sync_corpus.sh | tee -a "$LOG"

TEACHER_REPO=${TEACHER_REPO:-zai-org/GLM-4.5-Air-FP8}
TEACHER_REV=${TEACHER_REV:-}
KING_REPO=${KING_REPO:-TalentPigs/affine-5ekxlcg3fx-abc}
KING_REV=${KING_REV:-dbfbb3e2a17c7603e7fc68a3a15b343f42dfdef4}

# Launch teacher+king only by calling serve_three with chall = king local
# then immediately stopping chall if it started. Cleaner: inline two launches
# via serve_three env + stop chall.
log "launch teacher+king (chall placeholder then stop)"
TEACHER_REPO="$TEACHER_REPO" TEACHER_REV="$TEACHER_REV" \
  KING_REPO="$KING_REPO" KING_REV="$KING_REV" \
  CHALL_REPO="$KING_REPO" CHALL_REV="$KING_REV" \
  bash /root/mining_src/s3-duel-sim/serve_three.sh | tee -a "$LOG"

# Stop chall immediately — GPUs 4,5 stay free for post-merge merge settle /
# chall serve; we do not want a TalentPigs twin burning VRAM during train.
if [[ -f /root/logs/vllm_chall.pid ]]; then
  pid=$(cat /root/logs/vllm_chall.pid)
  if kill -0 "$pid" 2>/dev/null; then
    log "stop placeholder chall pid=$pid"
    kill "$pid" || true
    for _ in $(seq 1 30); do
      kill -0 "$pid" 2>/dev/null || break
      sleep 2
    done
    kill -9 "$pid" 2>/dev/null || true
  fi
  rm -f /root/logs/vllm_chall.pid
fi

log "wait teacher+king /v1/models"
START=$(date +%s)
TIMEOUT_S=${TIMEOUT_S:-1800}
while true; do
  t=0; k=0
  curl -sf --max-time 5 http://127.0.0.1:8000/v1/models >/dev/null 2>&1 && t=1
  curl -sf --max-time 5 http://127.0.0.1:8001/v1/models >/dev/null 2>&1 && k=1
  elapsed=$(( $(date +%s) - START ))
  log "t=$t k=$k elapsed=${elapsed}s"
  if [[ $t -eq 1 && $k -eq 1 ]]; then
    date -u +%Y-%m-%dT%H:%M:%SZ > /root/logs/h64_prewarm.done
    log "PREWARM_READY"
    exit 0
  fi
  if (( elapsed >= TIMEOUT_S )); then
    log "TIMEOUT"
    tail -40 /root/logs/vllm_teacher.log 2>/dev/null || true
    tail -40 /root/logs/vllm_king.log 2>/dev/null || true
    exit 1
  fi
  sleep 15
done
