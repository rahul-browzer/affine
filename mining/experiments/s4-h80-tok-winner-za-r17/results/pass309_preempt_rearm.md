# Pass 309 — H80 preempt rearm

**UTC:** 2026-08-08T12:58:47Z

## Problem
post_train chall-only serve @12:55:53Z with **bare** `TRITON_CACHE_DIR=/root/.triton/cache/chall`
(pid 17043, GPUs 4,5). Shard load still 0/2 @12:58Z on FUSE.GOCRYPTFS (64.56 GiB).
Preempt watcher (pid 892, armed at rent) hit poll **192/240** and would TIMEOUT
~12:66Z — before `:8002` can return 200 → recover264 never fires → bare n80 risk.

## Action
- Killed preempt pid 892 (PID-only; no `pkill -f`).
- Relaunched `watch_preempt_bare_tcache_pass264.sh` → pid **19017**, fresh 240 polls.
- Form + n80_retry + mid304 + post_train left alive; n80_retry ~poll 56/120 waiting engines.
- port8002=000 at rearm; teacher+king :8000/:8001=200.

## Pod stamp
`/root/affine_data/h80_pass309_preempt_rearm.json`

## Next
Wait chall health200 → preempt fires recover264 (bare→isolated) → triple-promptable → n80 a203.
