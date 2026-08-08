#!/usr/bin/env bash
# p410: re-point h100 watch_n80_retry → d203first. Match $0 only (p409).
# Leaves live longwait/sim alone.
set -euo pipefail
RETRY=/root/mining_src/s4-h100-f4-genesis-base/retry_h100_n80_d203first.sh
WATCH=/root/mining_src/s4-h2-merge/watch_n80_retry.sh
LOG=/root/logs/h100_watch_n80_d203first.log
PIDF=/root/logs/h100_watch_retry.pid

test -x "$RETRY"
test -x "$WATCH"

killed=0
for pid in /proc/[0-9]*; do
  cmd=$(tr '\0' ' ' <"$pid/cmdline" 2>/dev/null || true)
  # Match only scripts whose $0 is watch_n80_retry for h100 (not this rearm).
  case "$cmd" in
    *"/watch_n80_retry.sh h100 "*|*" watch_n80_retry.sh h100 "*)
      p=${pid#/proc/}
      kill "$p" 2>/dev/null || true
      killed=$((killed + 1))
      echo "killed watcher pid=$p"
      ;;
  esac
done
echo "killed_count=$killed"

nohup bash "$WATCH" h100 "$RETRY" >>"$LOG" 2>&1 &
echo $! >"$PIDF"
echo "armed d203first watcher pid=$(cat "$PIDF") retry=$RETRY"
sleep 1
ps -eo pid,cmd | awk '/watch_n80_retry/ && /h100/ && !/awk/ {print}'
tail -5 "$LOG" 2>/dev/null || true
