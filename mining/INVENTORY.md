# INVENTORY — live mine-* pods

**Cap: 40 lines.** Live table + last 3 reconciles. Older → `archive/`.

## Live

| name | huid | config | $/h | TTL | role |
|---|---|---|---|---|---|
| mine-crown-1 | lunar-orbit-50 (`1c4255fa-…`) | 8×B300 | $64.00 | 2026-08-11T16:12Z | TK@65536 · R2g Talent×saysth merge · R2i/441 · BKN/432 |

SSH: `ssh root@86.38.182.50 -p 40300`

Non-mine (do not touch): `affine-eval`, `affine-bench`, `affine-datagen`.

## Last reconciles

| when | action |
|---|---|
| 2026-08-11T00:16Z | p1913: fleet=1 · freed ~398 GiB dead blends (disk 334→729 GiB); R2g merge ~7/16; chal-00432 BKN live; burn$64/h; bal~$123646 |
| 2026-08-11T00:13Z | p1912: fleet=1 · chal-00440 Reason hr0.73× → R2g gate ok · CPU merge running; burn$64/h; bal~$123657 |
| 2026-08-11T00:10Z | p1911: fleet=1 · R2h REFUTE hr−0.59×; BKN prefetch DONE; armed 432 watch 140530; burn$64/h; bal~$123657 |
