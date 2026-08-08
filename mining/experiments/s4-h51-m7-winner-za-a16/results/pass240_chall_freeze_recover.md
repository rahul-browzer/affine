# H51 pass240 — chall Triton race → freeze recover (3rd)

UTC 2026-08-08T04:07:31Z pass239 chall pid=25276 died on **first**
completions after health: `__triton_launcher.so` ENOENT → EngineDeadError
→ APIServer exit. Clean shutdown (GPUs 4,5 → 0 MiB; no orphans).
Teacher :8000 + king :8001 stayed 200. `retry_h51_n80` had been waiting and
probed immediately on health → same p229 race (LESSON health→warmup 0s).

Action (not teardown): scp `relaunch_chall_pass240.sh` (H49 pass230 recipe:
outer×3 isolated TCACHE, wipe+30s, settle **45s after health**, warmup#1 →
`chmod -R a-w` freeze → warmup#2+#3 → rearm form+watch_n80_retry).
Killed racing watcher/retry pids 903/24831 first.
Launched nohup pid=**28472** @04:08:10Z; attempt1 chall **pid=28548**
TCACHE=`/root/.triton/isolated/h51_chall_p240_a1_1786162128_28472`
@04:08:48Z waiting health.

Log: `/root/logs/h51_chall_recover_pass240.log` ·
nohup: `/root/logs/h51_relaunch_chall_pass240.nohup`.

Next: poll `h51_chall_freeze_pass240.done` → n80 b203 → decision.
Do **not** `lium rm`. FALSE_PROBE ≠ REFUTE.
