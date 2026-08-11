# INVENTORY — live mine-* pods

**Cap: 40 lines.** Live table + last 3 reconciles. Older → `archive/`.

## Live

| name | huid | config | $/h | TTL | role |
|---|---|---|---|---|---|
| mine-crown-1 | lunar-orbit-50 (`1c4255fa-…`) | 8×B300 | $64.00 | 2026-08-11T16:12Z | TK@65536 · **R2q n80** + R2k…p + R2r |

SSH: `ssh root@86.38.182.50 -p 40300`

Non-mine (do not touch): `affine-eval`, `affine-bench`, `affine-datagen`.

## Last reconciles

| when | action |
|---|---|
| 2026-08-11T01:45Z | p1937: fleet=1 · R2s **WEAK_SKIP** Δ=1.53e-05 + purge 66G; R2q ~41/80; burn$64/h; bal~$123456 |
| 2026-08-11T01:39Z | p1936: fleet=1 · armed **R2s** saysth×awesome CPU premerge + n80 waiter; R2q ~22/80; purged R2g blend; burn$64/h; bal~$123467 |
| 2026-08-11T01:34Z | p1935: fleet=1 · R2i **SKIP_UNSERVABLE** 441 + purged thomp (−66G→539G free); R2q ~10/80; burn$64/h; bal~$123478 |
