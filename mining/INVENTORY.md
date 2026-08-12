# INVENTORY — live mine-* pods

**Cap: 40 lines.** Live table + last 3 reconciles. Older → `archive/`.

## Live

| name | huid | config | $/h | TTL | role |
|---|---|---|---|---|---|
| mine-crown-1 | gentle-orbit-bd (`3d07e519-…`) | 8×B200 | $52.25 | **2026-08-12T14:36Z** | R9 train + **R2bm** screen |
| mine-r3-grpo-1 | golden-hawk-ff (`d55eec0f-…`) | 8×B300 | $64.00 | 2026-08-12T16:29Z | **R3b** train; king ckp333 READY |
| mine-r4-fullft-1 | noble-orbit-9d (`70f95aab-…`) | 8×B300 | $64.00 | remove **2026-08-12T20:57Z** | **R11** Soft 19:57/Dead 20:27 |
| *(pending fleet)* | mine-r24…r32 | 8×B300 | ~$64 | rent POST + boot **2756348** | R24 first |

SSH crown: `ssh root@95.133.253.90 -p 40099`
SSH R3/R3b: `ssh root@204.9.206.245 -p 40051`
SSH R4/R11: `ssh root@86.38.182.50 -p 40307`
Host hist bridge: pid**3080195** (+chal-00521)

Non-mine (do not touch): `affine-eval`, `affine-bench`, `affine-datagen`.

## Last reconciles

| when | action |
|---|---|
| 2026-08-12T02:55Z | p2168: R2bm tttt-guass armed; B300×8=0; burn **$180.25/h** |
| 2026-08-12T02:52Z | p2167: R11 Soft/Dead→19:57/20:27; B300×8=0; burn **$180.25/h** |
| 2026-08-12T02:48Z | p2166: R2bl REFUTE; B300×8=0; burn **$180.25/h**; R9 unblocked |
