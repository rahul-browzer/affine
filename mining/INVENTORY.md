# INVENTORY — mine-* pods only

**Cap: 40 lines.** Live table + last 3 reconciles. Never touch non-`mine-*`.
Pre-compaction: `archive/INVENTORY-full-2026-08-07.md`.

## Live

| name | huid | gpu | $/hr | remove_at | purpose | status |
|---|---|---|---|---|---|---|
| mine-h61-1 | golden-matrix-4b | 8×H200 | $31.92 | ~2026-08-08T18:47Z | H61 m7×wZA lr5.15e-6 | n80 b203 64/80 |
| mine-h65-1 | calm-wolf-24 | 8×H200 | $28.00 | ~2026-08-08T20:11Z | H65 m7×wZA lr5.02e-6 | n80 b203 11/80 |
| mine-h66-1 | swift-eagle-f0 | 8×H200 | $28.00 | ~2026-08-08T20:26Z | H66 m7×wZA lr5.08e-6 | chall re-serve |
| mine-h67-1 | eager-hawk-f5 | 8×H200 | $28.00 | ~2026-08-08T20:51Z | H67 m7×wZA r=19 | train |
| mine-h68-1 | cosmic-shark-68 | 8×H200 | $31.92 | ~2026-08-08T20:58Z | H68 m7×wZA lr4.95e-6 | bootstrap |

SSH: h61 .18:20100 · h65 .237:40099 · h66 .232:40300 ·
h67 .236:40300 · h68 .21:20100 ·
known_hosts `/tmp/mine-h{61,65,66,67,68}-1.known_hosts` ·
**Free: 0**. Cap 5. Burn ~$147.8/h mining.

## Dead

| name | final spent | removed UTC | reason |
|---|---|---|---|
| mine-h63-1 | ~$48 | 2026-08-08T08:58Z | H63 REFUTE m=+0.00424 |
| mine-h64-1 | ~$44 | 2026-08-08T08:51Z | H64 REFUTE m=+0.02509 (best; z=2.993) |
| mine-h62-1 | ~$40 | 2026-08-08T08:26Z | H62 REFUTE band×1.273 |
| mine-h60-1 | ~$55 | 2026-08-08T08:10Z | H60 REFUTE m=+0.01350 |
| mine-h56-1 | ~$79 | 2026-08-08T07:27Z | H56 REFUTE m=+0.00140 |

## Recent reconciles (last 3)

| UTC | lium ps mine-* | action |
|---|---|---|
| 2026-08-08T08:58Z | h61/65–68 match | rm h63; rent h68 @$31.92 |
| 2026-08-08T08:52Z | h61/63/65–67 match | rm h64; rent h67 @$28; H66 king recover |
| 2026-08-08T08:33Z | h61/63–66 match | no rm; scaffold H68 lr=4.95e-6 |
