# H31 chall recover — pass 193

## Symptom
- n80 kicked after chall `/v1/models`=200 (king probe OK).
- First completions killed chall EngineCore: missing
  `__triton_launcher.so` under `/root/.triton/cache/chall/...`.
- `h31_sim_result.json` rejection_reason =
  `unpromptable:probe_sample_failed:ConnectError` (elapsed 26.8s).
- `write_merge_decision` wrote `REFUTE_H31` with `margin=null`.
- Watchers exited on decision; GPUs 4,5 empty; teacher+king still up.

## Action
- Quarantine decision/sim/artifact → `affine_data/false_probes/*_pass193_*`.
- `relaunch_chall_pass193.sh`: wipe chall Triton caches, unique
  `TRITON_CACHE_DIR`, serve `/root/h31/merged` on :8002 util=0.72.
- `recover_wait_chall_pass193.sh`: wait health + completions probe, then
  `retry_h31_n80.sh` + form/retry watchers.

## Decision rule
ConnectError / null-margin = false probe. Do **not** `lium rm`. Real
REFUTE only after paired margin with gates.
