# H51 pass237 — chall EngineDeadError recover

UTC 2026-08-08T03:48:43Z chall `:8002` died mid first n80 sample:
`vllm.v1.engine.exceptions.EngineDeadError` → completions 500 → APIServer exit.
Orphan `VLLM::Worker_TP{0,1}` pids 18028/18029 held GPUs 4,5 (~106 GiB, 100% util).
Sim `local-h51` gone; `watch_n80_retry` re-entered engine wait (poll~8/120).
Teacher :8000 + king :8001 stayed healthy.

Action (not teardown): wipe `/root/.triton/cache/chall*`,
`MERGE_DIR=/root/h51/merged UTIL=0.72 bash relaunch_chall_072.sh`
→ reaped orphans, free-check OK, new chall pid=21747 @03:52:07Z.
`FALSE_PROBE` quarantine of any partial sim artifacts.
Next: wait double-promptable → n80 retry (a203/b203 rotate).
