# H40 result — REFUTE-by-ops (and class-dead)

epochs=3 on m7×winner-zA. Merged + pushed, but chall never stayed promptable
across recover passes 212–219 (repeated Triton `__triton_launcher.so` race /
shm_broadcast hang on B200 GPUs 4–5). Last :8002=000 with orphan workers.

H38 already REFUTED epochs=2 at m=−0.00037 — intensity-up class is dead.
Tear down; do not recover further. Do not requeue ep≥2.
