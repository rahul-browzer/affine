# Pass 344 — H91 chall recover (king-seed + early-abort)

## Symptom
- p264 recover (pid=24172) hung on health polls after load-time
  `ImportError …/NODUTTS4…/__triton_launcher.so` @17:24:21Z.
- Log: "no king TCACHE to seed" — king lives on
  `/root/.triton/isolated/h91_king_p340_…` not `/root/.triton/cache/king`.
- Chall cold-JIT hit ghost launcher; EngineCore shm_broadcast; :8002=000;
  GPUs 4,5 ~37 GiB. Teacher+king stayed 200.

## Action
1. Killed recover264 pid=24172 (cmdline `/relaunch_chall_pass264.sh`).
2. Reaped chall 24285 + workers 24891/24892; GPUs 4,5 → 0 MiB.
3. Uploaded `relaunch_chall_pass344.sh`: seed from live :8001
   `TRITON_CACHE_DIR`; early-abort wait_health on launcher ImportError.
4. Launched recover344 **pid=26499** @17:32:46Z.

## Verified
- `seed TCACHE from …/h91_king_p340_1786209038_16311 (launcher.so=16)`
- chall_pid=26576 util=0.72 isolated TCACHE; t/k=200 c=000 (loading).

## Next
Await health→diverse warm→freeze→`h91_chall_freeze_pass344.done` →
rearm form+n80 → arm mid304 when n80 starts.
