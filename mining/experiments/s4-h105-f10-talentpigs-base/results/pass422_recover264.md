# F10 / H105 — pass 422 recover264

## Symptom
- n80 aborted FALSE_PROBE: `unpromptable:probe_sample_failed:ConnectError`
- chall EngineDead @ 00:37:01Z — Triton ENOENT
  `…/cache/chall/OV4T43AL…/__triton_launcher….so`
- Orphan `VLLM::Worker_TP*` 16024/16025 held GPUs 4/5 (44 GiB + 106 GiB @100%)
- Teacher :8000 + king :8001 stayed 200; `:8002=000`
- Bare cache mode=755 (writable) — classic mid-n80 ghost, not frozen-TCACHE issue

## Action
- Fired `relaunch_chall_pass264.sh` nohup @ 2026-08-09T00:41:39Z (pid 19783)
- Quarantined `h105_sim_result_artifact.json` → `false_probes/`
- Reaped orphans; GPUs 4,5 → 0 MiB; attempt 1/3 settle→wipe→king-seed writable
- `watch_n80_retry` (d203first) left armed; form watcher was gone (recover rearms on DONE)

## Decision
FALSE_PROBE ≠ REFUTE. Next: await recover DONE → chall promptable → n80 d203.
