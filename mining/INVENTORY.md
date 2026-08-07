# INVENTORY — mine-* pods only

**Cap: 40 lines.** Live table + last 3 reconciles. Never touch non-`mine-*`.
Pre-compaction: `archive/INVENTORY-full-2026-08-07.md`.

## Live

| name | huid | gpu | $/hr | remove_at | purpose | status |
|---|---|---|---|---|---|---|
| mine-h5c-1 | golden-hawk-dc | 8×H200 | $28.00 | 2026-08-07T19:37:46Z | H6 final n80 | mid50 SIGNAL_NEG; chall load |
| mine-h9-1 | noble-lion-ac | 8×H200 | $31.92 | ~2026-08-07T20:07Z | H9 TP×diane613 α0.75 | n80 retry 1/3 |
| mine-h10-1 | gentle-eagle-d5 | 8×H200 | $31.92 | ~2026-08-07T20:10Z | H10 TP×kevin α0.75 | n80~19/80 |
| mine-h11-1 | swift-fox-b5 | 8×H200 | $28.00 | ~2026-08-07T20:33Z | H11 TP×adambell α0.75 | n80~7/80 |
| mine-h12-1 | calm-hawk-89 | 8×H200 | $28.00 | 2026-08-07T20:42:45Z | H12 TP×plmk α0.75 | merge~15/16 |

mine-h5c-1: SSH 152.236.142.234:40298 · spent~$94
mine-h9-1: SSH 38.255.28.21:20100 · spent~$28
mine-h10-1: SSH 38.255.28.19:20099 · spent~$25
mine-h11-1: SSH 152.236.142.232:40311 · spent~$12
mine-h12-1: SSH 152.236.142.237:40311 · spent~$7
known_hosts `/tmp/mine-h{5c,9,10,11,12}-1.known_hosts`
**Free slot: 0**. Cap 5. H13 staged (no pod yet).

## Dead

| name | final spent | removed UTC | reason |
|---|---|---|---|
| mine-h8-1 | ~$27 | 2026-08-07T12:32:00Z | H8 REFUTE base×1.97 band |
| mine-h7-1 | ~$28 | 2026-08-07T12:27:40Z | H7 REFUTE base×2.21 band |
| mine-sim-1 | ~$252 | 2026-08-07T09:33:06Z | idle after H5b; H5c autopsy was CPU-only |

## Recent reconciles (last 3)

| UTC | lium ps mine-* | action |
|---|---|---|
| 2026-08-07T12:59Z | h5c+h9+h10+h11+h12 RUNNING | H6 mid50 SIGNAL_NEG; H9 n80 retry launched |
| 2026-08-07T12:56Z | h5c+h9+h10+h11+h12 RUNNING | match inv; H13 staged (kkk-af); no rent |
| 2026-08-07T12:51Z | h5c+h9+h10+h11+h12 RUNNING | H12 pivot plmk; resume launched |
