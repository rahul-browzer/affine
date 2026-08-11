# INVENTORY — live mine-* pods

**Cap: 40 lines.** Live table + last 3 reconciles. Older → `archive/`.

## Live

| name | huid | config | $/h | TTL | role |
|---|---|---|---|---|---|
| mine-crown-1 | gentle-orbit-bd (`3d07e519-…`) | 8×B200 | $52.25 | 2026-08-12T08:42Z | **R2bb** ckp333 chall load (200/200/000) |
| mine-r3-grpo-1 | golden-hawk-ff (`d55eec0f-…`) | 8×B300 | $64.00 | 2026-08-12T16:29Z | GRPO pid28660 step≥103 + TK + wedge-watch |
| *(pending fleet)* | mine-r4…r30 | 8×B300 | ~$64 | rent pid**2422351** + boot pid**2422369** | R4–R30 auto-boot (R30 HiAlpha after R29) |

SSH crown: `ssh root@95.133.253.90 -p 40099`
SSH R3: `ssh root@204.9.206.245 -p 40051`
Host R3 wedge: pid**2176107** `experiments/r3-reason-grpo/watch_r3_wedge.sh`

Non-mine (do not touch): `affine-eval`, `affine-bench`, `affine-datagen`.

## Last reconciles

| when | action |
|---|---|
| 2026-08-11T20:45Z | p2105: R30 HiAlpha armed+queue; rent/boot **2422351/2422369**; R2bb chall loading; R3≥103; B300×8=0; burn $116.25/h |
| 2026-08-11T20:42Z | p2104: R29 HiRank armed+queue; rent/boot **2416934/2417447**; R2bb chall loading; R3≥100; B300×8=0; burn $116.25/h |
| 2026-08-11T20:39Z | p2103: R2bb ckp333 armed (prefetch/reload/stage5); rent/boot **2413743/2413756**; R3≥98; B300×8=0; burn $116.25/h |
