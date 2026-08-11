# INVENTORY — live mine-* pods

**Cap: 40 lines.** Live table + last 3 reconciles. Older → `archive/`.

## Live

| name | huid | config | $/h | TTL | role |
|---|---|---|---|---|---|
| mine-crown-1 | gentle-orbit-bd (`3d07e519-…`) | 8×B200 | $52.25 | 2026-08-12T08:42Z | R2aq n80 · R2ar…av · v2 DONE |

SSH: `ssh root@95.133.253.90 -p 40099`

Non-mine (do not touch): `affine-eval`, `affine-bench`, `affine-datagen`.

## Last reconciles

| when | action |
|---|---|
| 2026-08-11T15:11Z | p2044: R2aw mt1 SKIP_UNSERVABLE (Glm4Moe); v2 prefetch DONE; R2aq~42/80; burn$52.25/h · bal~$121722 |
| 2026-08-11T15:08Z | p2043: arm R2av pure-v2+Stage-5 (wait R2au); prefetch Bittoby@766dbdc; R2aq~30/80; burn$52.25/h · bal~$121732 |
| 2026-08-11T15:04Z | p2042: arm R2au pure-sft4+Stage-5 (wait R2at); sft4 chall staged; R2aq~17/80; burn$52.25/h · bal~$121742 |
