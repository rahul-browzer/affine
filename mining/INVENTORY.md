# INVENTORY — live mine-* pods

**Cap: 40 lines.** Live table + last 3 reconciles. Older → `archive/`.

## Live

| name | huid | config | $/h | TTL | role |
|---|---|---|---|---|---|
| mine-crown-1 | gentle-orbit-bd (`3d07e519-…`) | 8×B200 | $52.25 | 2026-08-12T08:42Z | TKC · R2al n80 ~13/80 · R2ac premerge DONE · R2ab wait |

SSH: `ssh root@95.133.253.90 -p 40099`

Non-mine (do not touch): `affine-eval`, `affine-bench`, `affine-datagen`.

## Last reconciles

| when | action |
|---|---|
| 2026-08-11T10:00Z | p2008: stamped 470 hr0.094× → R2ac DONE; R2al ~13/80; burn$52.25/h · bal~$122354 |
| 2026-08-11T09:53Z | p2007: R2ak DONE hr0.641× SKIP Stage-5; R2al loading pig; R2ac eager Δ0.626; burn$52.25/h · bal~$122375 |
| 2026-08-11T09:30Z | p2006: re-armed R2ac Talent×google; R2ak ~15/80; burn$52.25/h · bal~$122426 |
