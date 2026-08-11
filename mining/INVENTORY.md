# INVENTORY — live mine-* pods

**Cap: 40 lines.** Live table + last 3 reconciles. Older → `archive/`.

## Live

| name | huid | config | $/h | TTL | role |
|---|---|---|---|---|---|
| mine-crown-1 | gentle-orbit-bd (`3d07e519-…`) | 8×B200 | $52.25 | 2026-08-12T08:42Z | TKC **200/200/200** · R2aj wait469 · R2ak/R2al · R2ab eager · Talent DONE |

SSH: `ssh root@95.133.253.90 -p 40099`

Non-mine (do not touch): `affine-eval`, `affine-bench`, `affine-datagen`.

## Last reconciles

| when | action |
|---|---|
| 2026-08-11T09:15Z | p2003: Talent DONE; armed R2ab eager+merge; stubbed closed pre-reset lanes; board 469 chall74/80; burn$52.25/h · bal~$122446 |
| 2026-08-11T09:11Z | p2002: armed Talent prefetch pid18123; board 469 king58/80; burn$52.25/h · bal~$122466 |
| 2026-08-11T09:08Z | p2001: pig DONE+prestage `/root/r2_out/pig_chall`; burn$52.25/h · bal~$122466 |
