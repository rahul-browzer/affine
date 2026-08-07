# INVENTORY — mine-* pods only

**Cap: 40 lines.** Live table + last 3 reconciles. Never touch non-`mine-*`.
Pre-compaction: `archive/INVENTORY-full-2026-08-07.md`.

## Live

| name | huid | gpu | $/hr | remove_at | purpose | status |
|---|---|---|---|---|---|---|
| mine-h14-1 | swift-orbit-cd | 8×H200 | $31.92 | 2026-08-07T21:38:17Z | H14 TP×kkkk α0.75 | n80 ~55/80 |
| mine-h15-1 | cosmic-shark-43 | 8×H200 | $28.00 | 2026-08-07T21:42:24Z | H15 TP×leary α0.75 | n80 ~43/80 |
| mine-h16-1 | cosmic-eagle-2d | 8×H200 | $28.00 | 2026-08-07T21:51:17Z | H16 TP×plmk α0.90 | n80 ~14/80 |
| mine-h17-1 | cosmic-orbit-9b | 8×H200 | $31.92 | 2026-08-07T21:56:20Z | H17 TP×kkk-af α0.90 | serve→n80 |
| mine-h18-1 | zesty-hawk-bc | 8×H200 | $5.66 | 2026-08-07T22:35:39Z | H18 TP×Shatoria α0.75 | bootstrap |

SSH: h14 .19:20100 · h15 152.236.142.232:40309 · h16 .237:40109 · h17 .21:20099 · h18 18.116.62.104:20119
known_hosts `/tmp/mine-h{14..18}-1.known_hosts` · **Free slot: 0**. Cap 5.

## Dead

| name | final spent | removed UTC | reason |
|---|---|---|---|
| mine-h13-1 | ~$34 | 2026-08-07T14:35Z | H13 REFUTE base×2.047 |
| mine-h12-1 | ~$31 | 2026-08-07T13:49Z | H12 REFUTE base×2.017 |
| mine-h5c-1 | ~$116 | 2026-08-07T13:45Z | H6 REFUTE +0.00330 |
| mine-h11-1 | ~$30 | 2026-08-07T13:38Z | H11 REFUTE base×1.866 |
| mine-h9-1 | ~$48 | 2026-08-07T13:38Z | H9 REFUTE base×1.851 |
| mine-h10-1 | ~$40 | 2026-08-07T13:31Z | H10 REFUTE base×1.983 |
| mine-h7/8/sim | ~$307 | earlier | H7/H8 band refute; sim idle |

## Recent reconciles (last 3)

| UTC | lium ps mine-* | action |
|---|---|---|
| 2026-08-07T14:36Z | h14–h18 match | H13 REFUTE rm; rented mine-h18-1 @$5.66/h |
| 2026-08-07T14:30Z | h13–h17 match | H16 teacher Triton recover + n80 retry; no rm/rent |
| 2026-08-07T14:22Z | h13–h17 match | H16 king=200→n80 live; H17 parents done; no rm/rent |
