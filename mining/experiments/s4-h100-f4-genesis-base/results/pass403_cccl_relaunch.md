# F4 / H100 — pass 403 chall relaunch

## Symptom
`relaunch_chall_cuda_p401` left chall dead: EngineCore init failed.
Root cause in `vllm_chall.log`:
```
cuda/std/__cccl/cuda_toolkit.h:41: error: CUDA compiler and CUDA toolkit
headers are incompatible
```
while compiling flashinfer `sampling` / `renorm.cu`.

## Diagnosis
- `nvidia/cu13` nvcc = **13.3** (V13.3.73)
- `cuda.h` `CUDA_VERSION` = **13000** (13.0)
- CCCL checks `_CCCL_CUDACC_EQUAL` vs CTK major.minor → fail
- King completions still 200 (kernels already resident); new EngineCore needs
  flashinfer sampling JIT → blocked
- turns.jsonl present (18384 lines); TCACHE n_so=22 OK — not a corpus/Triton miss

## Fix (armed)
1. Patch flashinfer header with
   `#define CCCL_DISABLE_CTK_COMPATIBILITY_CHECK 1 /* mining p403 … */`
   before the `#ifndef` guard.
2. Wipe `/root/.cache/flashinfer/0.6.11.post2/103a/cached_ops/sampling`.
3. Kill cuda401 waiter; launch `relaunch_chall_cuda_p403.sh` (CUDA_HOME=cu13,
   same TCACHE, freeze+rearm longwait on promptable).

## Status at handoff (2026-08-08T23:01Z)
- p403 launcher pid alive; chall_pid=85657; EngineCore init logged; **0**
  "incompatible" hits in chall log
- health :8002 still 000 (weights not on GPUs 4,5 yet — normal mid-load)
- Next: await CHALL PROMPTABLE → longwait n80

Script: `relaunch_chall_cuda_p403.sh`
