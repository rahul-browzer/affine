# INVENTORY — live mine-* pods

**Cap: 40 lines.** Live table + last 3 reconciles. Older → `archive/`.

## Live

| name | huid | config | $/h | TTL | role |
|---|---|---|---|---|---|
| mine-crown-1 | lunar-orbit-50 (`1c4255fa-…`) | 8×B300 | $64.00 | 2026-08-11T16:12Z | TK@65536 · R2g n80 · R2i/441 · R2j/432 · R2k/431 · R2l/450 · R2m/456 |

SSH: `ssh root@86.38.182.50 -p 40300`

Non-mine (do not touch): `affine-eval`, `affine-bench`, `affine-datagen`.

## Last reconciles

| when | action |
|---|---|
| 2026-08-11T00:52Z | p1924: fleet=1 · armed R2m Talent×cp200 + watch-456 (153317/153337/153346); R2g~70/80; burn$64/h; bal~$123568 |
| 2026-08-11T00:49Z | p1923: fleet=1 · armed R2l Talent×sft3 + watch-450 (152829/152852/152866); R2g~63/80; cp200 DONE; burn$64/h; bal~$123579 |
| 2026-08-11T00:46Z | p1922: fleet=1 · armed R2k Talent×BKN6 + watch-431 (152095/152117/152132); R2g~52/80; burn$64/h; bal~$123590 |
