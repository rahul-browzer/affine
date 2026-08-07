# H30 chall Triton recover — pass 192

**Symptom:** chall health=200 after load/compile; first `/v1/completions`
→ `ImportError: __triton_launcher.so: No such file or directory` →
`shm_broadcast` 60s hangs. Pipeline saw `/v1/models` ready and launched n80
anyway (`CHALL_SERVE_DONE` 20:25:42Z).

**Action:** quarantine progress; kill n80 + post_train by PID; reap GPUs 4,5
by index; wipe chall Triton/flashinfer caches; unique `TRITON_CACHE_DIR`;
relaunch chall; `recover_wait_chall_pass192.sh` requires completions probe
then `retry_h30_n80.sh`.
