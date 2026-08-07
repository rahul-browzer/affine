# INVENTORY — mine-* pods only

**Cap: 40 lines.** Live table + last 3 reconciles. Never touch non-`mine-*`.
Pre-compaction: `archive/INVENTORY-full-2026-08-07.md`.

## Live

| name | huid | gpu | $/hr | remove_at | purpose | status |
|---|---|---|---|---|---|---|
| mine-h23-1 | gentle-fox-b5 | 8×B300 | $63.60 | 2026-08-08T00:09:46Z | H23 TP×Talucampe α0.90 | merge ~15/16 |
| mine-h24-1 | brave-orbit-31 | 8×H200 | $28.00 | 2026-08-08T00:17:17Z | H24 TP×0ronoCris α0.90 | chall recover→n80 |
| mine-h25-1 | golden-shark-c8 | 8×H200 | $28.00 | 2026-08-08T00:08:24Z | H25 TP×Radiant28/m7 | king recover→n80 |
| mine-h26-1 | swift-matrix-98 | 8×H200 | $31.92 | 2026-08-08T01:20:36Z | H26 TP×kkk-af α0.90 | bootstrap |

SSH: h23 .244:40300 · h24 .234:40311 · h25 .232:40305 · h26 .22:20100
known_hosts `/tmp/mine-h{23,24,25,26}-1.known_hosts` · **Free slots: 1**. Cap 5.

## Dead

| name | final spent | removed UTC | reason |
|---|---|---|---|
| mine-h21-1 | ~$46 | 2026-08-07T17:20Z | H21 REFUTE m=−0.00682 |
| mine-h22-1 | ~$52 | 2026-08-07T17:20Z | H22 REFUTE m=−0.01179 |
| mine-h20-1 | ~$45 | 2026-08-07T16:17Z | H20 REFUTE m=−0.01168 |
| mine-h19/18… | earlier | earlier | REFUTE/idle |

## Recent reconciles (last 3)

| UTC | lium ps mine-* | action |
|---|---|---|
| 2026-08-07T17:20Z | h23–26; rm h21+h22 | H21/H22 REFUTE; rent h26; H24/H25 recover |
| 2026-08-07T16:37Z | h21–25 match | clipL1 rank; H25 n80 |
| 2026-08-07T16:25Z | h21–25 match | chall util 0.72 |
