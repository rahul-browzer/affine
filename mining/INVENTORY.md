# INVENTORY — live mine-* pods

**Cap: 40 lines.** Live table + last 3 reconciles. Older → `archive/`.

## Live

| name | huid | config | $/h | TTL | role |
|---|---|---|---|---|---|
| mine-crown-1 | gentle-orbit-bd (`3d07e519-…`) | 8×B200 | $52.25 | 2026-08-12T08:42Z | R2bf n80 ~15/80 |
| mine-r3-grpo-1 | golden-hawk-ff (`d55eec0f-…`) | 8×B300 | $64.00 | 2026-08-12T16:29Z | R3 n80 ~79–80/80 |
| mine-r4-fullft-1 | noble-orbit-9d (`70f95aab-…`) | 8×B300 | $64.00 | ~24h from 20:57Z | **R6** train@16384 |
| *(pending fleet)* | mine-r7…r32 | 8×B300 | ~$64 | rent **2674606** blind-fire + boot **2463724** | R7–R32 |

SSH crown: `ssh root@95.133.253.90 -p 40099`
SSH R3: `ssh root@204.9.206.245 -p 40051`
SSH R4/R6: `ssh root@86.38.182.50 -p 40307`
Host hist bridge: pid**2557085** (+chal-00508/511)

Non-mine (do not touch): `affine-eval`, `affine-bench`, `affine-datagen`.

## Last reconciles

| when | action |
|---|---|
| 2026-08-11T22:59Z | p2126: B300×8=0; R5→R6 on r4 (max_len16384); fleet→R7; burn **$180.25/h** |
| 2026-08-11T22:56Z | p2125: B300×8=0; R3 PYTHONPATH+v2 sim→n80; R5 REFUTE; R2bf n80; burn **$180.25/h** |
| 2026-08-11T22:50Z | p2124: B300×8=0; R5 reseat `/tmp`@65536→n80; R2be below→R2bf; burn **$180.25/h** |
