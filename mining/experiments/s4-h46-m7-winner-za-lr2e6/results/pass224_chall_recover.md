# Pass 224 — H46 chall freeze-recover launched

## Symptom
- :8002 models=000 while `vllm serve /root/h46/merged` alive (pid 13729).
- `vllm_chall.log`: `shm_broadcast` "No available shared memory broadcast block" (2×);
  later EngineCore claimed init 137.99s but API never reached health=200.
- Orphan `VLLM::Worker` / prior EngineCore PIDs on GPU 4–5 from earlier attempts.

## Action
- Adapted H45 `relaunch_chall_pass222.sh` → `relaunch_chall_pass224.sh`
  (EXP dirname sed **before** h45→h46; LESSONS clone rule).
- SCP + nohup on mine-h46-1 @ 2026-08-08T02:10:27Z.
- Reap/wipe/clear `torch_compile_cache` → relaunch TCACHE-isolated chall
  pid=16831 TCACHE=`h46_chall_p224_1786155027_16520`; waiting health then
  warmup+freeze+rearm `watch_n80_retry`.

## Next poll
- `/root/logs/h46_chall_recover_pass224.log` for `DONE_LAUNCH` / ABORT.
- Then n80 via retry watcher (a203 block_hash).
