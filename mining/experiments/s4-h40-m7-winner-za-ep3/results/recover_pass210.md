# H40 teacher recover — pass 210

**Symptom:** teacher APIServer pid alive, health=000; workers on GPUs 0,1
holding ~55 GiB each; EngineCore shm_broadcast hang. Log:
`ImportError: .../triton/cache/teacher/.../cuda_utils.so: No such file`.

**Action:** `relaunch_teacher_pass210.sh` — reap GPU 0,1 workers → wipe
`teacher`/`teacher_*` → settle 20s → unique `teacher_p210_*` TCACHE →
relaunch GLM on 0,1. King :8001 untouched. Train finished 78/78 @ 23:44Z
(loss 0.4043); merge started in parallel on 6,7.

**Launch:** teacher_pid=14742 @ 2026-08-07T23:45:04Z.
