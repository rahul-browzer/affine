# INVENTORY — live mine-* pods

**Cap: 40 lines.** Live table + last 3 reconciles. Older → `archive/`.

## Live

| name | huid | config | $/h | TTL | role |
|---|---|---|---|---|---|
| mine-crown-1 | lunar-orbit-50 (`1c4255fa-…`) | 8×B300 | $64.00 | 2026-08-11T16:12Z | 200/200/200 · H64 n80 + R1 train + merge waiter |

SSH: `ssh root@86.38.182.50 -p 40300`

Non-mine (do not touch): `affine-eval`, `affine-bench`, `affine-datagen`.

## Last reconciles

| when | action |
|---|---|
| 2026-08-10T16:51Z | p1858: fleet=1 mine-* · armed merge→reload→LoRA-n80 waiter pid24147; train 5/66; n80~34/80; burn$64/h |
| 2026-08-10T16:49Z | p1857: fleet=1 mine-* · launched R1 LoRA train pid23282; n80 ~30/80; burn$64/h |
| 2026-08-10T16:47Z | p1856: fleet=1 mine-* · n80 ~30/80 + sft_high_reason 1403 + peft; burn$64/h |
