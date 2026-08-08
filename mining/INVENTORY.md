# INVENTORY — mine-* pods only

**Cap: 40 lines.** Live table + last 3 reconciles. Never touch non-`mine-*`.
Pre-compaction: `archive/INVENTORY-full-2026-08-07.md`.

## Live

| name | huid | gpu | $/hr | remove_at | purpose | status |
|---|---|---|---|---|---|---|
| mine-h60-1 | swift-eagle-4e | 8×H200 | $31.92 | ~2026-08-08T18:27Z | H60 m7×wZA lr5.3e-6 | n80 ~11/80 |
| mine-h61-1 | golden-matrix-4b | 8×H200 | $31.92 | ~2026-08-08T18:47Z | H61 m7×wZA lr5.15e-6 | chall loading |
| mine-h62-1 | golden-matrix-66 | 8×H200 | $28.00 | ~2026-08-08T19:01Z | H62 m7×wZA r20 | chall loading |
| mine-h63-1 | noble-eagle-3f | 8×H200 | $31.92 | ~2026-08-08T19:28Z | H63 m7×wZA lr5.05e-6 | bootstrap |
| mine-h64-1 | gentle-wolf-eb | 8×H200 | $31.92 | ~2026-08-08T19:28Z | H64 m7×wZA r18 | bootstrap |

SSH: h60 .22:20100 · h61 .18:20100 · h62 .236:40310 ·
h63 .19:20100 · h64 .21:20099 ·
known_hosts `/tmp/mine-h{60,61,62,63,64}-1.known_hosts` ·
**Free: 0**. Cap 5. Burn ~$155.7/h mining.

## Dead

| name | final spent | removed UTC | reason |
|---|---|---|---|
| mine-h56-1 | ~$79 | 2026-08-08T07:27Z | H56 REFUTE m=+0.00140 |
| mine-h59-1 | ~$33 | 2026-08-08T07:27Z | H59 REFUTE band×1.273 |
| mine-h58-1 | ~$53 | 2026-08-08T07:01Z | H58 REFUTE m=+0.01466 |
| mine-h54-1 | ~$67 | 2026-08-08T06:47Z | H54 REFUTE m=+0.01380 |
| mine-h57-1 | ~$55 | 2026-08-08T06:26Z | H57 REFUTE m=+0.01537 |

## Recent reconciles (last 3)

| UTC | lium ps mine-* | action |
|---|---|---|
| 2026-08-08T07:29Z | h60–64 match | H56/H59 REFUTE→rm; H63/H64 rented+launch; no other rm |
| 2026-08-08T07:15Z | h56,59–62 match | no rm; H60 FALSE_PROBE→p260 recover |
| 2026-08-08T07:02Z | h56,59–62 match | H58 REFUTE→rm; H62 rented+launch; no other rm |
