# INVENTORY — mine-* pods only

**Cap: 40 lines.** Live table + last 3 reconciles. Never touch non-`mine-*`.
Pre-compaction: `archive/INVENTORY-full-2026-08-07.md`.

## Live

| name | huid | gpu | $/hr | remove_at | purpose | status |
|---|---|---|---|---|---|---|
| mine-h39-1 | swift-wolf-6e | 8×H200 | $33.81 | ~2026-08-08T11:11Z | H39 m7×wZA lr3e5 | n80 a203 ~46/80 |
| mine-h40-1 | gentle-eagle-c9 | 8×B200 | $40.00 | ~2026-08-08T11:12Z | H40 m7×wZA ep3 | chall p216 load |
| mine-h41-1 | zesty-lion-26 | 8×H200 | $31.92 | ~2026-08-08T11:14Z | H41 m7×wZA r32 | n80 a203 ~8/80 |
| mine-h42-1 | cosmic-matrix-bb | 8×H200 | $31.92 | ~2026-08-08T12:04Z | H42 m7×wZA lr5e6 | merging |
| mine-h43-1 | noble-eagle-18 | 8×H200 | $31.92 | ~2026-08-08T12:05Z | H43 m7×wZA α64 | merging |

SSH: h39 .54:40301 · h40 .147:20300 · h41 .19:20099 · h42 .21:20100 ·
h43 .22:20099 · known_hosts `/tmp/mine-h{39,40,41,42,43}-1.known_hosts` ·
**Free: 0**. Cap 5. Burn ~$169.6/h mining.

## Dead

| name | final spent | removed UTC | reason |
|---|---|---|---|
| mine-h38-1 | ~$61 | 2026-08-08T00:03Z | H38 REFUTE m=−0.00037 |
| mine-h37-1 | ~$61 | 2026-08-08T00:03Z | H37 REFUTE m=−0.00088 |
| mine-h36-1 | ~$59 | 2026-08-07T23:13Z | H36 REFUTE m=+0.00052 |
| mine-h35-1 | ~$59 | 2026-08-07T23:10Z | H35 REFUTE m=+0.01602 |
| mine-h34-1 | ~$69 | 2026-08-07T23:10Z | H34 REFUTE m=+0.00593 |
| mine-h37-1 (eager-lion-11) | ~$0.2 | 2026-08-07T21:53Z | REJECT 4 GPU @$11.6 |

## Recent reconciles (last 3)

| UTC | lium ps mine-* | action |
|---|---|---|
| 2026-08-08T00:20Z | h39–h43 match | H40 chall recover p216 (isolated TCACHE) |
| 2026-08-08T00:16Z | h39–h43 match | H40 chall recover p215 (triton) |
| 2026-08-08T00:08Z | h39–h43 match | H40/H41 chall recover p214 (triton) |
