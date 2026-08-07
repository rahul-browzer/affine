# H32 recover — pass 198

**Symptom:** n80 aborted after 3 attempts @ ~32/80. Engines healthy
(`/v1/models` 200) but idle. `watch_n80_retry` never relaunched.

**Root causes:**
1. Teacher `400` — prompt ≈30977 + max_tokens 1792 > max_model_len 32768
   on default `block_hash=0*64` slice (not Triton/EngineDead).
2. `watch_n80_retry.sh` `pgrep -f retry_h32_n80.sh` matched its **own**
   argv forever → deadlock after pipeline abort.

**Action:** Fixed watcher match; retry rotates `block_hash` (a198/b198/c198);
completions probe uses real model id; killed deadlocked watcher; relaunched
n80 with `block_hash=a198…`. Teacher GPUs 96–100% after launch.
