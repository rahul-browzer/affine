# Pass 347 — H94 chall recover (bare-cache ENOENT → recover347)

## Symptom
- Bare post_train chall on `/root/.triton/cache/chall` hit
  `ImportError …/4UYR2LE4…/__triton_launcher.so` @17:58:31Z → EngineDead;
  :8002=000; GPUs 4,5 idle.
- `restart_for_h2.sh` + `post_train` stuck `wait t=1 k=1 c=0` ~15m;
  n80 aborted `aborted_engines_unhealthy`; retry polling engines.
- King healthy on bare `/root/.triton/cache/king` (launcher.so=16–17).

## Action
1. Adapted H91 `relaunch_chall_pass344.sh` → `relaunch_chall_pass347.sh`
   (live :8001 `TRITON_CACHE_DIR` seed + early-abort launcher ENOENT).
2. Launched recover347 **pid=19076** @18:08:22Z; killed stuck
   post_train/restart/retry leftovers; reaped GPUs 4,5 (already empty).

## Verified
- `seed TCACHE from /root/.triton/cache/king (launcher.so=16)`
- chall_pid=19198 util=0.72
  `TCACHE=/root/.triton/isolated/h94_chall_p260_a1_1786212543_19076`
- t/k=200 c=000 (loading). Teacher+king untouched.

## Next
Await health→diverse warm→freeze→`h94_chall_freeze_pass347.done` →
rearm form+n80 → **arm mid304 when n80 starts**.
