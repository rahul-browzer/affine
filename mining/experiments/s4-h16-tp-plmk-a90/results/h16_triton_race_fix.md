# H16 king recovery (pass 147)

- Concurrent serve raced `~/.triton/cache` → king
  `ImportError: …/__triton_launcher….so: No such file` (GPUs 2,3 dead;
  teacher/chall stayed up).
- `wait_ready` stuck at t=1 k=0 c=1 (~680s of TIMEOUT_S=2400).
- Fix: wipe `/root/.triton/cache/king`, drop stale `vllm_king.pid`, relaunch
  via `serve_three.sh` (skips live t/c; isolated `TRITON_CACHE_DIR` +
  FlashInfer/DeepGEMM disables). King pid=12643 @14:15:51Z.
