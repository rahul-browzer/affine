# INVENTORY — mine-* pods only

**Cap: 40 lines.** Live table + last 3 reconciles. Never touch non-`mine-*`.
Pre-compaction: `archive/INVENTORY-full-2026-08-07.md`.

## Live

| name | huid | gpu | $/hr | remove_at | purpose | status |
|---|---|---|---|---|---|---|
| mine-h61-1 | golden-matrix-4b | 8×H200 | $31.92 | ~2026-08-08T18:47Z | H61 m7×wZA lr5.15e-6 | n80 b203 ~3/80 |
| mine-h63-1 | noble-eagle-3f | 8×H200 | $31.92 | ~2026-08-08T19:28Z | H63 m7×wZA lr5.05e-6 | n80 ~36/80 |
| mine-h64-1 | gentle-wolf-eb | 8×H200 | $31.92 | ~2026-08-08T19:28Z | H64 m7×wZA r18 | n80 ~32/80 |
| mine-h65-1 | calm-wolf-24 | 8×H200 | $28.00 | ~2026-08-08T20:11Z | H65 m7×wZA lr5.02e-6 | merge |
| mine-h66-1 | swift-eagle-f0 | 8×H200 | $28.00 | ~2026-08-08T20:26Z | H66 m7×wZA lr5.08e-6 | bootstrap |

SSH: h61 .18:20100 · h63 .19:20100 · h64 .21:20099 ·
h65 .237:40099 · h66 .232:40300 ·
known_hosts `/tmp/mine-h{61,63,64,65,66}-1.known_hosts` ·
**Free: 0**. Cap 5. Burn ~$151.8/h mining. Next fill: **H67 r=19**.

## Dead

| name | final spent | removed UTC | reason |
|---|---|---|---|
| mine-h62-1 | ~$40 | 2026-08-08T08:26Z | H62 REFUTE band×1.273 |
| mine-h60-1 | ~$55 | 2026-08-08T08:10Z | H60 REFUTE m=+0.01350 |
| mine-h56-1 | ~$79 | 2026-08-08T07:27Z | H56 REFUTE m=+0.00140 |
| mine-h59-1 | ~$33 | 2026-08-08T07:27Z | H59 REFUTE band×1.273 |
| mine-h58-1 | ~$53 | 2026-08-08T07:01Z | H58 REFUTE m=+0.01466 |

## Recent reconciles (last 3)

| UTC | lium ps mine-* | action |
|---|---|---|
| 2026-08-08T08:31Z | h61/63–66 match | no rm; scaffold H67 r=19 |
| 2026-08-08T08:26Z | h61/63–65 + rm h62 | H62 REFUTE; rent h66 @$28 |
| 2026-08-08T08:11Z | h61–65 match | rm h60 REFUTE; rent h65 @$28 |
