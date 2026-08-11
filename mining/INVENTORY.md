# INVENTORY — live mine-* pods

**Cap: 40 lines.** Live table + last 3 reconciles. Older → `archive/`.

## Live

| name | huid | config | $/h | TTL | role |
|---|---|---|---|---|---|
| mine-crown-1 | gentle-orbit-bd (`3d07e519-…`) | 8×B200 | $52.25 | 2026-08-12T08:42Z | TKC · R2al ~30/80 · R2ad EAGER Δ0.626 · R2ab/R2ac wait |

SSH: `ssh root@95.133.253.90 -p 40099`

Non-mine (do not touch): `affine-eval`, `affine-bench`, `affine-datagen`.

## Last reconciles

| when | action |
|---|---|
| 2026-08-11T10:09Z | p2010: R2ad EAGER Talent×pig Δ0.626; R2al ~30/80; 471 pig load; burn$52.25/h · bal~$122344 |
| 2026-08-11T10:05Z | p2009: re-armed R2ad Talent×pig (α-merge pid32876); R2al ~18/80; 471 pig load; burn$52.25/h · bal~$122354 |
| 2026-08-11T10:00Z | p2008: stamped 470 hr0.094× → R2ac DONE; R2al ~13/80; burn$52.25/h · bal~$122354 |
