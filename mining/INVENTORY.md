# INVENTORY — live mine-* pods

**Cap: 40 lines.** Live table + last 3 reconciles. Older → `archive/`.

## Live

| name | huid | config | $/h | TTL | role |
|---|---|---|---|---|---|
| mine-crown-1 | lunar-orbit-50 (`1c4255fa-…`) | 8×B300 | $64.00 | 2026-08-11T16:12Z | TK@65536 · R1c train + R1c/R2 waiters |

SSH: `ssh root@86.38.182.50 -p 40300`

Non-mine (do not touch): `affine-eval`, `affine-bench`, `affine-datagen`.

## Last reconciles

| when | action |
|---|---|
| 2026-08-10T20:42Z | p1882: fleet=1 · R1b n80#2 REFUTE margin−0.0135; R1c 37/132; chain DONE; burn$64/h; bal~$124127 |
| 2026-08-10T20:21Z | p1881: fleet=1 · R1b n80#2 25/80; R1c 3/132; merge waiter armed+R1b-dec gate; burn$64/h; bal~$124172 |
| 2026-08-10T20:18Z | p1880: fleet=1 · R1b n80#2 16/80; R1c train pre-started GPUs6–7; burn$64/h; bal~$124183 |
