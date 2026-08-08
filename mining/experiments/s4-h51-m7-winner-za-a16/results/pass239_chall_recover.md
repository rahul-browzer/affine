# H51 pass239 — chall Triton race recover (2nd)

UTC 2026-08-08T03:59:16Z chall `:8002` died mid n80 attempt1 (a203):
`__triton_launcher.so: No such file` → `EngineDeadError` → APIServer exit.
Orphan `VLLM::Worker_TP{0,1}` pids 22520/22521 (ppid=1) held GPUs 4,5 ~106 GiB.
`write_merge_decision` → `FALSE_PROBE_H51` ConnectError (quarantine, not REFUTE).
`retry_h51_n80` entered engine wait poll~0–8/120.

Action (not teardown): wipe `/root/.triton/cache/chall*`, settle 25s,
`MERGE_DIR=/root/h51/merged UTIL=0.72 bash relaunch_chall_072.sh`
→ reaped 22520/22521, free-check OK, new chall **pid=25276** @04:01:40Z.
Log: `/root/logs/h51_relaunch_chall_pass239.nohup`.
Teacher :8000 + king :8001 stayed healthy.

Next: wait health200 + double completions200 (settle≥45s) → n80 retry
(block_hash rotate a203→b203 on attempt2).
