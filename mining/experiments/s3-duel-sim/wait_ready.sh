#!/usr/bin/env bash
# Poll teacher/king/challenger /v1/models until all answer or timeout.
set -euo pipefail

TIMEOUT_S=${TIMEOUT_S:-1800}
START=$(date +%s)

ok() {
  local port=$1
  curl -sf --max-time 5 "http://127.0.0.1:${port}/v1/models" >/dev/null 2>&1
}

while true; do
  t=0; k=0; c=0
  ok 8000 && t=1
  ok 8001 && k=1
  ok 8002 && c=1
  now=$(date +%s)
  elapsed=$((now - START))
  echo "[wait] t=${t} k=${k} c=${c} elapsed=${elapsed}s"
  if [[ $t -eq 1 && $k -eq 1 && $c -eq 1 ]]; then
    echo "[wait] ALL_READY"
    exit 0
  fi
  if [[ $elapsed -ge $TIMEOUT_S ]]; then
    echo "[wait] TIMEOUT after ${TIMEOUT_S}s"
    for name in teacher king chall; do
      echo "---- tail vllm_${name}.log ----"
      tail -n 40 "/root/logs/vllm_${name}.log" 2>/dev/null || true
    done
    exit 1
  fi
  sleep 15
done
