# Pass 392 — F4 longwait watcher respawn fix

## Problem
`watch_n80_retry.sh` matched only `retry_${hyp}_n80\.sh`. Armed
`retry_h100_n80_longwait.sh` was invisible → watcher launched a new longwait
every POLL=30s. Observed 5 concurrent longwaits resetting `poll=0/360` each
spawn; engine wait never accumulates.

## Action
- Patched `s4-h2-merge/watch_n80_retry.sh` awk to match `retry_${hyp}_n80`
  (covers `_longwait`, `_b203first`).
- Killed watcher 54261 + children 54275/54726/55041/55380/55812 by PID.
- SCP fixed watcher; rearmed PID 56134 → single longwait 56147.
- Verified after 35s: still one longwait (no respawn).
- Left tokwatch 50986 + Range writer 42075 alone. Range 91%→96% @ ~13 MB/s.

## Next
Await Range→`tok331102.done`→king:8001+chall:8002→longwait n80 margin vs Tok.
