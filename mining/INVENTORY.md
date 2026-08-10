# INVENTORY — live mine-* pods

**Cap: 40 lines.** Live table + last 3 reconciles. Older → `archive/`.

## Live

| name | huid | config | $/h | TTL | role |
|---|---|---|---|---|---|
| mine-crown-1 | lunar-orbit-50 (`1c4255fa-…`) | 8×B300 | $64.00 | 2026-08-11T16:12Z | HF DL (~103G) + Reason n80 auto-launch |

SSH: `ssh root@86.38.182.50 -p 40300`

Non-mine (do not touch): `affine-eval`, `affine-bench`, `affine-datagen`.

## Last reconciles

| when | action |
|---|---|
| 2026-08-10T16:21Z | p1850: fleet=1 mine-* · installed pandas; HF~103G growing; burn$64/h |
| 2026-08-10T16:18Z | p1849: fleet=1 mine-* · harness+corpus v2+Reason watcher on crown; burn$64/h |
| 2026-08-10T16:15Z | p1848: fleet=1 mine-* · uploaded warm-stack + launched restore pid1305 |
