# INVENTORY — live mine-* pods

**Cap: 40 lines.** Live table + last 3 reconciles. Older → `archive/`.

## Live

| name | huid | config | $/h | TTL | role |
|---|---|---|---|---|---|
| mine-crown-1 | gentle-orbit-bd (`3d07e519-…`) | 8×B200 | $52.25 | **2026-08-13T02:35Z** | **R9** n80 vs ckp333 |
| mine-r3-grpo-1 | golden-hawk-ff (`d55eec0f-…`) | 8×B300 | $64.00 | 2026-08-12T16:29Z | **R3b** GRPO |
| mine-r4-fullft-1 | noble-orbit-9d (`70f95aab-…`) | 8×B300 | $64.00 | remove **2026-08-12T20:57Z** | **R13** offline-DPO |
| *(pending fleet)* | mine-r24…r32 + R5b/R10/R14… | 8×B300 | ~$64 | rent POST + boot **2756348** | R24 first |

SSH crown: `ssh root@95.133.253.90 -p 40099`
SSH R3/R3b: `ssh root@204.9.206.245 -p 40051`
SSH R4/R13: `ssh root@86.38.182.50 -p 40307`
Host hist bridge: pid**3174953** (+chal-00525)

Non-mine (do not touch): `affine-eval`, `affine-bench`, `affine-datagen`.

## Last reconciles

| when | action |
|---|---|
| 2026-08-12T04:57Z | p2188: 600-iter R24 burst empty; R12 REFUTE→R13 warm-arm; burn **$180.25/h** |
| 2026-08-12T04:46Z | p2187: 500-iter R24 burst empty; R9 graft+CUDA_HOME+n80 armed (~2/80); burn **$180.25/h** |
| 2026-08-12T04:27Z | p2186: R2bn REFUTE; 400-iter R24 burst empty; R9 merge live; burn **$180.25/h** |
