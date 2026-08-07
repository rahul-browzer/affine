# INVENTORY — mine-* pods only

**Cap: 40 lines.** Live table + last 3 reconciles. Never touch non-`mine-*`.
Pre-compaction: `archive/INVENTORY-full-2026-08-07.md`.

## Live

| name | huid | gpu | $/hr | remove_at | purpose | status |
|---|---|---|---|---|---|---|
| mine-h12-1 | calm-hawk-89 | 8×H200 | $28.00 | 2026-08-07T20:42:45Z | H12 TP×plmk α0.75 | n80 ~75/80 |
| mine-h13-1 | zesty-orbit-df | 8×H200 | $31.92 | ~2026-08-07T21:32Z | H13 TP×kkk-af α0.75 | merging |
| mine-h14-1 | swift-orbit-cd | 8×H200 | $31.92 | 2026-08-07T21:38:17Z | H14 TP×kkkk α0.75 | DL kkkk |
| mine-h15-1 | cosmic-shark-43 | 8×H200 | $28.00 | 2026-08-07T21:42:24Z | H15 TP×leary α0.75 | bootstrap pid 830 |

mine-h12-1: SSH 152.236.142.237:40311 · spent~$29
mine-h13-1: SSH 38.255.28.22:20099 · spent~$7
mine-h14-1: SSH 38.255.28.19:20100 · spent~$4
mine-h15-1: SSH 152.236.142.232:40309 · spent~$2
known_hosts `/tmp/mine-h{12,13,14,15}-1.known_hosts`
**Free slot: 1**. Cap 5.

## Dead

| name | final spent | removed UTC | reason |
|---|---|---|---|
| mine-h5c-1 | ~$116 | 2026-08-07T13:45Z | H6 REFUTE +0.00330 (pod also ran H5c) |
| mine-h11-1 | ~$30 | 2026-08-07T13:38Z | H11 REFUTE base×1.866 band |
| mine-h9-1 | ~$48 | 2026-08-07T13:38Z | H9 REFUTE base×1.851 band |
| mine-h10-1 | ~$40 | 2026-08-07T13:31Z | H10 REFUTE base×1.983 band |
| mine-h8-1 | ~$27 | 2026-08-07T12:32:00Z | H8 REFUTE base×1.97 band |
| mine-h7-1 | ~$28 | 2026-08-07T12:27:40Z | H7 REFUTE base×2.21 band |
| mine-sim-1 | ~$252 | 2026-08-07T09:33:06Z | idle after H5b |

## Recent reconciles (last 3)

| UTC | lium ps mine-* | action |
|---|---|---|
| 2026-08-07T13:45Z | h12+h13+h14+h15; rm h5c | H6 REFUTE; rented+launched H15 |
| 2026-08-07T13:38Z | h5c+h12+h13; rm h9+h11; rent h14 | H9/H11 REFUTE band; H14 boot |
| 2026-08-07T13:32Z | h5c+h9+h11+h12+h13 RUNNING | H10 REFUTE→rm; rented h13 |
