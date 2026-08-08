# INVENTORY — mine-* pods only

**Cap: 40 lines.** Live table + last 3 reconciles. Never touch non-`mine-*`.
Pre-compaction: `archive/INVENTORY-full-2026-08-07.md`.

## Live

| name | huid | gpu | $/hr | remove_at | purpose | status |
|---|---|---|---|---|---|---|
| mine-h56-1 | swift-fox-1d | 8×H200 | $28.00 | ~2026-08-08T16:38Z | H56 m7×wZA r24 | n80 ~54/80 |
| mine-h59-1 | lunar-comet-0f | 8×H200 | $28.00 | ~2026-08-08T18:17Z | H59 m7×wZA lr5.75e-6 | n80 ~51/80 |
| mine-h60-1 | swift-eagle-4e | 8×H200 | $31.92 | ~2026-08-08T18:27Z | H60 m7×wZA lr5.3e-6 | chall recover p260 |
| mine-h61-1 | golden-matrix-4b | 8×H200 | $31.92 | ~2026-08-08T18:47Z | H61 m7×wZA lr5.15e-6 | merge |
| mine-h62-1 | golden-matrix-66 | 8×H200 | $28.00 | ~2026-08-08T19:01Z | H62 m7×wZA r20 | train |

SSH: h56 .237:40099 · h59 .232:40300 · h60 .22:20100 ·
h61 .18:20100 · h62 .236:40310 ·
known_hosts `/tmp/mine-h{56,59,60,61,62}-1.known_hosts` ·
**Free: 0**. Cap 5. Burn ~$147.8/h mining.

## Dead

| name | final spent | removed UTC | reason |
|---|---|---|---|
| mine-h58-1 | ~$53 | 2026-08-08T07:01Z | H58 REFUTE m=+0.01466 |
| mine-h54-1 | ~$67 | 2026-08-08T06:47Z | H54 REFUTE m=+0.01380 |
| mine-h57-1 | ~$55 | 2026-08-08T06:26Z | H57 REFUTE m=+0.01537 |
| mine-h55-1 | ~$53 | 2026-08-08T06:16Z | H55 REFUTE band×1.256 |
| mine-h59-1 (golden-comet-7a) | ~$0 | 2026-08-08T06:16Z | reject: nvidia-smi=5 @$14.5 |

## Recent reconciles (last 3)

| UTC | lium ps mine-* | action |
|---|---|---|
| 2026-08-08T07:15Z | h56,59–62 match | no rm; H60 FALSE_PROBE→p260 recover |
| 2026-08-08T07:02Z | h56,59–62 match | H58 REFUTE→rm; H62 rented+launch; no other rm |
| 2026-08-08T06:48Z | h56,58–61 match | H54 REFUTE→rm; H61 rented+launch; no other rm |
