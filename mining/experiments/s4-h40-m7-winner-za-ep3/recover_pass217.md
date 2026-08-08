# H40 chall recover pass 217

## Failure (p216)
- Isolated TCACHE `/root/.triton/isolated/h40_chall_p216_*` cleared mid-init death.
- Chall pid=29824 reached health=200 @ 00:25:17Z; first completions 200 @ 00:25:30Z.
- EngineDead @ 00:26:10Z during settle/re-probe:
  `__triton_launcher.so: cannot open shared object file` (hash `74NSHKW…`).
- Other launcher.so files still present → TP race delete, not wipe glob.
- Formed `FALSE_PROBE_H40` / ConnectError; GPUs 4,5 free again.

## Fix
- `relaunch_chall_pass217.sh`: same isolated TCACHE launch, then health wait →
  warmup completion → `chmod -R a-w $TCACHE` → 2 more completions (incl. post-settle)
  → rearm watcher.
- `retry_h40_n80.sh`: freeze live chall TRITON_CACHE_DIR after first promptable.

## Decision
Do NOT `lium rm`. Quarantine false probe; recover in place.
