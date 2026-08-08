# INVENTORY — mine-* pods only

**Cap: 40 lines.** Live table + last 3 reconciles. Never touch non-`mine-*`.
Pre-compaction: `archive/INVENTORY-full-2026-08-07.md`.

## Live

| name | huid | gpu | $/hr | remove_at | purpose | status |
|---|---|---|---|---|---|---|
| mine-h45-1 | lunar-fox-40 | 8×H200 | $28.00 | ~2026-08-08T13:13Z | H45 m7×wZA r8 | n80 ~23/80 |
| mine-h46-1 | cosmic-fox-ea | 8×H200 | $31.92 | ~2026-08-08T13:28Z | H46 m7×wZA lr2.5e-6 | n80 ~61/80 |
| mine-h47-1 | golden-comet-01 | 8×H200 | $31.92 | ~2026-08-08T13:33Z | H47 m7×wZA α8 | n80 ~74/80 |
| mine-h48-1 | zesty-raven-35 | 8×H200 | $31.92 | ~2026-08-08T13:33Z | H48 m7×wZA lr1e-6 | n80 ~66/80 |
| mine-h49-1 | zesty-shark-45 | 8×H200 | $33.81 | ~2026-08-08T13:59Z | H49 m7×wZA α4 | chall recover p230 |

SSH: h45 .236:40299 · h46 .19:20100 · h47 .21:20099 · h48 .22:20100 ·
h49 .54:40300 · known_hosts `/tmp/mine-h{45,46,47,48,49}-1.known_hosts` ·
**Free: 0**. Cap 5. Burn ~$157.6/h mining.

## Dead

| name | final spent | removed UTC | reason |
|---|---|---|---|
| mine-h44-1 | ~$34 | 2026-08-08T01:58Z | H44 REFUTE m=−0.00017 |
| mine-h43-1 | ~$46 | 2026-08-08T01:32Z | H43 REFUTE m=+0.01123 |
| mine-h40-1 | ~$93 | 2026-08-08T01:32Z | H40 REFUTE-by-ops (ep3) |
| mine-h42-1 | ~$44 | 2026-08-08T01:28Z | H42 REFUTE m=+0.01613 |
| mine-h41-1 | ~$64 | 2026-08-08T01:13Z | H41 REFUTE m=+0.00533 |

## Recent reconciles (last 3)

| UTC | lium ps mine-* | action |
|---|---|---|
| 2026-08-08T02:53Z | h45–h49 match | H49 p229 ABORT→p230 recover (outer×3+45s) |
| 2026-08-08T02:44Z | h45–h49 match | H49 FALSE_PROBE→chall recover p229 |
| 2026-08-08T02:41Z | h45–h49 match | H49 freeze t+c → n80 a203 |
