# INVENTORY — live mine-* pods

**Cap: 40 lines.** Live table + last 3 reconciles. Older → `archive/`.

## Live

| name | huid | config | $/h | TTL | role |
|---|---|---|---|---|---|
| mine-crown-1 | gentle-orbit-bd (`3d07e519-…`) | 8×B200 | $52.25 | 2026-08-12T08:42Z | **R2bc** ec08 chall loading |
| mine-r3-grpo-1 | golden-hawk-ff (`d55eec0f-…`) | 8×B300 | $64.00 | 2026-08-12T16:29Z | GRPO step≥151 + TK + wedge-watch |
| mine-r4-fullft-1 | noble-orbit-9d (`70f95aab-…`) | 8×B300 | $64.00 | ~24h from 20:57Z | **n80 ~24/80** gathering |
| *(pending fleet)* | mine-r5…r32 | 8×B300 | ~$64 | rent **2471342** blind-fire + boot **2463724** | R5–R32 |

SSH crown: `ssh root@95.133.253.90 -p 40099`
SSH R3: `ssh root@204.9.206.245 -p 40051`
SSH R4: `ssh root@86.38.182.50 -p 40307`
Host R3 wedge: pid**2176107** `experiments/r3-reason-grpo/watch_r3_wedge.sh`

Non-mine (do not touch): `affine-eval`, `affine-bench`, `affine-datagen`.

## Last reconciles

| when | action |
|---|---|
| 2026-08-11T21:36Z | p2115: B300×8=0; **R4 n80 unblocked** (pyarrow+corpus v2+served id) ~24/80; R3≥151; burn **$180.25/h** |
| 2026-08-11T21:29Z | p2114: B300×8=0; **R2bc** armed (ec08); R4 TKC 200×3; R3≥141; burn **$180.25/h** |
| 2026-08-11T21:24Z | p2113: B300×8=0; R4 chall 32768→**65536** + n80 armed; R3≥135; burn **$180.25/h** |
