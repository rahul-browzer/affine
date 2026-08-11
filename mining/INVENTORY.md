# INVENTORY — live mine-* pods

**Cap: 40 lines.** Live table + last 3 reconciles. Older → `archive/`.

## Live

| name | huid | config | $/h | TTL | role |
|---|---|---|---|---|---|
| mine-crown-1 | lunar-orbit-50 (`1c4255fa-…`) | 8×B300 | $64.00 | 2026-08-11T16:12Z | TK@65536 · R2g n80 · R2i/441 · R2j/432 · R2k/431 · cp200 |

SSH: `ssh root@86.38.182.50 -p 40300`

Non-mine (do not touch): `affine-eval`, `affine-bench`, `affine-datagen`.

## Last reconciles

| when | action |
|---|---|
| 2026-08-11T00:46Z | p1922: fleet=1 · armed R2k Talent×BKN6 + watch-431 (152095/152117/152132); R2g~52/80; burn$64/h; bal~$123590 |
| 2026-08-11T00:42Z | p1921: fleet=1 · sth DONE; armed cp200 prefetch (150906); R2g~42/80; burn$64/h; bal~$123590 |
| 2026-08-11T00:37Z | p1920: fleet=1 · asdf+zeus DONE; sth~8GiB; R2g~36/80; armed R2j Talent×BKN7 (150140/150142); burn$64/h; bal~$123613 |
