#!/usr/bin/env bash
# Pass 192: after chall relaunch, require health + /v1/completions before n80.
set -euo pipefail

LOG=/root/logs/h30_chall_recover_pass192.log
log() { echo "[recover-wait192-h30] $(date -u +%Y-%m-%dT%H:%M:%SZ) $*" | tee -a "$LOG"; }

log "waiting chall health+probe (teacher+king must stay up)"
ok=0
for i in $(seq 1 160); do
  t=$(curl -s -o /dev/null -w "%{http_code}" --max-time 3 http://127.0.0.1:8000/health || true)
  k=$(curl -s -o /dev/null -w "%{http_code}" --max-time 3 http://127.0.0.1:8001/health || true)
  c=$(curl -s -o /dev/null -w "%{http_code}" --max-time 3 http://127.0.0.1:8002/health || true)
  if [[ "$t" == "200" && "$k" == "200" && "$c" == "200" ]]; then
    log "health t=$t k=$k c=$c at i=$i"
    sleep 20
    probe=$(curl -s --max-time 180 http://127.0.0.1:8002/v1/completions \
      -H "Content-Type: application/json" \
      -d '{"model":"/root/h30/merged","prompt":"hi","max_tokens":4,"temperature":0}' \
      | python3 -c "import sys,json; d=json.load(sys.stdin); print('ok' if d.get('choices') else 'bad')" 2>/dev/null || echo fail)
    log "chall_completions_probe=$probe i=$i"
    if [[ "$probe" == "ok" ]]; then
      ok=1
      break
    fi
  fi
  if [[ -f /root/logs/vllm_chall.pid ]]; then
    cpid=$(cat /root/logs/vllm_chall.pid || true)
    if [[ -n "${cpid:-}" ]] && ! kill -0 "$cpid" 2>/dev/null; then
      log "ERROR chall pid=$cpid dead at i=$i"
      exit 1
    fi
  fi
  if (( i % 10 == 0 )); then
    log "i=$i t=$t k=$k c=$c"
  fi
  sleep 15
done
if [[ "$ok" != "1" ]]; then
  log "ERROR chall never became promptable"
  exit 1
fi
log "chall promptable"

if ps -eo pid,cmd | awk '/[r]un_sim_duel.py/ && /local-h30/' | grep -q .; then
  log "n80 already running — done"
  exit 0
fi

# shellcheck disable=SC1091
source /root/venv/bin/activate
if [[ -f /root/mine.env ]]; then set -a; source /root/mine.env; set +a; fi
export PYTHONPATH=/root/mining_src/affine_pkg${PYTHONPATH:+:$PYTHONPATH}
export HF_HOME=${HF_HOME:-/root/hf}

rm -f /root/logs/h30_pipeline.aborted /root/logs/h30_n80_retry.aborted
date -u +%Y-%m-%dT%H:%M:%SZ > /root/logs/h30_chall_serve.done
nohup bash /root/mining_src/s4-h30-m7-king-self/retry_h30_n80.sh \
  >/root/logs/h30_n80_relaunch_pass192.nohup 2>&1 &
echo $! >/root/logs/h30_n80_relaunch_pass192.pid
log "relaunched retry pid=$(cat /root/logs/h30_n80_relaunch_pass192.pid)"

# Ensure form/retry watchers alive (awk; not pgrep alone)
if ! ps -eo pid,cmd | awk '/[w]atch_form_decision\.sh/ && / h30 /' | grep -q .; then
  nohup bash /root/mining_src/s4-h2-merge/watch_form_decision.sh \
    h30 /root/affine_data/h30_sim_result.json /root/affine_data/h30_decision.json \
    /root/logs/h30_form_decision.nohup \
    >/root/logs/h30_form_decision.launch.out 2>&1 &
  log "relaunched watch_form_decision"
fi
if ! ps -eo pid,cmd | awk '/[w]atch_n80_retry\.sh/ && / h30 /' | grep -q .; then
  nohup bash /root/mining_src/s4-h2-merge/watch_n80_retry.sh \
    h30 /root/mining_src/s4-h30-m7-king-self/retry_h30_n80.sh \
    >/root/logs/h30_watch_retry.launch.nohup 2>&1 &
  log "relaunched watch_n80_retry"
fi
log "DONE"
