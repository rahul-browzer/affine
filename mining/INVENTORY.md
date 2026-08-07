# INVENTORY — mine-* pods only

**Cap: 40 lines.** Live table + last 3 reconciles. Never touch non-`mine-*`.
Pre-compaction: `archive/INVENTORY-full-2026-08-07.md`.

## Live

| name | huid | gpu | $/hr | remove_at | purpose | status |
|---|---|---|---|---|---|---|
| mine-h23-1 | gentle-fox-b5 | 8×B300 | $63.60 | 2026-08-08T00:09:46Z | H23 TP×Talucampe α0.90 | n80 ~22/80 |
| mine-h27-1 | noble-orbit-fb | 8×H200 | $31.92 | 2026-08-08T05:34:02Z | H27 winner-zA LoRA | n80 ~51/80 + retry |
| mine-h28-1 | swift-hawk-e1 | 8×H200 | $28.00 | ~2026-08-08T06:11Z | H28 m7-init winner-zA | n80 attempt=1 live |

SSH: h23 .244:40300 · h27 .21:20099 · h28 .232:40311
known_hosts `/tmp/mine-h{23,27,28}-1.known_hosts` · **Free slots: 2**. Cap 5.

## Dead

| name | final spent | removed UTC | reason |
|---|---|---|---|
| mine-h26-1 | ~$44 | 2026-08-07T18:43Z | H26 REFUTE m=+0.00592 |
| mine-h24-1 | ~$62 | 2026-08-07T18:29Z | H24 REFUTE m=−0.00466 |
| mine-h25-1 | ~$55 | 2026-08-07T18:06Z | H25 REFUTE m=+0.00662 |
| mine-h21-1 | ~$46 | 2026-08-07T17:20Z | H21 REFUTE m=−0.00682 |
| mine-h22-1 | ~$52 | 2026-08-07T17:20Z | H22 REFUTE m=−0.01179 |

## Recent reconciles (last 3)

| UTC | lium ps mine-* | action |
|---|---|---|
| 2026-08-07T19:05Z | h23/27/28 match | H28 merge→chall probe=200→n80; H27~51; H23~22 |
| 2026-08-07T18:56Z | h23/27/28 match | H23 n80 launched; H28 merge; H27~30/80 |
| 2026-08-07T18:51Z | h23/27/28 match | H28 TRAIN_DONE→merge; armed h27/h28 retry |
