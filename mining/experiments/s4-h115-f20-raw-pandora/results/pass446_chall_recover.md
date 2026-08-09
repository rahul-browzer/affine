# p446 — F20 chall recover after FALSE_PROBE

- n80 attempt1 d203 → `rejection_reason=unpromptable:probe_sample_failed:ConnectError`
- chall EngineDead: `KeyError: cmpl-…` in `_update_states` @02:31:40Z; GPUs 4,5 free
- FALSE_PROBE quarantined under `false_probes/`; margin null — not REFUTE
- Action: `MERGE_DIR=/root/h115/chall UTIL=0.72 relaunch_chall_072.sh` (chall TCACHE n_so=21 kept)
- Teacher+king left up; `retry_h115_n80_d203first` waiting engines (poll~12/120)
- Post-arm: chall APIServer pid=14161 loading; next pass confirm :8002=200 + n80 restart
