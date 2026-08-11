# INVENTORY — live mine-* pods

**Cap: 40 lines.** Live table + last 3 reconciles. Older → `archive/`.

## Live

| name | huid | config | $/h | TTL | role |
|---|---|---|---|---|---|
| mine-crown-1 | gentle-orbit-bd (`3d07e519-…`) | 8×B200 | $52.25 | 2026-08-12T08:42Z | TKC · R2am n80#2 · h44→now prefetch · Stage-5 arm |

SSH: `ssh root@95.133.253.90 -p 40099`

Non-mine (do not touch): `affine-eval`, `affine-bench`, `affine-datagen`.

## Last reconciles

| when | action |
|---|---|
| 2026-08-11T12:55Z | p2027: R2am ~14/80; armed now-after-h44 + watch486; burn$52.25/h · bal~$122007 |
| 2026-08-11T12:53Z | p2026: R2am n80#2 ~6–10/80 healthy; armed h44 prefetch + R2am Stage-5 + watch485; burn$52.25/h · bal~$122007 |
| 2026-08-11T12:48Z | p2025: R2am ReadTimeout@61/80 → patch 600s×5 + relaunch n80#2 (~1/80); R2an wait; burn$52.25/h · bal~$122018 |
