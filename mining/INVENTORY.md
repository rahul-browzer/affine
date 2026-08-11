# INVENTORY — live mine-* pods

**Cap: 40 lines.** Live table + last 3 reconciles. Older → `archive/`.

## Live

| name | huid | config | $/h | TTL | role |
|---|---|---|---|---|---|
| mine-crown-1 | gentle-orbit-bd (`3d07e519-…`) | 8×B200 | $52.25 | 2026-08-12T08:42Z | TKC · R2ac n80 · R2an EAGER |

SSH: `ssh root@95.133.253.90 -p 40099`

Non-mine (do not touch): `affine-eval`, `affine-bench`, `affine-datagen`.

## Last reconciles

| when | action |
|---|---|
| 2026-08-11T11:16Z | p2019: R2ac ~16/80; armed R2an Talent×cp13 EAGER CPU+merge_reload; burn$52.25/h · bal~$122211 |
| 2026-08-11T11:13Z | p2018: R2ac ~14/80; armed chal-00481 cp13 prefetch+watch+host bridge (R2an); burn$52.25/h · bal~$122211 |
| 2026-08-11T11:09Z | p2017: R2ab REFUTE −1.59×; R2ac n80; 480 hr0.503×; R2am DONE+merge_reload armed; burn$52.25/h · bal~$122222 |
