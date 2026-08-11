# INVENTORY — live mine-* pods

**Cap: 40 lines.** Live table + last 3 reconciles. Older → `archive/`.

## Live

| name | huid | config | $/h | TTL | role |
|---|---|---|---|---|---|
| mine-crown-1 | lunar-orbit-50 (`1c4255fa-…`) | 8×B300 | $64.00 | 2026-08-11T16:12Z | TK@65536 · **R2l n80~55/80** · **R2n DONE** · stage5 · R2x/R2y wait |

SSH: `ssh root@86.38.182.50 -p 40300`

Non-mine (do not touch): `affine-eval`, `affine-bench`, `affine-datagen`.

## Last reconciles

| when | action |
|---|---|
| 2026-08-11T03:49Z | p1957: fleet=1 · R2l~55/80 · **R2n premerge DONE Δ0.671** · purged BKN6+R2g · burn$64/h · bal~$123177 |
| 2026-08-11T03:40Z | p1956: fleet=1 · R2l~31/80 · **SKIP R2w board asdf hr0.40×** · R2n CPU merge · tpc9 DONE · burn$64/h · bal~$123199 |
| 2026-08-11T03:37Z | p1955: fleet=1 · R2l~27/80 · **armed R2y Talent×tpc9** · tpc9~45GiB · burn$64/h · bal~$123199 |
