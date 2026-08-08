# Pass 229 — H49 chall recover (FALSE_PROBE)

**UTC:** 2026-08-08T02:41–02:44Z

## Failure
- n80 a203 attempt 1 → chall EngineDead @ 02:41:04Z:
  `__triton_launcher.so: No such file` under `/root/.triton/cache/chall/…`
  (p228 freeze mode 555 insufficient / race after first completions).
- `write_merge_decision` → `FALSE_PROBE_H49` ConnectError; form watcher ERROR.
- GPUs 4,5 free; teacher:8000 / king:8001 stayed 200.

## Recover (in flight)
- Script: `relaunch_chall_pass229.sh` (H48 p225 recipe).
- Quarantined `h49_sim_result_artifact.json` → `false_probes/`.
- Launched 02:43:20Z pid=22519; chall vllm pid=22598 @ 02:43:58Z.
- TCACHE=`/root/.triton/isolated/h49_chall_p229_1786157000_22519`
- Waiting health→warmup×3→freeze a-w→rearm form + `watch_n80_retry`.

## Check next pass
```
tail /root/logs/h49_chall_recover_pass229.log
# want: DONE_LAUNCH + frozen launcher.so
# then: run_sim_duel local-h49 + h49_sim_progress.json
```
Do **not** `lium rm` — FALSE_PROBE ≠ REFUTE.
