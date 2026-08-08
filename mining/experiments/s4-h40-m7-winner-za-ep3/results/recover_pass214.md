# H40 chall recover — pass 214

**Symptom:** `:8002` dead; GPUs 4,5 held ~135 GiB by orphan `VLLM::Worker_TP*` (pids 21480/21481, ppid=1). Teacher/king OK. Retry stuck at wait_engines poll~16/120. `FALSE_PROBE_H40` already quarantined (ConnectError).

**Root cause:** first `/v1/completions` after pass-212 relaunch hit Triton
`ImportError: …/chall_p212_…/__triton_launcher….so: No such file` → EngineDead → APIServer exit; workers left behind.

**Action:** `relaunch_chall_pass214.sh` — reap GPU 4,5 → wipe `chall`/`chall_*` → 20s settle → unique `chall_p214_*` TCACHE → `vllm serve` util=0.72 → rearm `watch_n80_retry`.

**Status at handoff:** DONE_LAUNCH 2026-08-08T00:08:42Z chall_pid=24586; watcher 24595. Next: wait health+completions×2 → hashed n80.
