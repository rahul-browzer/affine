# INVENTORY — live mine-* pods

**Cap: 40 lines.** Live table + last 3 reconciles. Older → `archive/`.

## Live

| name | huid | config | $/h | TTL | role |
|---|---|---|---|---|---|
| mine-crown-1 | lunar-orbit-50 (`1c4255fa-…`) | 8×B300 | $64.00 | 2026-08-11T16:12Z | TK@65536 · **R2v sft3 n80** · R2l…p+R2r wait |

SSH: `ssh root@86.38.182.50 -p 40300`

Non-mine (do not touch): `affine-eval`, `affine-bench`, `affine-datagen`.

## Last reconciles

| when | action |
|---|---|
| 2026-08-11T02:43Z | p1944: fleet=1 · **R2v armed** pure sft3 chall reload; burn$64/h; bal~$123333 |
| 2026-08-11T02:38Z | p1943: fleet=1 · **R2t REFUTE** hr **−0.93×**; blend purged; burn$64/h; bal~$123333 |
| 2026-08-11T02:20Z | p1942: fleet=1 · **R2k SKIP** 431 hr **−0.46×**; R2t ~34/80; burn$64/h; bal~$123367 |
