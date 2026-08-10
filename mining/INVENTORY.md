# INVENTORY — live mine-* pods

**Cap: 40 lines.** Live table + last 3 reconciles. Older → `archive/`.

## Live

| name | huid | config | $/h | TTL | role |
|---|---|---|---|---|---|
| mine-crown-1 | lunar-orbit-50 (`1c4255fa-…`) | 8×B300 | $64.00 | 2026-08-11T16:12Z | TK@65536 · R1c→R2e |

SSH: `ssh root@86.38.182.50 -p 40300`

Non-mine (do not touch): `affine-eval`, `affine-bench`, `affine-datagen`.

## Last reconciles

| when | action |
|---|---|
| 2026-08-10T21:27Z | p1892: fleet=1 · R2e Talent×awesome PREMERGE DONE Δ=0.626; waiter 104742; R1c~105/132; burn$64/h; bal~$124026 |
| 2026-08-10T21:16Z | p1891: fleet=1 · R2d pure awesome-v6 n80 waiter armed (104051); R1c~88/132; burn$64/h; bal~$124049 |
| 2026-08-10T21:13Z | p1890: fleet=1 · R2c skew PREMERGE DONE (Δ=0.009); R1c~84/132; burn$64/h; bal~$124060 |
