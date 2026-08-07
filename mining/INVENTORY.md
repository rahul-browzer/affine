# INVENTORY — mine-* pods only

**Cap: 40 lines.** Live table + last 3 reconciles. Never touch non-`mine-*`.
Pre-compaction: `archive/INVENTORY-full-2026-08-07.md`.

## Live

| name | huid | gpu | $/hr | remove_at | purpose | status |
|---|---|---|---|---|---|---|
| mine-h23-1 | gentle-fox-b5 | 8×B300 | $63.60 | 2026-08-08T00:09:46Z | H23 TP×Talucampe α0.90 | merge shard 15/16 |
| mine-h24-1 | brave-orbit-31 | 8×H200 | $28.00 | 2026-08-08T00:17:17Z | H24 TP×0ronoCris α0.90 | **n80 live** |
| mine-h25-1 | golden-shark-c8 | 8×H200 | $28.00 | 2026-08-08T00:08:24Z | H25 TP×Radiant28/m7 | n80 ~18/80 |
| mine-h26-1 | swift-matrix-98 | 8×H200 | $31.92 | 2026-08-08T01:20:36Z | H26 TP×kkk-af α0.90 | kkk DL ~44G |
| mine-h27-1 | noble-orbit-fb | 8×H200 | $31.92 | 2026-08-08T05:34:02Z | H27 winner-zA LoRA | bootstrap→train |

SSH: h23 .244:40300 · h24 .234:40311 · h25 .232:40305 · h26 .22:20100 · h27 .21:20099
known_hosts `/tmp/mine-h{23..27}-1.known_hosts` · **Free slots: 0**. Cap 5.

## Dead

| name | final spent | removed UTC | reason |
|---|---|---|---|
| mine-h21-1 | ~$46 | 2026-08-07T17:20Z | H21 REFUTE m=−0.00682 |
| mine-h22-1 | ~$52 | 2026-08-07T17:20Z | H22 REFUTE m=−0.01179 |
| mine-h20-1 | ~$45 | 2026-08-07T16:17Z | H20 REFUTE m=−0.01168 |

## Recent reconciles (last 3)

| UTC | lium ps mine-* | action |
|---|---|---|
| 2026-08-07T17:35Z | h23–27 match | rented h27; H24 n80 live; H25@18/80 |
| 2026-08-07T17:27Z | h23–26 match | H25 n80 live; H24 chall Triton recover |
| 2026-08-07T17:20Z | h23–26; rm h21+h22 | H21/H22 REFUTE; rent h26 |
