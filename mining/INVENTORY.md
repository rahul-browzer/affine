# INVENTORY — live mine-* pods

**Cap: 40 lines.** Live table + last 3 reconciles. Older → `archive/`.

## Live

| name | huid | config | $/h | TTL | role |
|---|---|---|---|---|---|
| mine-crown-1 | gentle-orbit-bd (`3d07e519-…`) | 8×B200 | $52.25 | **2026-08-13T02:35Z** | warm TKC; free |
| mine-r3-grpo-1 | golden-hawk-ff (`d55eec0f-…`) | 8×B300 | $64.00 | **2026-08-13T04:29Z** | **R24** + guass |
| mine-r4-fullft-1 | noble-orbit-9d (`70f95aab-…`) | 8×B300 | $64.00 | **2026-08-13T08:57Z** | **R21** pandora-GRPO |
| mine-r25-hitemp-1 | zesty-fox-bc (`20498068-…`) | 8×B200 | $40.00 | **2026-08-13T08:46Z** | **R25** bootstrap |
| *(pending fleet)* | mine-r26…r32 + R5b/R18… | 8×B300 | ~$64 | burst **3623101** | R26 next |

SSH crown: `ssh root@95.133.253.90 -p 40099`
SSH R3/R24: `ssh root@204.9.206.245 -p 40051`
SSH R4/R21: `ssh root@86.38.182.50 -p 40307`
SSH R25: `ssh root@150.136.71.147 -p 20309`
Host hist bridge: pid**3174953** (pending chal-00525)
Host fleet-rent: pid**3373328** (**SIGSTOP**; CONT after burst)
Host fleet-burst: pid**3623101** (p2212; mine=4/25; next=R26)
Host fleet-boot: pid**2756348**

Non-mine (do not touch): `affine-eval`, `affine-bench`, `affine-datagen`.

## Last reconciles

| when | action |
|---|---|
| 2026-08-12T08:55Z | p2212: R21 warm-arm on R4 train**140130**; burst→**3623101** QUEUE drop R21/R25; burn **$220.25/h** |
| 2026-08-12T08:48Z | p2211: **RENTED** r25 8×B200 $40; R20 REFUTE vs guass; burn **$220.25/h** |
| 2026-08-12T08:43Z | p2210: 8×=0; R17 REFUTE vs guass; R20 train DONE chall loading; burn **$180.25/h** |
