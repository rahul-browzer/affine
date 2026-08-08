# H63 pass264 — preempt bare TCACHE before n80

## Why
H61/H62 served chall with bare `TRITON_CACHE_DIR=/root/.triton/cache/chall`;
H62 needed p262 diverse-freeze recover mid-flight. STATE: preempt H63/H64.

## Action (2026-08-08T07:42Z)
- Cloned `relaunch_chall_pass262.sh` → `relaunch_chall_pass264.sh` (h62→h63,
  EXP=`s4-h63-m7-winner-za-lr505e6`; leftover h62/r20 = 0).
- Uploaded + launched `watch_preempt_bare_tcache_pass264.sh` pid=10613.
- Watcher waits for `h63_chall_serve.done` or `:8002` models=200; if TCACHE
  bare/non-isolated (or isolated but mode≠555 / n_so<16) → nohup recover264.

## State at arm
- train.done present; post_train still polling → merge next.
- teacher+king up; chall :8002 down (expected until merge serve).
