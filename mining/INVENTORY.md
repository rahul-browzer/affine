# INVENTORY — mine-* pods only

**Cap: 40 lines.** Live table + last 3 reconciles. Never touch non-`mine-*`.
Pre-compaction: `archive/INVENTORY-full-2026-08-07.md`.

## Live

| name | huid | gpu | $/hr | remove_at | purpose | status |
|---|---|---|---|---|---|---|
| mine-h54-1 | calm-matrix-9c | 8×H200 | $28.00 | ~2026-08-08T16:23Z | H54 m7×wZA lr8e-6 | n80 ~47/80 |
| mine-h56-1 | swift-fox-1d | 8×H200 | $28.00 | ~2026-08-08T16:38Z | H56 m7×wZA r24 | n80 ~37/80 |
| mine-h58-1 | eager-matrix-0d | 8×H200 | $31.92 | ~2026-08-08T17:22Z | H58 m7×wZA lr5.1e-6 | n80 ~31/80 |
| mine-h59-1 | lunar-comet-0f | 8×H200 | $28.00 | ~2026-08-08T18:17Z | H59 m7×wZA lr5.75e-6 | train ~21/26 |
| mine-h60-1 | swift-eagle-4e | 8×H200 | $31.92 | ~2026-08-08T18:27Z | H60 m7×wZA lr5.3e-6 | train launched |

SSH: h54 .236:40300 · h56 .237:40099 · h58 .21:20099 ·
h59 .232:40300 · h60 .22:20100 · known_hosts `/tmp/mine-h{54,56,58,59,60}-1.known_hosts` ·
**Free: 0**. Cap 5. Burn ~$147.8/h mining. Next: H61 staged (lr=5.15e-6).

## Dead

| name | final spent | removed UTC | reason |
|---|---|---|---|
| mine-h57-1 | ~$55 | 2026-08-08T06:26Z | H57 REFUTE m=+0.01537 |
| mine-h55-1 | ~$53 | 2026-08-08T06:16Z | H55 REFUTE band×1.256 |
| mine-h59-1 (golden-comet-7a) | ~$0 | 2026-08-08T06:16Z | reject: nvidia-smi=5 @$14.5 |
| mine-h51-1 | ~$55 | 2026-08-08T05:21Z | H51 REFUTE m=+0.00855 |
| mine-h53-1 | ~$42 | 2026-08-08T04:43Z | H53 REFUTE m=−0.00885 |

## Recent reconciles (last 3)

| UTC | lium ps mine-* | action |
|---|---|---|
| 2026-08-08T06:30Z | h54,56,58–60 match | no rm; H61 staged; H60 train up; n80 progressing |
| 2026-08-08T06:27Z | h54,56,58–60 match | H57 REFUTE→rm; H60 rented+bootstrap; no other rm |
| 2026-08-08T06:17Z | h54,56–59 match | H55 REFUTE→rm; H59 rented (2nd try); no other rm |
