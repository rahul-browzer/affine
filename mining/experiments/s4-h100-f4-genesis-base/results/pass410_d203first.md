# pass410 — F4 preempt H32 hash rotation (d203-first)

## Why
- F4 longwait still a203→b203→c203 MAX=3; attempt1 a203 already failed;
  live attempt2 b203 ~17/80. Attempt3 would be c203 (H32 on F7 p408).
- F7/F9 already on d203first; F4 was the remaining gap.

## Action
- Added `retry_h100_n80_d203first.sh` (drop a203+c203; d/e/f/g/b; MAX=6;
  longwait 360/120; FALSE_PROBE continue).
- SCP + `rearm_watcher_d203first_p410.sh` (kill watcher by `$0` cmdline).
- Left live longwait/sim on b203 alone.

## Status at arm
- b203 ~17/80; engines 200/200/200; watcher → d203first for next retry.
