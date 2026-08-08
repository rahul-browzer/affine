# Pass 391 — F4 n80 longwait rearm

## Problem
Range Tok shard1 at ~85% (~5.4 GiB left, writer PID alive). `tokwatch` (p388)
correctly waiting to stamp `tok331102.done` → king util=0.72 → chall.
Meanwhile `retry_h100_n80.sh` was in `_wait_engines 120` at poll≈36 — would
ABORT again ~22:22Z before king+chall can load (MoE 10–20 m each after DL).

## Action
- Wrote `retry_h100_n80_longwait.sh`: initial wait `${WAIT_ENGINE_POLLS:-360}`
  (90 m), mid `${WAIT_ENGINE_POLLS_MID:-120}`.
- Killed short retry PID 51096 + watcher PID 1269 by exact `$0` cmdline.
- Rearmed `watch_n80_retry.sh h100 …/retry_h100_n80_longwait.sh` (PID 54261);
  longwait launched (poll=0/360 @22:02:07Z).
- Left `watch_tok_done_serve_pass388.sh` PID 50986 untouched.

## Decision rule (unchanged)
Await Range→tok.done→king:8001→chall:8002→n80 margin vs Tok. Screen bar
+0.015 → CONFIRM k=4; submit only >0.04.
