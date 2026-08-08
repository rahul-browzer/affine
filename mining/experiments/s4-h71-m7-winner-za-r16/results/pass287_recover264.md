# H71 pass287 — bare chall → preempt264 → recover264

UTC 2026-08-08T10:28–10:36Z on mine-h71-1 (eager-fox-be).

## Sequence
1. Merge DONE 10:28:06Z; weight_identical=false vs m7 + Tok331102.
2. post_train chall-only re-serve :8002 GPUs 4,5 util=0.72
   `TRITON_CACHE_DIR=/root/.triton/cache/chall` (bare).
3. Mid-load Triton WARNING ghost ENOENT
   `…/NCEDKKNH…/__triton_launcher….so` (later present; load continued).
4. :8002=200 @10:35:12Z; preempt264 saw bare TCACHE → launch recover264
   pid=17072 (p283 no double-launch; single recover).
5. recover killed leftover watch_n80_retry (877) + retry_h71 (908);
   wiped chall caches; seeded king→isolated WRITABLE; relaunched chall
   `TCACHE=/root/.triton/isolated/h71_chall_p260_a1_1786185360_17072`
   pid=17274; waiting health then diverse-warm+freeze; will rearm form+n80.

## Side facts
- Stale retry wait started 10:05Z (before chall existed); at chall load was
  poll≈100/120 — would have aborted before promptable. recover kills+rearms.
- Teacher :8000 + Tok king :8001 stayed 200 through recover.
- HF pushes adapter/merged backgrounded at merge (non-blocking).

## Next
Await recover264 warm→freeze→rearm → n80 vs Tok331102 (a203/b203/c203).
