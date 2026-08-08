# Pass 300 — H76 king-only recover

## Symptom
- n80 died mid-draw (~18/80) with `httpx.ConnectError` after king
  `EngineDeadError` / `RPC call to sample_tokens timed out` @ 12:17:44Z.
- `:8000` teacher OK, `:8002` chall OK; `:8001` DOWN.
- Orphan `VLLM::Worker_TP*` ppid=1 on GPUs 2,3 (~117 GiB each).

## Action
- Launch `king_recover_pass300.sh` (king-only; chall untouched).
- Reap GPUs 2,3 by UUID→PID; wipe `cache/king`; relaunch Tok331102 @
  `eb8bf9a…` util 0.80; wait completions 200; clear stale sim progress.
- Existing `watch_n80_retry` / `retry_h76_n80` stay armed → fresh n80 vs Tok a203.

## Decision rule
- FALSE_PROBE path, not REFUTE. Next pass: await `h76_decision.json`.
