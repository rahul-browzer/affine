# INVENTORY — live mine-* pods

**Cap: 40 lines.** Live table + last 3 reconciles. Older → `archive/`.

## Live

| name | huid | config | $/h | TTL | role |
|---|---|---|---|---|---|
| mine-crown-1 | gentle-orbit-bd (`3d07e519-…`) | 8×B200 | $52.25 | **2026-08-13T02:35Z** | **R22** golden-GRPO |
| mine-r3-grpo-1 | golden-hawk-ff (`d55eec0f-…`) | 8×B300 | $64.00 | **2026-08-13T04:29Z** | **R25 n80** ~24/80 |
| mine-r4-fullft-1 | noble-orbit-9d (`70f95aab-…`) | 8×B300 | $64.00 | **2026-08-13T08:57Z** | **R19** re-serve |
| mine-r25-hitemp-1 | zesty-fox-bc (`20498068-…`) | 8×B200 | $40.00 | **2026-08-13T08:46Z** | **REBOOT_FAILED** |
| *(pending fleet)* | mine-r23… then R27–R32… | 8×B300 | ~$64 | burst **4116237** | **R23 next** |

SSH crown/R22: `ssh root@95.133.253.90 -p 40099`
SSH R3/R25n80: `ssh root@204.9.206.245 -p 40051`
SSH R4/R19: `ssh root@86.38.182.50 -p 40307`
SSH R25: `ssh root@150.136.71.147 -p 20309` (refused)
Host fleet-rent: pid**3373328** (**SIGSTOP**; CONT after burst)
Host fleet-burst: pid**4116237** (p2249; MAX_ITERS=**86400**; mine=4/25; next=**R23**)
Host fleet-boot: pid**3852238**
Host p2248 dec-watch **4107829**

Non-mine (do not touch): `affine-eval`, `affine-bench`, `affine-datagen`.

## Last reconciles

| when | action |
|---|---|
| 2026-08-12T13:00Z | p2250: R25 n80 LIVE (PYTHONPATH fix); form-dec armed; burn **$220.25/h** |
| 2026-08-12T12:54Z | p2249: R33 REFUTE; R22 warm on crown; burst→R23; R25 recover armed; burn **$220.25/h** |
| 2026-08-12T12:48Z | p2248: R25 HF 16/16→chall load on R3; premature partial-serve killed; burn **$220.25/h** |
