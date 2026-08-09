# F15 pass432 — preempt gocryptfs merge hang

**When:** 2026-08-09T01:31:54Z
**Pod:** mine-f15-1 (calm-wolf-f7)

## Observation
- Train finished; `post_train` started GPU `merge_lora --device-map auto --out /root/h110/merged`.
- `/root` is `fuse.gocryptfs`. Mid-save: WCHAN=`request_wait_answer`, `.tmpjxy7Et` ≈ **49.7 GiB** (exact F14 hang signature).
- `/tmp` is overlay (safe).

## Action
- Killed hung merge pid 16356 + post_train 5802.
- Launched `merge_recover_pass432.sh`: contiguous-clone + `max_shard_size=5GB` → `/tmp/h110_merged`, symlink `/root/h110/merged`, resume `post_train` with `SKIP_MERGE=1`.

## Status at handoff
- CPU merge loading base @01:32Z (pid 17075). Next pass: wait merge.done → chall serve → n80 d203.
