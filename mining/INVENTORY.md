# INVENTORY — live mine-* pods

**Cap: 40 lines.** Live table + last 3 reconciles. Older → `archive/`.

## Live

| name | huid | config | $/h | TTL | role |
|---|---|---|---|---|---|
| mine-crown-1 | gentle-orbit-bd (`3d07e519-…`) | 8×B200 | $52.25 | 2026-08-12T08:42Z | TKC · R2al ~40/80 · watch480 · sbs DONE |

SSH: `ssh root@95.133.253.90 -p 40099`

Non-mine (do not touch): `affine-eval`, `affine-bench`, `affine-datagen`.

## Last reconciles

| when | action |
|---|---|
| 2026-08-11T10:16Z | p2012: sbs-v1 prefetch DONE; armed on-pod watch480 (pid36279); R2al ~40/80; burn$52.25/h · bal~$122324 |
| 2026-08-11T10:13Z | p2011: armed sbs-v1 prefetch (480); bridge→471+480; R2al ~34/80; burn$52.25/h · bal~$122334 |
| 2026-08-11T10:09Z | p2010: R2ad EAGER Talent×pig Δ0.626; R2al ~30/80; 471 pig load; burn$52.25/h · bal~$122344 |
