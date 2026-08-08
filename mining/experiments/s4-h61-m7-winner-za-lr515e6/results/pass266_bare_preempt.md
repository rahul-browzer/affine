# Pass 266 — H61 bare-TCACHE mid-n80 → recover264

## Observation
- n80 attempt 2/3 `b203…` @ ~21/80 with chall `TRITON_CACHE_DIR=/root/.triton/cache/chall` (bare).
- Engines health 200×3; no recover/preempt scripts on pod (unlike H63/H64).
- H60/H62 already isolated freeze (mode=555 n_so=23) — only H61 bare.

## Action
- Cloned `relaunch_chall_pass264.sh` + `watch_preempt_bare_tcache_pass264.sh` from H64
  (`s4-h64…` → `s4-h61…`, h64→h61; full EXP dirname first).
- SCP + `nohup` recover @ 2026-08-08T08:01:12Z pid=19114.
- Quarantined `h61_sim_progress.json`; killed bare n80 sim + watch_n80_retry + retry.

## Expect
- attempt1: wipe → king-seed writable isolated TCACHE → health → diverse warm → freeze → rearm form+n80.
- Next pass: wait `h61_chall_freeze_pass264.done` then n80 (rotated hash via retry).
