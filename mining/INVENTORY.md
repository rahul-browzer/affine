# INVENTORY — live mine-* pods

**Cap: 40 lines.** Live table + last 3 reconciles. Older → `archive/`.

## Live

| name | huid | config | $/h | TTL | role |
|---|---|---|---|---|---|
| mine-crown-1 | gentle-orbit-bd (`3d07e519-…`) | 8×B200 | $52.25 | 2026-08-12T08:42Z | **R2bb** n80 pid199154 (~7/80) |
| mine-r3-grpo-1 | golden-hawk-ff (`d55eec0f-…`) | 8×B300 | $64.00 | 2026-08-12T16:29Z | GRPO step≥110 + TK + wedge-watch |
| *(pending fleet)* | mine-r4…r31 | 8×B300 | ~$64 | rent pid**2436070** + boot pid**2436073** | R4–R31 auto-boot (R31 NoDrop after R30) |

SSH crown: `ssh root@95.133.253.90 -p 40099`
SSH R3: `ssh root@204.9.206.245 -p 40051`
Host R3 wedge: pid**2176107** `experiments/r3-reason-grpo/watch_r3_wedge.sh`

Non-mine (do not touch): `affine-eval`, `affine-bench`, `affine-datagen`.

## Last reconciles

| when | action |
|---|---|
| 2026-08-11T20:54Z | p2107: R31 NoDrop armed+queue; rent/boot **2436070/2436073**; R2bb~7/80; R3≥110; B300×8=0; burn $116.25/h |
| 2026-08-11T20:51Z | p2106: R2bb chall remat+relaunch (incomplete snap race) → n80; R3≥108; rent/boot **2422351/2422369**; B300×8=0; burn $116.25/h |
| 2026-08-11T20:45Z | p2105: R30 HiAlpha armed+queue; rent/boot **2422351/2422369**; R2bb chall loading; R3≥103; B300×8=0; burn $116.25/h |
