# Pass 286 — H71 preempt rearm + p283 patch

**UTC:** 2026-08-08T10:28:40Z
**Pod:** mine-h71-1 (eager-fox-be)

## Why

Merge finished 10:28:10Z (`OK_NON_IDENTICAL` vs m7 + Tok331102); chall-only
re-serve launched 10:28:11Z. Preempt watcher (pid 878) was at poll **~132/240**
and still ran the **pre-p283** script that relaunches recover on
`isolated && mode≠555` — same race that killed healthy H70 chall at 10:14:49Z.

## Action

- Uploaded p283-fixed `watch_preempt_bare_tcache_pass264.sh` (leave alone when
  isolated; skip if `relaunch_chall` already alive).
- Killed preempt PID **878** (PID-only).
- Relaunched → PID **13015**, fresh 240 polls.
- Marker: `/root/affine_data/h71_pass286_preempt_rearm.json`

## Concurrent

| item | state |
|---|---|
| merge | done; shards 47G+19G + visual 852M |
| HF push | adapter+merged background |
| chall serve | `restart_for_h2.sh` loading; :8002=000 |
| king | Tok331102 kept on :8001 |
| n80 | retry armed; waits engines |

Next: chall health200 → preempt fires recover264 only if bare TCACHE → n80 vs Tok.
