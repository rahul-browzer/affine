# INVENTORY — mine-* pods only

**Cap: 40 lines.** Live table + last 3 reconciles. Never touch non-`mine-*`.
Pre-compaction: `archive/INVENTORY-full-2026-08-07.md`.

## Live

| name | huid | gpu | $/hr | remove_at | purpose | status |
|---|---|---|---|---|---|---|
| mine-h5c-1 | golden-hawk-dc | 8×H200 | $28.00 | 2026-08-07T19:37:46Z | H6 train+mid50+pipe | train~90; mid50 retry |
| mine-h9-1 | noble-lion-ac | 8×H200 | $31.92 | ~2026-08-07T20:07Z | H9 TP×diane613 α0.75 | n80~26/80 |
| mine-h10-1 | gentle-eagle-d5 | 8×H200 | $31.92 | ~2026-08-07T20:10Z | H10 TP×kevin α0.75 | kevin dl ~65G |
| mine-h11-1 | swift-fox-b5 | 8×H200 | $28.00 | ~2026-08-07T20:33Z | H11 TP×adambell α0.75 | mirror resume dl |

mine-h5c-1: SSH 152.236.142.234:40298 · spent~$83
mine-h9-1: SSH 38.255.28.21:20100 · spent~$15
mine-h10-1: SSH 38.255.28.19:20099 · spent~$13
mine-h11-1: SSH 152.236.142.232:40311 · spent~$1
known_hosts `/tmp/mine-h{5c,9,10,11}-1.known_hosts`
**Free slot: 1**. Cap 5.

## Dead

| name | final spent | removed UTC | reason |
|---|---|---|---|
| mine-h8-1 | ~$27 | 2026-08-07T12:32:00Z | H8 REFUTE base×1.97 band |
| mine-h7-1 | ~$28 | 2026-08-07T12:27:40Z | H7 REFUTE base×2.21 band |
| mine-sim-1 | ~$252 | 2026-08-07T09:33:06Z | idle after H5b; H5c autopsy was CPU-only |

## Recent reconciles (last 3)

| UTC | lium ps mine-* | action |
|---|---|---|
| 2026-08-07T12:38Z | h5c+h9+h10+h11 RUNNING | mid50 ReadTimeout→retry; H11 404→0pentensor mirror; client timeout 480s×5 |
| 2026-08-07T12:33:40Z | h5c+h9+h10+h11 RUNNING | H8 REFUTE rm; rented mine-h11-1; H11 boot |
| 2026-08-07T12:27:40Z | h5c+h8+h9+h10 RUNNING | H7 REFUTE; `lium rm mine-h7-1`; H9 n80 live |
