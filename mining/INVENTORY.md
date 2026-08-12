# INVENTORY — live mine-* pods

**Cap: 40 lines.** Live table + last 3 reconciles. Older → `archive/`.

## Live

| name | huid | config | $/h | TTL | role |
|---|---|---|---|---|---|
| mine-crown-1 | gentle-orbit-bd (`3d07e519-…`) | 8×B200 | $52.25 | 2026-08-12T08:42Z | R2bk n80 + R9 train + R2bl wait |
| mine-r3-grpo-1 | golden-hawk-ff (`d55eec0f-…`) | 8×B300 | $64.00 | 2026-08-12T16:29Z | **R3b** train + post→ckp333 |
| mine-r4-fullft-1 | noble-orbit-9d (`70f95aab-…`) | 8×B300 | $64.00 | remove 2026-08-12T20:57Z | **R8** n80 vs ckp333 |
| *(pending fleet)* | mine-r7…r32 | 8×B300 | ~$64 | rent POST + boot **2756348** | R7 first |

SSH crown: `ssh root@95.133.253.90 -p 40099`
SSH R3/R3b: `ssh root@204.9.206.245 -p 40051`
SSH R4/R8: `ssh root@86.38.182.50 -p 40307`
Host hist bridge: pid**2964435** (+chal-00520)

Non-mine (do not touch): `affine-eval`, `affine-bench`, `affine-datagen`.

## Last reconciles

| when | action |
|---|---|
| 2026-08-12T01:54Z | p2157: R8 n80 launched vs ckp333; B300×8=0; burn **$180.25/h** |
| 2026-08-12T01:48Z | p2156: R2bl Bittoby v3 armed; R9↔R2bl wait; B300×8=0; burn **$180.25/h** |
| 2026-08-12T01:41Z | p2155: king→ckp333 DONE; R2bk n80 armed; B300×8=0; burn **$180.25/h** |
