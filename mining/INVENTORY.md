# INVENTORY — mine-* pods only

**Cap: 40 lines.** Live table + last 3 reconciles. Never touch non-`mine-*`.
Pre-compaction: `archive/INVENTORY-full-2026-08-07.md`.

## Live

| name | huid | gpu | $/hr | remove_at | purpose | status |
|---|---|---|---|---|---|---|
| mine-h28-1 | swift-hawk-e1 | 8×H200 | $28.00 | ~2026-08-08T06:11Z | H28 m7×winner-zA | n80 32/80 |
| mine-h29-1 | golden-wolf-bc | 8×H200 | $31.92 | ~2026-08-08T07:28Z | H29 TP×king-self | train ~32/46 |
| mine-h30-1 | golden-hawk-9f | 8×H200 | $31.92 | ~2026-08-08T07:39Z | H30 m7×king-self | train live |
| mine-h31-1 | golden-raven-d8 | 8×H200 | $28.00 | ~2026-08-08T07:42Z | H31 m7×king-self lr3e5 | train live |
| mine-h32-1 | noble-raven-24 | 8×B200 | $40.00 | ~2026-08-08T07:48Z | H32 TP×king-self lr3e5 | bootstrap |

SSH: h28 .232:40311 · h29 .21:20100 · h30 .22:20100 · h31 .236:40301 ·
h32 150.136.71.147:20300 · known_hosts `/tmp/mine-h2{8,9,0,1,2}-1.known_hosts` ·
**Free: 0**. Cap 5.

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
| 2026-08-07T19:48Z | h28–h31 match; H200 rent fail→B200 | rented h32 @$40/h ttl12h |
| 2026-08-07T19:43Z | h28+h29+h30+h31 match | rented h31 @$28/h ttl12h (H31) |
| 2026-08-07T19:39Z | h28+h29+h30 match | rented h30; killed stale h28 form pid876 |
