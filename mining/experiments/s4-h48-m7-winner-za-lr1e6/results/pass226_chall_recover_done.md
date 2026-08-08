# Pass 226 — H48 recover → DONE_LAUNCH → n80

## Recover outcome
- `h48_chall_recover_pass225.log`: health=200 @ poll=28 (02:22:48Z).
- Warmup completions 200×3 after freeze; TCACHE
  `/root/.triton/isolated/h48_chall_p225_1786155461_17395` mode 555 (a-w).
- `DONE_LAUNCH` 2026-08-08T02:23:18Z; rearmed `watch_n80_retry` pid=20426.

## n80
- retry: double-promptable @ 02:23:39Z → attempt 1/3 `block_hash=a203…`.
- `run_sim_duel.py` pid=20645 alive; engines t/k/c=200; chall completions 200×2.
- Stale `/root/logs/h48_sim_n80.done` @ 02:16:49Z (pre-recover false stamp) —
  ignored; new sim writing to `h48_sim_progress.json` (may lag first turns).

## Peer snap @ ~02:25Z
- H45 n80 ~32/80 · H46 ~14/80 · H47 ~20/80 · H49 train.done→merge (~48% load).
