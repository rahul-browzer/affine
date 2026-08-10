# INVENTORY — live mine-* pods

**Cap: 40 lines.** Live table + last 3 reconciles. Older → `archive/`.

## Live

| name | huid | config | $/h | TTL | role |
|---|---|---|---|---|---|
| mine-crown-1 | lunar-orbit-50 (`1c4255fa-…`) | 8×B300 | $64.00 | 2026-08-11T16:12Z | TK@65536 · R2e ~28/80 · 440+R2g wait |

SSH: `ssh root@86.38.182.50 -p 40300`

Non-mine (do not touch): `affine-eval`, `affine-bench`, `affine-datagen`.

## Last reconciles

| when | action |
|---|---|
| 2026-08-10T23:14Z | p1903: fleet=1 · R2e ~28/80; R2g waiter 130003 armed; burn$64/h; bal~$123792 |
| 2026-08-10T23:11Z | p1902: fleet=1 · saysth prefetch DONE; R2e ~21/80; 440 watcher 129745; burn$64/h; bal~$123792 |
| 2026-08-10T23:06Z | p1901: fleet=1 · R2e ~7/80 + saysth prefetch 129090; burn$64/h; bal~$123803 |
