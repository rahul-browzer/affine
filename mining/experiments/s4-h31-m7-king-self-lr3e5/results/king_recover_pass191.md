# H31 king recover — pass 191

King `:8001` died mid-serve_three wait on Triton
`__triton_launcher.so` missing (EngineCore 20:18:05Z). GPUs 2,3 empty;
teacher `:8000` healthy; merge done non-id; pipeline still in health wait.

Action: `relaunch_king_pass191.sh` — reap GPU 2,3, wipe `king*` Triton +
flashinfer sampling, unique `TRITON_CACHE_DIR`, relaunch king +
`recover_wait_pass191.sh` (completions probe; fallback chall+n80 if
pipeline aborts).

Launched 2026-08-07T20:20:09Z king_pid=14061 wait_pid=14066.
