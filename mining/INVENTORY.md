# INVENTORY — mine-* pods only

**Cap: 40 lines.** Live table + last 3 reconciles. Never touch non-`mine-*`.
Pre-compaction: `archive/INVENTORY-full-2026-08-07.md`.

## Live

| name | huid | gpu | $/hr | remove_at | purpose | status |
|---|---|---|---|---|---|---|
| mine-h29-1 | golden-wolf-bc | 8×H200 | $31.92 | ~2026-08-08T07:28Z | H29 TP×king-self | chall loading |
| mine-h30-1 | golden-hawk-9f | 8×H200 | $31.92 | ~2026-08-08T07:39Z | H30 m7×king-self | merging |
| mine-h31-1 | golden-raven-d8 | 8×H200 | $28.00 | ~2026-08-08T07:42Z | H31 m7×ks lr3e5 | serve→n80 |
| mine-h32-1 | noble-raven-24 | 8×B200 | $40.00 | ~2026-08-08T07:48Z | H32 TP×ks lr3e5 | serve→n80 |
| mine-h33-1 | gentle-comet-aa | 8×H200 | $28.00 | ~2026-08-08T08:15Z | H33 TP×ks ep2 | bootstrap |

SSH: h29 .21:20100 · h30 .22:20100 · h31 .236:40301 ·
h32 150.136.71.147:20300 · h33 .232:40309 ·
known_hosts `/tmp/mine-h2{9,0,1,2}-1.known_hosts` + `/tmp/mine-h33-1.known_hosts` ·
**Free: 0**. Cap 5.

## Dead

| name | final spent | removed UTC | reason |
|---|---|---|---|
| mine-h28-1 | ~$57 | 2026-08-07T20:13Z | H28 REFUTE m=+0.01095 |
| mine-h23-1 | ~$204 | 2026-08-07T19:24Z | H23 REFUTE m=−0.00777 |
| mine-h27-1 | ~$58 | 2026-08-07T19:23Z | H27 REFUTE m=−0.00792 |
| mine-h26-1 | ~$44 | 2026-08-07T18:43Z | H26 REFUTE m=+0.00592 |
| mine-h24-1 | ~$62 | 2026-08-07T18:29Z | H24 REFUTE m=−0.00466 |
| mine-h25-1 | ~$55 | 2026-08-07T18:06Z | H25 REFUTE m=+0.00662 |

## Recent reconciles (last 3)

| UTC | lium ps mine-* | action |
|---|---|---|
| 2026-08-07T20:16Z | h29–h33 match; h28 gone | H28 REFUTE+rm; rented h33 @$28 |
| 2026-08-07T19:52Z | h28–h32 match | relaunched H29/H30 prewarm |
| 2026-08-07T19:48Z | h28–h31 match; H200→B200 | rented h32 @$40/h |
