#!/usr/bin/env bash
# p2141: post_train_pipeline.sh baked Soft/Deadman from Aug-9 → will skip n80
# after chall serve. Wait for merge (+ optional chall), then force n80 via retry.
set -euo pipefail
LOG=/root/logs/h101_continue_n80_p2141.nohup
PIDF=/root/logs/h101_continue_n80_p2141.pid
echo $$ >"$PIDF"
exec >>"$LOG" 2>&1
log(){ echo "[h101-cont-p2141] $(date -u +%Y-%m-%dT%H:%M:%SZ) $*"; }

log "start — waiting merge.done (stale DEADMAN_UTC=2026-08-09 would skip n80)"
for i in $(seq 1 720); do
  if [[ -f /root/logs/h101_pipeline.done ]] || [[ -f /root/affine_data/h101_decision.json ]]; then
    log "pipeline/decision already done — exit"
    exit 0
  fi
  if [[ -f /root/logs/h101_merge.done ]]; then
    log "merge.done at iter=$i"
    break
  fi
  (( i % 12 == 0 )) && log "wait-merge iter=$i"
  sleep 10
done
if [[ ! -f /root/logs/h101_merge.done ]]; then
  log "TIMEOUT waiting merge.done"
  exit 2
fi

# Let post_train try chall serve; then intervene if it aborts on deadman.
log "watching for chall_serve.done or aborted_no_n80_budget (max ~90m)"
for i in $(seq 1 540); do
  if [[ -f /root/logs/h101_pipeline.done ]] || [[ -f /root/affine_data/h101_sim_result.json ]]; then
    log "sim/pipeline done without intervene — exit"
    exit 0
  fi
  if [[ -f /root/logs/h101_pipeline.aborted ]]; then
    reason=$(cat /root/logs/h101_pipeline.aborted)
    log "pipeline aborted: $reason"
    break
  fi
  if [[ -f /root/logs/h101_chall_serve.done ]]; then
    # Give post_train 60s to either launch n80 or abort on deadman
    sleep 60
    if [[ -f /root/affine_data/h101_sim_result.json ]] || pgrep -f 'run_sim_duel.py.*local-h101' >/dev/null 2>&1; then
      log "n80 already launched by post_train — exit"
      exit 0
    fi
    if [[ -f /root/logs/h101_pipeline.aborted ]] || ! kill -0 "$(cat /root/logs/h101_post_train.pid 2>/dev/null || echo 0)" 2>/dev/null; then
      log "chall up but post_train stopped without n80 — intervene"
      break
    fi
    # post_train still alive after chall — maybe launching; wait more
    if pgrep -f 'run_sim_duel.py.*local-h101' >/dev/null 2>&1; then
      log "n80 appeared — exit"
      exit 0
    fi
  fi
  (( i % 12 == 0 )) && log "wait-intervene iter=$i aborted=$(test -f /root/logs/h101_pipeline.aborted && echo y || echo n) chall=$(test -f /root/logs/h101_chall_serve.done && echo y || echo n)"
  sleep 10
done

if [[ -f /root/affine_data/h101_sim_result.json ]] || [[ -f /root/logs/h101_pipeline.done ]]; then
  log "done already — exit"
  exit 0
fi

# Kill stale post_train if still hanging after abort/skip
if [[ -f /root/logs/h101_post_train.pid ]]; then
  ppid=$(cat /root/logs/h101_post_train.pid || true)
  if [[ -n "${ppid:-}" ]] && kill -0 "$ppid" 2>/dev/null; then
    log "stopping stale post_train pid=$ppid"
    kill "$ppid" 2>/dev/null || true
    sleep 5
    kill -9 "$ppid" 2>/dev/null || true
  fi
fi

# Ensure chall served from merged
if [[ ! -f /root/logs/h101_chall_serve.done ]] || ! curl -sf --max-time 3 http://127.0.0.1:8002/health >/dev/null; then
  log "re-serve chall from /root/h101/merged"
  set -a
  # shellcheck disable=SC1091
  source /root/mine.env
  set +a
  source /root/venv/bin/activate
  export PYTHONPATH=/root/mining_src/affine_pkg:${PYTHONPATH:-}
  RESTART_KING=0 \
    MERGE=/root/h101/merged \
    KEVIN_REPO=Tok331102/affine-5EqYW8McUc-af10 \
    KEVIN_REV=eb8bf9a356a254f71faaa439e8abc3cfba572c53 \
    TEACHER_REPO=zai-org/GLM-4.5-Air-FP8 \
    bash /root/mining_src/s4-h2-merge/restart_for_h2.sh
  date -u +%Y-%m-%dT%H:%M:%SZ > /root/logs/h101_chall_serve.done
fi

log "launching retry_h101_n80.sh"
rm -f /root/logs/h101_pipeline.aborted
nohup bash /root/mining_src/s4-h101-f6-short-format/retry_h101_n80.sh \
  >>/root/logs/h101_n80_retry.nohup 2>&1 &
echo $! >/root/logs/h101_n80_retry.pid
log "retry pid=$(cat /root/logs/h101_n80_retry.pid) — continue done"
date -u +%Y-%m-%dT%H:%M:%SZ > /root/logs/h101_continue_n80_p2141.done
