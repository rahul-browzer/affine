# H15 engine recovery (pass 146)

- Concurrent serve raced `~/.triton/cache` → chall
  `ImportError: …/__triton_launcher….so: No such file`.
- Manual chall restart without `serve_three.sh` env → FlashInfer ninja /
  CUDA header mismatch (`CUDA compiler and CUDA toolkit headers are incompatible`).
- Fix: keep teacher/king; relaunch chall via patched `serve_three.sh`
  (isolated `TRITON_CACHE_DIR=/root/.triton/cache/chall` + FlashInfer/DeepGEMM
  disables). `start_h15_n80` still in `wait_ready`.
