# H37 recover pass204 — false ConnectError REFUTE

## What happened
- Chall p203 reached `Application startup complete` (health 200).
- Watcher launched n80 with block_hash=a203… immediately on health.
- First `/v1/completions` hit missing
  `__triton_launcher.so` → EngineDead → ConnectError.
- `run_sim_duel` wrote null-margin sim with
  `rejection_reason=unpromptable:probe_sample_failed:ConnectError`.
- `write_merge_decision.py` emitted `REFUTE_H37` (false).

## Actions (pass204)
1. Quarantined `h37_{decision,sim_result,sim_result_artifact}.json` →
   `/root/affine_data/false_probes/*_pass204_*`.
2. Patched `write_merge_decision.py` → emit `FALSE_PROBE_*` on
   unpromptable/ConnectError/EngineDead (do not REFUTE).
3. Patched `retry_h37_n80.sh` `_engines_ok` to require chall
   `/v1/completions` 200 (not health alone).
4. Relaunched chall via `relaunch_chall_pass204.sh`
   (wipe→settle→unique TCACHE `chall_p204_*`); rearmed watcher.

## Decision
H37 still **open**. Do not tear down. Next: wait for chall
promptable → block-hash n80 → real margin.
