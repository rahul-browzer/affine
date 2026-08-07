# INVENTORY — mine-* pods only

**Cap: 40 lines.** Live table + last 3 reconciles. Never touch non-`mine-*`.
Pre-compaction: `archive/INVENTORY-full-2026-08-07.md`.

## Live

| name | huid | gpu | $/hr | remove_at | purpose | status |
|---|---|---|---|---|---|---|
| mine-h20-1 | swift-lion-ac | 8×H200 | $31.92 | 2026-08-07T22:52:59Z | H20 TP×leary α0.90 | n80 ~59/80 |
| mine-h21-1 | golden-wolf-62 | 8×H200 | $28.00 | 2026-08-07T23:41:29Z | H21 TP×sft2 α0.75 | →n80 |
| mine-h22-1 | lunar-shark-f2 | 8×H200 | $31.92 | 2026-08-07T23:41:57Z | H22 TP×kevin α0.90 | DL kevin |
| mine-h25-1 | golden-shark-c8 | 8×H200 | $28.00 | 2026-08-08T00:08:24Z | H25 TP×Radiant28 α0.90 | bootstrap |
| mine-h23-1 | gentle-fox-b5 | 8×B300 | $63.60 | 2026-08-08T00:09:46Z | H23 TP×Talucampe α0.90 | bootstrap |

SSH: h20 .22:20100 · h21 .237:40310 · h22 .21:20100 · h25 .232:40305 · h23 .244:40300
known_hosts `/tmp/mine-h{20,21,22,23,25}-1.known_hosts` · **Free slots: 0**. Cap 5.
H24 staged next free (0ronoCris).

## Dead

| name | final spent | removed UTC | reason |
|---|---|---|---|
| mine-h19-1 | ~$37 | 2026-08-07T16:09Z | H19 REFUTE m=+0.00348 base×1.121 |
| mine-h18-1 | ~$28 | 2026-08-07T16:06Z | H18 REFUTE band×1.997 |
| mine-h25-1 (golden-fox-c0) | ~$0.05 | 2026-08-07T16:07Z | dud: ls$22.64→rent$5.66 COUNT=2 |
| mine-h17/16… | ~$600 | earlier | REFUTE/idle teardowns |

## Recent reconciles (last 3)

| UTC | lium ps mine-* | action |
|---|---|---|
| 2026-08-07T16:10Z | h20–22+h25+h23 | H18/H19 REFUTE→rm; H25+H23 up; dud fox-c0 rm |
| 2026-08-07T15:49Z | h18–h22 match | polled; staged H25; bal~$32682 |
| 2026-08-07T15:47Z | h18–h22 match | polled; staged H24; bal~$32682 |
