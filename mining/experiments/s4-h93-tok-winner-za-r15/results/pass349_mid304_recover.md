# Pass 349 — H93 n80 live on bare chall → mid304 → recover264

## Symptom
- n80 a203 started (`run_sim_duel` local-h93); t/k/c = 200/200/200.
- Chall `TRITON_CACHE_DIR=/root/.triton/cache/chall` (bare); king also bare.
- mid304 not armed (recover264 rearms form+n80 only).

## Action
- Armed `watch_mid_n80_bare_tcache_pass304.sh` pid=20451 @18:20:56Z.
- First two loops false-skipped (`recover already alive`) — concurrent
  `bash -c` argv contained `relaunch_chall_pass264.sh` string.
- @18:21:26Z fired recover264 pid=20547; killed sim 19793; GPUs 4,5 free;
  attempt 1/3 settle after wipe.

## Next
Await recover264 DONE (freeze+rearm form/n80) → **re-arm mid304** when
n80 starts (one-shot mid304 exits when sim dies).
