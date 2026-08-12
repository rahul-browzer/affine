#!/usr/bin/env bash
# p2247 host watcher: when R25 merge lands on R24, swap chall and n80 (backup path).
set -euo pipefail
ROOT=/home/const/subnet120/mining
LOG=$ROOT/experiments/r25-hitemp-grpo/artifacts/p2247_r24_dl_watch.log
mkdir -p "$(dirname "$LOG")"
exec >>"$LOG" 2>&1
log(){ echo "[p2247-r24w] $(date -u +%Y-%m-%dT%H:%M:%SZ) $*"; }

HOST=204.9.206.245
PORT=40051
ssh_r24(){ ssh -o StrictHostKeyChecking=accept-new -o ConnectTimeout=10 -o BatchMode=yes -p "$PORT" "root@$HOST" "$@"; }

log "wait for /root/r25_from_hf complete"
for i in $(seq 1 240); do
  st=$(ssh_r24 'bash -s' <<'EOS' || echo SSH_FAIL
if [[ -f /root/r25_from_hf/config.json && -f /root/r25_from_hf/model-00016-of-00016.safetensors ]]; then
  echo READY $(du -sh /root/r25_from_hf | awk "{print \$1}")
elif [[ -f /root/logs/r25_hf_dl.pid ]] && kill -0 "$(cat /root/logs/r25_hf_dl.pid)" 2>/dev/null; then
  echo DOWNLOADING $(du -sh /root/r25_from_hf 2>/dev/null | awk "{print \$1}")
else
  echo DEAD
  tail -n 5 /root/logs/r25_hf_dl.nohup 2>/dev/null | tr "\n" "|"
fi
EOS
)
  log "poll=$i $st"
  case "$st" in
    READY*) break ;;
    DEAD*) log "FATAL dl dead"; exit 1 ;;
  esac
  sleep 30
  if (( i == 240 )); then log "FATAL timeout"; exit 1; fi
done

scp -o StrictHostKeyChecking=accept-new -P "$PORT" \
  "$ROOT/experiments/r25-hitemp-grpo/p2247_r24_serve_r25_n80.sh" \
  "root@$HOST:/root/" || true

log "launch R25-on-R24 serve+n80"
ssh_r24 'bash -s' <<'EOS'
set -euo pipefail
chmod +x /root/p2247_r24_serve_r25_n80.sh
if [[ -f /root/affine_data/r25_decision.json ]]; then
  echo ALREADY_HAVE_DEC
  cat /root/affine_data/r25_decision.json
  exit 0
fi
nohup bash /root/p2247_r24_serve_r25_n80.sh >/root/logs/p2247_r24_serve_r25.nohup 2>&1 &
echo $! >/root/logs/p2247_r24_serve_r25.pid
sleep 3
if kill -0 "$(cat /root/logs/p2247_r24_serve_r25.pid)" 2>/dev/null; then
  echo SERVE_ARMED pid=$(cat /root/logs/p2247_r24_serve_r25.pid)
else
  echo FAIL
  tail -n 40 /root/logs/p2247_r24_serve_r25.nohup || true
  exit 1
fi
EOS
log "DONE"
