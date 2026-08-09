# pass454 — F18 teacher+chall shm_broadcast recover

**Symptom:** :8000/:8002=000, king :8001=200. Teacher+chall EngineCore
`shm_broadcast` every 60s since ~02:52Z (~15m). GPUs 0,1 ~56 GiB; 4,5 ~37 GiB;
2,3 king healthy 106 GiB.

**Action:** `recover_teacher_chall_pass454.sh` @03:08:05Z — reap 0,1+4,5; leave
king; wipe teacher*/chall*; settle20; seed chall from `/root/.triton/cache/king`
(n_so=0 cold); unique TCACHEs util=0.72. teacher_pid=19744 chall_pid=19954.

**Expect:** both promptable ~10–15m → bootstrap/retry arms n80 d203.
Next: confirm :8000/:8002=200 + completions; if shm hang again → hardware-suspect.
