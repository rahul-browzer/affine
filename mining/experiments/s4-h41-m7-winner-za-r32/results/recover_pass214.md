# H41 chall recover — pass 214

**Symptom:** `:8002` dead; GPUs 4,5 held ~106 GiB. `nvidia-smi` listed stale `[Not Found]` pids 2360588/2360589 — reap by those alone failed. Real holders were orphan `VLLM::Worker_TP*` 18795/18796 (ppid=1). Retry stuck poll~24/120. `FALSE_PROBE_H41` quarantined.

**Root cause:** first completions probe hit Triton
`ImportError: …/cache/chall/…/__triton_launcher….so: No such file` → EngineDead.

**Action:** `relaunch_chall_pass214.sh` + kill orphan workers via `ps` (`VLLM::` && ppid=1). Then wipe→settle→unique TCACHE→serve util=0.72→rearm watcher.

**Status at handoff:** DONE_LAUNCH 2026-08-08T00:09:21Z chall_pid=23143; watcher 23152. Next: wait health+completions×2 → hashed n80.
