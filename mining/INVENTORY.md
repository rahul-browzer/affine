# INVENTORY — mine-* pods only

**Cap: 40 lines.** Live table + last 3 reconciles. Never touch non-`mine-*`.
Pre-compaction: `archive/INVENTORY-full-2026-08-07.md`.

## Live

| name | huid | gpu | $/hr | remove_at | purpose | status |
|---|---|---|---|---|---|---|
| mine-h23-1 | gentle-fox-b5 | 8×B300 | $63.60 | 2026-08-08T00:09:46Z | H23 TP×Talucampe α0.90 | t up; k/c compile |
| mine-h24-1 | brave-orbit-31 | 8×H200 | $28.00 | 2026-08-08T00:17:17Z | H24 TP×0ronoCris α0.90 | n80 ~33/80 |
| mine-h25-1 | golden-shark-c8 | 8×H200 | $28.00 | 2026-08-08T00:08:24Z | H25 TP×Radiant28/m7 | n80 ~72/80 |
| mine-h26-1 | swift-matrix-98 | 8×H200 | $31.92 | 2026-08-08T01:20:36Z | H26 TP×kkk-af α0.90 | n80 @1/80 |
| mine-h27-1 | noble-orbit-fb | 8×H200 | $31.92 | 2026-08-08T05:34:02Z | H27 winner-zA LoRA | train ~30/51 |

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
| 2026-08-07T18:02Z | h23–27 match | H26 n80+form armed; H25@72 H24@33 H27@30/51 H23 t=200 |
| 2026-08-07T17:59Z | h23–27 match | reset H23 wait (orphan); H25@64 H26 merge+serve H27@25/51 |
| 2026-08-07T17:56Z | h23–27 match | re-arm H24/H25 form+retry; H23 engine relaunch; H25@61 H26@15/16 |
