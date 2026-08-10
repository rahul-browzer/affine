# INVENTORY — live mine-* pods

**Cap: 40 lines.** Live table + last 3 reconciles. Older → `archive/`.

## Live

| name | huid | config | $/h | TTL | role |
|---|---|---|---|---|---|
| mine-crown-1 | lunar-orbit-50 (`1c4255fa-…`) | 8×B300 | $64.00 | 2026-08-11T16:12Z | TK@65536 · R1b train+waiter |

SSH: `ssh root@86.38.182.50 -p 40300`

Non-mine (do not touch): `affine-eval`, `affine-bench`, `affine-datagen`.

## Last reconciles

| when | action |
|---|---|
| 2026-08-10T18:18Z | p1868: fleet=1 · armed R1b merge→n80 waiter pid80760; train 3/126; burn$64/h; bal~$124451 |
| 2026-08-10T18:15Z | p1867: fleet=1 · launched R1b LoRA max_len=16384 pid79866; burn$64/h; bal~$124451 |
| 2026-08-10T18:13Z | p1866: fleet=1 · R1 LoRA n80 DONE margin+0.0005 z=0.105 → no submit; burn$64/h; bal~$124462 |
