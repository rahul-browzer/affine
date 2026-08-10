# INVENTORY — live mine-* pods

**Cap: 40 lines.** Live table + last 3 reconciles. Older → `archive/`.

## Live

| name | huid | config | $/h | TTL | role |
|---|---|---|---|---|---|
| mine-crown-1 | lunar-orbit-50 (`1c4255fa-…`) | 8×B300 | $64.00 | 2026-08-11T16:12Z | TK@65536 · R1c/R2/R2b |

SSH: `ssh root@86.38.182.50 -p 40300`

Non-mine (do not touch): `affine-eval`, `affine-bench`, `affine-datagen`.

## Last reconciles

| when | action |
|---|---|
| 2026-08-10T20:58Z | p1887: fleet=1 · unblocked nearmiss DONE (diane gated); R2b merge+reload armed; burn$64/h; bal~$124094 |
| 2026-08-10T20:54Z | p1886: fleet=1 · R1c~56/132; armed R2b Tok×awesome premerge 100240; burn$64/h; bal~$124105 |
| 2026-08-10T20:52Z | p1885: fleet=1 · R1c~52/132; R2 99246 wait; launched nearmiss prefetch 99742; burn$64/h; bal~$124105 |
