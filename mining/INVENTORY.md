# INVENTORY — live mine-* pods

**Cap: 40 lines.** Live table + last 3 reconciles. Older → `archive/`.

## Live

| name | huid | config | $/h | TTL | role |
|---|---|---|---|---|---|
| mine-crown-1 | gentle-orbit-bd (`3d07e519-…`) | 8×B200 | $52.25 | 2026-08-12T08:42Z | TK ok; **R2be** hope12 armed |
| mine-r3-grpo-1 | golden-hawk-ff (`d55eec0f-…`) | 8×B300 | $64.00 | 2026-08-12T16:29Z | GRPO step≥167 + wedge |
| mine-r4-fullft-1 | noble-orbit-9d (`70f95aab-…`) | 8×B300 | $64.00 | ~24h from 20:57Z | **R4b** ~30/52 train |
| *(pending fleet)* | mine-r5…r32 | 8×B300 | ~$64 | rent **2471342** blind-fire + boot **2463724** | R5–R32 |

SSH crown: `ssh root@95.133.253.90 -p 40099`
SSH R3: `ssh root@204.9.206.245 -p 40051`
SSH R4: `ssh root@86.38.182.50 -p 40307`
Host R3 wedge: pid**2176107** `experiments/r3-reason-grpo/watch_r3_wedge.sh`
Host hist bridge: pid**2557085** (+chal-00508/511)

Non-mine (do not touch): `affine-eval`, `affine-bench`, `affine-datagen`.

## Last reconciles

| when | action |
|---|---|
| 2026-08-11T21:56Z | p2118: B300×8=0; R2bd UNSERVABLE→**R2be** hope12; burn **$180.25/h** |
| 2026-08-11T21:53Z | p2117: B300×8=0; R2bc UNSERVABLE (HF-id); **R2bd** armed; burn **$180.25/h** |
| 2026-08-11T21:44Z | p2116: B300×8=0; **R4 REFUTE**→**R4b** train; R2bc weight-fail; burn **$180.25/h** |
