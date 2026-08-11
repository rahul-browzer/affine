# INVENTORY — live mine-* pods

**Cap: 40 lines.** Live table + last 3 reconciles. Older → `archive/`.

## Live

| name | huid | config | $/h | TTL | role |
|---|---|---|---|---|---|
| mine-crown-1 | lunar-orbit-50 (`1c4255fa-…`) | 8×B300 | $64.00 | 2026-08-11T16:12Z | TKC@65536 · **R2ag** pure-tpc9 n80 ~9/5 · R2y wait 463 · disk~378 GiB |

SSH: `ssh root@86.38.182.50 -p 40300`

Non-mine (do not touch): `affine-eval`, `affine-bench`, `affine-datagen`.

## Last reconciles

| when | action |
|---|---|
| 2026-08-11T07:43Z | p1988: fleet=1 · R2ag n80 started (chall:8002 healthy; sim 285579) · burn$64/h · bal~$122651 |
| 2026-08-11T07:34Z | p1987: fleet=1 · R2ag pure-tpc9 armed (chall loading) · watch463 history · burn$64/h · bal~$122673 |
| 2026-08-11T07:29Z | p1986: fleet=1 · R2af SKIP_BOARD hr−0.04× · R2x purged · chall killed · burn$64/h · bal~$122685 |
