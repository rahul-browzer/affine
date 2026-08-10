# INVENTORY — live mine-* pods

**Cap: 40 lines.** Live table + last 3 reconciles. Older → `archive/`.

## Live

| name | huid | config | $/h | TTL | role |
|---|---|---|---|---|---|
| mine-crown-1 | lunar-orbit-50 (`1c4255fa-…`) | 8×B300 | $64.00 | 2026-08-11T16:12Z | TK@65536 · R1b+waiters · R2 parent prefetch |

SSH: `ssh root@86.38.182.50 -p 40300`

Non-mine (do not touch): `affine-eval`, `affine-bench`, `affine-datagen`.

## Last reconciles

| when | action |
|---|---|
| 2026-08-10T18:34Z | p1872: fleet=1 · R1b~32/126; launched R2 TalentPigs+kevin prefetch pid83501; burn$64/h; bal~$124418 |
| 2026-08-10T18:31Z | p1871: fleet=1 · armed R1b→R1c chain pid83033; R1b 27/126; burn$64/h; bal~$124418 |
| 2026-08-10T18:29Z | p1870: fleet=1 · R1b 23/126; R1c EPOCHS=6 + merge waiter staged; burn$64/h; bal~$124429 |
