# INVENTORY — live mine-* pods

**Cap: 40 lines.** Live table + last 3 reconciles. Older → `archive/`.

## Live

| name | huid | config | $/h | TTL | role |
|---|---|---|---|---|---|
| mine-crown-1 | lunar-orbit-50 (`1c4255fa-…`) | 8×B300 | $64.00 | 2026-08-11T16:12Z | TK@65536 · R2i/k…p + R2q + **R2r** |

SSH: `ssh root@86.38.182.50 -p 40300`

Non-mine (do not touch): `affine-eval`, `affine-bench`, `affine-datagen`.

## Last reconciles

| when | action |
|---|---|
| 2026-08-11T01:17Z | p1931: fleet=1 · armed R2r Talent×whoami (162125/162126); whoami DONE; burn$64/h; bal~$123512 |
| 2026-08-11T01:14Z | p1930: fleet=1 · armed whoami prefetch+watch-458 (159761/159877); burn$64/h; bal~$123523 |
| 2026-08-11T01:10Z | p1929: fleet=1 · R2j SKIP (432 hr −0.57×); board→441; burn$64/h; bal~$123535 |
