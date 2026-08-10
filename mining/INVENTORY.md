# INVENTORY — live mine-* pods

**Cap: 40 lines.** Live table + last 3 reconciles. Older → `archive/`.

## Live

| name | huid | config | $/h | TTL | role |
|---|---|---|---|---|---|
| mine-crown-1 | lunar-orbit-50 (`1c4255fa-…`) | 8×B300 | $64.00 | 2026-08-11T16:12Z | TK@65536 · R1b+R1c · R2 α-merge+α n80 |

SSH: `ssh root@86.38.182.50 -p 40300`

Non-mine (do not touch): `affine-eval`, `affine-bench`, `affine-datagen`.

## Last reconciles

| when | action |
|---|---|
| 2026-08-10T18:45Z | p1875: fleet=1 · R2 prefetch DONE; α-merge shard1 written; fixed premerge meta stamp; R1b~48/126; burn$64/h; bal~$124395 |
| 2026-08-10T18:41Z | p1874: fleet=1 · armed R2 CPU premerge pid85406 + relaunched α waiter pid85408; R1b~42/126; kevin~28G; burn$64/h; bal~$124407 |
| 2026-08-10T18:38Z | p1873: fleet=1 · staged+armed R2 α-merge waiter pid84752; R1b~37/126; TalentPigs~66G; burn$64/h; bal~$124407 |
