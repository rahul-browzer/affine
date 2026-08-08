# H101/F6 pass380 — hung GPU merge → CPU recover

## Symptom
- `merge_lora.py --device-map auto` (CUDA 6,7) mid-save: tmp `.tmpoLv6Za`
  stuck at **49739502312** B; WCHAN=`request_wait_answer`; `write_bytes=4096`
  flat over 5s; GPU util 0% holding ~34 GiB/GPU.
- Same failure mode as H95 p352 / H100/F4 p376.
- T/K already live (:8000/:8001=200); preempt264 poll≈186/240 → would TIMEOUT.

## Action
- Kill hung merge+post_train by PID; clear partial `$MERGED`.
- Patch `post_train_pipeline.sh` with `SKIP_MERGE` / `MERGE_DEVICE_MAP`.
- Relaunch `--device-map cpu` via `merge_recover_pass380.sh`; on success
  resume post_train `SKIP_MERGE=1` + rearm preempt264.

## Next
Await CPU merge → chall:8002 → n80 vs Tok.
