# INVENTORY — live mine-* pods

**Cap: 40 lines.** Live table + last 3 reconciles. Older → `archive/`.

## Live

| name | huid | config | $/h | TTL | role |
|---|---|---|---|---|---|
| mine-crown-1 | gentle-orbit-bd (`3d07e519-…`) | 8×B200 | $52.25 | 2026-08-12T08:42Z | **R2bb** n80 ~31/80 |
| mine-r3-grpo-1 | golden-hawk-ff (`d55eec0f-…`) | 8×B300 | $64.00 | 2026-08-12T16:29Z | GRPO step≥119 + TK + wedge-watch |
| mine-r4-fullft-1 | noble-orbit-9d (`70f95aab-…`) | 8×B300 | $64.00 | ~24h from 20:57Z | **R4** full-FT train pid2488 |
| *(pending fleet)* | mine-r5…r32 | 8×B300 | ~$64 | rent **2458663** @3s + boot **2458664** | R5–R32 |

SSH crown: `ssh root@95.133.253.90 -p 40099`
SSH R3: `ssh root@204.9.206.245 -p 40051`
SSH R4: `ssh root@86.38.182.50 -p 40307`
Host R3 wedge: pid**2176107** `experiments/r3-reason-grpo/watch_r3_wedge.sh`

Non-mine (do not touch): `affine-eval`, `affine-bench`, `affine-datagen`.

## Last reconciles

| when | action |
|---|---|
| 2026-08-11T21:05Z | p2109: B300×8=0; fleet rent→**3s** (pids **2458663/2458664**); R4 TRAIN started; R2bb~31/80; R3≥119; burn **$180.25/h** |
| 2026-08-11T20:59Z | p2108: **RENTED** mine-r4-fullft-1 8×B300 + bootstrapped; R32 KL armed; rent/boot **2448500/2448503**; R2bb~20/80; R3≥115; burn **$180.25/h** |
| 2026-08-11T20:54Z | p2107: R31 NoDrop armed+queue; rent/boot **2436070/2436073**; R2bb~7/80; R3≥110; B300×8=0; burn $116.25/h |
