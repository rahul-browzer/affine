# H77 king-only recover — pass 308

**When:** 2026-08-08T12:55Z
**Symptom:** pass306 king pid=26103 never became promptable. Worker_TP1
`ImportError` on `cache/king/NODUTTS…/__triton_launcher.so` @12:51:39Z,
then EngineCore `shm_broadcast` hang (60s loops). health:8001=000 while
APIServer still alive. Teacher+chall healthy. retry poll≈28/120 burning.
GPUs 2/3 ~37 GiB with hung workers.

**Action:** Killed recover306 + hung king + short-budget retry + mid304.
Reaped GPU 2,3 pids 26957/26958. Deployed `king_recover_pass308.sh`
(wipe `cache/king(+_*)`, settle 25s, relaunch Tok@eb8bf9a :8001).
Rearmed `watch_n80_retry` (fresh 0/120) + mid304. Chall untouched
(:8002=200).

**Check:** `tail -f /root/logs/h77_king_recover_pass308.nohup` → KING
PROMPTABLE; retry starts fresh a203 n80. king308 pid=29360 @12:55:34Z.
