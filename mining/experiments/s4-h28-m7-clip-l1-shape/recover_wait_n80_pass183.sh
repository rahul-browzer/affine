#!/usr/bin/env bash
# Wait for king health+completions probe, then kick retry_h28_n80.sh.
# Separate file so recover-wait cannot self-match its own bash -c argv.
set -euo pipefail

LOG=/root/logs/h28_king_recover_pass183.log
log() { echo "[recover-wait183] $(date -u +%Y-%m-%dT%H:%M:%SZ) $*" | tee -a "$LOG"; }

log "waiting king health+probe"
ok=0
for i in $(seq 1 160); do
  k=$(curl -s -o /dev/null -w "%{http_code}" --max-time 3 http://127.0.0.1:8001/health || true)
  t=$(curl -s -o /dev/null -w "%{http_code}" --max-time 3 http://127.0.0.1:8000/health || true)
  c=$(curl -s -o /dev/null -w "%{http_code}" --max-time 3 http://127.0.0.1:8002/health || true)
  if [[ "$k" == "200" && "$t" == "200" && "$c" == "200" ]]; then
    log "health t=$t k=$k c=$c at i=$i"
    sleep 20
    probe=$(curl -s --max-time 180 http://127.0.0.1:8001/v1/completions \
      -H "Content-Type: application/json" \
      -d '{"model":"TalentPigs/affine-5ekxlcg3fx-abc","prompt":"hi","max_tokens":4,"temperature":0}' \
      | python3 -c "import sys,json; d=json.load(sys.stdin); print('ok' if d.get('choices') else 'bad')" 2>/dev/null || echo fail)
    log "king_completions_probe=$probe i=$i"
    if [[ "$probe" == "ok" ]]; then
      ok=1
      break
    fi
  fi
  if [[ -f /root/logs/vllm_king.pid ]]; then
    kpid=$(cat /root/logs/vllm_king.pid || true)
    if [[ -n "${kpid:-}" ]] && ! kill -0 "$kpid" 2>/dev/null; then
      log "ERROR king pid=$kpid dead at i=$i"
      exit 1
    fi
  fi
  if (( i % 10 == 0 )); then
    log "i=$i t=$t k=$k c=$c"
  fi
  sleep 15
done
if [[ "$ok" != "1" ]]; then
  log "ERROR king never became promptable"
  exit 1
fi

# shellcheck disable=SC1091
source /root/venv/bin/activate
if [[ -f /root/mine.env ]]; then
  set -a
  # shellcheck disable=SC1091
  source /root/mine.env
  set +a
fi
export PYTHONPATH=/root/mining_src/affine_pkg${PYTHONPATH:+:$PYTHONPATH}
export HF_HOME=${HF_HOME:-/root/hf}

# Clear aborted markers so retry can proceed
rm -f /root/logs/h28_pipeline.aborted /root/logs/h28_n80_retry.aborted
rm -f /root/logs/h28_n80.done

nohup bash /root/mining_src/s4-h28-m7-clip-l1-shape/retry_h28_n80.sh \
  >/root/logs/h28_n80_relaunch_pass183.nohup 2>&1 &
echo $! >/root/logs/h28_n80_relaunch_pass183.pid
log "relaunched retry_h28_n80 pid=$(cat /root/logs/h28_n80_relaunch_pass183.pid)"

# Ensure form+retry watchers are alive (count via awk, not pgrep -f)
form_n=$(ps -eo pid,cmd | awk '/[w]atch_form_decision\.sh/ && / h28 /' | wc -l)
retry_n=$(ps -eo pid,cmd | awk '/[w]atch_n80_retry\.sh/ && / h28 /' | wc -l)
log "watchers form=$form_n retry=$retry_n"
if [[ "$form_n" -eq 0 ]]; then
  if [[ ! -x /root/mining_src/s4-h2-merge/watch_form_decision.sh ]]; then
    log "WARN form script missing — next pass must re-scp"
  else
    nohup bash /root/mining_src/s4-h2-merge/watch_form_decision.sh \
      h28 /root/affine_data/h28_sim_result.json /root/affine_data/h28_decision.json \
      /root/logs/h28_form_decision.nohup \
      >/root/logs/h28_form_decision.launch.out 2>&1 &
    echo $! >/root/logs/h28_form_decision.pid
    log "re-armed form pid=$(cat /root/logs/h28_form_decision.pid)"
  fi
fi
if [[ "$retry_n" -eq 0 ]]; then
  nohup bash /root/mining_src/s4-h2-merge/watch_n80_retry.sh \
    h28 /root/mining_src/s4-h28-m7-clip-l1-shape/retry_h28_n80.sh \
    >/root/logs/h28_watch_retry.launch.nohup 2>&1 &
  echo $! >/root/logs/h28_watch_retry.pid
  log "re-armed retry-watcher pid=$(cat /root/logs/h28_watch_retry.pid)"
fi
log "DONE"
