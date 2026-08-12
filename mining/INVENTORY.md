# INVENTORY — live mine-* pods

**Cap: 40 lines.** Live table + last 3 reconciles. Older → `archive/`.

## Live

| name | huid | config | $/h | TTL | role |
|---|---|---|---|---|---|
| mine-crown-1 | gentle-orbit-bd (`3d07e519-…`) | 8×B200 | $52.25 | **2026-08-12T14:36Z** | **R9** train+post (R2bm done) |
| mine-r3-grpo-1 | golden-hawk-ff (`d55eec0f-…`) | 8×B300 | $64.00 | 2026-08-12T16:29Z | **R3b** train; dec-watch armed |
| mine-r4-fullft-1 | noble-orbit-9d (`70f95aab-…`) | 8×B300 | $64.00 | remove **2026-08-12T20:57Z** | **R12** BoN-CE train |
| *(pending fleet)* | mine-r24…r32 | 8×B300 | ~$64 | rent POST + boot **2756348** | R24 first |

SSH crown: `ssh root@95.133.253.90 -p 40099`
SSH R3/R3b: `ssh root@204.9.206.245 -p 40051`
SSH R4/R12: `ssh root@86.38.182.50 -p 40307`
Host hist bridge: pid**3080195** (+chal-00521)

Non-mine (do not touch): `affine-eval`, `affine-bench`, `affine-datagen`.

## Last reconciles

| when | action |
|---|---|
| 2026-08-12T03:34Z | p2176: R2bm REFUTE; B300×8=0; burn **$180.25/h** |
| 2026-08-12T03:31Z | p2175: R11 REFUTE→R12 warm-arm; B300×8=0; burn **$180.25/h** |
| 2026-08-12T03:27Z | p2174: R11 n80 relaunched (missing sim file); B300×8=0; burn **$180.25/h** |
