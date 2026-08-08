# H40 recover pass215

- p214 chall (pid 24586) reached health=200 @ 00:13:45Z then died on first
  real completion @ 00:13:59Z: `__triton_launcher.so` ImportError in
  `chall_p214_*` cache → EngineDead → :8002 down.
- Orphans: `VLLM::Worker` 25396/25397 ppid=1 on GPUs 4/5 (~48/135 GiB).
- Action: `relaunch_chall_pass215.sh` — reap → wipe chall/chall_* → 20s
  settle → TCACHE `chall_p215_1786148103_27695` → chall_pid=27757 →
  rearmed `watch_n80_retry` pid=27766. DONE_LAUNCH 00:15:30Z.
- H41 p214 recover held; n80 a203 started 00:13:29Z.
