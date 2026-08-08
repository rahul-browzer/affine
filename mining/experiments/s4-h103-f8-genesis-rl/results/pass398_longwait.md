# H103/F8 pass398 — longwait arm

## Problem
Shortwait `retry_h103_n80.sh` at poll **108/120** while king332 Tok still loading
(`:8001=000`, poll~30/180) and chall never started (`:8002=000`, GPUs 4–5 idle).
post_train waiting on king health before `restart_for_h2.sh` → merged chall.
120×15s would ABORT before chall load even begins.

## Action
- Wrote `retry_h103_n80_longwait.sh` (WAIT_ENGINE_POLLS=360, same as F4 p391).
- SCP → pod; kill shortwait retry pid=19641 + watcher pid=877 by PID.
- Rearm watcher → longwait; launch longwait pid=26896 (poll 0/360 @22:34:11Z).

## State left
- king_recover_pass332 still loading Tok util0.72 isolated TCACHE.
- post_train alive → will chall-serve `/root/h103/merged` when king promptable.
- merge.done + OK_NON_IDENTICAL already present.
- Next: king done → chall↑ → longwait n80.
