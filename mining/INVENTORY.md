# INVENTORY — mine-* pods only

**Cap: 40 lines.** Live table + last 3 reconciles. Never touch non-`mine-*`.
Pre-compaction: `archive/INVENTORY-full-2026-08-07.md`.

## Live

| name | huid | gpu | $/hr | remove_at | purpose | status |
|---|---|---|---|---|---|---|
| mine-h5c-1 | golden-hawk-dc | 8×H200 | $28.00 | 2026-08-07T19:37:46Z | H5c n80 + H6 train+pipe | RUNNING |
| mine-h7-1 | lunar-orbit-1b | 8×H200 | $28.00 | ~2026-08-07T19:28:24Z | H7 TP×pandora α0.75 | MERGE |
| mine-h8-1 | zesty-fox-15 | 8×H200 | $28.00 | ~2026-08-07T19:32:53Z | H8 TP×golden-crown α0.75 | BOOTSTRAP |

mine-h5c-1: SSH 152.236.142.234:40298 · n80 43690 · H6 train 46680 · H6 pipe 53727
mine-h7-1: SSH 152.236.142.232:40299 · pipe 829 · merge ~13/16
mine-h8-1: SSH 152.236.142.237:40301 · pipe 820 · teacher DL
known_hosts `/tmp/mine-h{5c,7,8}-1.known_hosts`

## Dead

| name | final spent | removed UTC | reason |
|---|---|---|---|
| mine-sim-1 | ~$252 | 2026-08-07T09:33:06Z | idle after H5b; H5c autopsy was CPU-only |

## Recent reconciles (last 3)

| UTC | lium ps mine-* | action |
|---|---|---|
| 2026-08-07T11:39:47Z | h5c+h7+h8 RUNNING | matches; uploaded+launched H6 post_train pipe 53727 |
| 2026-08-07T11:33:14Z | h5c+h7+h8 RUNNING | rented mine-h8-1; H8 pipeline launched |
| 2026-08-07T11:29:17Z | mine-h5c-1 + mine-h7-1 RUNNING | rented mine-h7-1; H7 pipeline launched |
