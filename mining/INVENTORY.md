# INVENTORY — live mine-* pods

**Cap: 40 lines.** Live table + last 3 reconciles. Older → `archive/`.

## Live

| name | huid | config | $/h | TTL | role |
|---|---|---|---|---|---|
| mine-crown-1 | gentle-orbit-bd (`3d07e519-…`) | 8×B200 | $52.25 | 2026-08-12T08:42Z | **R2bg** cp1266 prefetch→n80 |
| mine-r3-grpo-1 | golden-hawk-ff (`d55eec0f-…`) | 8×B300 | $64.00 | 2026-08-12T16:29Z | **R3b** train ~step12 |
| mine-r4-fullft-1 | noble-orbit-9d (`70f95aab-…`) | 8×B300 | $64.00 | ~24h from 20:57Z | **R6** train~35/96 |
| *(pending fleet)* | mine-r7…r32 | 8×B300 | ~$64 | rent **2714756** B300×22 POLL=0 + boot **2463724** | R7–R32 |

SSH crown: `ssh root@95.133.253.90 -p 40099`
SSH R3/R3b: `ssh root@204.9.206.245 -p 40051`
SSH R4/R6: `ssh root@86.38.182.50 -p 40307`
Host hist bridge: pid**2733446** (+chal-00514)

Non-mine (do not touch): `affine-eval`, `affine-bench`, `affine-datagen`.

## Last reconciles

| when | action |
|---|---|
| 2026-08-11T23:28Z | p2133: R2bf REFUTE; arm R2bg cp1266; B300×8=0; fleet ×22 POLL=0; burn **$180.25/h** |
| 2026-08-11T23:19Z | p2132: B300×8=0; skip empty B200 fallback; fleet→**×22** POLL=0 pid2714756; burn **$180.25/h** |
| 2026-08-11T23:15Z | p2131: B300×8=0; fleet→**parallel×16** MAX_ITERS=86400 pid2708039; burn **$180.25/h** |
