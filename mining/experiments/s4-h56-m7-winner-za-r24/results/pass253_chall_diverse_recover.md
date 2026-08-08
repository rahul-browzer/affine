# H56 pass253 — chall recover after p251 freeze→n80 ENOENT

## Symptom
- p251 writable-w1→freeze: a1 w1/w2/w3=200, n_so 16→22, mode=555 @05:58Z.
- n80 a203 started @05:58:37Z → FALSE_PROBE @05:59:24Z
  `rejection_reason=unpromptable:…ConnectError`
- chall log: Triton `__triton_launcher.so` ENOENT for hash
  `OV4T43ALNWYQZE7T4BHFALNYA46DNQIQ3HNMOAGEVHXEXIJTCUGA` under frozen
  isolated TCACHE; EngineDead; :8002 down. GPUs 4–5 free.

## Action
- Quarantine artifact (not REFUTE).
- Launch `relaunch_chall_pass253.sh` (pid recorded in
  `/root/logs/h56_chall_recover_pass253.pid`): same king-seed + writable
  path as p251, but **diverse warmups** (short/med/long/4k) before freeze
  to JIT the n80-shaped hash while writable.

## Decision rule
- Recover OK → watcher rearms → n80; margin>0.04 submit else REFUTE.
- `FALSE_PROBE_*` ≠ REFUTE; never `lium rm`.
