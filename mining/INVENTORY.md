# INVENTORY — live mine-* pods

**Cap: 40 lines.** Live table + last 3 reconciles. Older → `archive/`.

## Live

| name | huid | config | $/h | TTL | role |
|---|---|---|---|---|---|
| mine-crown-1 | lunar-orbit-50 (`1c4255fa-…`) | 8×B300 | $64.00 | 2026-08-11T16:12Z | TKC@65536 · **R2ag** n80 ~49/49 · **R2ah** armed · host-hist bridge · disk~444 GiB |

SSH: `ssh root@86.38.182.50 -p 40300`

Non-mine (do not touch): `affine-eval`, `affine-bench`, `affine-datagen`.

## Last reconciles

| when | action |
|---|---|
| 2026-08-11T08:01Z | p1991: fleet=1 · R2ah pure-v9 armed after R2ag · R2ag ~49/49 · burn$64/h · bal~$122618 |
| 2026-08-11T07:55Z | p1990: fleet=1 · host history bridge 467–471 · R2ag ~36/38 · burn$64/h · bal~$122618 |
| 2026-08-11T07:49Z | p1989: fleet=1 · 463 unservable→R2y SKIP+purge · watch467–471 history · R2ag ~21/21 · burn$64/h · bal~$122640 |
