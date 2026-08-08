# H84 pass322 — mid304 arm + king322 recover

## Findings
- n80 had started (run_sim_duel a203) then king EngineDead @14:41:55Z:
  bare `/root/.triton/cache/king/EAUHKKZ…/__triton_launcher.so` ENOENT.
- :8001=000; :8000/:8002=200; GPUs 2,3 free; chall isolated TCACHE intact.
- retry_h84_n80 waiting engines (ConnectError after king death).

## Actions
1. Armed mid304 pid=24264 (`watch_mid_n80_bare_tcache_pass304.sh`) — recover264
   had not rearmed it.
2. Fired `king_recover_pass322.sh` pid=24932 — isolated TCACHE
   `/root/.triton/isolated/h84_king_p322_1786200212_24932` util=0.72
   (not bare 311 / not util=0.80). Leave chall alone.

## Next
Await `h84_king_recover_pass322.done` / KING PROMPTABLE → retry relaunches n80.
Keep mid304. If ABORT exit2/3 → re-fire lower util / fresh isolated.
