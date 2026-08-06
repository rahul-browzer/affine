#!/usr/bin/env bash
set -euo pipefail
mkdir -p /root/logs /root/hf
pkill -f '/root/bootstrap.sh' 2>/dev/null || true
sleep 1
nohup bash /root/bootstrap.sh >> /root/logs/bootstrap.nohup.out 2>&1 &
echo "BOOTSTRAP_PID=$!"
sleep 4
echo "=== nohup ==="
tail -n 50 /root/logs/bootstrap.nohup.out || true
echo "=== log ==="
tail -n 50 /root/logs/bootstrap.log || true
test -s /root/mine.env && echo MINE_ENV_STILL_OK
ps -ef | grep -E 'bootstrap|uv|snapshot' | grep -v grep || true
