# p491 — F29 watcher rearm + d203→e203

- d203 n80 reached chall=79/king=79 then died: king `:8001` HTTP 400 (inject length).
- retry rotated to e203 attempt 2/6 @ 06:59:50Z; sim alive, engines 200.
- `watch_n80_retry` was still aimed at missing `s4-h124-f26-af-k1/…` (p480 residue).
  Killed PID 30893; rearmed to `s4-h124-f29-golden-full-ft/retry_h124_n80_d203first.sh`.
- On-pod `relaunch_chall_pass264.sh` also had f26-af-k1 — sed'd to real EXP.
- Decision: wait e203 a2 for margin; do not REFUTE on d203 400 (FALSE_PROBE-class).
