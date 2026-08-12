# INVENTORY — live mine-* pods

**Cap: 40 lines.** Live table + last 3 reconciles. Older → `archive/`.

## Live

| name | huid | config | $/h | TTL | role |
|---|---|---|---|---|---|
| mine-crown-1 | gentle-orbit-bd (`3d07e519-…`) | 8×B200 | $52.25 | **2026-08-12T14:36Z** | **R2bm n80** + R9 train |
| mine-r3-grpo-1 | golden-hawk-ff (`d55eec0f-…`) | 8×B300 | $64.00 | 2026-08-12T16:29Z | **R3b** train; dec-watch armed |
| mine-r4-fullft-1 | noble-orbit-9d (`70f95aab-…`) | 8×B300 | $64.00 | remove **2026-08-12T20:57Z** | **R11 n80** ~35/80 |
| *(pending fleet)* | mine-r24…r32 | 8×B300 | ~$64 | rent POST + boot **2756348** | R24 first |

SSH crown: `ssh root@95.133.253.90 -p 40099`
SSH R3/R3b: `ssh root@204.9.206.245 -p 40051`
SSH R4/R11: `ssh root@86.38.182.50 -p 40307`
Host hist bridge: pid**3080195** (+chal-00521)

Non-mine (do not touch): `affine-eval`, `affine-bench`, `affine-datagen`.

## Last reconciles

| when | action |
|---|---|
| 2026-08-12T03:27Z | p2174: R11 n80 relaunched (missing sim file); B300×8=0; burn **$180.25/h** |
| 2026-08-12T03:21Z | p2173: R11 Triton false_probe→reseed+relaunch+n80-retry; B300×8=0; burn **$180.25/h** |
| 2026-08-12T03:16Z | p2172: R11 merge+HF purge+push; B300×8=0; burn **$180.25/h** |
