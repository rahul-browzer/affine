# H32 king Triton recover — pass 192

**Symptom:** recover191 king health=200 then first completions →
`__triton_launcher.so` missing → EngineDead; recover_wait exited.
Chall already loading on :8002; post_train still alive.

**Action:** `relaunch_king_pass192.sh` — reap GPUs 2,3 by index, wipe
caches, unique `TRITON_CACHE_DIR`, relaunch + `recover_wait_pass192.sh`.
