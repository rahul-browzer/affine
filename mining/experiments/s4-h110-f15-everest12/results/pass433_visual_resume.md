# F15 pass433 — visual EFAULT finish + SKIP_MERGE

**When:** 2026-08-09T01:34:27Z
**Pod:** mine-f15-1 (calm-wolf-f7)

## Observation
- pass432 CPU merge wrote 16 language shards to `/tmp/h110_merged` then died:
  `SafetensorError: Bad address (os error 14)` on `save_file` of 333 visual keys
  (mmap from gocryptfs base, same as H109 p429c).
- No symlink, no merge.done, no post_train.

## Action
- `finish_visual_pass433.py`: contig-clone then `save_file` →
  `model-visual-restored.safetensors` (893 179 504 B, n_vis=333).
- `resume_post_merge_pass433.sh`: symlink `/root/h110/merged` → `/tmp`,
  merge.done, preempt264, `SKIP_MERGE=1` post_train.

## Status at handoff
- Identity OK_NON_IDENTICAL; HF push adapter+merged background.
- Chall-only re-serve started @01:34:51Z (teacher+king :8000/:8001=200).
- Next: chall :8002=200 + freeze → n80 d203.
