# INVENTORY — live mine-* pods

**Cap: 40 lines.** Live table + last 3 reconciles. Older → `archive/`.

## Live

| name | huid | config | $/h | TTL | role |
|---|---|---|---|---|---|
| mine-crown-1 | gentle-orbit-bd (`3d07e519-…`) | 8×B200 | $52.25 | 2026-08-12T08:42Z | TK; R2be n80 + R2bf waiter |
| mine-r3-grpo-1 | golden-hawk-ff (`d55eec0f-…`) | 8×B300 | $64.00 | 2026-08-12T16:29Z | merge→`/tmp`→n80 |
| mine-r4-fullft-1 | noble-orbit-9d (`70f95aab-…`) | 8×B300 | $64.00 | ~24h from 20:57Z | **R5** Genesis full-FT |
| *(pending fleet)* | mine-r6…r32 | 8×B300 | ~$64 | rent **2597099** blind-fire + boot **2463724** | R6–R32 |

SSH crown: `ssh root@95.133.253.90 -p 40099`
SSH R3: `ssh root@204.9.206.245 -p 40051`
SSH R4/R5: `ssh root@86.38.182.50 -p 40307`
Host R3 wedge: pid**2176107** `experiments/r3-reason-grpo/watch_r3_wedge.sh`
Host hist bridge: pid**2557085** (+chal-00508/511)

Non-mine (do not touch): `affine-eval`, `affine-bench`, `affine-datagen`.

## Last reconciles

| when | action |
|---|---|
| 2026-08-11T22:36Z | p2122: B300×8=0; R3 merge unstick→`/tmp`; R2bf prefetch DONE; R5@22/26; burn **$180.25/h** |
| 2026-08-11T22:23Z | p2121: B300×8=0; **R2bf** dpo2 armed; R3 DONE→merge; R5 FT@5/26; burn **$180.25/h** |
| 2026-08-11T22:18Z | p2120: B300×8=0; **R4b REFUTE**→**R5** on r4; fleet→R6; burn **$180.25/h** |
