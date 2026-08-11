# INVENTORY — live mine-* pods

**Cap: 40 lines.** Live table + last 3 reconciles. Older → `archive/`.

## Live

| name | huid | config | $/h | TTL | role |
|---|---|---|---|---|---|
| mine-crown-1 | lunar-orbit-50 (`1c4255fa-…`) | 8×B300 | $64.00 | 2026-08-11T16:12Z | TK@65536 · **R2n n80~13/80** · purged REFUTED HF |

SSH: `ssh root@86.38.182.50 -p 40300`

Non-mine (do not touch): `affine-eval`, `affine-bench`, `affine-datagen`.

## Last reconciles

| when | action |
|---|---|
| 2026-08-11T04:20Z | p1959: fleet=1 · R2n~13/80 · **purged sft3+kevin+saysth+awesome-v6 (~281 GiB)** · hub 701 GiB · burn$64/h · bal~$123099 |
| 2026-08-11T04:16Z | p1958: fleet=1 · **R2l REFUTE −0.89×** · R2n n80 started · purged R2l · burn$64/h · bal~$123110 |
| 2026-08-11T03:49Z | p1957: fleet=1 · R2l~55/80 · **R2n premerge DONE Δ0.671** · purged BKN6+R2g · burn$64/h · bal~$123177 |
