#!/usr/bin/env bash
# Pass 191: wait king health+completions; if pipeline aborted, serve chall + n80.
set -euo pipefail

LOG=/root/logs/h31_king_recover_pass191.log
log() { echo "[recover-wait191-h31] $(date -u +%Y-%m-%dT%H:%M:%SZ) $*" | tee -a "$LOG"; }

log "waiting king health+probe (pipeline may resume on health alone)"
ok=0
for i in $(seq 1 160); do
  k=$(curl -s -o /dev/null -w "%{http_code}" --max-time 3 http://127.0.0.1:8001/health || true)
  t=$(curl -s -o /dev/null -w "%{http_code}" --max-time 3 http://127.0.0.1:8000/health || true)
  if [[ "$k" == "200" && "$t" == "200" ]]; then
    log "health t=$t k=$k at i=$i"
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
    log "i=$i t=$t k=$k"
  fi
  sleep 15
done
if [[ "$ok" != "1" ]]; then
  log "ERROR king never became promptable"
  exit 1
fi
log "king promptable"

# If live pipeline already moved to chall/n80, noop.
if ps -eo pid,cmd | awk '/[r]un_sim_duel.py/ && /local-h31/' | grep -q .; then
  log "n80 already running — done"
  exit 0
fi
if [[ -f /root/logs/h31_chall_serve.done ]] && \
   [[ "$(curl -s -o /dev/null -w "%{http_code}" --max-time 3 http://127.0.0.1:8002/health || true)" == "200" ]]; then
  log "chall already up — kick retry_h31_n80 if needed"
  # shellcheck disable=SC1091
  source /root/venv/bin/activate
  if [[ -f /root/mine.env ]]; then set -a; source /root/mine.env; set +a; fi
  export PYTHONPATH=/root/mining_src/affine_pkg${PYTHONPATH:+:$PYTHONPATH}
  export HF_HOME=${HF_HOME:-/root/hf}
  rm -f /root/logs/h31_pipeline.aborted /root/logs/h31_n80_retry.aborted
  nohup bash /root/mining_src/s4-h31-m7-king-self-lr3e5/retry_h31_n80.sh \
    >/root/logs/h31_n80_relaunch_pass191.nohup 2>&1 &
  echo $! >/root/logs/h31_n80_relaunch_pass191.pid
  log "relaunched retry pid=$(cat /root/logs/h31_n80_relaunch_pass191.pid)"
  exit 0
fi

# Pipeline aborted or still stuck: chall-only serve then n80.
if [[ -f /root/logs/h31_pipeline.aborted ]] || \
   ! ps -eo pid,cmd | awk '/[p]ost_train_pipeline.sh/ && /h31/' | grep -q .; then
  log "pipeline gone/aborted — chall-only serve + n80"
  # shellcheck disable=SC1091
  source /root/venv/bin/activate
  if [[ -f /root/mine.env ]]; then set -a; source /root/mine.env; set +a; fi
  export HF_HOME=${HF_HOME:-/root/hf}
  MERGED=/root/h31/merged
  KING_REPO=TalentPigs/affine-5ekxlcg3fx-abc
  KING_REV=dbfbb3e2a17c7603e7fc68a3a15b343f42dfdef4
  unset CUDA_VISIBLE_DEVICES
  RESTART_KING=0 \
    MERGE="$MERGED" \
    KEVIN_REPO="$KING_REPO" \
    KEVIN_REV="$KING_REV" \
    TEACHER_REPO=zai-org/GLM-4.5-Air-FP8 \
    bash /root/mining_src/s4-h2-merge/restart_for_h2.sh
  date -u +%Y-%m-%dT%H:%M:%SZ > /root/logs/h31_chall_serve.done
  log "CHALL_SERVE_DONE"
  export PYTHONPATH=/root/mining_src/affine_pkg${PYTHONPATH:+:$PYTHONPATH}
  rm -f /root/logs/h31_pipeline.aborted /root/logs/h31_n80_retry.aborted
  nohup bash /root/mining_src/s4-h31-m7-king-self-lr3e5/retry_h31_n80.sh \
    >/root/logs/h31_n80_relaunch_pass191.nohup 2>&1 &
  echo $! >/root/logs/h31_n80_relaunch_pass191.pid
  log "relaunched retry pid=$(cat /root/logs/h31_n80_relaunch_pass191.pid)"
else
  log "pipeline still alive — leave it to chall+n80 after health"
fi
log "DONE"
