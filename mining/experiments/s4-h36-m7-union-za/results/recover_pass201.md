# H36 teacher recover — pass 201

**Symptom:** `:8000` dead; GPUs 0,1 empty. Prewarm teacher died at
`21:32:41Z` with Triton
`__triton_launcher.so: No such file or directory` under
`/root/.triton/cache/teacher/...` (concurrent prewarm race). King `:8001`
stayed healthy. Merge was writing shard 2 on GPUs 6,7.

**Action:** `relaunch_teacher_pass201.sh` — wipe teacher/flashinfer caches,
unique `TRITON_CACHE_DIR=teacher_p201_*`, relaunch GLM teacher on 0,1.

**Result:** teacher health 200 + `/v1/completions` probe ok @ ~22:11Z.
Merge finished (non-id vs m7 + TalentPigs). Pipeline proceeded to
chall-only serve `:8002` (`restart_for_h2.sh`) without re-running
`serve_three` (t/k already 200). HF salvage pushes started.

**Chall follow-up:** first chall (`chall/` cache via restart_for_h2) died
`22:14:10Z` same `__triton_launcher.so` race. Relaunched
`22:16:45Z` with wipe→5s→`chall_p201_*` (pid 16455); pipeline/restart
still alive to pick up health. @22:19Z GPUs 4,5 ~38 GiB loading,
t/k=200.
