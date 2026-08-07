# H40 chall recover — pass 212

**Symptom:** chall `:8002` mid-load on GPUs 4,5 (~38 GiB) hit
`ImportError: .../triton/cache/chall/.../__triton_launcher.so: No such file`.
Teacher `:8000` + king `:8001` stayed health=200. Retry wait poll~44/120.

**Action:** `relaunch_chall_pass212.sh` — reap GPU 4,5 → wipe `chall`/`chall_*`
FIRST → 20s settle → unique `TCACHE=chall_p212_*` → vllm serve `/root/h40/merged`
→ rearm `watch_n80_retry` (killed stale retry/post_train wait_ready).

**Launched:** 2026-08-07T23:55:59Z chall_pid=20664 watcher=20673.
Next pass: wait chall completions×2 then hashed n80 a203.
