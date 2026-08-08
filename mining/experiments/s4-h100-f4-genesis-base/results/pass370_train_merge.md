# Pass 370 — F4 train DONE → merge live; Tok king DL resumed

**When:** 2026-08-08T20:18Z–20:31Z
**Pod:** mine-f4-1 (calm-wolf-30, 8×B300 @$63.60)

## Result
- Train finished step **60/60** @20:18Z (`train.done`); fit-filter kept 477/1059.
- Final loss ~0.999 @ step 60; adapter at `/root/h100/train/adapter` + ckpt-50/60.
- post_train saw `train.done` @20:19:05Z → merge_lora live @20:19:20Z
  (pid 21030; writing `.tmp*` shard, ~47 GiB apparent @20:30Z).
- Teacher DL was DONE earlier; **Tok331102 king DL had stalled** mid-shard
  (~15–20 GiB / 35 GiB incompletes) with no `tok331102.done` → prewarm blocked
  (engines 000/000/000).
- p370 killed HF DL and tried F1→F4 peer rsync (~16 MB/s) — **slower than HF**;
  aborted rsync, resumed `snapshot_download` (pid in
  `/root/logs/h100_tok_redownload.pid`). Cost: lost partial incompletes
  (~half of each 35 GiB shard). Lesson: never swap a live HF resume for a
  slower peer path.

## Next
Await merge.done + identity check → chall serve; await `tok331102.done` →
prewarm T/K → n80. Do not tear down.
