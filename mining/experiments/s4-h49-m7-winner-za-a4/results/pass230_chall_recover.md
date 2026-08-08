# Pass 230 — H49 chall recover (p229 ABORT → retry)

**UTC:** 2026-08-08T02:50–02:52Z

## p229 failure
- health=200 @ poll=42 (02:50:50Z) → warmup #1 immediately → 500 in 4s.
- Error: `__triton_launcher.so: No such file` under isolated TCACHE
  `h49_chall_p229_1786157000_22519/...` (TP race on first completion).
- Log: `ABORT warmup #1 failed`. GPUs 4,5 free; teacher:8000 / king:8001 OK.

## p230 recover (in flight)
- Script: `relaunch_chall_pass230.sh` (upgraded from p229).
- Changes vs p229:
  1. **Outer retry ×3** — fresh isolated TCACHE each attempt on warmup fail.
  2. **45s settle after health=200** before first warmup (p229 raced here).
- Launched 02:52:09Z pid=25769; log `/root/logs/h49_chall_recover_pass230.log`.

## Check next pass
```
tail /root/logs/h49_chall_recover_pass230.log
# want: DONE_LAUNCH + frozen launcher.so
# then: run_sim_duel local-h49 + h49_sim_progress.json
```
Do **not** `lium rm` — FALSE_PROBE ≠ REFUTE.
