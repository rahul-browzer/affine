# INVENTORY — mine-* pods only

**Cap: 40 lines.** Live table + last 3 reconciles. Never touch non-`mine-*`.
Pre-compaction: `archive/INVENTORY-full-2026-08-07.md`.

## Live

| name | huid | gpu | $/hr | remove_at | purpose | status |
|---|---|---|---|---|---|---|
| mine-h23-1 | gentle-fox-b5 | 8×B300 | $63.60 | 2026-08-08T00:09:46Z | H23 TP×Talucampe α0.90 | king recover177→n80 |
| mine-h26-1 | swift-matrix-98 | 8×H200 | $31.92 | 2026-08-08T01:20:36Z | H26 TP×kkk-af α0.90 | n80 ~55/80 |
| mine-h27-1 | noble-orbit-fb | 8×H200 | $31.92 | 2026-08-08T05:34:02Z | H27 winner-zA LoRA | merge→n80 |
| mine-h28-1 | swift-hawk-e1 | 8×H200 | $28.00 | ~2026-08-08T06:11Z | H28 m7-init winner-zA | train ~6/51 |

SSH: h23 .244:40300 · h26 .22:20100 · h27 .21:20099 · h28 .232:40311
known_hosts `/tmp/mine-h{23,26,27,28}-1.known_hosts` · **Free slots: 1**. Cap 5.

## Dead

| name | final spent | removed UTC | reason |
|---|---|---|---|
| mine-h24-1 | ~$62 | 2026-08-07T18:29Z | H24 REFUTE m=−0.00466 |
| mine-h25-1 | ~$55 | 2026-08-07T18:06Z | H25 REFUTE m=+0.00662 |
| mine-h21-1 | ~$46 | 2026-08-07T17:20Z | H21 REFUTE m=−0.00682 |
| mine-h22-1 | ~$52 | 2026-08-07T17:20Z | H22 REFUTE m=−0.01179 |

## Recent reconciles (last 3)

| UTC | lium ps mine-* | action |
|---|---|---|
| 2026-08-07T18:29Z | h23/26/27/28; h24 rm | H24 REFUTE+rm; H23 king Triton relaunch |
| 2026-08-07T18:15Z | h23/24/26/27/28 match | H23 king EngineDead→relaunch; no rent/rm |
| 2026-08-07T18:12Z | h23/24/26/27/28 match | rented+launched H28; COUNT=8 |
