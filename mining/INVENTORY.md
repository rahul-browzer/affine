# INVENTORY — live mine-* pods

**Cap: 40 lines.** Live table + last 3 reconciles. Older → `archive/`.

## Live

| name | huid | config | $/h | TTL | role |
|---|---|---|---|---|---|
| mine-crown-1 | gentle-orbit-bd (`3d07e519-…`) | 8×B200 | $52.25 | **2026-08-13T02:35Z** | **R33** guass-GRPO |
| mine-r3-grpo-1 | golden-hawk-ff (`d55eec0f-…`) | 8×B300 | $64.00 | **2026-08-13T04:29Z** | **R25 n80** (16/16 HF) |
| mine-r4-fullft-1 | noble-orbit-9d (`70f95aab-…`) | 8×B300 | $64.00 | **2026-08-13T08:57Z** | **R19** Talent-GRPO |
| mine-r25-hitemp-1 | zesty-fox-bc (`20498068-…`) | 8×B200 | $40.00 | **2026-08-13T08:46Z** | **REBOOT_FAILED** |
| *(pending fleet)* | mine-r22… then R23/R27–R32… | 8×B300 | ~$64 | burst **3962156** | **R22 next** |

SSH crown/R33: `ssh root@95.133.253.90 -p 40099`
SSH R3/R25n80: `ssh root@204.9.206.245 -p 40051`
SSH R4/R19: `ssh root@86.38.182.50 -p 40307`
SSH R25: `ssh root@150.136.71.147 -p 20309` (refused)
Host fleet-rent: pid**3373328** (**SIGSTOP**; CONT after burst)
Host fleet-burst: pid**3962156** (p2241; MAX_ITERS=**86400**; mine=4/25; next=**R22**)
Host fleet-boot: pid**3852238**
Host p2247 reboot-watch **4091485**; p2248 dec-watch **4107829**

Non-mine (do not touch): `affine-eval`, `affine-bench`, `affine-datagen`.

## Last reconciles

| when | action |
|---|---|
| 2026-08-12T12:48Z | p2248: R25 HF 16/16→chall load on R3; premature partial-serve killed; gates hardened; burn **$220.25/h** |
| 2026-08-12T12:40Z | p2247: R24 n80 SIGNAL_POS_BELOW; R25 reboot FAILED; R25 HF migrate; burn **$220.25/h** |
| 2026-08-12T12:10Z | p2246: 8×=0; R25 chall enforce-eager+Triton warm/freeze → n80~35/80; burn **$220.25/h** |
