# pass409 — F9 preempt H32 hash rotation (d203-first)

## Why
- F7 p408: c203 teacher 400 @~7/80 (`30977+1792 > 32768`).
- F9 was mid-n80 on c203 (~14/80) when armed; left live sim alone.

## Action
- Added `retry_h104_n80_d203first.sh` (drop a203+c203; d/e/f/g/b; MAX=6;
  longwait 360/120; FALSE_PROBE continue).
- SCP + rearm watcher → d203first (sim kept on c203).
- Lesson: never `bash -c` containing watcher path when killing by cmdline
  substring — killed SSH session; use scp'd rearm script matching `$0`.

## Status at arm
- c203 continuing (later ~47/80); watcher live on d203first for next retry.
