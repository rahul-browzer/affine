# INVENTORY — mine-* pods only

**Cap: 40 lines.** Live table + last 3 reconciles. Never touch non-`mine-*`.
Pre-compaction: `archive/INVENTORY-full-2026-08-07.md`.

## Live

| name | huid | gpu | $/hr | remove_at | purpose | status |
|---|---|---|---|---|---|---|
| mine-h56-1 | swift-fox-1d | 8×H200 | $28.00 | ~2026-08-08T16:38Z | H56 m7×wZA r24 | n80 b203 |
| mine-h58-1 | eager-matrix-0d | 8×H200 | $31.92 | ~2026-08-08T17:22Z | H58 m7×wZA lr5.1e-6 | n80 ~59/80 |
| mine-h59-1 | lunar-comet-0f | 8×H200 | $28.00 | ~2026-08-08T18:17Z | H59 m7×wZA lr5.75e-6 | n80 b203 |
| mine-h60-1 | swift-eagle-4e | 8×H200 | $31.92 | ~2026-08-08T18:27Z | H60 m7×wZA lr5.3e-6 | merge |
| mine-h61-1 | golden-matrix-4b | 8×H200 | $31.92 | ~2026-08-08T18:47Z | H61 m7×wZA lr5.15e-6 | bootstrap |

SSH: h56 .237:40099 · h58 .21:20099 · h59 .232:40300 ·
h60 .22:20100 · h61 .18:20100 · known_hosts `/tmp/mine-h{56,58,59,60,61}-1.known_hosts` ·
**Free: 0**. Cap 5. Burn ~$151.8/h mining. Next: H62 (r=20).

## Dead

| name | final spent | removed UTC | reason |
|---|---|---|---|
| mine-h54-1 | ~$67 | 2026-08-08T06:47Z | H54 REFUTE m=+0.01380 |
| mine-h57-1 | ~$55 | 2026-08-08T06:26Z | H57 REFUTE m=+0.01537 |
| mine-h55-1 | ~$53 | 2026-08-08T06:16Z | H55 REFUTE band×1.256 |
| mine-h59-1 (golden-comet-7a) | ~$0 | 2026-08-08T06:16Z | reject: nvidia-smi=5 @$14.5 |
| mine-h51-1 | ~$55 | 2026-08-08T05:21Z | H51 REFUTE m=+0.00855 |

## Recent reconciles (last 3)

| UTC | lium ps mine-* | action |
|---|---|---|
| 2026-08-08T06:48Z | h56,58–61 match | H54 REFUTE→rm; H61 rented+launch; no other rm |
| 2026-08-08T06:35Z | h54,56,58–60 match | no rm; H62 staged (r=20); n80/train/merge OK |
| 2026-08-08T06:30Z | h54,56,58–60 match | no rm; H61 staged; H60 train up; n80 progressing |
