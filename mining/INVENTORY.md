# INVENTORY — mine-* pods only

**Cap: 40 lines.** Live table + last 3 reconciles. Never touch non-`mine-*`.
Pre-compaction: `archive/INVENTORY-full-2026-08-07.md`.

## Live

| name | huid | gpu | $/hr | remove_at | purpose | status |
|---|---|---|---|---|---|---|
| mine-h5c-1 | golden-hawk-dc | 8×H200 | $28.00 | 2026-08-07T19:37:46Z | H6 train+mid50+pipe | train~50/99; mid50 merge |
| mine-h7-1 | lunar-orbit-1b | 8×H200 | $28.00 | ~2026-08-07T19:28:24Z | H7 TP×pandora α0.75 | n80~43/80 |
| mine-h8-1 | zesty-fox-15 | 8×H200 | $28.00 | ~2026-08-07T19:32:53Z | H8 TP×golden-crown α0.75 | n80~34/80 |
| mine-h9-1 | noble-lion-ac | 8×H200 | $31.92 | ~2026-08-07T20:07Z | H9 TP×diane613 α0.75 | boot pipelin 863 |

mine-h5c-1: SSH 152.236.142.234:40298 · train 46680 · mid50 63689 · pipe 53727 · spent~$70
mine-h7-1: SSH 152.236.142.232:40299 · n80 11769 · spent~$18
mine-h8-1: SSH 152.236.142.237:40301 · n80 12199 · spent~$16
mine-h9-1: SSH 38.255.28.21:20100 · pipeline 863 · spent~$0
known_hosts `/tmp/mine-h{5c,7,8,9}-1.known_hosts`

## Dead

| name | final spent | removed UTC | reason |
|---|---|---|---|
| mine-sim-1 | ~$252 | 2026-08-07T09:33:06Z | idle after H5b; H5c autopsy was CPU-only |

## Recent reconciles (last 3)

| UTC | lium ps mine-* | action |
|---|---|---|
| 2026-08-07T12:07:24Z | h5c+h7+h8+h9 RUNNING | rented mine-h9-1; H9 pipeline launched |
| 2026-08-07T12:04:33Z | h5c+h7+h8 RUNNING | matches; launched H6 mid50 waiter 63689 |
| 2026-08-07T12:01:20Z | h5c+h7+h8 RUNNING | matches; H5c n80 REFUTE recorded; H8 n80 live |
