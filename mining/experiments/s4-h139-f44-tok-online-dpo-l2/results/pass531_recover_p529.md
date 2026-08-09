# p531 — F44 recover264 DONE + watcher p529 + relaunch path fix

## Timeline
- chall recover264 health=200 @ poll=33; CUDA-graph/autotune; freeze n_so=23; DONE_LAUNCH 11:29:25Z.
- recover rearmed watcher to **stale** `retry_h139_n80_d203first.sh` (a203).
- Immediately killed that watcher; armed `*_p529.sh`. Live retry was already p529; n80 d203 started 11:28:03Z.
- SCP patched `relaunch_chall_pass264.sh` → p529 after process exit (never edit live running script).

## Status
engines 200/200/200; n80 d203 via p529; form+watcher on p529.
FP≠REFUTE. Await margin; m>+0.015 → CONFIRM k=4.
