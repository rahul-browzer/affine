# INVENTORY — live mine-* pods

**Cap: 40 lines.** Live table + last 3 reconciles. Older → `archive/`.

## Live

| name | huid | config | $/h | TTL | role |
|---|---|---|---|---|---|
| mine-crown-1 | gentle-orbit-bd (`3d07e519-…`) | 8×B200 | $52.25 | **2026-08-13T02:35Z** | **R33** guass-GRPO train |
| mine-r3-grpo-1 | golden-hawk-ff (`d55eec0f-…`) | 8×B300 | $64.00 | **2026-08-13T04:29Z** | **R24** train~145 + guass |
| mine-r4-fullft-1 | noble-orbit-9d (`70f95aab-…`) | 8×B300 | $64.00 | **2026-08-13T08:57Z** | **R5b** Talent FT bootstrap |
| mine-r25-hitemp-1 | zesty-fox-bc (`20498068-…`) | 8×B200 | $40.00 | **2026-08-13T08:46Z** | **R25** train~129 + guass |
| *(pending fleet)* | mine-r19… then R22/R23/R27–R32… | 8×B300 | ~$64 | burst **3888146** | **R19 next** |

SSH crown/R33: `ssh root@95.133.253.90 -p 40099`
SSH R3/R24: `ssh root@204.9.206.245 -p 40051`
SSH R4/R5b: `ssh root@86.38.182.50 -p 40307`
SSH R25: `ssh root@150.136.71.147 -p 20309`
Host fleet-rent: pid**3373328** (**SIGSTOP**; CONT after burst)
Host fleet-burst: pid**3888146** (p2235; MAX_ITERS=**86400**; mine=4/25; next=**R19**)
Host fleet-boot: pid**3852238** (pass=2233; R33/R5b already warm)

Non-mine (do not touch): `affine-eval`, `affine-bench`, `affine-datagen`.

## Last reconciles

| when | action |
|---|---|
| 2026-08-12T11:03Z | p2235: R21 REFUTE + R26 SIGNAL_POS_BELOW vs guass; warm R33@crown + R5b@r4; burst→R19; burn **$220.25/h** |
| 2026-08-12T10:48Z | p2234: R21+R26 post_train relaunch (merge live); R24/R25 waiter refresh; burn **$220.25/h** |
| 2026-08-12T10:43Z | p2233: R33 guass-init armed+QUEUE; burst**3851526**/boot**3852238**; rent empty; burn **$220.25/h** |
