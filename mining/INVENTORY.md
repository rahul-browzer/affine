# INVENTORY — live mine-* pods

**Cap: 40 lines.** Live table + last 3 reconciles. Older → `archive/`.

## Live

| name | huid | config | $/h | TTL | role |
|---|---|---|---|---|---|
| mine-crown-1 | lunar-orbit-50 (`1c4255fa-…`) | 8×B300 | $64.00 | 2026-08-11T16:12Z | TK@65536 · R2d→R2e |

SSH: `ssh root@86.38.182.50 -p 40300`

Non-mine (do not touch): `affine-eval`, `affine-bench`, `affine-datagen`.

## Last reconciles

| when | action |
|---|---|
| 2026-08-10T22:20Z | p1895: fleet=1 · R1c REFUTE −0.0171; R2d chall :8002=200 → n80; R2e waits; burn$64/h; bal~$123903 |
| 2026-08-10T21:34Z | p1893: fleet=1 · weak R2/R2b/R2c SKIPPED; R2d waits R1c; chall restored 200; R1c~116/132; burn$64/h; bal~$124026 |
| 2026-08-10T21:27Z | p1892: fleet=1 · R2e Talent×awesome PREMERGE DONE Δ=0.626; waiter 104742; R1c~105/132; burn$64/h; bal~$124026 |
