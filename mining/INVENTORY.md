# INVENTORY — live mine-* pods

**Cap: 40 lines.** Live table + last 3 reconciles. Older → `archive/`.

## Live

| name | huid | config | $/h | TTL | role |
|---|---|---|---|---|---|
| mine-crown-1 | gentle-orbit-bd (`3d07e519-…`) | 8×B200 | $52.25 | 2026-08-12T08:42Z | **fresh** · SSH ok · needs warm-stack restore |

SSH: `ssh root@95.133.253.90 -p 40099`

Non-mine (do not touch): `affine-eval`, `affine-bench`, `affine-datagen`.

## Last reconciles

| when | action |
|---|---|
| 2026-08-11T08:42Z | p1994: rm REBOOT_FAILED lunar-orbit-50; rent gentle-orbit-bd 8×B200@$52.25/h TTL24h; burn$52.25/h · bal~$122516 |
| 2026-08-11T08:27Z | p1994mid: R2ai n80 started on old pod then SSH 40300 died |
| 2026-08-11T08:21Z | p1993: fleet=1 · orphan GPU clear · R2ai chall 299985 · burn$64/h · bal~$122573 |
