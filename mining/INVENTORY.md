# INVENTORY — live mine-* pods

**Cap: 40 lines.** Live table + last 3 reconciles. Older → `archive/`.

## Live

| name | huid | config | $/h | TTL | role |
|---|---|---|---|---|---|
| mine-crown-1 | lunar-orbit-50 (`1c4255fa-…`) | 8×B300 | $64.00 | 2026-08-11T16:12Z | Reason crown / sim |

SSH: `ssh root@86.38.182.50 -p 40300`

Non-mine (do not touch): `affine-eval`, `affine-bench`, `affine-datagen`.

## Last reconciles

| when | action |
|---|---|
| 2026-08-10T16:13Z | p1847: `lium rm mine-watch-1 -y` (golden-wolf-bd); rented `mine-crown-1` on zesty-lion-98 UUID → lunar-orbit-50 8×B300 @$64/h TTL 24h |
| 2026-08-10 operator | Reason v3 reset: tear `mine-watch-1`, rent `mine-crown-1` 8×B300 |
