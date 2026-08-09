# H106/F11 progress

## 2026-08-09T00:59Z p426
- FALSE_PROBE @00:57:41Z: `unpromptable:ConnectError` — n80 raced recover w1
  Triton ENOENT (n_so 16→21) → EngineDead; salvage pre-frozen relaunch mid-load.
- Watcher had already quarantined decision/sim → `false_probes/*_watchQ_*`.
- Killed premature retry+watcher; armed `watch_recover_done_d203_p426.sh`
  (waits DONE_LAUNCH → rearm d203first with `KING_REPO=…-af10`).
- Patched pod+host `relaunch_chall_pass264.sh` rearm → `retry_h106_n80_d203first.sh`.
- Note: false-probe sim_result listed king `…-af11` despite on-disk defaults af10 —
  sidecar force-exports af10 on rearm.
- F10 parallel: n80 d203 at 1/80 @00:58Z (not this hyp).
