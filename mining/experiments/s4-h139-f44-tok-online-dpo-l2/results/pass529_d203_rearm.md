# pass529 — F44 a203→d203 rearm + chall recover

## Finding
`retry_h139_n80_d203first.sh` was misnamed a203-first (hashes a/b/c only) and lacked
`_is_false_probe_sim` — same class as F41 p523 / F42 p527.

## Actions
1. Deployed `retry_h139_n80_d203first_p529.sh` (d203-first + nested FP guard).
2. Killed live a203 `run_sim_duel` (~0 pairs); re-pointed `watch_n80_retry` → p529.
3. Chall :8002 died (GPUs 4,5 empty); fired `relaunch_chall_pass264.sh`.
4. p529 retry waiting engines; will start d203 when chall promptable.

## Do not
Treat early `N80_DONE` / null-margin as REFUTE; quarantine FP and continue hashes.
