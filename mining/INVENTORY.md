# INVENTORY — live mine-* pods

**Cap: 40 lines.** Live table + last 3 reconciles. Older → `archive/`.

## Live

| name | huid | config | $/h | TTL | role |
|---|---|---|---|---|---|
| mine-crown-1 | gentle-orbit-bd (`3d07e519-…`) | 8×B200 | $52.25 | **2026-08-13T02:35Z** | **R33** guass-GRPO train |
| mine-r3-grpo-1 | golden-hawk-ff (`d55eec0f-…`) | 8×B300 | $64.00 | **2026-08-13T04:29Z** | **R24** train~178 + guass |
| mine-r4-fullft-1 | noble-orbit-9d (`70f95aab-…`) | 8×B300 | $64.00 | **2026-08-13T08:57Z** | **R19** Talent-GRPO + T/K |
| mine-r25-hitemp-1 | zesty-fox-bc (`20498068-…`) | 8×B200 | $40.00 | **2026-08-13T08:46Z** | **R25** train~174 + guass |
| *(pending fleet)* | mine-r22… then R23/R27–R32… | 8×B300 | ~$64 | burst **3962156** | **R22 next** |

SSH crown/R33: `ssh root@95.133.253.90 -p 40099`
SSH R3/R24: `ssh root@204.9.206.245 -p 40051`
SSH R4/R19: `ssh root@86.38.182.50 -p 40307`
SSH R25: `ssh root@150.136.71.147 -p 20309`
Host fleet-rent: pid**3373328** (**SIGSTOP**; CONT after burst)
Host fleet-burst: pid**3962156** (p2241; MAX_ITERS=**86400**; mine=4/25; next=**R22**)
Host fleet-boot: pid**3852238** (pass=2233; R33/R5b warm)

Non-mine (do not touch): `affine-eval`, `affine-bench`, `affine-datagen`.

## Last reconciles

| when | action |
|---|---|
| 2026-08-12T11:36Z | p2241: R5b SIGNAL_POS_BELOW→R19 warm-arm on r4 (train166479); burst→R22; burn **$220.25/h** |
| 2026-08-12T11:32Z | p2240: R5b CHALL_REPO fix → n80 gathering ~29/80; form165834/watch165185/retry165182; burn **$220.25/h** |
| 2026-08-12T11:28Z | p2239: R5b n80 watchers re-armed (form161132/watch161150/retry161164); burn **$220.25/h** |
