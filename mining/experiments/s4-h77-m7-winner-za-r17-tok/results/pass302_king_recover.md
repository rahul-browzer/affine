# H77 king-only recover — pass 302

**When:** 2026-08-08T12:30Z
**Symptom:** Mid-n80 king EngineDead @12:25Z — Triton ghost
`__triton_launcher.so` ENOENT under `/root/.triton/cache/king/…`.
APIServer exited; GPUs 2,3 free (0 MiB). Teacher+chall healthy.
`retry_h77_n80` waiting poll=16/40 with king health=000 — would exhaust
before a reload finishes.

**Action:** Deployed `king_recover_pass302.sh` (adapted from H76
`king_recover_pass300.sh`). Reaped nothing (gpus free), wiped
`cache/king(+_*)`, settle 25s, relaunch Tok@eb8bf9a on :8001 GPUs 2,3.
Killed stale retry (short 40-poll budget) and rearmed `watch_n80_retry`.

**Check:** `tail -f /root/logs/h77_king_recover_pass302.nohup` → KING PROMPTABLE
then retry should start fresh a203 n80.
