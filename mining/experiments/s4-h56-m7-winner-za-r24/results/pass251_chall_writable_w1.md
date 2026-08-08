# H56 pass251 — chall recover after p247 ABORT

**p247 outcome:** outer×3 king-seed + PRE-FREEZE before w1 all failed.
a1/a2/a3 health=200 @~poll33, settle45, n_pre=16, mode=555, then
`comp a*_w1 code=500` with
`__triton_launcher.so` ENOENT on **new** hashes not in king seed
(a3: `4UYR2LE4XOZQ…`). Prefreeze blocks JIT writes for warmup shapes.

**Action @2026-08-08T05:50:28Z** pid=26088:
`relaunch_chall_pass251.sh` — king-seed, **writable** w1 (settle60),
freeze only after w1 OK; if w1 fails and n_so>n_seed, salvage relaunch
same TCACHE pre-frozen. Rearms form+watch_n80_retry →
`h56_chall_freeze_pass251.done`. FALSE_PROBE, not REFUTE.

Teacher/king left up. Next: wait freeze.done → n80.
