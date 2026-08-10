# INVENTORY — live mine-* pods

**Cap: 40 lines.** Live table + last 3 reconciles. Older → `archive/`.

## Live

| name | huid | config | $/h | TTL | role |
|---|---|---|---|---|---|
| mine-crown-1 | lunar-orbit-50 (`1c4255fa-…`) | 8×B300 | $64.00 | 2026-08-11T16:12Z | TK@65536 · R1b n80 running · R1c/R2 waiters |

SSH: `ssh root@86.38.182.50 -p 40300`

Non-mine (do not touch): `affine-eval`, `affine-bench`, `affine-datagen`.

## Last reconciles

| when | action |
|---|---|
| 2026-08-10T19:46Z | p1878: fleet=1 · R1b train+merge DONE; n80 chall10/king9; engines 200; burn$64/h; bal~$124250 |
| 2026-08-10T19:13Z | p1876: fleet=1 · R2 premerge DONE max_abs_delta=0.277; R1b~93/126; engines 200; burn$64/h; bal~$124328 |
| 2026-08-10T18:45Z | p1875: fleet=1 · R2 prefetch DONE; α-merge shard1 written; fixed premerge meta stamp; R1b~48/126; burn$64/h; bal~$124395 |
