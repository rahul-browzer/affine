# H40 recover pass218

p217 failed mid-load: `__triton_launcher.so` ImportError @00:46:34 then
`shm_broadcast` hang (No available shared memory broadcast block). health never 200;
freeze-after-warmup never reached.

Action: relaunch_chall_pass218.sh = p217 path + wipe `/root/.cache/vllm/torch_compile_cache`
before launch (LESSONS CUDA-graph hang).
