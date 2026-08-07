# INVENTORY — mine-* pods only

**Cap: 40 lines.** Live table + last 3 reconciles. Never touch non-`mine-*`.
Pre-compaction: `archive/INVENTORY-full-2026-08-07.md`.

## Live

| name | huid | gpu | $/hr | remove_at | purpose | status |
|---|---|---|---|---|---|---|
| mine-h16-1 | cosmic-eagle-2d | 8×H200 | $28.00 | 2026-08-07T21:51:17Z | H16 TP×plmk α0.90 | n80 ~42/80 |
| mine-h17-1 | cosmic-orbit-9b | 8×H200 | $31.92 | 2026-08-07T21:56:20Z | H17 TP×kkk-af α0.90 | n80 ~28/80 |
| mine-h18-1 | zesty-hawk-bc | 8×H200 | $5.66 | 2026-08-07T22:35:39Z | H18 TP×Shatoria α0.75 | serve→n80 |
| mine-h19-1 | eager-eagle-c6 | 8×H200 | $28.00 | 2026-08-07T22:49:58Z | H19 TP×kkkk α0.90 | bootstrap |
| mine-h20-1 | swift-lion-ac | 8×H200 | $31.92 | 2026-08-07T22:52:59Z | H20 TP×leary α0.90 | bootstrap |

SSH: h16 .237:40109 · h17 .21:20099 · h18 18.116.62.104:20119 · h19 .234:40297 · h20 .22:20100
known_hosts `/tmp/mine-h{16..20}-1.known_hosts` · **Free slot: 0**. Cap 5.

## Dead

| name | final spent | removed UTC | reason |
|---|---|---|---|
| mine-h15-1 | ~$33 | 2026-08-07T14:52Z | H15 REFUTE base×2.107 |
| mine-h14-1 | ~$38 | 2026-08-07T14:49Z | H14 REFUTE base×2.044 |
| mine-h13-1 | ~$34 | 2026-08-07T14:35Z | H13 REFUTE base×2.047 |
| mine-h12-1 | ~$31 | 2026-08-07T13:49Z | H12 REFUTE base×2.017 |
| mine-h5c-1 | ~$116 | 2026-08-07T13:45Z | H6 REFUTE +0.00330 |
| mine-h11/9/10 | ~$118 | earlier | H11/H9/H10 band refute |
| mine-h7/8/sim | ~$307 | earlier | H7/H8 band; sim idle |

## Recent reconciles (last 3)

| UTC | lium ps mine-* | action |
|---|---|---|
| 2026-08-07T14:53Z | h16–h20 match | H14/H15 REFUTE rm; rented h19+h20 α0.90 hedges |
| 2026-08-07T14:36Z | h14–h18 match | H13 REFUTE rm; rented mine-h18-1 @$5.66/h |
| 2026-08-07T14:30Z | h13–h17 match | H16 teacher Triton recover + n80 retry; no rm/rent |
