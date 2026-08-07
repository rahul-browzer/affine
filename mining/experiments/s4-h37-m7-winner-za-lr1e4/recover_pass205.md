# H37 recover pass205

**Trigger:** chall p204 died mid-load — Worker missing
`__triton_launcher.so` under `chall_p204_*` (22:47Z). GPUs 4,5 free.
No decision written (waiting retry held).

**Fix shipped:**
- `relaunch_chall_pass205.sh` — wipe→settle **20s**→unique TCACHE
- `retry_h37_n80.sh` — wait engines (≤120×15s) + **double** completions
  probe 20s apart; quarantine false_probe DEC/SIM
- `watch_n80_retry.sh` — auto-quarantine false_probe; python-gated sim check

**State after:** chall_pid alive, watcher+waiting retry armed, no decision.
