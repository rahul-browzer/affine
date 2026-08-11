# INVENTORY — live mine-* pods

**Cap: 40 lines.** Live table + last 3 reconciles. Older → `archive/`.

## Live

| name | huid | config | $/h | TTL | role |
|---|---|---|---|---|---|
| mine-crown-1 | lunar-orbit-50 (`1c4255fa-…`) | 8×B300 | $64.00 | 2026-08-11T16:12Z | TK@65536 · R2g n80 · R2i/441 · R2j/432 · sth |

SSH: `ssh root@86.38.182.50 -p 40300`

Non-mine (do not touch): `affine-eval`, `affine-bench`, `affine-datagen`.

## Last reconciles

| when | action |
|---|---|
| 2026-08-11T00:37Z | p1920: fleet=1 · asdf+zeus DONE; sth~8GiB; R2g~36/80; armed R2j Talent×BKN7 (150140/150142); burn$64/h; bal~$123613 |
| 2026-08-11T00:30Z | p1919: fleet=1 · R2g ~16/80; sft3 DONE; asdf~27GiB; armed sth after zeus (@8d81e782…); burn$64/h; bal~$123624 |
| 2026-08-11T00:28Z | p1918: fleet=1 · R2g ~12/80; armed zeus after asdf (@accc9249…); burn$64/h; bal~$123624 |
