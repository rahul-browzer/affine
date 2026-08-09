# p531 — F46 watcher rearm + recover264 rearm path fix

## Problem
Live `watch_n80_retry` pointed at misnamed `retry_h141_n80_d203first.sh` (a203-first, no nested FP guard).
`relaunch_chall_pass264.sh` line 477 also rearmed that stale path — recover264 at 11:23:50Z undid p529's watcher.

## Fix
1. Killed stale watcher; armed `retry_h141_n80_d203first_p529.sh` (left live p529 retry + d203 n80 alone).
2. Patched local+pod `relaunch_chall_pass264.sh` and `upload_and_launch.sh` → p529.
3. Progress at fix: c=3…10/80 d203; engines 200/200/200.

## Decision rule unchanged
Await n80 margin; m>+0.015 → CONFIRM k=4; else REFUTE/tear (no replace).
