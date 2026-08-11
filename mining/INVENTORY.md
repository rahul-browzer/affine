# INVENTORY — live mine-* pods

**Cap: 40 lines.** Live table + last 3 reconciles. Older → `archive/`.

## Live

| name | huid | config | $/h | TTL | role |
|---|---|---|---|---|---|
| mine-crown-1 | gentle-orbit-bd (`3d07e519-…`) | 8×B200 | $52.25 | 2026-08-12T08:42Z | TKC · R2am→R2ao→R2ap→R2aq · Stage-5 |

SSH: `ssh root@95.133.253.90 -p 40099`

Non-mine (do not touch): `affine-eval`, `affine-bench`, `affine-datagen`.

## Last reconciles

| when | action |
|---|---|
| 2026-08-11T13:08Z | p2031: armed R2aq pure-now+Stage-5 wait R2ap; now chall dir ready; R2am ~46/80; burn$52.25/h · bal~$121977 |
| 2026-08-11T13:05Z | p2030: armed R2ap pure-h44+Stage-5 wait R2ao; h44 chall dir ready; R2am ~39/80; burn$52.25/h · bal~$121987 |
| 2026-08-11T13:02Z | p2029: SKIP_BOARD R2an (cp13 hr0.16×); arm R2ao pure-af17 + Stage-5; af17 DONE; R2am ~30/80; burn$52.25/h · bal~$121987 |
