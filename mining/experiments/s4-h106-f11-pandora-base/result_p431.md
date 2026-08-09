# p431 — F11 nested FALSE_PROBE detect + e203 relaunch

## Bug
`run_sim_duel.py` writes `rejection_reason` under `verdict`, not top-level.
`_is_false_probe_sim` only checked top-level → treated inject-400 as success →
`N80_DONE` → `watch_n80_retry` quarantined FP decision and relaunched attempt 1
on d203 forever (≥32 quarantine files).

## Fix
- Nested `verdict.rejection_reason` in `_is_false_probe_sim` (all F10–F15 retry scripts).
- New `retry_h106_n80_e203first_p431.sh` (e203→f→g→b→d); watcher re-pointed.
- DETECT_OK on quarantined sim; live sim `block-hash=e203…005` @01:27:31Z.

## Also
F13 watcher was armed on bare `retry_h108_n80.sh` (a203) while d203 sim ran — re-pointed.
