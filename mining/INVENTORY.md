# INVENTORY — live mine-* pods

**Cap: 40 lines.** Live table + last 3 reconciles. Older → `archive/`.

## Live

| name | huid | config | $/h | TTL | role |
|---|---|---|---|---|---|
| mine-crown-1 | lunar-orbit-50 (`1c4255fa-…`) | 8×B300 | $64.00 | 2026-08-11T16:12Z | TK+LoRA@65536 · n80 ~4–6/80 |

SSH: `ssh root@86.38.182.50 -p 40300`

Non-mine (do not touch): `affine-eval`, `affine-bench`, `affine-datagen`.

## Last reconciles

| when | action |
|---|---|
| 2026-08-10T17:39Z | p1862: fleet=1 · LoRA n80 alive chall4/king6 @65536; burn$64/h; bal~$124541 |
| 2026-08-10T17:35Z | p1861: fleet=1 · grafted 333 visual→chall reload (3/3 shards+cudagraph); burn$64/h |
| 2026-08-10T17:30Z | p1860: fleet=1 · train+merge done; TK 200@65536 FlashInfer-off; LoRA config fix+chall reload; burn$64/h |
