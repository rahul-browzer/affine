# H32 king recover — pass 191

King `:8001` died on Triton `__triton_launcher.so` race; orphan workers
held ~37 GiB on GPUs 2,3. Teacher healthy; merge done non-id; pipeline
still in teacher/king health wait after placeholder chall stop.

Action: `relaunch_king_pass191.sh` — kill orphans by GPU index, wipe
caches, unique `TRITON_CACHE_DIR`, relaunch + `recover_wait_pass191.sh`.

Launched 2026-08-07T20:20:14Z king_pid=11015 wait_pid=11020
(reaped workers 5892/5893 parent 5571).
