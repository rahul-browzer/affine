# INVENTORY — mine-* pods only

**Cap: 40 lines.** Live table + last 3 reconciles. Never touch non-`mine-*`.
Pre-compaction: `archive/INVENTORY-full-2026-08-07.md`.

## Live

| name | huid | gpu | $/hr | remove_at | purpose | status |
|---|---|---|---|---|---|---|
| mine-h18-1 | golden-comet-e1 | 8×H200 | $28.00 | 2026-08-07T22:57:31Z | H18 TP×Shatoria α0.75 | n80 ~37/80 |
| mine-h19-1 | eager-eagle-c6 | 8×H200 | $28.00 | 2026-08-07T22:49:58Z | H19 TP×kkkk α0.90 | n80 ~42/80 |
| mine-h20-1 | swift-lion-ac | 8×H200 | $31.92 | 2026-08-07T22:52:59Z | H20 TP×leary α0.90 | n80 ~26/80 |
| mine-h21-1 | golden-wolf-62 | 8×H200 | $28.00 | 2026-08-07T23:41:29Z | H21 TP×sft2 α0.75 | DL teacher |
| mine-h22-1 | lunar-shark-f2 | 8×H200 | $31.92 | 2026-08-07T23:41:57Z | H22 TP×kevin α0.90 | DL kevin |

SSH: h18 .232:40307 · h19 .234:40297 · h20 .22:20100 · h21 .237:40310 · h22 .21:20100
known_hosts `/tmp/mine-h{18..22}-1.known_hosts` · **Free slots: 0**. Cap 5.
H23+H24 staged (no pods yet).

## Dead

| name | final spent | removed UTC | reason |
|---|---|---|---|
| mine-h17-1 | ~$45 | 2026-08-07T15:19Z | H17 REFUTE m=−0.0037 base×1.133 |
| mine-h16-1 | ~$41 | 2026-08-07T15:19Z | H16 REFUTE m=+0.0097 base×1.146 |
| mine-h18-1 (zesty-hawk-bc) | ~$2 | 2026-08-07T14:57Z | dud: API 8×H200, host 2 GPUs |
| mine-h15/14/13… | ~$600 | earlier | band/idle teardowns |

## Recent reconciles (last 3)

| UTC | lium ps mine-* | action |
|---|---|---|
| 2026-08-07T15:47Z | h18–h22 match | polled; no decision; staged H24; bal~$32682 |
| 2026-08-07T15:45Z | h18–h22 match | polled; no decision; staged H23; 0 free |
| 2026-08-07T15:42Z | h18–h22 match | rented h21+h22 (COUNT=8); launched bootstraps |
