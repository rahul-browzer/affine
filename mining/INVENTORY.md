# INVENTORY — mine-* pods only

**Cap: 40 lines.** Live table + last 3 reconciles. Never touch non-`mine-*`.
Pre-compaction: `archive/INVENTORY-full-2026-08-07.md`.

## Live

| name | huid | gpu | $/hr | remove_at | purpose | status |
|---|---|---|---|---|---|---|
| mine-h5c-1 | golden-hawk-dc | 8×H200 | $28.00 | 2026-08-07T19:37:46Z | H6 train+mid50+pipe | train~80; mid50~29/40 |
| mine-h9-1 | noble-lion-ac | 8×H200 | $31.92 | ~2026-08-07T20:07Z | H9 TP×diane613 α0.75 | n80~15/80 |
| mine-h10-1 | gentle-eagle-d5 | 8×H200 | $31.92 | ~2026-08-07T20:10Z | H10 TP×kevin α0.75 | kevin dl ~58G |
| mine-h11-1 | swift-fox-b5 | 8×H200 | $28.00 | ~2026-08-07T20:33Z | H11 TP×adambell α0.75 | boot pip |

mine-h5c-1: SSH 152.236.142.234:40298 · spent~$82
mine-h9-1: SSH 38.255.28.21:20100 · spent~$14
mine-h10-1: SSH 38.255.28.19:20099 · spent~$12
mine-h11-1: SSH 152.236.142.232:40311 · spent~$0
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
| 2026-08-07T12:33:40Z | h5c+h9+h10+h11 RUNNING | H8 REFUTE rm; rented mine-h11-1; H11 boot |
| 2026-08-07T12:27:40Z | h5c+h8+h9+h10 RUNNING | H7 REFUTE; `lium rm mine-h7-1`; H9 n80 live |
| 2026-08-07T12:20:07Z | h5c+h7+h8+h9+h10 RUNNING | deployed H6 nested fix-watchers; H9 MERGE_DONE |
