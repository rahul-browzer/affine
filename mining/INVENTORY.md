# INVENTORY — live mine-* pods

**Cap: 40 lines.** Live table + last 3 reconciles. Older → `archive/`.

## Live

| name | huid | config | $/h | TTL | role |
|---|---|---|---|---|---|
| mine-crown-1 | gentle-orbit-bd (`3d07e519-…`) | 8×B200 | $52.25 | 2026-08-12T08:42Z | TKC · R2aj SKIP · R2ak google load · R2ab premerge DONE · R2al wait |

SSH: `ssh root@95.133.253.90 -p 40099`

Non-mine (do not touch): `affine-eval`, `affine-bench`, `affine-datagen`.

## Last reconciles

| when | action |
|---|---|
| 2026-08-11T09:19Z | p2004: stamped 469 hr0.459×; R2aj SKIP; R2ab Δ0.626 DONE; R2ak loading google; burn$52.25/h · bal~$122446 |
| 2026-08-11T09:15Z | p2003: Talent DONE; armed R2ab eager+merge; stubbed closed pre-reset lanes; board 469 chall74/80; burn$52.25/h · bal~$122446 |
| 2026-08-11T09:11Z | p2002: armed Talent prefetch pid18123; board 469 king58/80; burn$52.25/h · bal~$122466 |
