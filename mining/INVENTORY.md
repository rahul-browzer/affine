# INVENTORY — live mine-* pods

**Cap: 40 lines.** Live table + last 3 reconciles. Older → `archive/`.

## Live

| name | huid | config | $/h | TTL | role |
|---|---|---|---|---|---|
| mine-crown-1 | lunar-orbit-50 (`1c4255fa-…`) | 8×B300 | $64.00 | 2026-08-11T16:12Z | TK@65536 · R1b n80 + R1c train + R1c/R2 waiters |

SSH: `ssh root@86.38.182.50 -p 40300`

Non-mine (do not touch): `affine-eval`, `affine-bench`, `affine-datagen`.

## Last reconciles

| when | action |
|---|---|
| 2026-08-10T20:21Z | p1881: fleet=1 · R1b n80#2 25/80; R1c 3/132; merge waiter armed+R1b-dec gate; burn$64/h; bal~$124172 |
| 2026-08-10T20:18Z | p1880: fleet=1 · R1b n80#2 16/80; R1c train pre-started GPUs6–7; burn$64/h; bal~$124183 |
| 2026-08-10T20:14Z | p1879: fleet=1 · R1b n80#1 ReadTimeout@~76/80; patched 600s×5; relaunch king1/80; burn$64/h; bal~$124194 |
