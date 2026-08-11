# INVENTORY — live mine-* pods

**Cap: 40 lines.** Live table + last 3 reconciles. Older → `archive/`.

## Live

| name | huid | config | $/h | TTL | role |
|---|---|---|---|---|---|
| mine-crown-1 | lunar-orbit-50 (`1c4255fa-…`) | 8×B300 | $64.00 | 2026-08-11T16:12Z | TKC@65536 · **R2ag** n80 ~36/38 · host-hist bridge · disk~444 GiB |

SSH: `ssh root@86.38.182.50 -p 40300`

Non-mine (do not touch): `affine-eval`, `affine-bench`, `affine-datagen`.

## Last reconciles

| when | action |
|---|---|
| 2026-08-11T07:55Z | p1990: fleet=1 · host history bridge 467–471 · R2ag ~36/38 · burn$64/h · bal~$122618 |
| 2026-08-11T07:49Z | p1989: fleet=1 · 463 unservable→R2y SKIP+purge · watch467–471 history · R2ag ~21/21 · burn$64/h · bal~$122640 |
| 2026-08-11T07:43Z | p1988: fleet=1 · R2ag n80 started (chall:8002 healthy; sim 285579) · burn$64/h · bal~$122651 |
