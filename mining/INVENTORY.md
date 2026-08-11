# INVENTORY — live mine-* pods

**Cap: 40 lines.** Live table + last 3 reconciles. Older → `archive/`.

## Live

| name | huid | config | $/h | TTL | role |
|---|---|---|---|---|---|
| mine-crown-1 | gentle-orbit-bd (`3d07e519-…`) | 8×B200 | $52.25 | 2026-08-12T08:42Z | TKC · R2am n80 · R2an wait |

SSH: `ssh root@95.133.253.90 -p 40099`

Non-mine (do not touch): `affine-eval`, `affine-bench`, `affine-datagen`.

## Last reconciles

| when | action |
|---|---|
| 2026-08-11T12:15Z | p2023: R2ad REFUTE −1.18×; purged pig ~66GiB; R2am chall READY→n80; R2an wait; burn$52.25/h · bal~$122089 |
| 2026-08-11T11:37Z | p2021: R2ac REFUTE −0.978×; purged google ~66GiB; R2ad chall loading; R2an Δ0.626 wait481; burn$52.25/h · bal~$122160 |
| 2026-08-11T11:19Z | p2020: R2ac ~31/80; armed Stage-5 push + HF prepurge +140.5GiB; R2an merge mid; burn$52.25/h · bal~$122201 |
