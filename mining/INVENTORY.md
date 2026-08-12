# INVENTORY — live mine-* pods

**Cap: 40 lines.** Live table + last 3 reconciles. Older → `archive/`.

## Live

| name | huid | config | $/h | TTL | role |
|---|---|---|---|---|---|
| mine-crown-1 | gentle-orbit-bd (`3d07e519-…`) | 8×B200 | $52.25 | **2026-08-13T02:35Z** | **R16** golden-REINFORCE |
| mine-r3-grpo-1 | golden-hawk-ff (`d55eec0f-…`) | 8×B300 | $64.00 | **2026-08-12T16:29Z** | **R15** pandora-REINFORCE |
| mine-r4-fullft-1 | noble-orbit-9d (`70f95aab-…`) | 8×B300 | $64.00 | remove **2026-08-12T20:57Z** | **R14** kevin-REINFORCE |
| *(pending fleet)* | mine-r24…r32 + R5b/R10/R17… | 8×B300 | ~$64 | rent POST + boot **2756348** | R24 first |

SSH crown/R16: `ssh root@95.133.253.90 -p 40099`
SSH R3/R15: `ssh root@204.9.206.245 -p 40051`
SSH R4/R14: `ssh root@86.38.182.50 -p 40307`
Host hist bridge: pid**3174953** (+chal-00525)
Host fleet-rent: pid**3373328**

Non-mine (do not touch): `affine-eval`, `affine-bench`, `affine-datagen`.

## Last reconciles

| when | action |
|---|---|
| 2026-08-12T06:15Z | p2192: R16 warm-arm crown; 1000-iter R24 burst empty; waiter→**3373328**; burn **$180.25/h** |
| 2026-08-12T05:56Z | p2191: 900-iter R24 burst empty; R15 warm-arm on R3; waiter→**3351343**; burn **$180.25/h** |
| 2026-08-12T05:42Z | p2190: 800-iter R24 burst empty; R3b REFUTE; R14 warm-arm on R4; burn **$180.25/h** |
