# H100/F4 pass376 — hung GPU merge → CPU recover

## Symptom
- `merge_lora.py --device-map auto` (CUDA 6,7) reached `save_pretrained`.
- Shard1 tmp stuck at **49739502312** B from ~20:55Z; WCHAN=`request_wait_answer`
  on gocryptfs; wchar flat over 45s; GPU util 0% holding ~34 GiB/GPU.
- Same failure mode as H95 p352.

## Action
- Killed hung merge pid=21030 + post_train pid=9401; paused Tok DL pid=22989
  (FS dual-write pressure).
- Patched `post_train_pipeline.sh`: `SKIP_MERGE` / `MERGE_DEVICE_MAP` + soft
  deadline → remove_at−1h (`2026-08-09T06:18Z` / deadman `06:48Z`).
- Relaunched `--device-map cpu` via `merge_recover_pass376.sh` (pid 31876;
  merge pid 31939). On success: resume Tok DL + post_train `SKIP_MERGE=1`.

## Next
Await CPU merge → chall serve; Tok `tok331102.done` → prewarm T/K → n80.
