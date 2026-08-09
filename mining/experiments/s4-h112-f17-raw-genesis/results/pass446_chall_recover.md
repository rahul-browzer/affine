# p446 — F17 chall recover after Triton ENOENT hang

- chall died mid-load: `__triton_launcher.so` ENOENT hash `4WD73Z7E…` @02:23:32Z
- EngineCore hung on shm_broadcast 60s loops; GPUs 4,5 ~37 GiB zombie workers
- Action: reap workers/parents on GPUs 4,5; wipe chall TCACHE; rsync seed from king (n_so=17); relaunch util=0.72
- Teacher+king left up; retry watcher still in `_wait_engines` (poll~124/360)
- Post-arm: chall APIServer pid=15121 loading; next pass confirm :8002=200 + n80 start
