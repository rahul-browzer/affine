#!/usr/bin/env bash
set -euo pipefail
LOG=/root/logs/wait_tok_bootstrap.log
exec >>"$LOG" 2>&1
echo "[wait] $(date -u +%Y-%m-%dT%H:%M:%SZ) watching tok_init.done + fast_range_dl"
for i in $(seq 1 720); do
  if [[ -s /root/logs/tok_init.done && -s /root/logs/teacher.done ]]; then
    # ensure blob present and not still .partdata
    BLOB=/root/hf/hub/models--Tok331102--affine-5EqYW8McUc-af10/blobs/da0b5fc3bc074ae0cda8599d4e1b96cfed5817518b87f82dc18393398123d9aa
    if [[ -f "$BLOB" && ! -f "${BLOB}.partdata" ]]; then
      sz=$(stat -c%s "$BLOB")
      echo "[wait] tok ready size=$sz at iter=$i"
      break
    fi
  fi
  if [[ -f /root/logs/fast_range_dl.pid ]] && ! kill -0 "$(cat /root/logs/fast_range_dl.pid)" 2>/dev/null; then
    if [[ ! -s /root/logs/tok_init.done ]]; then
      echo "[wait] FATAL fast_range_dl exited without tok_init.done"
      tail -40 /root/logs/fast_range_dl.log || true
      exit 1
    fi
  fi
  sleep 10
done
if [[ ! -s /root/logs/tok_init.done ]]; then
  echo "[wait] FATAL timeout"
  exit 1
fi
# avoid double-launch
if [[ -f /root/logs/r3_train_launched.stamp ]]; then
  echo "[wait] train already launched; exit"
  exit 0
fi
if [[ -f /root/logs/bootstrap_r3.pid ]] && kill -0 "$(cat /root/logs/bootstrap_r3.pid)" 2>/dev/null; then
  echo "[wait] bootstrap already running pid=$(cat /root/logs/bootstrap_r3.pid)"
  exit 0
fi
echo "[wait] $(date -u +%Y-%m-%dT%H:%M:%SZ) relaunching bootstrap_r3.sh"
nohup bash /root/mining_src/r3-reason-grpo/bootstrap_r3.sh >/root/logs/bootstrap_r3.nohup 2>&1 &
echo $! >/root/logs/bootstrap_r3.pid
echo "[wait] bootstrap pid=$(cat /root/logs/bootstrap_r3.pid)"
