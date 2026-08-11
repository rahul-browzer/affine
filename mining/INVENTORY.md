# INVENTORY — live mine-* pods

**Cap: 40 lines.** Live table + last 3 reconciles. Older → `archive/`.

## Live

| name | huid | config | $/h | TTL | role |
|---|---|---|---|---|---|
| mine-crown-1 | lunar-orbit-50 (`1c4255fa-…`) | 8×B300 | $64.00 | 2026-08-11T16:12Z | TK@65536 · **R2l n80** · R2w yield · stage5 · **v8+tpc9 prefetch** |

SSH: `ssh root@86.38.182.50 -p 40300`

Non-mine (do not touch): `affine-eval`, `affine-bench`, `affine-datagen`.

## Last reconciles

| when | action |
|---|---|
| 2026-08-11T03:31Z | p1953: fleet=1 · R2l~11/80 · **armed awesome-v8+tpc9 prefetch + watch 462/463** · burn$64/h · bal~$123221 |
| 2026-08-11T03:28Z | p1952: fleet=1 · R2l~5/80 · armed R2l stage5 HF push · burn$64/h · bal~$123221 |
| 2026-08-11T03:26Z | p1951: fleet=1 · R2v hr0.39× harvest · R2l↔R2w deadlock fix · R2l n80 live · burn$64/h · bal~$123221 |
