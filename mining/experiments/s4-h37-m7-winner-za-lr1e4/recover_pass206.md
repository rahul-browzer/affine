# H37 chall recover pass206

**UTC:** 2026-08-07T23:04Z
**Cause:** p205 chall health=200 @23:01:48Z, then first `/v1/completions`
at 23:02:03Z → EngineDead `__triton_launcher.so` missing from
`chall_p205_*` cache (same Triton race as p203–p205).
**Action:** `relaunch_chall_pass206.sh` — wipe chall caches → settle 20s →
unique `chall_p206_*` TCACHE → serve :8002 util=0.72 → rearm
`watch_n80_retry` (double-completions gate).
**Do not** `lium rm`. H38 p205 survived double-probe; n80 a203 running.
