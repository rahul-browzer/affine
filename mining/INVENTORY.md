# INVENTORY — mine-* pods only

**Cap: 40 lines.** Live table + last 3 reconciles. Never touch non-`mine-*`.
Pre-compaction: `archive/INVENTORY-full-2026-08-07.md`.

## Live

| name | huid | gpu | $/hr | remove_at | purpose | status |
|---|---|---|---|---|---|---|
| mine-h54-1 | calm-matrix-9c | 8×H200 | $28.00 | ~2026-08-08T16:23Z | H54 m7×wZA lr8e-6 | freeze.done → n80 |
| mine-h55-1 | lunar-shark-0b | 8×H200 | $31.92 | ~2026-08-08T16:36Z | H55 m7×wZA lr5.5e-6 | n80 ~13/80 |
| mine-h56-1 | swift-fox-1d | 8×H200 | $28.00 | ~2026-08-08T16:38Z | H56 m7×wZA r24 | chall prefreeze p247 |
| mine-h57-1 | eager-shark-95 | 8×H200 | $31.92 | ~2026-08-08T16:44Z | H57 m7×wZA lr5.25e-6 | chall re-serve |
| mine-h58-1 | eager-matrix-0d | 8×H200 | $31.92 | ~2026-08-08T17:22Z | H58 m7×wZA lr5.1e-6 | bootstrap |

SSH: h54 .236:40300 · h55 .19:20100 · h56 .237:40099 ·
h57 .18:20100 · h58 .21:20099 · known_hosts `/tmp/mine-h{54,55,56,57,58}-1.known_hosts` ·
**Free: 0**. Cap 5. Burn ~$151.8/h mining.

## Dead

| name | final spent | removed UTC | reason |
|---|---|---|---|
| mine-h51-1 | ~$55 | 2026-08-08T05:21Z | H51 REFUTE m=+0.00855 |
| mine-h53-1 | ~$42 | 2026-08-08T04:43Z | H53 REFUTE m=−0.00885 |
| mine-h52-1 | ~$49 | 2026-08-08T04:38Z | H52 REFUTE m=+0.01280 |
| mine-h50-1 | ~$44 | 2026-08-08T04:36Z | H50 REFUTE m=+0.00322 |
| mine-h49-1 | ~$80 | 2026-08-08T04:22Z | H49 REFUTE m=+0.01174 |

## Recent reconciles (last 3)

| UTC | lium ps mine-* | action |
|---|---|---|
| 2026-08-08T05:26Z | h54–58 match | H56 chall prefreeze recover launched |
| 2026-08-08T05:22Z | h54–58 | H51 REFUTE rm; rent h58; H54 chall recover |
| 2026-08-08T04:48Z | h51,54–57 match | soft/deadman defaults patched; no rent/rm |
