# pass396 — F7 dual-n80 + watcher pattern

## Symptom
Two `retry_h102_n80_b203first.sh` under one `watch_n80_retry` (PIDs 32693+33687)
spawned concurrent sims on **c203** and **b203**, same `h102_sim_result.json`.

## Root cause
Pod copy of `watch_n80_retry.sh` still matched only `retry_${hyp}_n80\\.sh`.
`…_b203first.sh` / `…_longwait.sh` invisible → POLL respawn (LESSONS p392; local
already fixed, pods stale).

## Action
- Kill c203 sim 33788 + parent retry 32693; keep b203 33908/33687.
- SCP fixed watcher → F4/F6/F7/F8/F9; rearm F7 watcher 34604.
- 35s later: still single b203 (no respawn).

## Next
Await b203 margin; do not re-arm a second retry.
