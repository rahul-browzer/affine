# INVENTORY — live mine-* pods

**Cap: 40 lines.** Live table + last 3 reconciles. Older → `archive/`.

## Live

| name | huid | config | $/h | TTL | role |
|---|---|---|---|---|---|
| mine-crown-1 | gentle-orbit-bd (`3d07e519-…`) | 8×B200 | $52.25 | 2026-08-12T08:42Z | **R2bj** n80 ~8/80 + **R9** train 6–7 |
| mine-r3-grpo-1 | golden-hawk-ff (`d55eec0f-…`) | 8×B300 | $64.00 | 2026-08-12T16:29Z | **R3b** train ~step62 |
| mine-r4-fullft-1 | noble-orbit-9d (`70f95aab-…`) | 8×B300 | $64.00 | remove 2026-08-12T20:57Z | **R6b** chall re-serve |
| *(pending fleet)* | mine-r7…r32 | 8×B300 | ~$64 | rent **2840405** POST-rent + boot **2756348** | R7–R8,R24–R32… |

SSH crown: `ssh root@95.133.253.90 -p 40099`
SSH R3/R3b: `ssh root@204.9.206.245 -p 40051`
SSH R4/R6b: `ssh root@86.38.182.50 -p 40307`
Host hist bridge: pid**2860424** (+chal-00517)

Non-mine (do not touch): `affine-eval`, `affine-bench`, `affine-datagen`.

## Last reconciles

| when | action |
|---|---|
| 2026-08-12T01:07Z | p2149: R6b merge.done + kill stale chall; R2bj n80~8/80; B300×8=0; burn **$180.25/h** |
| 2026-08-12T01:04Z | p2148: R2bj reload dead→relaunched chall loading; B300×8=0; burn **$180.25/h** |
| 2026-08-12T00:58Z | p2147: R2bi UNSERVABLE→R2bj saysth armed; B300×8=0; burn **$180.25/h** |
