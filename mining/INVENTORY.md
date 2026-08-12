# INVENTORY — live mine-* pods

**Cap: 40 lines.** Live table + last 3 reconciles. Older → `archive/`.

## Live

| name | huid | config | $/h | TTL | role |
|---|---|---|---|---|---|
| mine-crown-1 | gentle-orbit-bd (`3d07e519-…`) | 8×B200 | $52.25 | **2026-08-13T02:35Z** | **R26** LoTemp + guass |
| mine-r3-grpo-1 | golden-hawk-ff (`d55eec0f-…`) | 8×B300 | $64.00 | **2026-08-13T04:29Z** | **R24** + guass + tmax + n80-gate |
| mine-r4-fullft-1 | noble-orbit-9d (`70f95aab-…`) | 8×B300 | $64.00 | **2026-08-13T08:57Z** | **R21** pandora-GRPO |
| mine-r25-hitemp-1 | zesty-fox-bc (`20498068-…`) | 8×B200 | $40.00 | **2026-08-13T08:46Z** | **R25** + guass |
| *(pending fleet)* | mine-r10… then R18/R5b/R19… | 8×B300 | ~$64 | burst **3735496** | **R10 next** |

SSH crown/R26: `ssh root@95.133.253.90 -p 40099`
SSH R3/R24: `ssh root@204.9.206.245 -p 40051`
SSH R4/R21: `ssh root@86.38.182.50 -p 40307`
SSH R25: `ssh root@150.136.71.147 -p 20309`
Host fleet-rent: pid**3373328** (**SIGSTOP**; CONT after burst)
Host fleet-burst: pid**3735496** (p2223; MAX_ITERS=**86400**; mine=4/25; next=**R10**)
Host fleet-boot: pid**2756348**

Non-mine (do not touch): `affine-eval`, `affine-bench`, `affine-datagen`.

## Last reconciles

| when | action |
|---|---|
| 2026-08-12T09:52Z | p2223: R10 Hub OK; QUEUE→R10/R18 first; burst**3725622**→**3735496**; 8×=0; burn **$220.25/h** |
| 2026-08-12T09:47Z | p2222: burst **3704917**→**3725622** MAX_ITERS **3000→86400** next=R27; 8×=0; burn **$220.25/h** |
| 2026-08-12T09:44Z | p2221: n80 teacher-len≥65536 gate; posts relaunch R24/R21/R26/R25; 8×=0 next=R27; burn **$220.25/h** |
