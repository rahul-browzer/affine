# H88 pass335 — king EngineDead + bare chall TCACHE

## Facts
- :8000=200 :8001=000 :8002=200. GPUs 2,3 empty (king dead).
- King log: completions 500s then Shutdown @16:28:11Z (EngineDead).
- Chall TCACHE=`/root/.triton/cache/chall` mode=755 (**bare** — n80 unsafe).
- form + watch_n80_retry were armed but blocked on king.

## Actions
1. Launched `king_recover_pass311.sh` pid=20492 (wipe king caches, leave chall).
2. Launched `relaunch_chall_pass264.sh` pid=20582 (bare→isolated freeze).
   Recover killed leftover watch_n80 pid=920 (expected; rearms form+n80).
3. Teacher stayed :8000=200 through both launches.

## Next
Wait both recovers DONE → all three promptable → n80 a203 + arm mid304.
