# INVENTORY — live mine-* pods

**Cap: 40 lines.** Live table + last 3 reconciles. Older → `archive/`.

## Live

| name | huid | config | $/h | TTL | role |
|---|---|---|---|---|---|
| mine-crown-1 | lunar-orbit-50 (`1c4255fa-…`) | 8×B300 | $64.00 | 2026-08-11T16:12Z | TK@65536 · R2h n80 · R2g/440 · R2i/441 · BKN prefetch |

SSH: `ssh root@86.38.182.50 -p 40300`

Non-mine (do not touch): `affine-eval`, `affine-bench`, `affine-datagen`.

## Last reconciles

| when | action |
|---|---|
| 2026-08-10T23:56Z | p1910: fleet=1 · R2h ~36/80; armed BKN seven prefetch 139298; burn$64/h; bal~$123691 |
| 2026-08-10T23:53Z | p1909: fleet=1 · R2h ~30/80; armed R2i reload 139014; thomp prefetch DONE; burn$64/h; bal~$123702 |
| 2026-08-10T23:50Z | p1908: fleet=1 · R2h ~19/80; armed 441 watch 138617 + R2i premerge 138637; burn$64/h; bal~$123702 |
