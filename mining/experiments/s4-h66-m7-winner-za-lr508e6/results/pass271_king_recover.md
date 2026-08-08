# H66 pass271 — king Triton ENOENT recover

- After merge OK (non-identical), king :8001 dead: workers ImportError
  `__triton_launcher.so` ENOENT under `/root/.triton/cache/king/…` @08:40:56Z;
  APIServer hung (shm_broadcast 60s loops); GPUs 2–3 held ~37 GiB zombies.
- post_train in teacher/king wait loop (would ABORT after ~30m).
- Action: SIGKILL king+GPU2/3 workers; wipe `cache/king` + inductor king;
  `serve_three` with KING=TalentPigs@dbfbb3e2 + CHALL=/root/h66/merged
  (pids king=14425 chall=14580 @08:53Z). Teacher kept.
- Next: wait :8001/:8002=200; post_train should pass wait → chall-only
  restart_for_h2 (may re-serve merged) → preempt264 → n80.
