# H14 engine recovery (pass 146)

- First launch: concurrent teacher/king/chall raced shared `~/.triton/cache`
  → chall `FileNotFoundError: …/_bilinear_pos_embed_kernel.json`.
- Naive `pkill vllm` left orphan GPU workers ([Not Found] PIDs) holding ~117 GiB;
  restart then hit `Free memory … less than desired GPU memory utilization`.
- Manual restart without `serve_three.sh` env (`VLLM_USE_FLASHINFER_SAMPLER=0`,
  `VLLM_USE_DEEP_GEMM=0`) → teacher died on FlashInfer ninja sampling build.
- Fix: kill GPU compute PIDs via `nvidia-smi`, then relaunch via patched
  `serve_three.sh` (per-role `TRITON_CACHE_DIR` + 20 s stagger). `start_h14_n80`
  still in `wait_ready` (TIMEOUT 2400 s).
