# INVENTORY — mine-* pods only

**Cap: 40 lines.** Live table + last 3 reconciles. Never touch non-`mine-*`.
Pre-compaction: `archive/INVENTORY-full-2026-08-07.md`.

## Live

| name | huid | gpu | $/hr | remove_at | purpose | status |
|---|---|---|---|---|---|---|
| mine-h32-1 | noble-raven-24 | 8×B200 | $40.00 | ~2026-08-08T07:48Z | H32 TP×ks lr3e5 | n80 a198 relaunch |
| mine-h33-1 | gentle-comet-aa | 8×H200 | $28.00 | ~2026-08-08T08:15Z | H33 TP×ks ep2 | n80 ~34/80 |
| mine-h34-1 | calm-wolf-a8 | 8×H200 | $31.92 | ~2026-08-08T08:59Z | H34 m7×ks ep2 | train ~50/92 |
| mine-h35-1 | calm-fox-12 | 8×H200 | $31.92 | ~2026-08-08T09:19Z | H35 m7×ks lr1e4 | train |
| mine-h36-1 | calm-orbit-65 | 8×H200 | $31.92 | ~2026-08-08T09:21Z | H36 m7×union | train+extra_dl |

SSH: h32 .147:20300 · h33 .232:40309 · h34 .19:20100 · h35 .21:20100 ·
h36 .22:20098 · known_hosts `/tmp/mine-h3{2,3,4,5,6}-1.known_hosts` ·
**Free: 0**. Cap 5.

## Dead

| name | final spent | removed UTC | reason |
|---|---|---|---|
| mine-h31-1 | ~$40 | 2026-08-07T21:20Z | H31 REFUTE m=+0.00016 |
| mine-h30-1 | ~$47 | 2026-08-07T21:17Z | H30 REFUTE m=−0.00316 |
| mine-h29-1 | ~$48 | 2026-08-07T20:59Z | H29 REFUTE m=−0.01527 |
| mine-h28-1 | ~$57 | 2026-08-07T20:13Z | H28 REFUTE m=+0.01095 |
| mine-h23-1 | ~$204 | 2026-08-07T19:24Z | H23 REFUTE m=−0.00777 |
| mine-h27-1 | ~$58 | 2026-08-07T19:23Z | H27 REFUTE m=−0.00792 |

## Recent reconciles (last 3)

| UTC | lium ps mine-* | action |
|---|---|---|
| 2026-08-07T21:26Z | h32–h36 match | H32 n80 recover; H36 bootstrap recover |
| 2026-08-07T21:22Z | h32–h36 match | H30/H31 REFUTE+rm; rented h35+h36 |
| 2026-08-07T21:06Z | h30–h34 match | H33 chall OK→n80; H34 train; H30~59 |
