# Pass 360 — F1 king bare-cache ENOENT → king332

- King died ~19:28Z: Triton ENOENT
  `/root/.triton/cache/king/QU66URD…/fused_moe_kernel.ptx` (+ Cuda all_reduce invalid arg).
- Teacher :8000=200; train RL on GPUs 6,7 (~step 35/200, mean_r≈0.1).
- Launched `king_recover_pass332.sh` pid=13900 @19:35:39Z —
  isolated TCACHE `/root/.triton/isolated/h98_king_p332_1786217742_13900`, util=0.72, GPUs 2,3.
- King vLLM pid=14168 started 19:36:07Z; await PROMPTABLE. Train untouched.
