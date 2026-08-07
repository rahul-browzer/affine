# INVENTORY — mine-* pods only

**Cap: 40 lines.** Live table + last 3 reconciles. Never touch non-`mine-*`.
Pre-compaction: `archive/INVENTORY-full-2026-08-07.md`.

## Live

| name | huid | gpu | $/hr | remove_at | purpose | status |
|---|---|---|---|---|---|---|
| mine-h37-1 | swift-matrix-54 | 8×H200 | $28.00 | ~2026-08-08T09:53Z | H37 m7×wZA lr1e4 | n80 @61/80 |
| mine-h38-1 | golden-matrix-b9 | 8×H200 | $28.00 | ~2026-08-08T09:52Z | H38 m7×wZA ep2 | n80 @59/80 |
| mine-h39-1 | swift-wolf-6e | 8×H200 | $33.81 | ~2026-08-08T11:11Z | H39 m7×wZA lr3e5 | n80 a203 sole |
| mine-h40-1 | gentle-eagle-c9 | 8×B200 | $40.00 | ~2026-08-08T11:12Z | H40 m7×wZA ep3 | chall→retry n80 |
| mine-h41-1 | zesty-lion-26 | 8×H200 | $31.92 | ~2026-08-08T11:14Z | H41 m7×wZA r32 | merge+disarm |

SSH: h37 .232:40311 · h38 .236:40298 · h39 .54:40301 · h40 .147:20300 ·
h41 .19:20099 · known_hosts `/tmp/mine-h{37,38,39,40,41}-1.known_hosts` ·
**Free: 0**. Cap 5. Burn ~$161.7/h mining.

## Dead

| name | final spent | removed UTC | reason |
|---|---|---|---|
| mine-h36-1 | ~$59 | 2026-08-07T23:13Z | H36 REFUTE m=+0.00052 |
| mine-h35-1 | ~$59 | 2026-08-07T23:10Z | H35 REFUTE m=+0.01602 |
| mine-h34-1 | ~$69 | 2026-08-07T23:10Z | H34 REFUTE m=+0.00593 |
| mine-h37-1 (eager-lion-11) | ~$0.2 | 2026-08-07T21:53Z | REJECT 4 GPU @$11.6 |
| mine-h33-1 | ~$42 | 2026-08-07T21:51Z | H33 REFUTE m=−0.00158 |
| mine-h32-1 | ~$80 | 2026-08-07T21:51Z | H32 REFUTE m=−0.00601 |

## Recent reconciles (last 3)

| UTC | lium ps mine-* | action |
|---|---|---|
| 2026-08-07T23:52Z | h37–h41 match | H39 bare-n80 kill; H40 disarm; H41 disarm armed |
| 2026-08-07T23:45Z | h37–h41 match | H40 teacher recover p210; train.done |
| 2026-08-07T23:42Z | h37–h41 match | H41 king recover p209; H37/38 n80 mid |
