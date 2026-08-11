# INVENTORY — live mine-* pods

**Cap: 40 lines.** Live table + last 3 reconciles. Older → `archive/`.

## Live

| name | huid | config | $/h | TTL | role |
|---|---|---|---|---|---|
| mine-crown-1 | lunar-orbit-50 (`1c4255fa-…`) | 8×B300 | $64.00 | 2026-08-11T16:12Z | TK@65536 · **R2p n80** · v9 prefetch · R2x/y eager |

SSH: `ssh root@86.38.182.50 -p 40300`

Non-mine (do not touch): `affine-eval`, `affine-bench`, `affine-datagen`.

## Last reconciles

| when | action |
|---|---|
| 2026-08-11T05:33Z | p1966: fleet=1 · R2p n80~2/80 · **armed awesome-v9 prefetch** chal467 · burn$64/h · bal~$122942 |
| 2026-08-11T05:28Z | p1965: fleet=1 · **R2o REFUTE hr−1.10×** · purge ~66 GiB · **R2p chall reload** · burn$64/h · bal~$122975 |
| 2026-08-11T05:17Z | p1964: fleet=1 · R2o~53/80 · **chal455 sth hr0.79×** · **R2p premerge DONE** Δ0.671 · fixed R2p r2m gate · burn$64/h · bal~$122987 |
