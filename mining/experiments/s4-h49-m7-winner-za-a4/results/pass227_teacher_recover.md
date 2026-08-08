# Pass 227 — H49 teacher recover

**Cause:** teacher :8000 died mid-init with Triton race:
`/root/.triton/cache/teacher/.../__triton_launcher.so: No such file or directory`
(GPUs 0,1 free; king :8001 promptable on 2,3; merge_lora writing shard0 on 6,7).

**Action:** `relaunch_teacher_pass227.sh` — reap 0,1 → wipe `teacher*` caches →
20s settle → unique `TCACHE=teacher_p227_*` → `vllm serve GLM-4.5-Air-FP8` :8000.

**Result:** DONE_LAUNCH 02:27:51Z teacher_pid=14276. King untouched (200).
Merge pid 11725 still writing `.tmph3QtXk` (~50 GB). Chall not yet served.
Next: wait teacher promptable → freeze TCACHE → merge.done → chall → n80.
