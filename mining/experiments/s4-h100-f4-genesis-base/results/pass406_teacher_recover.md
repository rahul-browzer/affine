# pass 406 — F4 teacher Triton ENOENT mid-n80 → recover332

## Observation
- n80 a203 (armed p405) died ~23:15Z: `httpx.ConnectError` to :8000.
- Teacher log: bare `/root/.triton/cache/teacher/6YKNXZRS…/__triton_launcher.so` ENOENT → EngineDead → APIServer exit.
- GPUs 0,1 empty; king :8001 / chall :8002 still 200 (leave alone).

## Action
- Launched `/root/mining_src/s4-h100-f4-genesis-base/relaunch_teacher_pass332.sh`
  (pid 98838 → teacher vllm 98931).
- Wipe teacher* caches + settle20 + unique TCACHE
  `/root/.triton/cache/teacher_p332_1786230992_98838`, util=0.80, GPUs 0,1.
- CCCL already patched; libcudart.so symlink present.
- Watcher `watch_n80_retry` + `retry_h100_n80_longwait` still armed — will wait engines then re-run a203.

## Other pods (screen)
- F7: FALSE_PROBE (chall 400) wrote decision then restarted b203 @ king5/chall8.
- F8 a203: king31/chall31.
- F9 b203: king39/chall40.

## Next
Confirm :8000 health200 + completions; n80 resumes; await margins.
