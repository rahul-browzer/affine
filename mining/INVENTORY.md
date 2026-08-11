# INVENTORY — live mine-* pods

**Cap: 40 lines.** Live table + last 3 reconciles. Older → `archive/`.

## Live

| name | huid | config | $/h | TTL | role |
|---|---|---|---|---|---|
| mine-crown-1 | gentle-orbit-bd (`3d07e519-…`) | 8×B200 | $52.25 | 2026-08-12T08:42Z | R2as n80 · R2at…ax wait · tt_chall ready |

SSH: `ssh root@95.133.253.90 -p 40099`

Non-mine (do not touch): `affine-eval`, `affine-bench`, `affine-datagen`.

## Last reconciles

| when | action |
|---|---|
| 2026-08-11T15:57Z | p2050: R2as ~26/80; tt prefetch DONE + tt_chall prestaged; burn$52.25/h · bal~$121630 |
| 2026-08-11T15:53Z | p2049: R2as ~17/80; armed R2ax pure-tt+prefetch; burn$52.25/h · bal~$121640 |
| 2026-08-11T15:48Z | p2048: R2as ~7/80; pre-staged `/root/r2_out/v2_chall`; burn$52.25/h · bal~$121650 |
