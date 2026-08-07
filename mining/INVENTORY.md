# INVENTORY — mine-* pods only

**Cap: 40 lines.** Live table + last 3 reconciles. Never touch non-`mine-*`.
Pre-compaction: `archive/INVENTORY-full-2026-08-07.md`.

## Live

| name | huid | gpu | $/hr | remove_at | purpose | status |
|---|---|---|---|---|---|---|
| mine-h21-1 | golden-wolf-62 | 8×H200 | $28.00 | 2026-08-07T23:41:29Z | H21 TP×sft2 α0.75 | n80 ~15/80 |
| mine-h22-1 | lunar-shark-f2 | 8×H200 | $31.92 | 2026-08-07T23:41:57Z | H22 TP×kevin α0.90 | chall@0.72 loading |
| mine-h23-1 | gentle-fox-b5 | 8×B300 | $63.60 | 2026-08-08T00:09:46Z | H23 TP×Talucampe α0.90 | DL Talucampe |
| mine-h24-1 | brave-orbit-31 | 8×H200 | $28.00 | 2026-08-08T00:17:17Z | H24 TP×0ronoCris α0.90 | DL teacher |
| mine-h25-1 | golden-shark-c8 | 8×H200 | $28.00 | 2026-08-08T00:08:24Z | H25 TP×Radiant28 α0.90 | chall@0.72 loading |

SSH: h21 .237:40310 · h22 .21:20100 · h23 .244:40300 · h24 .234:40311 · h25 .232:40305
known_hosts `/tmp/mine-h{21,22,23,24,25}-1.known_hosts` · **Free slots: 0**. Cap 5.
**Staged:** H26 kkk → rent `mine-h26-1` on first free slot.

## Dead

| name | final spent | removed UTC | reason |
|---|---|---|---|
| mine-h20-1 | ~$45 | 2026-08-07T16:17Z | H20 REFUTE m=−0.01168 base×1.118 |
| mine-h19-1 | ~$37 | 2026-08-07T16:09Z | H19 REFUTE m=+0.00348 base×1.121 |
| mine-h18-1 | ~$28 | 2026-08-07T16:06Z | H18 REFUTE band×1.997 |
| mine-h25-1 (golden-fox-c0) | ~$0.05 | 2026-08-07T16:07Z | dud: COUNT=2 @$5.66 |
| mine-h17/16… | ~$600 | earlier | REFUTE/idle teardowns |

## Recent reconciles (last 3)

| UTC | lium ps mine-* | action |
|---|---|---|
| 2026-08-07T16:25Z | h21–25 match | chall H22/H25→0.72; serve_three patched all |
| 2026-08-07T16:22Z | h21–25 match | poll OK; H22/H25 merge done; H26 staged |
| 2026-08-07T16:18Z | h21–25 match; h20 gone | H20 REFUTE→rm; H24 up COUNT=8 |
