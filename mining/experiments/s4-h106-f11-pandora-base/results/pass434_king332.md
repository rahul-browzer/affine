# F11 / H106 — pass 434 king_recover_pass332

- Pre: :8000=200 :8001=000 :8002=200; n80 stuck @16/80; orphan VLLM::Worker pids 8917/8918 on GPUs 2,3 util100 holding ~117 GiB each.
- Action: scp + nohup `king_recover_pass332.sh` pid=31613 @2026-08-09T01:37:16Z; leave chall.
- Post-launch: orphans reaped; GPUs 2,3 → 0 MiB; vllm serve Tok331102/…-af10@eb8bf9a util=0.72 TCACHE=`/root/.triton/isolated/h106_king_p332_1786239439_31613` king pid=31778; chall :8002=200; e203 wait poll~16/120.
- Cleared stale sim progress (fresh n80 after king promptable).
