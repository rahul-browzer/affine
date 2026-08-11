# INVENTORY — live mine-* pods

**Cap: 40 lines.** Live table + last 3 reconciles. Older → `archive/`.

## Live

| name | huid | config | $/h | TTL | role |
|---|---|---|---|---|---|
| mine-crown-1 | lunar-orbit-50 (`1c4255fa-…`) | 8×B300 | $64.00 | 2026-08-11T16:12Z | TK@65536 · **R2v sft3 n80** · bridge→R2l · waiters |

SSH: `ssh root@86.38.182.50 -p 40300`

Non-mine (do not touch): `affine-eval`, `affine-bench`, `affine-datagen`.

## Last reconciles

| when | action |
|---|---|
| 2026-08-11T02:53Z | p1946: fleet=1 · **R2v~12/80** + **bridge_r2v_to_r2l** armed; burn$64/h; bal~$123300 |
| 2026-08-11T02:49Z | p1945: fleet=1 · **R2v n80 gathering** 1/80 engines 200/200/200; burn$64/h; bal~$123311 |
| 2026-08-11T02:43Z | p1944: fleet=1 · **R2v armed** pure sft3 chall reload; burn$64/h; bal~$123333 |
