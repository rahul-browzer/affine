# H77 king-only recover — pass 306

**When:** 2026-08-08T12:47Z
**Symptom:** Mid-n80 king EngineDead @12:44:18Z —
`TimeoutError: RPC call to sample_tokens timed out` → APIServer exit.
Progress frozen chall 15/80 (no king count). GPUs 2,3 free 0 MiB; no
orphans ppid=1. Teacher+chall healthy (:8000/:8002=200). mid304 exited
`sim gone`. `retry_h77_n80` waiting engines poll≈8/40 — short budget would
expire before a reload.

**Action:** Deployed `king_recover_pass306.sh` (from pass302). Reaped
nothing, wiped `cache/king(+_*)`, settle 25s, relaunch Tok@eb8bf9a on
:8001 GPUs 2,3. Cleared stale sim progress. Killed short-budget retry +
rearmed `watch_n80_retry` (new retry poll=0/120) + mid304 wait-for-sim.
Chall untouched.

**Check:** `tail -f /root/logs/h77_king_recover_pass306.nohup` → KING
PROMPTABLE; then retry starts fresh a203 n80. King pid=26103 started
12:47:33Z.
