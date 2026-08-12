# INVENTORY — live mine-* pods

**Cap: 40 lines.** Live table + last 3 reconciles. Older → `archive/`.

## Live

| name | huid | config | $/h | TTL | role |
|---|---|---|---|---|---|
| mine-crown-1 | gentle-orbit-bd (`3d07e519-…`) | 8×B200 | $52.25 | **2026-08-13T02:35Z** | **R2bn** n80 + R9 (post R2bn-gated) |
| mine-r3-grpo-1 | golden-hawk-ff (`d55eec0f-…`) | 8×B300 | $64.00 | 2026-08-12T16:29Z | **R3b** GRPO |
| mine-r4-fullft-1 | noble-orbit-9d (`70f95aab-…`) | 8×B300 | $64.00 | remove **2026-08-12T20:57Z** | **R12** BoN |
| *(pending fleet)* | mine-r24…r32 + R5b/R10/R13… | 8×B300 | ~$64 | rent POST + boot **2756348** | R24 first |

SSH crown: `ssh root@95.133.253.90 -p 40099`
SSH R3/R3b: `ssh root@204.9.206.245 -p 40051`
SSH R4/R12: `ssh root@86.38.182.50 -p 40307`
Host hist bridge: pid**3174953** (+chal-00525)

Non-mine (do not touch): `affine-eval`, `affine-bench`, `affine-datagen`.

## Last reconciles

| when | action |
|---|---|
| 2026-08-12T04:00Z | p2182: crown TTL+12h→02:35Z; R24 burst empty; burn **$180.25/h** |
| 2026-08-12T03:54Z | p2181: R9 post +R2bn gate; B300×8=0; burn **$180.25/h** |
| 2026-08-12T03:52Z | p2180: R2bn alloy chall+n80 armed; B300×8=0; burn **$180.25/h** |
