# INVENTORY — live mine-* pods

**Cap: 40 lines.** Live table + last 3 reconciles. Older → `archive/`.

## Live

| name | huid | config | $/h | TTL | role |
|---|---|---|---|---|---|
| mine-crown-1 | lunar-orbit-50 (`1c4255fa-…`) | 8×B300 | $64.00 | 2026-08-11T16:12Z | TK@65536 · R2aa–ac eager DONE · **R2ad Talent×pig eager RUNNING** · watches 462/463/467–471 |

SSH: `ssh root@86.38.182.50 -p 40300`

Non-mine (do not touch): `affine-eval`, `affine-bench`, `affine-datagen`.

## Last reconciles

| when | action |
|---|---|
| 2026-08-11T06:19Z | p1977: fleet=1 · R2ac eager DONE Δ0.626 · **armed R2ad Talent×pig** (pids 256029/256030) · disk~115 GiB · burn$64/h · bal~$122841 |
| 2026-08-11T06:14Z | p1976: fleet=1 · R2ab eager DONE Δ0.626 · **armed R2ac Talent×google** (pids 254948/254949) · disk~172 GiB · burn$64/h · bal~$122853 |
| 2026-08-11T06:09Z | p1975: fleet=1 · **R2p REFUTE hr−0.93×** · Stage-5 SKIP · kill chall · purge sth ~66GiB · R2aa eager DONE · R2ab~13/16 · burn$64/h · bal~$122864 |
