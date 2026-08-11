# INVENTORY — live mine-* pods

**Cap: 40 lines.** Live table + last 3 reconciles. Older → `archive/`.

## Live

| name | huid | config | $/h | TTL | role |
|---|---|---|---|---|---|
| mine-crown-1 | gentle-orbit-bd (`3d07e519-…`) | 8×B200 | $52.25 | 2026-08-12T08:42Z | TKC · R2ab ~57/80 · R2ac fixed · watch480 |

SSH: `ssh root@95.133.253.90 -p 40099`

Non-mine (do not touch): `affine-eval`, `affine-bench`, `affine-datagen`.

## Last reconciles

| when | action |
|---|---|
| 2026-08-11T10:55Z | p2015: fixed R2ac↔R2ad deadlock (holding-stamp); R2ab ~57/80; burn$52.25/h · bal~$122252 |
| 2026-08-11T10:49Z | p2014: R2al SKIP_BOARD (471 hr0.58×); R2ad DONE; R2ab ~42/80; burn$52.25/h · bal~$122262 |
| 2026-08-11T10:16Z | p2012: sbs-v1 prefetch DONE; armed on-pod watch480 (pid36279); R2al ~40/80; burn$52.25/h · bal~$122324 |
