#!/bin/bash
# p426: after recover264 DONE_LAUNCH, ensure n80 watcher points at d203first (not bare a203).
set -u
LOG=/root/logs/h106_chall_recover_pass264.log
HYP=h106
RETRY=/root/mining_src/s4-h106-f11-pandora-base/retry_h106_n80_d203first.sh
WATCH=/root/mining_src/s4-h2-merge/watch_n80_retry.sh
log(){ echo "[p426-d203-repoint] $(date -u +%Y-%m-%dT%H:%M:%SZ) $*"; }
log "waiting for DONE_LAUNCH in $LOG"
for i in $(seq 1 240); do
  if grep -q "DONE_LAUNCH" "$LOG" 2>/dev/null; then
    log "saw DONE_LAUNCH"
    break
  fi
  # also bail if recover process gone without DONE
  if ! pgrep -f "relaunch_chall_pass264.sh" >/dev/null 2>&1; then
    if grep -q "DONE_LAUNCH" "$LOG" 2>/dev/null; then
      log "recover exited with DONE"
      break
    fi
    log "recover exited WITHOUT DONE — abort sidecar"
    exit 1
  fi
  sleep 15
done
if ! grep -q "DONE_LAUNCH" "$LOG" 2>/dev/null; then
  log "timeout waiting DONE — abort"
  exit 1
fi
sleep 5  # let recover finish its own rearm
# Kill whatever recover armed (may be bare a203 if patch missed)
while read -r pid; do
  [ -n "$pid" ] || continue
  log "kill old watcher $pid"
  kill "$pid" 2>/dev/null || true
done < <(ps -eo pid,args | awk '/[w]atch_n80_retry\.sh/ && / h106 / {print $1}')
while read -r pid; do
  [ -n "$pid" ] || continue
  cmd=$(tr "\0" " " </proc/$pid/cmdline 2>/dev/null || true)
  case "$cmd" in
    *watch_n80*) continue ;;
    *) log "kill old retry $pid"; kill "$pid" 2>/dev/null || true ;;
  esac
done < <(ps -eo pid,args | awk '/[r]etry_h106_n80/ {print $1}')
rm -f /root/logs/${HYP}_n80.done
# quarantine any false probe left behind
mkdir -p /root/affine_data/false_probes
ts=$(date -u +%Y%m%dT%H%M%SZ)
if [ -f /root/affine_data/${HYP}_decision.json ] && grep -q FALSE_PROBE /root/affine_data/${HYP}_decision.json 2>/dev/null; then
  mv /root/affine_data/${HYP}_decision.json "/root/affine_data/false_probes/${HYP}_decision_p426done_${ts}.json"
  rm -f /root/affine_data/${HYP}_sim_result.json
fi
export KING_REPO=Tok331102/affine-5EqYW8McUc-af10
export KING_REV=eb8bf9a356a254f71faaa439e8abc3cfba572c53
nohup env KING_REPO="$KING_REPO" KING_REV="$KING_REV" bash "$WATCH" "$HYP" "$RETRY" \
  >/root/logs/h106_watch_n80_p426_postdone.nohup 2>&1 &
echo $! >/root/logs/h106_watch_retry.pid
log "rearmed d203first watcher pid=$(cat /root/logs/h106_watch_retry.pid) KING_REPO=$KING_REPO"
# also ensure form
if ! ps -eo args | awk '/[w]atch_form_decision\.sh/ && / h106 / {found=1} END{exit !found}'; then
  nohup bash /root/mining_src/s4-h2-merge/watch_form_decision.sh h106 \
    /root/affine_data/h106_sim_result.json /root/affine_data/h106_decision.json \
    /root/logs/h106_form_decision.nohup \
    >/root/logs/h106_form_decision.launch.p426.nohup 2>&1 &
  echo $! >/root/logs/h106_form_decision.pid
  log "rearmed form pid=$(cat /root/logs/h106_form_decision.pid)"
fi
log "SIDE_DONE"
