# INVENTORY — live mine-* pods

**Cap: 40 lines.** Live table + last 3 reconciles. Older → `archive/`.

## Live

| name | huid | config | $/h | TTL | role |
|---|---|---|---|---|---|
| mine-crown-1 | lunar-orbit-50 (`1c4255fa-…`) | 8×B300 | $64.00 | 2026-08-11T16:12Z | TK@65536 · **R2o n80** · **R2p** Δ0.671 ready · R2x/y eager |

SSH: `ssh root@86.38.182.50 -p 40300`

Non-mine (do not touch): `affine-eval`, `affine-bench`, `affine-datagen`.

## Last reconciles

| when | action |
|---|---|
| 2026-08-11T05:17Z | p1964: fleet=1 · R2o~53/80 · **chal455 sth hr0.79×** · **R2p premerge DONE** Δ0.671 · fixed R2p r2m gate · burn$64/h · bal~$122987 |
| 2026-08-11T05:03Z | p1963: fleet=1 · R2o~26/80 · **R2y eager Talent×tpc9 DONE** Δ0.622 · burn$64/h · bal~$123008 |
| 2026-08-11T04:54Z | p1962: fleet=1 · **R2n REFUTE hr−1.07×** · unstuck R2o→n80 · R2x eager Δ0.626 · purge R2n ~66 GiB · burn$64/h · bal~$123031 |
