# H55 pass248 — king mid-n80 die → recover

**Symptom:** n80 at challenger 16/80 → `httpx.ConnectError` (king :8001).
Teacher :8000 + chall :8002 stayed 200. GPUs 2,3 held ~117 GiB by
`VLLM::Worker` ppid=1 (pids 7293/7294). `nvidia-smi` compute-apps listed
stale `[Not Found]` PIDs 2773593/2773594 — first relaunch reap missed the
real orphans; free-check stayed 0/2; king launched into occupied VRAM.

**Action:** force-kill ppid=1 Workers → GPUs 2,3 → 0 MiB → re-run
`relaunch_king_pass248.sh` (wipe + settle20 + unique `king_p248_*` TCACHE).
`watch_n80_retry` already waiting engines. **FALSE_PROBE**, not REFUTE.

**Check next:** `:8001` health+completions 200×2 → n80 resume (a203).
