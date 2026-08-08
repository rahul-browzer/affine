# H90 pass340 — king-only recover mid-n80

**Trigger:** n80 a203 @ challenger 23/80; king EngineDead
`TimeoutError: RPC call to sample_tokens timed out` @17:08:27Z;
`:8001=000`, GPUs 2,3 empty; chall/teacher 200; retry waiting engines.

**Action:** `king_recover_pass340.sh` — isolated TCACHE util=0.72,
no completions probe, leave chall. Clears stale sim progress for clean retry.

**Check:** `cat /root/logs/h90_king_recover_pass340.done` + `:8001=200`;
retry_h90_n80 watcher already armed.
