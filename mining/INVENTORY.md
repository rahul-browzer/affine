# INVENTORY — live mine-* pods

**Cap: 40 lines.** Live table + last 3 reconciles. Older → `archive/`.

## Live

| name | huid | config | $/h | TTL | role |
|---|---|---|---|---|---|
| mine-crown-1 | lunar-orbit-50 (`1c4255fa-…`) | 8×B300 | $64.00 | 2026-08-11T16:12Z | TK@65536 · R1c/R2 · nearmiss prefetch |

SSH: `ssh root@86.38.182.50 -p 40300`

Non-mine (do not touch): `affine-eval`, `affine-bench`, `affine-datagen`.

## Last reconciles

| when | action |
|---|---|
| 2026-08-10T20:52Z | p1885: fleet=1 · R1c~52/132; R2 99246 wait; launched nearmiss prefetch 99742; burn$64/h; bal~$124105 |
| 2026-08-10T20:49Z | p1884: fleet=1 · R2 pgrep→pidfile fix + relaunch 99246; R1c ~47/132; burn$64/h; bal~$124116 |
| 2026-08-10T20:46Z | p1883: fleet=1 · R1c 44/132; waiters OK; HF purged 6×~70GiB (~423GiB); burn$64/h; bal~$124116 |
