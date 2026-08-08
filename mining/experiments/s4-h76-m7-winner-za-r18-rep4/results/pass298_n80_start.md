# H76 pass298 — n80 start after stale-retry refresh

UTC: 2026-08-08T12:12Z

## Problem
- `retry_h76_n80.sh` at poll **112/120** while chall still compiling (GPUs 4,5 ~38 GiB).
- Bare post_train chall then hit health; preempt264 saw bare TCACHE → recover264.

## Action
- Refreshed watcher+retry (fresh poll 0/120). Lesson: even `/[r]etry_h76_n80\.sh/`
  matches `watch_n80_retry …/retry_….sh` argv — exclude watcher when killing.
- recover264 relaunched chall on isolated TCACHE; completions **200×2** @12:11:55Z.
- n80 attempt 1/3 started @12:12:18Z block_hash=a203… vs Tok331102.

## Status at handoff
- `run_sim_duel.py` live (local-h76). recover264 still mid settle→writable-w1 after
  health=200 — next pass: watch for FALSE_PROBE if freeze races n80.
- H74 ~71/80 · H75 ~58/80 · H77/H78 still merging.
