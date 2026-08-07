# H37 chall recover pass203

**Symptom:** chall :8002 EngineCore init failed after loading shards
(GPUs 4,5 → 0 MiB). post_train stuck in `wait_ready` t=1 k=1 c=0.

**Action:** `relaunch_chall_pass203.sh` — kill post_train/wait_ready,
wipe `chall`/`chall_*` Triton caches → 5s settle → unique
`chall_p203_*` TCACHE → vllm serve `/root/h37/merged` util=0.72.
Patched `watch_n80_retry` (non-exec) + `retry_h37_n80.sh` (block-hash
rotation) owns n80 when t/k/c=200.

**Also this pass:** H34 first n80 died teacher 400 @~40/80 on default
`block_hash=0*64`; H34–H36 restarted on `a203…001`.
