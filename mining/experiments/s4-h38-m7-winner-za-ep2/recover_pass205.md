# H38 recover pass205

**Trigger:** chall p204 briefly health=200 → completions 500 / EngineDead
(`__triton_launcher.so`) → n80 false_probe ConnectError → decision written
`false_probe:true` → watcher exited (22:49Z).

**Fix shipped:** quarantine DEC/SIM → `relaunch_chall_pass205.sh` (settle20s)
+ same wait/double-probe/false_probe-aware watcher+retry as H37.

**State after:** false_probe Q'd to `affine_data/false_probes/`; chall p205
loading; watcher+waiting retry armed.
