# pass396 — F9 bare-cache peer-seed then preempt→isolated

## Timeline
- post_train served chall on **bare** `/root/.triton/cache/chall` (3 .so).
- 22:23:50Z peer-seed king→bare: 3→20 .so; chall reached health+completions 200.
- 22:24:55Z `watch_preempt_bare` killed healthy chall (bare path = recover trigger).
- recover264 relaunch: pathfile seed **19 launcher.so** → isolated
  `h104_chall_p260_a1_1786227931_26802`; chall_pid=26987 loading.

## Lesson
Peer-seeding bare cache buys minutes then preempt fires. Prefer isolated TCACHE
from first launch; if stuck on bare mid-load, either disable preempt or let
recover264 own the relaunch (do not fight it with mid-load rsync alone).

## Next
Await chall:8002=200 → warm/freeze → n80.
