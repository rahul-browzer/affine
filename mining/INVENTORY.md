# INVENTORY — live mine-* pods

**Cap: 40 lines.** Live table + last 3 reconciles. Older → `archive/`.

## Live

| name | huid | config | $/h | TTL | role |
|---|---|---|---|---|---|
| mine-crown-1 | gentle-orbit-bd (`3d07e519-…`) | 8×B200 | $52.25 | **2026-08-13T02:35Z** | **R16** chall→n80 |
| mine-r3-grpo-1 | golden-hawk-ff (`d55eec0f-…`) | 8×B300 | $64.00 | **2026-08-12T16:29Z** | **R15** pandora-REINFORCE |
| mine-r4-fullft-1 | noble-orbit-9d (`70f95aab-…`) | 8×B300 | $64.00 | remove **2026-08-12T20:57Z** | **R20** kevin-GRPO |
| *(pending fleet)* | mine-r24…r32 + R5b/R10/R17… | 8×B300 | ~$64 | rent POST + boot **2756348** | R24 first |

SSH crown/R16: `ssh root@95.133.253.90 -p 40099`
SSH R3/R15: `ssh root@204.9.206.245 -p 40051`
SSH R4/R20: `ssh root@86.38.182.50 -p 40307`
Host hist bridge: pid**3174953** (+chal-00525)
Host fleet-rent: pid**3373328** (STOP; CONT after burst_p2194)
Host burst: pid**3400683**

Non-mine (do not touch): `affine-eval`, `affine-bench`, `affine-datagen`.

## Last reconciles

| when | action |
|---|---|
| 2026-08-12T06:44Z | p2195: 8×=0; R16 merge+HF DONE chall loading; purged 9 REFUTED HF (~634 GiB); burn **$180.25/h** |
| 2026-08-12T06:39Z | p2194: R14 REFUTE→R20 warm-arm R4; R16 merge relaunch; 1500-iter burst; burn **$180.25/h** |
| 2026-08-12T06:34Z | p2193: 1200-iter R24 burst empty; waiter CONT **3373328**; burn **$180.25/h** |
