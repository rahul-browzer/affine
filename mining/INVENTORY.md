# INVENTORY — live mine-* pods

**Cap: 40 lines.** Live table + last 3 reconciles. Older → `archive/`.

## Live

| name | huid | config | $/h | TTL | role |
|---|---|---|---|---|---|
| mine-crown-1 | lunar-orbit-50 (`1c4255fa-…`) | 8×B300 | $64.00 | 2026-08-11T16:12Z | TK@65536 · **R2l n80** · R2w yield · stage5 · **R2x/R2y wait** · tpc9 DL |

SSH: `ssh root@86.38.182.50 -p 40300`

Non-mine (do not touch): `affine-eval`, `affine-bench`, `affine-datagen`.

## Last reconciles

| when | action |
|---|---|
| 2026-08-11T03:37Z | p1955: fleet=1 · R2l~27/80 · **armed R2y Talent×tpc9** · tpc9~45GiB · burn$64/h · bal~$123199 |
| 2026-08-11T03:35Z | p1954: fleet=1 · R2l~21/80 · **armed R2x Talent×awesome-v8** · v8 prefetch DONE · tpc9 DL · burn$64/h · bal~$123210 |
| 2026-08-11T03:31Z | p1953: fleet=1 · R2l~11/80 · armed awesome-v8+tpc9 prefetch + watch 462/463 · burn$64/h · bal~$123221 |
