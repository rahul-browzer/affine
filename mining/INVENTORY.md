# INVENTORY — mine-* pods only

**Cap: 40 lines.** Live table + last 3 reconciles. Never touch non-`mine-*`.
Pre-compaction: `archive/INVENTORY-full-2026-08-07.md`.

## Live

| name | huid | gpu | $/hr | remove_at | purpose | status |
|---|---|---|---|---|---|---|
| mine-h30-1 | golden-hawk-9f | 8×H200 | $31.92 | ~2026-08-08T07:39Z | H30 m7×king-self | n80 ~46/80 |
| mine-h31-1 | golden-raven-d8 | 8×H200 | $28.00 | ~2026-08-08T07:42Z | H31 m7×ks lr3e5 | n80 ~36/80 |
| mine-h32-1 | noble-raven-24 | 8×B200 | $40.00 | ~2026-08-08T07:48Z | H32 TP×ks lr3e5 | n80 ~29/80 |
| mine-h33-1 | gentle-comet-aa | 8×H200 | $28.00 | ~2026-08-08T08:15Z | H33 TP×ks ep2 | chall loading |
| mine-h34-1 | calm-wolf-a8 | 8×H200 | $31.92 | ~2026-08-08T08:59Z | H34 m7×ks ep2 | bootstrap |

SSH: h30 .22:20100 · h31 .236:40301 · h32 150.136.71.147:20300 ·
h33 .232:40309 · h34 .19:20100 ·
known_hosts `/tmp/mine-h3{0,1,2,4}-1.known_hosts` + `/tmp/mine-h33-1.known_hosts` ·
**Free: 0**. Cap 5.

## Dead

| name | final spent | removed UTC | reason |
|---|---|---|---|
| mine-h29-1 | ~$48 | 2026-08-07T20:59Z | H29 REFUTE m=−0.01527 |
| mine-h28-1 | ~$57 | 2026-08-07T20:13Z | H28 REFUTE m=+0.01095 |
| mine-h23-1 | ~$204 | 2026-08-07T19:24Z | H23 REFUTE m=−0.00777 |
| mine-h27-1 | ~$58 | 2026-08-07T19:23Z | H27 REFUTE m=−0.00792 |
| mine-h26-1 | ~$44 | 2026-08-07T18:43Z | H26 REFUTE m=+0.00592 |
| mine-h24-1 | ~$62 | 2026-08-07T18:29Z | H24 REFUTE m=−0.00466 |

## Recent reconciles (last 3)

| UTC | lium ps mine-* | action |
|---|---|---|
| 2026-08-07T21:00Z | h30–h34 match | H29 REFUTE+rm; rented h34; H33 merge done |
| 2026-08-07T20:42Z | h29–h33 match | H31 chall probe ok→n80; H32 n80~15; H29~49 |
| 2026-08-07T20:36Z | h29–h33 match | H31 false REFUTE quarantine+chall recover193 |
