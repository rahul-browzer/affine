# INVENTORY — live mine-* pods

**Cap: 40 lines.** Live table + last 3 reconciles. Older → `archive/`.

## Live

| name | huid | config | $/h | TTL | role |
|---|---|---|---|---|---|
| mine-crown-1 | lunar-orbit-50 (`1c4255fa-…`) | 8×B300 | $64.00 | 2026-08-11T16:12Z | engines→65536 · R1 train + merge→LoRA-n80 |

SSH: `ssh root@86.38.182.50 -p 40300`

Non-mine (do not touch): `affine-eval`, `affine-bench`, `affine-datagen`.

## Last reconciles

| when | action |
|---|---|
| 2026-08-10T17:02Z | p1859: fleet=1 mine-* · H64 CRASH ctx32768→relaunch engines@65536; train~42/66; burn$64/h |
| 2026-08-10T16:51Z | p1858: fleet=1 mine-* · armed merge→reload→LoRA-n80 waiter pid24147; train 5/66; n80~34/80; burn$64/h |
| 2026-08-10T16:49Z | p1857: fleet=1 mine-* · launched R1 LoRA train pid23282; n80 ~30/80; burn$64/h |
