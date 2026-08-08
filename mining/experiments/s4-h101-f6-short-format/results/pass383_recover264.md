# H101/F6 pass383 — bare chall Triton ENOENT → recover264

## Symptom
- Merged chall finished weight load 3/3 then died at engine startup:
  `RuntimeError: .../cache/chall/WPOY3MSZ…/__triton_launcher….so: No such file`
  (bare `/root/.triton/cache/chall`, classic FALSE_PROBE path).

## Action
- Fired `relaunch_chall_pass264.sh` (pid 19128) @ 21:30:05Z.
- Rearmed `watch_n80_retry` for h101 (was absent after earlier abort).
- T/K stayed :8000/:8001=200; form watcher live; preempt still polling.

## Next
Await recover264 DONE (isolated :8002=200 + freeze) → n80 vs Tok.
