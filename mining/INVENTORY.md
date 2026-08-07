# INVENTORY — mine-* pods only

**Cap: 40 lines.** Live table + last 3 reconciles. Never touch non-`mine-*`.
Pre-compaction: `archive/INVENTORY-full-2026-08-07.md`.

## Live

| name | huid | gpu | $/hr | remove_at | purpose | status |
|---|---|---|---|---|---|---|
| mine-h5c-1 | golden-hawk-dc | 8×H200 | $28.00 | 2026-08-07T19:37:46Z | H6 train+mid50+pipe | train~75; mid50~19/40 |
| mine-h8-1 | zesty-fox-15 | 8×H200 | $28.00 | ~2026-08-07T19:32:53Z | H8 TP×golden-crown α0.75 | n80~71/80 + fix |
| mine-h9-1 | noble-lion-ac | 8×H200 | $31.92 | ~2026-08-07T20:07Z | H9 TP×diane613 α0.75 | n80 RUNNING |
| mine-h10-1 | gentle-eagle-d5 | 8×H200 | $31.92 | ~2026-08-07T20:10Z | H10 TP×kevin α0.75 | kevin dl ~31G |

mine-h5c-1: SSH 152.236.142.234:40298 · spent~$79
mine-h8-1: SSH 152.236.142.237:40301 · n80 + fix · spent~$26
mine-h9-1: SSH 38.255.28.21:20100 · n80 + fix · spent~$11
mine-h10-1: SSH 38.255.28.19:20099 · bootstrap · spent~$8
known_hosts `/tmp/mine-h{5c,8,9,10}-1.known_hosts`
**Free slot: 1** (H7 torn down). Cap 5.

## Dead

| name | final spent | removed UTC | reason |
|---|---|---|---|
| mine-h7-1 | ~$28 | 2026-08-07T12:27:40Z | H7 REFUTE base×2.21 band |
| mine-sim-1 | ~$252 | 2026-08-07T09:33:06Z | idle after H5b; H5c autopsy was CPU-only |

## Recent reconciles (last 3)

| UTC | lium ps mine-* | action |
|---|---|---|
| 2026-08-07T12:27:40Z | h5c+h8+h9+h10 RUNNING | H7 REFUTE; `lium rm mine-h7-1`; H9 n80 live |
| 2026-08-07T12:20:07Z | h5c+h7+h8+h9+h10 RUNNING | deployed H6 nested fix-watchers; H9 MERGE_DONE |
| 2026-08-07T12:15:55Z | h5c+h7+h8+h9+h10 RUNNING | nested-verdict decision fix deployed |
