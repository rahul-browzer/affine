# INVENTORY — live mine-* pods

**Cap: 40 lines.** Live table + last 3 reconciles. Older → `archive/`.

## Live

| name | huid | config | $/h | TTL | role |
|---|---|---|---|---|---|
| mine-crown-1 | gentle-orbit-bd (`3d07e519-…`) | 8×B200 | $52.25 | 2026-08-12T08:42Z | R2av v2 n80 ~63/80 |
| mine-r3-grpo-1 | golden-hawk-ff (`d55eec0f-…`) | 8×B300 | $64.00 | 2026-08-12T16:29Z | GRPO + TK prewarm |

SSH crown: `ssh root@95.133.253.90 -p 40099`
SSH R3: `ssh root@204.9.206.245 -p 40051`

Non-mine (do not touch): `affine-eval`, `affine-bench`, `affine-datagen`.

## Last reconciles

| when | action |
|---|---|
| 2026-08-11T17:54Z | p2062: R3 king→65536; teacher NCCL orphan cleared+relaunched; GRPO resumed step10; B300×8=0 |
| 2026-08-11T17:31Z | p2061: unstuck R3 w0 range; tok stamped; teacher:8000; GRPO launched; R2au REFUTE; R2av n80; B300×8=0 |
| 2026-08-11T17:09Z | p2060: killed ~4MB/s HF; 16-way CDN range DL @~90MB/s + waiter→bootstrap; B300×8=0 |
