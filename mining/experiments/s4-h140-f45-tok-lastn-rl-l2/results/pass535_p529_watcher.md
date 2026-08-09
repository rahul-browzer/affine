# p535 — F45 watcher → p529 (d203-first + nested FP)

## Why
Live `retry_h140_n80_d203first.sh` was still a203-first and wrote `N80_DONE` on any
rc=0 (no nested `_is_false_probe_sim`). Attempt1 a203 already died king-400@40;
attempt2 b203 mid-n80. F44/F46 had this fix; F45 did not.

## Done
1. Added `retry_h140_n80_d203first_p529.sh` (from H141 p529; d203-first + nested FP).
2. Patched local+pod `relaunch_chall_pass264.sh` and `upload_and_launch.sh` → p529
   (avoids p531 undo on recover264 DONE_LAUNCH).
3. Killed watcher pid=928 by PID (python /proc cmdline); armed watcher → p529.
4. Left live old retry (24373) + b203 n80 (27868) alone — do not interrupt mid-flight.

## State at arm
engines 200/200/200; n80 b203 @~16→17/80; form watcher untouched.
Next FP or retry death → p529 (not a203).
