# INVENTORY — live mine-* pods

**Cap: 40 lines.** Live table + last 3 reconciles. Older → `archive/`.

## Live

| name | huid | config | $/h | TTL | role |
|---|---|---|---|---|---|
| mine-crown-1 | gentle-orbit-bd (`3d07e519-…`) | 8×B200 | $52.25 | 2026-08-12T08:42Z | R2az REFUTE; **R2ba** awesome-v10 n80 ~30/80 |
| mine-r3-grpo-1 | golden-hawk-ff (`d55eec0f-…`) | 8×B300 | $64.00 | 2026-08-12T16:29Z | GRPO pid28660 step≥75 + TK + wedge-watch |
| *(pending fleet)* | mine-r4…r22 | 8×B300 | ~$64 | rent pid**2358190** + boot pid**2358204** | R4–R22 auto-boot (target 25) |

SSH crown: `ssh root@95.133.253.90 -p 40099`
SSH R3: `ssh root@204.9.206.245 -p 40051`
Host R3 wedge: pid**2176107** `experiments/r3-reason-grpo/watch_r3_wedge.sh`

Non-mine (do not touch): `affine-eval`, `affine-bench`, `affine-datagen`.

## Last reconciles

| when | action |
|---|---|
| 2026-08-11T20:14Z | p2096: R22 golden-GRPO uploader+fleet-boot; rent/boot pids **2358190/2358204**; R2ba ~30/80; R3≥75; B300×8=0; burn $116.25/h |
| 2026-08-11T20:10Z | p2095: R21 pandora-GRPO uploader+fleet-boot; rent/boot pids **2344642/2344658**; R2ba ~20/80; R3≥72; B300×8=0; burn $116.25/h |
| 2026-08-11T20:07Z | p2094: R20 kevin-GRPO uploader+fleet-boot; rent/boot pids **2337108/2337122**; R2ba ~12/80; R3≥68; B300×8=0; burn $116.25/h |
