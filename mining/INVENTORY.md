# INVENTORY — mine-* pods only

**Cap: 40 lines.** Live table + last 3 reconciles. Never touch non-`mine-*`.
Pre-compaction: `archive/INVENTORY-full-2026-08-07.md`.

## Live

| name | huid | gpu | $/hr | remove_at | purpose | status |
|---|---|---|---|---|---|---|
| mine-h54-1 | calm-matrix-9c | 8×H200 | $28.00 | ~2026-08-08T16:23Z | H54 m7×wZA lr8e-6 | n80 c203 @16/80 |
| mine-h56-1 | swift-fox-1d | 8×H200 | $28.00 | ~2026-08-08T16:38Z | H56 m7×wZA r24 | n80 a203 @16/80 |
| mine-h57-1 | eager-shark-95 | 8×H200 | $31.92 | ~2026-08-08T16:44Z | H57 m7×wZA lr5.25e-6 | n80 a203 @63/80 |
| mine-h58-1 | eager-matrix-0d | 8×H200 | $31.92 | ~2026-08-08T17:22Z | H58 m7×wZA lr5.1e-6 | n80 a203 @1/80 |
| mine-h59-1 | lunar-comet-0f | 8×H200 | $28.00 | ~2026-08-08T18:17Z | H59 m7×wZA lr5.75e-6 | bootstrap |

SSH: h54 .236:40300 · h56 .237:40099 · h57 .18:20100 ·
h58 .21:20099 · h59 .232:40300 · known_hosts `/tmp/mine-h{54,56,57,58,59}-1.known_hosts` ·
**Free: 0**. Cap 5. Burn ~$147.8/h mining.

## Dead

| name | final spent | removed UTC | reason |
|---|---|---|---|
| mine-h55-1 | ~$53 | 2026-08-08T06:16Z | H55 REFUTE band×1.256 |
| mine-h59-1 (golden-comet-7a) | ~$0 | 2026-08-08T06:16Z | reject: nvidia-smi=5 @$14.5 |
| mine-h51-1 | ~$55 | 2026-08-08T05:21Z | H51 REFUTE m=+0.00855 |
| mine-h53-1 | ~$42 | 2026-08-08T04:43Z | H53 REFUTE m=−0.00885 |
| mine-h52-1 | ~$49 | 2026-08-08T04:38Z | H52 REFUTE m=+0.01280 |

## Recent reconciles (last 3)

| UTC | lium ps mine-* | action |
|---|---|---|
| 2026-08-08T06:17Z | h54,56–59 match | H55 REFUTE→rm; H59 rented (2nd try); no other rm |
| 2026-08-08T06:02Z | h54–58 match | H56+H58 FALSE_PROBE → p253 recover; no rent/rm |
| 2026-08-08T05:59Z | h54–58 match | H56 p251 freeze→n80 a203; no rent/rm |
