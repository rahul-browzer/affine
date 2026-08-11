# INVENTORY — live mine-* pods

**Cap: 40 lines.** Live table + last 3 reconciles. Older → `archive/`.

## Live

| name | huid | config | $/h | TTL | role |
|---|---|---|---|---|---|
| mine-crown-1 | gentle-orbit-bd (`3d07e519-…`) | 8×B200 | $52.25 | 2026-08-12T08:42Z | **R2bb** ckp333 prefetch/reload pids 191709/191710 |
| mine-r3-grpo-1 | golden-hawk-ff (`d55eec0f-…`) | 8×B300 | $64.00 | 2026-08-12T16:29Z | GRPO pid28660 step≥98 + TK + wedge-watch |
| *(pending fleet)* | mine-r4…r28 | 8×B300 | ~$64 | rent pid**2413743** + boot pid**2413756** | R4–R28 auto-boot (R28 HiLR after R27) |

SSH crown: `ssh root@95.133.253.90 -p 40099`
SSH R3: `ssh root@204.9.206.245 -p 40051`
Host R3 wedge: pid**2176107** `experiments/r3-reason-grpo/watch_r3_wedge.sh`

Non-mine (do not touch): `affine-eval`, `affine-bench`, `affine-datagen`.

## Last reconciles

| when | action |
|---|---|
| 2026-08-11T20:39Z | p2103: R2bb ckp333 armed (prefetch/reload/stage5); rent/boot **2413743/2413756**; R3≥98; B300×8=0; burn $116.25/h |
| 2026-08-11T20:35Z | p2102: R2ba WEAK m=+0.007; R28 HiLR uploader+fleet-boot; rent/boot pids **2406489/2406492**; R3≥93; B300×8=0; burn $116.25/h |
| 2026-08-11T20:30Z | p2101: R27 BigG-GRPO (G=16) uploader+fleet-boot; poll 10s; rent/boot pids **2397672/2397693**; R2ba ~67/80; R3≥90; B300×8=0; burn $116.25/h |
