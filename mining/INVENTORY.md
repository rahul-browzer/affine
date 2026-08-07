# INVENTORY — mine-* pods only

**Cap: 40 lines.** Live table + last 3 reconciles. Never touch non-`mine-*`.
Pre-compaction: `archive/INVENTORY-full-2026-08-07.md`.

## Live

| name | huid | gpu | $/hr | remove_at | purpose | status |
|---|---|---|---|---|---|---|
| mine-h28-1 | swift-hawk-e1 | 8×H200 | $28.00 | ~2026-08-08T06:11Z | H28 m7-init winner-zA | king recover→n80 |
| mine-h29-1 | golden-wolf-bc | 8×H200 | $31.92 | ~2026-08-08T07:28Z | H29 king-self clip-L1 | bootstrap→train |

SSH: h28 .232:40311 · h29 .21:20100 · known_hosts `/tmp/mine-h2{8,9}-1.known_hosts` · **Free: 3**. Cap 5.

## Dead

| name | final spent | removed UTC | reason |
|---|---|---|---|
| mine-h23-1 | ~$204 | 2026-08-07T19:24Z | H23 REFUTE m=−0.00777 |
| mine-h27-1 | ~$58 | 2026-08-07T19:23Z | H27 REFUTE m=−0.00792 |
| mine-h26-1 | ~$44 | 2026-08-07T18:43Z | H26 REFUTE m=+0.00592 |
| mine-h24-1 | ~$62 | 2026-08-07T18:29Z | H24 REFUTE m=−0.00466 |
| mine-h25-1 | ~$55 | 2026-08-07T18:06Z | H25 REFUTE m=+0.00662 |
| mine-h21-1 | ~$46 | 2026-08-07T17:20Z | H21 REFUTE m=−0.00682 |
| mine-h22-1 | ~$52 | 2026-08-07T17:20Z | H22 REFUTE m=−0.01179 |

## Recent reconciles (last 3)

| UTC | lium ps mine-* | action |
|---|---|---|
| 2026-08-07T19:29Z | h28+h29 match | rented h29 @$31.92/h ttl12h; H29 bootstrap up |
| 2026-08-07T19:24Z | h28 only | rm h27+h23 after REFUTE; H28 king relaunch |
| 2026-08-07T19:07Z | h23/27/28 match | re-armed form on all 3; n80 32/53/7 |
