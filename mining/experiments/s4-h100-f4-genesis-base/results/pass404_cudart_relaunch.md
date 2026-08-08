# F4 / H100 — pass 404 cudart symlink relaunch

## Finding
cuda403 CCCL patch worked (weights loaded, torch.compile OK) but EngineCore died at
flashinfer sampling JIT link:

```
/usr/bin/ld: cannot find -lcudart: No such file or directory
```

cu13 ships only `libcudart.so.13` (+ static), no unversioned `libcudart.so`.

## Fix (live on mine-f4-1)
1. `ln -sfn libcudart.so.13 $CUDA_HOME/lib/libcudart.so` (linktest OK)
2. Keep CCCL_DISABLE patch; wipe `cached_ops/sampling`
3. Relaunch chall on isolated TCACHE (n_so=22, mode=755)
4. Script awaits promptable → **diverse-warm d1–d4** → freeze → longwait n80
   (`relaunch_chall_cuda_p404.sh`; also `wait_warm_freeze_p404.sh` as wait-only)

## Status @ 2026-08-08T23:07Z
- chall_pid=90746, :8002=000 (loading)
- teacher/king still 200
- Scripts: `/root/mining_src/s4-h100-f4-genesis-base/relaunch_chall_cuda_p404.sh`
