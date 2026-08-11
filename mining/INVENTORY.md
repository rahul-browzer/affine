# INVENTORY — live mine-* pods

**Cap: 40 lines.** Live table + last 3 reconciles. Older → `archive/`.

## Live

| name | huid | config | $/h | TTL | role |
|---|---|---|---|---|---|
| mine-crown-1 | lunar-orbit-50 (`1c4255fa-…`) | 8×B300 | $64.00 | 2026-08-11T16:12Z | TK@65536 · R2g reload→n80 · R2i/441 · BKN/432 · prefetch BKN6 |

SSH: `ssh root@86.38.182.50 -p 40300`

Non-mine (do not touch): `affine-eval`, `affine-bench`, `affine-datagen`.

## Last reconciles

| when | action |
|---|---|
| 2026-08-11T00:21Z | p1915: fleet=1 · R2g merge DONE (Δ0.626) + chall reload pid142866; BKN6 ~48GiB; burn$64/h; bal~$123635 |
| 2026-08-11T00:18Z | p1914: fleet=1 · armed BKN-six prefetch (chal-00431); R2g ~11/16; burn$64/h; bal~$123646 |
| 2026-08-11T00:16Z | p1913: fleet=1 · freed ~398 GiB dead blends (disk 334→729 GiB); R2g merge ~7/16; chal-00432 BKN live; burn$64/h; bal~$123646 |
