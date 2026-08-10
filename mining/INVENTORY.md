# INVENTORY — live mine-* pods

**Cap: 40 lines.** Live table + last 3 reconciles. Older → `archive/`.

## Live

| name | huid | config | $/h | TTL | role |
|---|---|---|---|---|---|
| mine-crown-1 | lunar-orbit-50 (`1c4255fa-…`) | 8×B300 | $64.00 | 2026-08-11T16:12Z | warm-stack restore → Reason sim |

SSH: `ssh root@86.38.182.50 -p 40300`

Non-mine (do not touch): `affine-eval`, `affine-bench`, `affine-datagen`.

## Last reconciles

| when | action |
|---|---|
| 2026-08-10T16:15Z | p1848: fleet=1 mine-* · uploaded warm-stack + launched restore pid1305 (DL in flight) |
| 2026-08-10T16:13Z | p1847: `lium rm mine-watch-1 -y`; rented `mine-crown-1` lunar-orbit-50 8×B300 @$64/h TTL24h |
| 2026-08-10 operator | Reason v3 reset: tear watch, rent crown 8×B300 |
