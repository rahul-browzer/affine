# INVENTORY — live mine-* pods

**Cap: 40 lines.** Live table + last 3 reconciles. Older → `archive/`.

## Live

| name | huid | config | $/h | TTL | role |
|---|---|---|---|---|---|
| mine-crown-1 | lunar-orbit-50 (`1c4255fa-…`) | 8×B300 | $64.00 | 2026-08-11T16:12Z | 200/200/200 · H64 n80 ~19/80 + R1 data staged |

SSH: `ssh root@86.38.182.50 -p 40300`

Non-mine (do not touch): `affine-eval`, `affine-bench`, `affine-datagen`.

## Last reconciles

| when | action |
|---|---|
| 2026-08-10T16:44Z | p1855: fleet=1 mine-* · n80 ~19/80 + high_reason harvest 1403; burn$64/h |
| 2026-08-10T16:38Z | p1854: fleet=1 mine-* · n80 progressing + HF export fix; burn$64/h |
| 2026-08-10T16:33Z | p1853: fleet=1 mine-* · watcher relaunch→n80 running; burn$64/h |
