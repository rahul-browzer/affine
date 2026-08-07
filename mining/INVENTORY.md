# INVENTORY — mine-* pods only

**Cap: 40 lines.** Live table + last 3 reconciles. Never touch non-`mine-*`.
Pre-compaction: `archive/INVENTORY-full-2026-08-07.md`.

## Live

| name | huid | gpu | $/hr | remove_at | purpose | status |
|---|---|---|---|---|---|---|
| mine-h34-1 | calm-wolf-a8 | 8×H200 | $31.92 | ~2026-08-08T08:59Z | H34 m7×ks ep2 | n80 ~31/80 |
| mine-h35-1 | calm-fox-12 | 8×H200 | $31.92 | ~2026-08-08T09:19Z | H35 m7×ks lr1e4 | chall load |
| mine-h36-1 | calm-orbit-65 | 8×H200 | $31.92 | ~2026-08-08T09:21Z | H36 m7×union | chall load |
| mine-h37-1 | swift-matrix-54 | 8×H200 | $28.00 | ~2026-08-08T09:53Z | H37 m7×wZA lr1e4 | train |
| mine-h38-1 | golden-matrix-b9 | 8×H200 | $28.00 | ~2026-08-08T09:52Z | H38 m7×wZA ep2 | train |

SSH: h34 .19:20100 · h35 .21:20100 · h36 .22:20098 · h37 .232:40311 ·
h38 .236:40298 · known_hosts `/tmp/mine-h3{4,5,6,7,8}-1.known_hosts` ·
**Free: 0**. Cap 5. Burn ~$151.8/h mining.

## Dead

| name | final spent | removed UTC | reason |
|---|---|---|---|
| mine-h37-1 (eager-lion-11) | ~$0.2 | 2026-08-07T21:53Z | REJECT 4 GPU @$11.6 |
| mine-h33-1 | ~$42 | 2026-08-07T21:51Z | H33 REFUTE m=−0.00158 |
| mine-h32-1 | ~$80 | 2026-08-07T21:51Z | H32 REFUTE m=−0.00601 |
| mine-h31-1 | ~$40 | 2026-08-07T21:20Z | H31 REFUTE m=+0.00016 |
| mine-h30-1 | ~$47 | 2026-08-07T21:17Z | H30 REFUTE m=−0.00316 |
| mine-h29-1 | ~$48 | 2026-08-07T20:59Z | H29 REFUTE m=−0.01527 |

## Recent reconciles (last 3)

| UTC | lium ps mine-* | action |
|---|---|---|
| 2026-08-07T22:19Z | h34–h38 match | H34 n80; H35/H36 engine recover+chall; H37/H38 train |
| 2026-08-07T22:03Z | h34–h38 match | H34 n80 up; H37/H38 train; H35/H36 merge |
| 2026-08-07T21:54Z | h34–h38 match | H32/H33 REFUTE+rm; H37/H38 up |
