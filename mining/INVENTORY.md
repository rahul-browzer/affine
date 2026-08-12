# INVENTORY — live mine-* pods

**Cap: 40 lines.** Live table + last 3 reconciles. Older → `archive/`.

## Live

| name | huid | config | $/h | TTL | role |
|---|---|---|---|---|---|
| mine-crown-1 | gentle-orbit-bd (`3d07e519-…`) | 8×B200 | $52.25 | **2026-08-13T02:35Z** | **R22** golden-GRPO |
| mine-r3-grpo-1 | golden-hawk-ff (`d55eec0f-…`) | 8×B300 | $64.00 | **2026-08-13T04:29Z** | **R23** diane warm |
| mine-r4-fullft-1 | noble-orbit-9d (`70f95aab-…`) | 8×B300 | $64.00 | **2026-08-13T08:57Z** | **R27** BigG G=16 |
| *(pending fleet)* | mine-r28… then R29–R32… | 8×B300 | ~$64 | burst **4176223** | **R28 next** |

SSH crown/R22: `ssh root@95.133.253.90 -p 40099`
SSH R3/R23: `ssh root@204.9.206.245 -p 40051`
SSH R4/R27: `ssh root@86.38.182.50 -p 40307`
Host fleet-rent: pid**3373328** (**SIGSTOP**; CONT after burst)
Host fleet-burst: pid**4176223** (p2253; SKIP_PID_LOCK; next=**R28**)
Host fleet-boot: pid**3852238**

Non-mine (do not touch): `affine-eval`, `affine-bench`, `affine-datagen`.

## Last reconciles

| when | action |
|---|---|
| 2026-08-12T13:24Z | p2253: R27 warm on R4 (train 177775); burst→R28; burn **$180.25/h** |
| 2026-08-12T13:12Z | p2252: R23 warm on R3; R19 SIGNAL_POS_BELOW; burst→R27; burn **$180.25/h** |
| 2026-08-12T13:06Z | p2251: R25 REFUTE; tear zesty-fox + failed R23; R19 chall Triton→n80; burn **$180.25/h** |
