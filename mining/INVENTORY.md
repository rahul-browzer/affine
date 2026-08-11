# INVENTORY — live mine-* pods

**Cap: 40 lines.** Live table + last 3 reconciles. Older → `archive/`.

## Live

| name | huid | config | $/h | TTL | role |
|---|---|---|---|---|---|
| mine-crown-1 | gentle-orbit-bd (`3d07e519-…`) | 8×B200 | $52.25 | 2026-08-12T08:42Z | R2as n80 · R2at…av wait |

SSH: `ssh root@95.133.253.90 -p 40099`

Non-mine (do not touch): `affine-eval`, `affine-bench`, `affine-datagen`.

## Last reconciles

| when | action |
|---|---|
| 2026-08-11T15:48Z | p2048: R2as ~7/80; pre-staged `/root/r2_out/v2_chall`; burn$52.25/h · bal~$121650 |
| 2026-08-11T15:46Z | p2047: R2as engines 200/200/200; n80 ~1/80; burn$52.25/h · bal~$121650 |
| 2026-08-11T15:42Z | p2046: R2ar SKIP_UNSERVABLE (index/shard); R2as 726 loading; burn$52.25/h · bal~$121661 |
