# H40 recover pass216

- p215 chall (pid 27757) never reached health: EngineCore died @ 00:18:37Z
  during `determine_available_memory` — `__triton_launcher.so` missing from
  `chall_p215_1786148103_27695/...` (same Triton race, but mid-init not
  post-first-completion). GPUs 4,5 already free (no orphan workers).
- Action: `relaunch_chall_pass216.sh` — wipe chall/chall_* + prior isolated →
  30s settle → TCACHE `/root/.triton/isolated/h40_chall_p216_*` (outside the
  `chall_*` wipe glob so a concurrent wipe cannot delete live .so) → util=0.72.
- DONE_LAUNCH 2026-08-08T00:20:12Z chall_pid=29824; watcher 29833.
- Next: wait health+completions×2 → hashed n80. Do not `lium rm`.
