# INVENTORY — live mine-* pods

**Cap: 40 lines.** Live table + last 3 reconciles. Older → `archive/`.

## Live

| name | huid | config | $/h | TTL | role |
|---|---|---|---|---|---|
| mine-crown-1 | lunar-orbit-50 (`1c4255fa-…`) | 8×B300 | $64.00 | 2026-08-11T16:12Z | TK@65536 · R2e n80 |

SSH: `ssh root@86.38.182.50 -p 40300`

Non-mine (do not touch): `affine-eval`, `affine-bench`, `affine-datagen`.

## Last reconciles

| when | action |
|---|---|
| 2026-08-10T23:01Z | p1900: fleet=1 · R2e chall:8002 200 + n80 pid128291 active (teacher busy); burn$64/h; bal~$123825 |
| 2026-08-10T22:57Z | p1899: fleet=1 · R2d DONE hr=0.22× SIGNAL_POS; R2e chall 124848 loading; burn$64/h; bal~$123825 |
| 2026-08-10T22:35Z | p1898: fleet=1 · R2d ~32/80; R2f premerge Δ=0.00899 → WEAK_SKIP n80; R2e waits; burn$64/h; bal~$123870 |
