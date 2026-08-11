# INVENTORY — live mine-* pods

**Cap: 40 lines.** Live table + last 3 reconciles. Older → `archive/`.

## Live

| name | huid | config | $/h | TTL | role |
|---|---|---|---|---|---|
| mine-crown-1 | gentle-orbit-bd (`3d07e519-…`) | 8×B200 | $52.25 | 2026-08-12T08:42Z | R2ap n80 · R2aq/ar/as · 492 |

SSH: `ssh root@95.133.253.90 -p 40099`

Non-mine (do not touch): `affine-eval`, `affine-bench`, `affine-datagen`.

## Last reconciles

| when | action |
|---|---|
| 2026-08-11T14:32Z | p2038: R2ap~41/80; rearm host-hist bridge for 485–492; burn$52.25/h · bal~$121803 |
| 2026-08-11T14:29Z | p2037: R2ap~33/80; arm R2as pure-726 reload+Stage-5; prefetch726 DONE; burn$52.25/h · bal~$121814 |
| 2026-08-11T14:26Z | p2036: R2ap~21/80; arm watch492+prefetch726 (hope11 DONE); burn$52.25/h · bal~$121814 |
