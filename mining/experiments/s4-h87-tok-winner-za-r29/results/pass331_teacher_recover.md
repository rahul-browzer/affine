# Pass 331 — H87 teacher recover

**Cause:** teacher `:8000` EngineDead — Triton ENOENT
`/root/.triton/cache/teacher/4NLUGJ4U…/__triton_launcher.so` @15:55:22Z.
King `:8001=200`. Merge writing on GPUs 6,7 (`merge_lora` → `.tmpOL1jei` ~47G).
n80-retry aborted once @16:01 (engines unhealthy) then rearmed; prewarm stuck `t=0 k=1`.

**Action:** `relaunch_teacher_pass331.sh` — reap GPUs 0,1 → wipe `teacher*` →
settle20 → unique `TCACHE=teacher_p331_*` → `vllm serve GLM-4.5-Air-FP8` :8000.
Leave king + merge alone.

**Result:** DONE_LAUNCH 16:08:34Z pid=14571
`TCACHE=/root/.triton/cache/teacher_p331_1786205292_14426`; EngineCore init
@16:09:02Z; king untouched; merge still writing `.tmpOL1jei` ~47G on 6,7.
Next: `:8000=200` → post_train resumes after merge → chall → n80+mid304.
