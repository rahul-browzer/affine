# H104/F9 pass 400 — arm n80 longwait during king332 load

## Symptom
After p399 king332 Tok relaunch (:8001), short `retry_h104_n80.sh` was mid-retry
waiting engines at **poll=32/40** while king still loading (GPU2/3 ~38 GiB,
`:8001=000`). Chall `:8002=200` + teacher `:8000=200` already up. Poll40 would
ABORT before king promptable (~10–15 m MoE load).

## Action
- Added `retry_h104_n80_longwait.sh` (WAIT 360 / mid 120, same as F8/F4).
- SCP to pod; killed short retry+watcher by PID; rearmed
  `watch_n80_retry.sh h104 …/retry_h104_n80_longwait.sh`.
- Confirmed: watcher+longwait live; log shows `poll=0/360` @ 22:45:34Z.

## Note
SSH `ps|awk` self-match on cmdline can false-skip rearm — use `/proc/*/cmdline`
exact `$0` match (LESSON already).
