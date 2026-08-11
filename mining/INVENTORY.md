# INVENTORY — live mine-* pods

**Cap: 40 lines.** Live table + last 3 reconciles. Older → `archive/`.

## Live

| name | huid | config | $/h | TTL | role |
|---|---|---|---|---|---|
| mine-crown-1 | gentle-orbit-bd (`3d07e519-…`) | 8×B200 | $52.25 | 2026-08-12T08:42Z | R2at hope11 n80 ~15/80 |
| mine-r3-grpo-1 | golden-hawk-ff (`d55eec0f-…`) | 8×B300 | $64.00 | 2026-08-12T16:29Z | R3 GRPO — bootstrap next |

SSH crown: `ssh root@95.133.253.90 -p 40099`
SSH R3: `ssh root@204.9.206.245 -p 40051`

Non-mine (do not touch): `affine-eval`, `affine-bench`, `affine-datagen`.

## Last reconciles

| when | action |
|---|---|
| 2026-08-11T16:30Z | p2054: rented last 8×B300 → `mine-r3-grpo-1`; burn $116.25/h; B300 left=0 |
| 2026-08-11T16:25Z | p2052: R2at engines 200/200/200; n80 ~4/80; burn$52.25/h · bal~$121579 |
| 2026-08-11T16:17Z | p2051: R2as WEAK_SKIP 0.060×; R2at hope11 loading :8002; burn$52.25/h |
