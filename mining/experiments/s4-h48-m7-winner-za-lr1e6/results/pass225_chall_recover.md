# Pass 225 — H48 chall freeze-recover launched

## Symptom
- :8002 APIServer exited (`Finished server process`); GPUs 4–5 = 0 MiB.
- Teacher/king still healthy :8000/:8001=200. merge.done present.
- watch_n80_retry + retry_h48_n80 were waiting on a dead chall.

## Action
- Adapted H46 `relaunch_chall_pass224.sh` → `relaunch_chall_pass225.sh`
  (EXP dirname sed **before** h46→h48; LESSONS clone rule).
- SCP + nohup on mine-h48-1 @ 2026-08-08T02:17:41Z pid=17395.
- Same freeze path: wipe → isolated TCACHE → warmup → chmod a-w →
  rearm `watch_n80_retry`.

## Also this pass
- H46 recover p224 → `DONE_LAUNCH` 02:16:10Z → n80 a203 started 02:16:31Z.
- H47 n80 a203 running (comp 200×2); TCACHE `/root/.triton/cache/chall`
  frozen a-w @ 02:15:14Z.

## Next poll
- `/root/logs/h48_chall_recover_pass225.log` for `DONE_LAUNCH` / ABORT.
- Then n80 via rearmed watcher (a203).
