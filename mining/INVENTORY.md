# INVENTORY — live mine-* pods

**Cap: 40 lines.** Live table + last 3 reconciles. Older → `archive/`.

## Live

| name | huid | config | $/h | TTL | role |
|---|---|---|---|---|---|
| mine-crown-1 | gentle-orbit-bd (`3d07e519-…`) | 8×B200 | $52.25 | 2026-08-12T08:42Z | R2at hope11 n80 ~33/80 |
| mine-r3-grpo-1 | golden-hawk-ff (`d55eec0f-…`) | 8×B300 | $64.00 | 2026-08-12T16:29Z | R3 pip+parallel_dl |

SSH crown: `ssh root@95.133.253.90 -p 40099`
SSH R3: `ssh root@204.9.206.245 -p 40051`

Non-mine (do not touch): `affine-eval`, `affine-bench`, `affine-datagen`.

## Last reconciles

| when | action |
|---|---|
| 2026-08-11T16:37Z | p2056: R3 parallel_dl tok+teacher mid-pip; burn $116.25/h; B300×8=0 |
| 2026-08-11T16:34Z | p2055: uploaded+launched R3 bootstrap on golden-hawk-ff; burn $116.25/h; B300×8=0 |
| 2026-08-11T16:30Z | p2054: rented last 8×B300 → `mine-r3-grpo-1`; burn $116.25/h; B300 left=0 |
