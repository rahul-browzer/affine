# H60 pass260 — chall recover (default chall cache ENOENT)

## Symptom
- Merge DONE @07:05:26Z; weight_identical=false; HF salvage push armed.
- Chall launched @07:06:01Z gpus=4,5 util=0.72 TRITON=`/root/.triton/cache/chall`.
- Health :8002=200 @07:10:33Z; post_train deferred n80 to retry (PIPELINE_DONE).
- Completions hang: Worker ImportError
  `/root/.triton/cache/chall/4UYR2LE4…/__triton_launcher….so` ENOENT
  + shm_broadcast 60s loops. FALSE_PROBE class (not REFUTE).

## Action
- Quarantine: do not tear down pod.
- Launch `relaunch_chall_pass260.sh` (p253 diverse writable warmups→freeze)
  pid in `/root/logs/h60_chall_recover_pass260.pid` @07:15:06Z.
- Cleared hung retry/watch leftovers; GPUs 4–5 reaped to 0 MiB; attempt 1/3
  wiping role+isolated chall Triton caches then settle.

## Decision rule
- Recover OK → watcher rearms → n80; margin>0.04 submit else REFUTE.
- `FALSE_PROBE_*` ≠ REFUTE; never `lium rm`.
