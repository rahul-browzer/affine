# INVENTORY — live mine-* pods

**Cap: 40 lines.** Live table + last 3 reconciles. Older → `archive/`.

## Live

| name | huid | config | $/h | TTL | role |
|---|---|---|---|---|---|
| mine-crown-1 | gentle-orbit-bd (`3d07e519-…`) | 8×B200 | $52.25 | 2026-08-12T08:42Z | restore **2138** · corpus **2143** · SSH ok |

SSH: `ssh root@95.133.253.90 -p 40099`

Non-mine (do not touch): `affine-eval`, `affine-bench`, `affine-datagen`.

## Last reconciles

| when | action |
|---|---|
| 2026-08-11T08:48Z | p1995: seeded mine.env+triton+harness; restore pid2138 (uv pip); corpus waiter2143; burn$52.25/h · bal~$122507 |
| 2026-08-11T08:42Z | p1994: rm REBOOT_FAILED lunar-orbit-50; rent gentle-orbit-bd 8×B200@$52.25/h TTL24h |
| 2026-08-11T08:27Z | p1994mid: R2ai n80 started on old pod then SSH 40300 died |
