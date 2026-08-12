# INVENTORY — live mine-* pods

**Cap: 40 lines.** Live table + last 3 reconciles. Older → `archive/`.

## Live

| name | huid | config | $/h | TTL | role |
|---|---|---|---|---|---|
| mine-crown-1 | gentle-orbit-bd (`3d07e519-…`) | 8×B200 | $52.25 | 2026-08-12T08:42Z | **R2bh** IntoLayer n80 ~12/80 |
| mine-r3-grpo-1 | golden-hawk-ff (`d55eec0f-…`) | 8×B300 | $64.00 | 2026-08-12T16:29Z | **R3b** train ~step36 |
| mine-r4-fullft-1 | noble-orbit-9d (`70f95aab-…`) | 8×B300 | $64.00 | remove 2026-08-12T20:57Z | **R6** merge+n80 continue |
| *(pending fleet)* | mine-r7…r32 | 8×B300 | ~$64 | rent **2784801** POST-rent + boot **2756348** | R7–R32 |

SSH crown: `ssh root@95.133.253.90 -p 40099`
SSH R3/R3b: `ssh root@204.9.206.245 -p 40051`
SSH R4/R6: `ssh root@86.38.182.50 -p 40307`
Host hist bridge: pid**2777023** (+chal-00516)

Non-mine (do not touch): `affine-eval`, `affine-bench`, `affine-datagen`.

## Last reconciles

| when | action |
|---|---|
| 2026-08-12T00:16Z | p2141: R6 train.done→merge; n80-continue armed; B300×8=0; burn **$180.25/h** |
| 2026-08-12T00:09Z | p2140: R2bg REFUTE; R2bh reload; B300×8=0; burn **$180.25/h**; fleet pid2784801 |
| 2026-08-11T23:58Z | p2139: fleet→**api-POST-rent** pid2784801; B300×8=0; burn **$180.25/h** |
