# INVENTORY — live mine-* pods

**Cap: 40 lines.** Live table + last 3 reconciles. Older → `archive/`.

## Live

| name | huid | config | $/h | TTL | role |
|---|---|---|---|---|---|
| mine-crown-1 | lunar-orbit-50 (`1c4255fa-…`) | 8×B300 | $64.00 | 2026-08-11T16:12Z | TK@65536 · **R2p n80** · sbs prefetch · R2z eager Δ0.671 · R2x/y wait |

SSH: `ssh root@86.38.182.50 -p 40300`

Non-mine (do not touch): `affine-eval`, `affine-bench`, `affine-datagen`.

## Last reconciles

| when | action |
|---|---|
| 2026-08-11T05:45Z | p1968: fleet=1 · R2p~27/80 · **armed sbs prefetch** chal468 · burn$64/h · bal~$122920 |
| 2026-08-11T05:43Z | p1967: fleet=1 · R2p~20/80 · **v9 DONE** · **R2z eager Δ0.671** + watch467 · burn$64/h · bal~$122920 |
| 2026-08-11T05:33Z | p1966: fleet=1 · R2p n80~2/80 · **armed awesome-v9 prefetch** chal467 · burn$64/h · bal~$122942 |
