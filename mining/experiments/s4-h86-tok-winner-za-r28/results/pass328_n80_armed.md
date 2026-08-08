# H86 pass328 — salvage recover → n80 + mid304

## What happened
- p327 left H86 at recover264 settle→w1; n80 retry had ABORT@15:30 (engines not promptable) then watcher died.
- Recover attempt1 writable w1: Triton ENOENT on new hash `4UYR2LE4…/__triton_launcher.so` @15:38:59; n_so 16→22; health stayed 200 but completions hung (shm_broadcast 60s).
- Salvage path (LESSON p274): kill + relaunch **same** isolated TCACHE pre-frozen mode=555 @15:42:02.
- health=200 @15:46:34; settle 45s; salvage warmups 200; DONE_LAUNCH @15:48:08.
- Recover rearmed form + watch_n80_retry; retry double-promptable @poll=0 → n80 attempt1/3 block_hash=a203.
- mid304 armed @15:49:21 (pid 21998). First arm attempt false-positive matched SSH `bash -c` text containing script path — fixed by matching argv1 only.

## Live
- TCACHE=`/root/.triton/isolated/h86_chall_p260_a1_1786203135_16506` mode=555
- sim pid=21469 local-h86 a203; ports t/k/c=200
- No decision yet.
