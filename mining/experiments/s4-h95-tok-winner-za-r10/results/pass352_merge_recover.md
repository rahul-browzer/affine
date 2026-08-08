# H95 pass352 — hung GPU merge → CPU recover

## Symptom
- `merge_lora.py --device-map auto` (CUDA_VISIBLE=6,7) reached `save_pretrained`.
- Shard1 wrote 47G in ~14m; shard2 tmp stuck at 19G from 18:56Z with
  WCHAN=`request_wait_answer`, 0% CPU, 0 byte growth over 10s+.
- Teacher/king :8000/:8001 stayed 200; :8002 down (expected).

## Action
- Kill hung merge pid=13111 + post_train pid=4995 (teacher/king untouched).
- Relaunch merge `--device-map cpu` (pid logged in
  `/root/logs/h95_merge_recover_pass352.pid`).
- Watcher → `resume_post_merge_pass352.sh` (SKIP_MERGE=1) or
  post_train with `MERGE_DEVICE_MAP=cpu`.
- post_train now honors `SKIP_MERGE` / `MERGE_DEVICE_MAP`.

## Next
Await CPU merge → chall serve → n80+mid304.
