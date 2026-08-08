# H54 pass248 — king down at n80 start → recover

**Symptom:** n80 `run_sim_duel` armed with a203 but :8001=000; GPUs 2,3
already free (clean king exit, no orphans). Teacher/chall 200.

**Action:** kill doomed sim; launch `relaunch_king_pass248.sh` →
`king_pid=26558` @ 05:29:28Z. `watch_n80_retry` live.

**Check next:** king promptable → retry starts fresh n80.
