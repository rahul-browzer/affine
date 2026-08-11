# INVENTORY — live mine-* pods

**Cap: 40 lines.** Live table + last 3 reconciles. Older → `archive/`.

## Live

| name | huid | config | $/h | TTL | role |
|---|---|---|---|---|---|
| mine-crown-1 | gentle-orbit-bd (`3d07e519-…`) | 8×B200 | $52.25 | 2026-08-12T08:42Z | R2ax n80 + R2ay/R2az + v10 prefetch |
| mine-r3-grpo-1 | golden-hawk-ff (`d55eec0f-…`) | 8×B300 | $64.00 | 2026-08-12T16:29Z | GRPO pid23755 + TK |
| *(pending)* | mine-r4-fullft-1 | 8×B300 | ~$64 | waiter pid2139807 | R4 full-FT when stock |

SSH crown: `ssh root@95.133.253.90 -p 40099`
SSH R3: `ssh root@204.9.206.245 -p 40051`

Non-mine (do not touch): `affine-eval`, `affine-bench`, `affine-datagen`.

## Last reconciles

| when | action |
|---|---|
| 2026-08-11T18:23Z | p2067: R4 rent waiter+v10 prefetch; R3 step20; R2ax~34/80; B300×8=0 |
| 2026-08-11T18:14Z | p2066: purge iynocr2p+h64+sft4; arm R2az vvv; R3 step10; B300×8=0 |
| 2026-08-11T18:08Z | p2065: R2ax ~8/80; R2ay sbs-v2 prefetch+reload+stage5; host-hist→504; B300×8=0 |
