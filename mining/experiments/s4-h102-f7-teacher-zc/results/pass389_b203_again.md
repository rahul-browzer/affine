# H102/F7 pass389 — kill a203 FALSE_PROBE loop → b203 again

## Prior
p387 forced b203 (PID28788 ~4/80). Mid-n80 king/chall 400 then FALSE_PROBE
quarantine + watcher re-exec reset attempt→1/a203.

## This pass
- a203 attempt @21:54:39 → FALSE_PROBE in ~50s (`unpromptable` chall :8002 400)
  even though short `hi` completions were 200×3 afterward (transient).
- Root: retry treats `rc=0` + sim-with-rejection as `N80_DONE` → watcher
  quarantines → relaunches attempt 1/a203 forever; never reaches b203/c203.
- Killed a203 sim PID30522 (rc=143) @21:55:01 → attempt 2/`b203` PID30753
  @21:55:22; engines t/k/c=200.
- Local `retry_h102_n80.sh`: b203-first + FALSE_PROBE continues to next hash
  (do **not** scp onto live retry — bash-offset LESSON; sync when idle).

## Next
Await b203 n80 margin; if FALSE_PROBE again, scp fixed retry then relaunch.
