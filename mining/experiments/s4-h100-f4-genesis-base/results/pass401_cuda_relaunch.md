# Pass 401 — F4 chall CUDA_HOME relaunch

- p397 frozen relaunch ABORT path: Worker `Could not find nvcc` /
  `cuda_home='/usr/local/cuda' doesn't exist` (GPUs 4–7 empty, poll≳114/120).
- Root cause: `relaunch_chall_frozen_p397.sh` never exported cu13 `CUDA_HOME`
  (pass264 does). Frozen 555 TCACHE + missing JIT → hard fail.
- Fix: `relaunch_chall_cuda_p401.sh` — set `CUDA_HOME=…/nvidia/cu13`, TCACHE
  mode 755 for JIT, freeze after promptable, rearm longwait.
- Launched 22:50:16Z chall_pid=80609; poll=6/180 health=000 loading (no nvcc
  in log). Await promptable → n80.
