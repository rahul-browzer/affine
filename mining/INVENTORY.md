# INVENTORY — live mine-* pods

**Cap: 40 lines.** Live table + last 3 reconciles. Older → `archive/`.

## Live

| name | huid | config | $/h | TTL | role |
|---|---|---|---|---|---|
| mine-crown-1 | gentle-orbit-bd (`3d07e519-…`) | 8×B200 | $52.25 | 2026-08-12T08:42Z | TKC **200/200/200** · R2aj board-wait 469 · sky DONE · google DL · pig-chain · watch469/470 |

SSH: `ssh root@95.133.253.90 -p 40099`

Non-mine (do not touch): `affine-eval`, `affine-bench`, `affine-datagen`.

## Last reconciles

| when | action |
|---|---|
| 2026-08-11T09:03Z | p1999: sky prefetch DONE; google DL; armed watch469+pig-after-google; burn$52.25/h · bal~$122476 |
| 2026-08-11T09:00Z | p1998: warm TKC READY 200/200/200; R2aj→board-wait 469; sky prefetch DL; burn$52.25/h · bal~$122476 |
| 2026-08-11T08:55Z | p1997: armed R2ak pure-google + google-after-sky + watch470; restore HF progressing; burn$52.25/h · bal~$122497 |
