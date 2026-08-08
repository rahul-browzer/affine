# H80 king-only recover — pass 311

**When:** 2026-08-08T13:13Z
**Symptom:** After recover264 DONE_LAUNCH (chall triple-promptable @13:11:20Z),
n80 attempt 1 died within ~90s: king Worker_TP0 Triton ENOENT
`cache/king/EAUHKKZ…/__triton_launcher.so` @13:12:33Z → EngineDead →
APIServer shutdown. health:8001=000; GPUs 2/3 empty. Teacher+chall stayed
:8000/:8002=200. mid304 saw sim gone → exited. retry stuck on short
post-fail wait (0/40).

**Action:** Deployed `king_recover_pass311.sh` (king-only; chall untouched).
Killed short-budget `retry_h80_n80` by `$0`. Wipe `cache/king(+_*)`, settle
25s, relaunch Tok@eb8bf9a :8001. Rearmed `watch_n80_retry` + mid304.

**Check:** `tail -f /root/logs/h80_king_recover_pass311.nohup` → KING
PROMPTABLE; retry starts fresh a203 n80. king311 pid=24852 @13:14:27Z.
