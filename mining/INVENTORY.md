# INVENTORY — mine-* pods only

**Cap: 40 lines.** Live table + last 3 reconciles. Never touch non-`mine-*`.
Pre-compaction: `archive/INVENTORY-full-2026-08-07.md`.

## Live

| name | huid | gpu | $/hr | remove_at | purpose | status |
|---|---|---|---|---|---|---|
| mine-h51-1 | brave-lion-47 | 8×H200 | $28.00 | ~2026-08-08T15:03Z | H51 m7×wZA α16 | n80 b203 ~30/80 |
| mine-h54-1 | calm-matrix-9c | 8×H200 | $28.00 | ~2026-08-08T16:23Z | H54 m7×wZA lr8e-6 | merge (recovered) |
| mine-h55-1 | lunar-shark-0b | 8×H200 | $31.92 | ~2026-08-08T16:36Z | H55 m7×wZA lr5.5e-6 | train+post relaunch |
| mine-h56-1 | swift-fox-1d | 8×H200 | $28.00 | ~2026-08-08T16:38Z | H56 m7×wZA r24 | train+post relaunch |
| mine-h57-1 | eager-shark-95 | 8×H200 | $31.92 | ~2026-08-08T16:44Z | H57 m7×wZA lr5.25e-6 | bootstrap |

SSH: h51 .232:40300 · h54 .236:40300 · h55 .19:20100 ·
h56 .237:40099 · h57 .18:20100 · known_hosts `/tmp/mine-h{51,54,55,56,57}-1.known_hosts` ·
**Free: 0**. Cap 5. Burn ~$147.8/h mining.

## Dead

| name | final spent | removed UTC | reason |
|---|---|---|---|
| mine-h53-1 | ~$42 | 2026-08-08T04:43Z | H53 REFUTE m=−0.00885 |
| mine-h52-1 | ~$49 | 2026-08-08T04:38Z | H52 REFUTE m=+0.01280 |
| mine-h50-1 | ~$44 | 2026-08-08T04:36Z | H50 REFUTE m=+0.00322 |
| mine-h49-1 | ~$80 | 2026-08-08T04:22Z | H49 REFUTE m=+0.01174 |
| mine-h45-1 | ~$55 | 2026-08-08T03:20Z | H45 REFUTE m=+0.00819 |

## Recent reconciles (last 3)

| UTC | lium ps mine-* | action |
|---|---|---|
| 2026-08-08T04:44Z | h51,54–57 | H53 REFUTE rm; recover h54/55/56 soft-abort; rent h57 |
| 2026-08-08T04:38Z | h51,53–56 | H50+H52 REFUTE rm; rent h55+h56 |
| 2026-08-08T04:28Z | h50–h54 match | H51 prefreeze OK→n80; H54 train |
