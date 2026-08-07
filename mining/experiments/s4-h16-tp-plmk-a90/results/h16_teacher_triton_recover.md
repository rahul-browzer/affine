# H16 teacher recovery (pass 149)

- Mid-n80 teacher died @14:22:31Z:
  `ImportError: …/triton/cache/teacher/…/__triton_launcher….so: No such file`
  (same race as H14/H15/H16-king; orphan workers 8623/8624 held GPUs 0,1 ~117 GiB).
- n80 `httpx.ConnectError`; start_h16_n80 burned out.
- Fix: `kill -9` GPU0/1 orphans → wipe `/root/.triton/cache/teacher` + stale
  `vllm_teacher.pid` → `serve_three.sh` (skips live k/c; pid=16305) →
  ALL_READY 14:29:50Z → `retry_h16_n80.sh` attempt 1/3.
