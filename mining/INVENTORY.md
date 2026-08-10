# INVENTORY — live mine-* pods

**Cap: 40 lines.** Live table + last 3 reconciles. Older → `archive/`.

## Live

| name | huid | config | $/h | TTL | role |
|---|---|---|---|---|---|
| mine-crown-1 | lunar-orbit-50 (`1c4255fa-…`) | 8×B300 | $64.00 | 2026-08-11T16:12Z | TK@65536 · R2h n80 · R2g/440 · thomp prefetch |

SSH: `ssh root@86.38.182.50 -p 40300`

Non-mine (do not touch): `affine-eval`, `affine-bench`, `affine-datagen`.

## Last reconciles

| when | action |
|---|---|
| 2026-08-10T23:47Z | p1907: fleet=1 · R2h ~7/80; armed thompsville prefetch 138058; burn$64/h; bal~$123713 |
| 2026-08-10T23:45Z | p1906: fleet=1 · R2e DONE hr−1.18×; R2h n80 137312 up; burn$64/h; bal~$123725 |
| 2026-08-10T23:20Z | p1905: fleet=1 · R2e ~37/80; armed R2h TTK 130845; rearmed R2g 130835; burn$64/h; bal~$123780 |
