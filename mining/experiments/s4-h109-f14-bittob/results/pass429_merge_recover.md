# F14 / H109 pass429 — merge recover

## Problem
- p428 CPU merge to `/root` (gocryptfs) hung: `.tmpU0UAYq` = 49739502312 B,
  `write_bytes=4096`, WCHAN=`request_wait_answer`, wchar growing.
- Retry save to `/tmp` overlay: `SafetensorError: Bad address (os error 14)`
  on first shard (also with `max_shard_size=5GB`).

## Fix (pass429c)
1. Contiguous-clone `state_dict` after `merge_and_unload`.
2. `save_pretrained(..., max_shard_size="5GB")` → `/tmp/h109_merged` (16 shards).
3. Visual restore: clone tensors then `save_file` → `model-visual-restored.safetensors`
   (333 keys, 852 MiB) via `finish_visual_pass429c.py`.
4. `ln -sfn /tmp/h109_merged /root/h109/merged`; `SKIP_MERGE=1` post_train.

## Outcome
- merge.done @01:18:04Z; chall serve launched util=0.72 GPUs 4,5.
- Scripts: `merge_recover_pass429c.sh`, `finish_visual_pass429c.py`,
  `resume_post_merge_pass429c.sh`.
