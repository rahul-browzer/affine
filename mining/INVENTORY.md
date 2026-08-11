# INVENTORY — live mine-* pods

**Cap: 40 lines.** Live table + last 3 reconciles. Older → `archive/`.

## Live

| name | huid | config | $/h | TTL | role |
|---|---|---|---|---|---|
| mine-crown-1 | gentle-orbit-bd (`3d07e519-…`) | 8×B200 | $52.25 | 2026-08-12T08:42Z | restore **2138** · R2aj **3857** · R2ak **5813** · sky/google prefetch |

SSH: `ssh root@95.133.253.90 -p 40099`

Non-mine (do not touch): `affine-eval`, `affine-bench`, `affine-datagen`.

## Last reconciles

| when | action |
|---|---|
| 2026-08-11T08:55Z | p1997: armed R2ak pure-google + google-after-sky + watch470; restore HF progressing; burn$52.25/h · bal~$122497 |
| 2026-08-11T08:51Z | p1996: armed R2aj pure-sky + prefetch (wait warm); restore HF DL progressing; burn$52.25/h · bal~$122497 |
| 2026-08-11T08:48Z | p1995: seeded mine.env+triton+harness; restore pid2138 (uv pip); corpus waiter2143; burn$52.25/h · bal~$122507 |
