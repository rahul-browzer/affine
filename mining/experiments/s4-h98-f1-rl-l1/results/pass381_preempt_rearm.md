# H98/F1 pass381 — rearm preempt after TIMEOUT

## Symptom
- Merge DONE 21:16Z (`weight_identical=false`, 66 GiB + visual).
- Chall re-serve started 21:17Z on **bare** `TRITON_CACHE_DIR=/root/.triton/cache/chall`
  GPUs 4,5 util=0.72; loading shards 0/3 @21:18Z; :8002 still 000.
- `watch_preempt_bare_tcache_pass264` had **TIMEOUT @19:47Z** (poll 240/240)
  during train/merge — no live preempt when chall finally launched.
- n80_retry waiting engines (poll~36/120); form watcher alive.

## Action
- Rearmed `watch_preempt_bare_tcache_pass264.sh` pid=36816 @21:19:01Z.
- On :8002=200 with bare TCACHE → recover264 (expected).

## Next
Await chall health→recover264→completions probe→n80 vs Tok.
