# Pass 361 — H99 teacher recover (pre-train-end)

## Symptom
Teacher `:8000=000` since ~19:23Z. Log: Triton ENOENT on bare
`/root/.triton/cache/teacher/POHQPAXFL7…/__triton_launcher.so` → Worker_TP1
ImportError → EngineCore shm hang. Zombie APIServer pid=4746 held GPUs 0,1
(~56 GiB each) with no health.

## Action
Train at step 50/60 (near end). Launched
`relaunch_teacher_pass332.sh` @19:39:34Z (pid 13215) — reaped GPUs 0,1,
wiped teacher* caches, settled 20s, relaunched with isolated
`TCACHE=/root/.triton/cache/teacher_p332_1786217974_13215` util=0.80.
Train on 6,7 left alone. King `:8001=200` left alone. Chall not up yet.

## Follow-up
Next pass: await `:8000=200` + completions probe before post_train merge/n80.
If still 000 after ~10m load, re-fire same script (unique TCACHE).
