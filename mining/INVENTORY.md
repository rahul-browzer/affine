# INVENTORY — live mine-* pods

**Cap: 40 lines.** Live table + last 3 reconciles. Older → `archive/`.

## Live

| name | huid | config | $/h | TTL | role |
|---|---|---|---|---|---|
| mine-crown-1 | gentle-orbit-bd (`3d07e519-…`) | 8×B200 | $52.25 | 2026-08-12T08:42Z | **R2bb DONE** → arm R2bc |
| mine-r3-grpo-1 | golden-hawk-ff (`d55eec0f-…`) | 8×B300 | $64.00 | 2026-08-12T16:29Z | GRPO step≥135 + TK + wedge-watch |
| mine-r4-fullft-1 | noble-orbit-9d (`70f95aab-…`) | 8×B300 | $64.00 | ~24h from 20:57Z | **R4** chall@65536 + n80 armed |
| *(pending fleet)* | mine-r5…r32 | 8×B300 | ~$64 | rent **2471342** blind-fire + boot **2463724** | R5–R32 |

SSH crown: `ssh root@95.133.253.90 -p 40099`
SSH R3: `ssh root@204.9.206.245 -p 40051`
SSH R4: `ssh root@86.38.182.50 -p 40307`
Host R3 wedge: pid**2176107** `experiments/r3-reason-grpo/watch_r3_wedge.sh`

Non-mine (do not touch): `affine-eval`, `affine-bench`, `affine-datagen`.

## Last reconciles

| when | action |
|---|---|
| 2026-08-11T21:24Z | p2113: B300×8=0; R4 chall 32768→**65536** + n80 armed; R3≥135; burn **$180.25/h** |
| 2026-08-11T21:20Z | p2112: B300×8=0; R4 gocryptfs salvage→finalize+serve; R2bb m=+0.013 z=2.50 WEAK; R3≥133; burn **$180.25/h** |
| 2026-08-11T21:14Z | p2111: B300×8=0; fleet→**blind-fire** POLL=0 (pid **2471342**); 90s R5 burst 41 miss; R4 26/26 writing; R2bb~60/80; R3≥129; burn **$180.25/h** |
