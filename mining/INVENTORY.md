# INVENTORY — live mine-* pods

**Cap: 40 lines.** Live table + last 3 reconciles. Older → `archive/`.

## Live

| name | huid | config | $/h | TTL | role |
|---|---|---|---|---|---|
| mine-crown-1 | lunar-orbit-50 (`1c4255fa-…`) | 8×B300 | $64.00 | 2026-08-11T16:12Z | TKC@65536 · **R2ai** sbs chall loading · orphans cleared · host-hist bridge · disk~444 GiB |

SSH: `ssh root@86.38.182.50 -p 40300`

Non-mine (do not touch): `affine-eval`, `affine-bench`, `affine-datagen`.

## Last reconciles

| when | action |
|---|---|
| 2026-08-11T08:21Z | p1993: fleet=1 · killed orphan R2ah EngCore/workers · R2ai chall relaunch pid299985 · burn$64/h · bal~$122573 |
| 2026-08-11T08:18Z | p1992: fleet=1 · R2ag REFUTE −0.52× · R2ah/R2z SKIP board 0.21× · R2ai sbs armed · burn$64/h · bal~$122573 |
| 2026-08-11T08:01Z | p1991: fleet=1 · R2ah pure-v9 armed after R2ag · R2ag ~49/49 · burn$64/h · bal~$122618 |
