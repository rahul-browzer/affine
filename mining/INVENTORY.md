# INVENTORY — live mine-* pods

**Cap: 40 lines.** Live table + last 3 reconciles. Older → `archive/`.

## Live

| name | huid | config | $/h | TTL | role |
|---|---|---|---|---|---|
| mine-crown-1 | lunar-orbit-50 (`1c4255fa-…`) | 8×B300 | $64.00 | 2026-08-11T16:12Z | TK@65536 · **R2p n80~47/80** · google ~46GiB · pig-after-google · watches 468–471 · R2p Stage-5 |

SSH: `ssh root@86.38.182.50 -p 40300`

Non-mine (do not touch): `affine-eval`, `affine-bench`, `affine-datagen`.

## Last reconciles

| when | action |
|---|---|
| 2026-08-11T05:55Z | p1972: fleet=1 · R2p~47/80 · armed Reason watches 468–471 + R2p Stage-5 · google~46GiB · burn$64/h · bal~$122897 |
| 2026-08-11T05:52Z | p1971: fleet=1 · R2p~43/80 · sky DONE · google RUNNING · **armed pig-after-google** chal471 · burn$64/h · bal~$122897 |
| 2026-08-11T05:50Z | p1970: fleet=1 · R2p~35/80 · sbs DONE · sky RUNNING · **armed google-after-sky** chal470 · burn$64/h · bal~$122908 |
