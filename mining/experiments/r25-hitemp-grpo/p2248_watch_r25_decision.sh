#!/usr/bin/env bash
# p2248: poll R3 for R25-on-R24 n80 decision
set -euo pipefail
ROOT=/home/const/subnet120/mining
LOG=$ROOT/experiments/r25-hitemp-grpo/artifacts/p2248_r25_decision_watch.log
mkdir -p "$(dirname "$LOG")"
exec >>"$LOG" 2>&1
log(){ echo "[p2248-dec] $(date -u +%Y-%m-%dT%H:%M:%SZ) $*"; }
HOST=204.9.206.245; PORT=40051
ssh_r(){ ssh -o StrictHostKeyChecking=accept-new -o ConnectTimeout=10 -o BatchMode=yes -p "$PORT" "root@$HOST" "$@"; }
log "start waiting for /root/affine_data/r25_decision.json"
for i in $(seq 1 360); do
  st=$(ssh_r 'bash -s' <<'EOS' || echo SSH_FAIL
if [[ -f /root/affine_data/r25_decision.json ]]; then
  echo DECISION; cat /root/affine_data/r25_decision.json
elif [[ -f /root/affine_data/r25_sim_progress.json ]]; then
  python3 -c 'import json;d=json.load(open("/root/affine_data/r25_sim_progress.json"));print("PROG",d.get("done"),"/",d.get("n"), "pairs",d.get("n_paired"))' 2>/dev/null || echo PROG
elif kill -0 "$(cat /root/logs/p2247_r24_serve_r25.pid 2>/dev/null || echo 0)" 2>/dev/null; then
  code=$(curl -s -o /dev/null -w "%{http_code}" --max-time 3 http://127.0.0.1:8002/v1/models || echo 000)
  echo SERVING :8002=$code
elif kill -0 "$(cat /root/logs/vllm_chall.pid 2>/dev/null || echo 0)" 2>/dev/null; then
  echo CHALL_LOAD
else
  echo DEAD; tail -n 8 /root/logs/p2247_r24_serve_r25.nohup 2>/dev/null | tr "\n" "|"
fi
EOS
)
  log "poll=$i $st"
  case "$st" in
    DECISION*) exit 0 ;;
    DEAD*) log "FATAL"; exit 1 ;;
  esac
  sleep 60
done
log "FATAL timeout"; exit 1
