# INVENTORY — live mine-* pods

**Cap: 40 lines.** Live table + last 3 reconciles. Older → `archive/`.

## Live

| name | huid | config | $/h | TTL | role |
|---|---|---|---|---|---|
| mine-crown-1 | lunar-orbit-50 (`1c4255fa-…`) | 8×B300 | $64.00 | 2026-08-11T16:12Z | TK@65536 · **R2r n80 ~37/80** · R2af chall pre-ready · HF prepurge +211 GiB |

SSH: `ssh root@86.38.182.50 -p 40300`

Non-mine (do not touch): `affine-eval`, `affine-bench`, `affine-datagen`.

## Last reconciles

| when | action |
|---|---|
| 2026-08-11T07:05Z | p1984: fleet=1 · R2r ~37/80 · R2af chall dir pre-materialised · burn$64/h · bal~$122730 |
| 2026-08-11T07:02Z | p1983: fleet=1 · R2r ~29/80 · HF Stage-5 prepurge +210.7 GiB · burn$64/h · bal~$122752 |
| 2026-08-11T06:58Z | p1982: fleet=1 · R2ae SKIP_GATED sth · armed R2af pure awesome-v8 · burn$64/h · bal~$122763 |
