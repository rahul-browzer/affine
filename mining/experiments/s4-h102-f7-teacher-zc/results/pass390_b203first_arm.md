# H102/F7 pass390 — arm b203-first retry without killing live n80

## Fact
- Pod `retry_h102_n80.sh` still a203-first + N80_DONE on FALSE_PROBE (md5 `05c3a504…`).
- Local fix (md5 `64f1c416…`): BLOCK_HASHES b203→c203→a203; FALSE_PROBE → rc=42 continue.
- Live b203 sim PID30753 was mid-n80 (~1–4/80) — must not edit running script.

## Action
- SCP fix → `/root/mining_src/s4-h102-f7-teacher-zc/retry_h102_n80_b203first.sh`
- Kill watcher PID28888 only; relaunch → b203first (new watcher PID31470).
- Left old retry PID30286 + sim PID30753 untouched.

## Expected
- If b203 yields real margin → decision written; watcher exits.
- If FALSE_PROBE → watcher quarantines + launches b203first (no a203 loop).

## Next
Await b203 margin; tear down only after decision.
