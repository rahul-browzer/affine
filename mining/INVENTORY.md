# INVENTORY — live mine-* pods

**Cap: 40 lines.** Live table + last 3 reconciles. Older → `archive/`.

## Live

| name | huid | config | $/h | TTL | role |
|---|---|---|---|---|---|
| mine-crown-1 | gentle-orbit-bd (`3d07e519-…`) | 8×B200 | $52.25 | 2026-08-12T08:42Z | R2ap n80 · R2aq/R2ar wait |

SSH: `ssh root@95.133.253.90 -p 40099`

Non-mine (do not touch): `affine-eval`, `affine-bench`, `affine-datagen`.

## Last reconciles

| when | action |
|---|---|
| 2026-08-11T14:21Z | p2035: R2ap n80~7/80; arm R2ar iynocr2p+hope11 prefetch/watch/Stage-5; burn$52.25/h · bal~$121824 |
| 2026-08-11T14:11Z | p2034: R2ao REFUTE −0.074×; Stage-5 SKIP; R2ap h44 chall loading; burn$52.25/h · bal~$121844 |
| 2026-08-11T13:43Z | p2033: TKC 200/200/200; R2ao died mid-script edit; continue_r2ao_n80 launched; burn$52.25/h · bal~$121905 |
