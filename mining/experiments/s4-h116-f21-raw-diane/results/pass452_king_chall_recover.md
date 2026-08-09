# p452 — F21 king+chall recover

- Pre: teacher :8000=200 (GPUs 0,1); king :8001=000 EngineDead TimeoutError@02:51; chall :8002=000 NCCL timeout; orphan Workers 14727/14728 ppid=1 on GPUs 4,5 (~135/48 GiB); GPUs 2,3 free; TCACHE king/chall n_so=20
- F14/F15 still mid-n80 (75/80, 72/80) — poll next; this pass armed F21 recover
- Action: `recover_king_chall_pass452.sh` nohup pid=18051 @2026-08-09T02:58:16Z — reap 2–5, quarantine partial n80, seed isolated TCACHEs from chall n_so≥16, launch king:8001 + chall:8002 util=0.72 staggered 30s; leave teacher
- Launch: king_pid=18220 @02:58:54Z; chall_pid=18606 @02:59:24Z; SEED chall n_so=19 → isolated TCACHEs
- @03:01Z still loading (GPUs 2–5 ~38–44 GiB); teacher 200; recover pid=18051 alive
- Also p452: F14/F15 n80 REFUTE torn (m=−0.05784 / −0.08285)
- Next: confirm both promptable + teacher 200 → n80 d203; if Triton ENOENT re-fire with fresh seed
