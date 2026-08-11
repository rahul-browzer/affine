# INVENTORY — live mine-* pods

**Cap: 40 lines.** Live table + last 3 reconciles. Older → `archive/`.

## Live

| name | huid | config | $/h | TTL | role |
|---|---|---|---|---|---|
| mine-crown-1 | gentle-orbit-bd (`3d07e519-…`) | 8×B200 | $52.25 | 2026-08-12T08:42Z | TKC · R2ac n80 · R2am wait-R2ad · 480 hr0.50× |

SSH: `ssh root@95.133.253.90 -p 40099`

Non-mine (do not touch): `affine-eval`, `affine-bench`, `affine-datagen`.

## Last reconciles

| when | action |
|---|---|
| 2026-08-11T11:09Z | p2017: R2ab REFUTE −1.59×; R2ac n80; 480 hr0.503×; R2am DONE+merge_reload armed; burn$52.25/h · bal~$122222 |
| 2026-08-11T11:00Z | p2016: armed R2am Talent×sbs-v1 EAGER premerge; R2ab ~67/80; burn$52.25/h · bal~$122242 |
| 2026-08-11T10:55Z | p2015: fixed R2ac↔R2ad deadlock (holding-stamp); R2ab ~57/80; burn$52.25/h · bal~$122252 |
