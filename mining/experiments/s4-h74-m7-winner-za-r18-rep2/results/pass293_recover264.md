# H74 pass293 — bare chall up → recover264 isolated relaunch

UTC 2026-08-08T11:12–11:14Z · mine-h74-1 brave-orbit-28

## What happened
- Bare post_train chall (`TRITON_CACHE_DIR=/root/.triton/cache/chall`) reached
  `:8002` health=200 @ ~11:12:39Z after ~6m load (compile+cudagraph).
- preempt264 saw BARE TCACHE → launched `relaunch_chall_pass264.sh` pid=17163.
- Recover killed bare chall + post_train wait + stale retry/watcher; **kept**
  teacher:8000 + Tok king:8001.
- Attempt 1/3: wipe → settle 30s → seed king cache (launcher.so=16) WRITABLE →
  launch chall pid=17413 on
  `TCACHE=/root/.triton/isolated/h74_chall_p260_a1_1786187602_17163`
  util=0.72 GPUs 4,5. Waiting health=200 then diverse-warm → freeze → rearm
  form+n80.

## Next
Await recover264 DONE (warm+freeze+rearm) → n80 vs Tok a203 → decision.json.
Do not kill recover; do not sed live scripts.
