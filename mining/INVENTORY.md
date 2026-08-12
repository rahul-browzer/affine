# INVENTORY — live mine-* pods

**Cap: 40 lines.** Live table + last 3 reconciles. Older → `archive/`.

## Live

| name | huid | config | $/h | TTL | role |
|---|---|---|---|---|---|
| mine-crown-1 | gentle-orbit-bd (`3d07e519-…`) | 8×B200 | $52.25 | **2026-08-13T02:35Z** | warm TKC; R17 REFUTE |
| mine-r3-grpo-1 | golden-hawk-ff (`d55eec0f-…`) | 8×B300 | $64.00 | **2026-08-13T04:29Z** | **R24** + guass retarget |
| mine-r4-fullft-1 | noble-orbit-9d (`70f95aab-…`) | 8×B300 | $64.00 | **2026-08-13T08:57Z** | **R20** chall→n80 |
| *(pending fleet)* | mine-r25…r32 + R5b/R18… | 8×B300 | ~$64 | burst **3557663** | R25 first |

SSH crown/R17: `ssh root@95.133.253.90 -p 40099`
SSH R3/R24: `ssh root@204.9.206.245 -p 40051`
SSH R4/R20: `ssh root@86.38.182.50 -p 40307`
Host hist bridge: pid**3174953** (pending chal-00525)
Host fleet-rent: pid**3373328** (**SIGSTOP**; CONT after burst)
Host fleet-burst: pid**3557663** (p2205 SKIP_PID_LOCK 3000)
Host fleet-boot: pid**2756348**

Non-mine (do not touch): `affine-eval`, `affine-bench`, `affine-datagen`.

## Last reconciles

| when | action |
|---|---|
| 2026-08-12T08:43Z | p2210: 8×=0; R17 REFUTE vs guass; R20 train DONE chall loading; burn **$180.25/h** |
| 2026-08-12T08:40Z | p2209: 8×=0; R4 guass DONE; R17 n80 relaunch vs guass **352823**; burn **$180.25/h** |
| 2026-08-12T08:29Z | p2208: 8×=0; R3 guass prefetch+retarget **89518**; burn **$180.25/h** |
