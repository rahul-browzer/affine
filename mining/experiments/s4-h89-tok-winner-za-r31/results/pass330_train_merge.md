# H89 pass330 — train DONE → merge → chall serve

UTC 2026-08-08T15:54–16:05Z · pod mine-h89-1 (gentle-fox-06)

## Train
- finished_utc `2026-08-08T15:54:31Z` · elapsed 658s · steps 26/26
- train_loss **0.4368** · kept 205/406 · thought_ok=205
- adapter `/root/h89/train/adapter` (62M) · `train.done` written

## Merge
- started 15:55:02Z → shards 47G+19G + **model-visual-restored.safetensors 852MiB**
- `/root/logs/h89_merge.done` @16:02Z
- identity: `identical_to_base=false` `identical_to_king=false` (window_any_diff)

## Chall serve
- launched 16:02:43Z port 8002 GPUs 4,5 util=0.72 isolated TCACHE
- teacher+king kept (:8000/:8001=200); chall loading shards @16:04Z
- form+n80_retry watchers still armed; **arm mid304 when n80 starts**

## Peer snapshot @~16:05Z
- H85 n80 **58/80** · H86 **17/80** · H87 train step~15 · H88 train step~10 (DOWNLOAD→train @15:53Z)
