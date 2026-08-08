# pass408 — F7 H32 hash rotation (d203-first)

## Observation
- c203 teacher 400 @ king7/chall8: `30977+1792 > 32768` (exact H32 overflow).
- a203 (attempt 3) immediately FALSE_PROBE chall 400 → wrote N80_DONE (retry
  `_is_false_probe_sim` missed nested rejection; watcher quarantined).
- a203 known-bad per script comment; c203 now confirmed same overflow turn.

## Action
- New script `retry_h102_n80_d203first.sh` (never edit live): drop a203+c203,
  hashes `d203,e203,f203,g203,b203`, `MAX_ATTEMPTS=6`.
- Killed old watcher/retry; armed watcher → d203first.
- 23:28:49Z n80 attempt 1/6 `block_hash=d203…` running; engines 200/200/200.

## Decision
Not REFUTE. Continue SCREEN on fresh hashes. Next pass: read d203 margin or
rotate e203 on teacher-400 / chall FALSE_PROBE.
