# pass516 — F44 teacher recover332

**UTC:** 2026-08-09T09:47Z
**Symptom:** `:8000=000`, king `:8001=200`, GPUs 0,1 free. Teacher EngineDead @09:40:51Z —
Triton ENOENT on bare `/root/.triton/cache/teacher/POHQPAXFL7…/__triton_launcher.so`.
Prewarm stuck `t=0 k=1` ~10m; online-DPO train blocked.

**Action:** `nohup relaunch_teacher_pass332.sh` (pid 11674). Wipe teacher* → settle20 →
unique `TCACHE=/root/.triton/cache/teacher_p332_1786268823_11674` → vllm serve teacher
pid=11866 util=0.80 on GPUs 0,1. King left alone.

**Next:** await `:8000=200` → prewarm completes → train_online_dpo launch.
Do not rm pod on FALSE_PROBE; leave king.
