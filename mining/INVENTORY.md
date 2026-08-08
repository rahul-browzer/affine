# INVENTORY — mine-* pods only

**Cap: 40 lines.** Live table + last 3 reconciles. Never touch non-`mine-*`.
Pre-compaction: `archive/INVENTORY-full-2026-08-07.md`.

## Live

| name | huid | gpu | $/hr | remove_at | purpose | status |
|---|---|---|---|---|---|---|
| mine-h50-1 | eager-hawk-5b | 8×H200 | $28.00 | ~2026-08-08T15:03Z | H50 m7×wZA lr7.5e-6 | n80 a203 ~68/80 |
| mine-h51-1 | brave-lion-47 | 8×H200 | $28.00 | ~2026-08-08T15:03Z | H51 m7×wZA α16 | n80 a203 started |
| mine-h52-1 | noble-wolf-4b | 8×H200 | $31.92 | ~2026-08-08T15:05Z | H52 m7×wZA lr6e-6 | n80 a203 ~62/80 |
| mine-h53-1 | zesty-raven-e1 | 8×H200 | $31.92 | ~2026-08-08T15:20Z | H53 m7×wZA lr4e-6 | n80 a203 ~50/80 |
| mine-h54-1 | calm-matrix-9c | 8×H200 | $28.00 | ~2026-08-08T16:23Z | H54 m7×wZA lr8e-6 | train pid=2563 |

SSH: h50 .237:40499 · h51 .232:40300 · h52 .18:20099 · h53 .22:20100 ·
h54 .236:40300 · known_hosts `/tmp/mine-h{50,51,52,53,54}-1.known_hosts` ·
**Free: 0**. Cap 5. Burn ~$147.8/h mining.

## Dead

| name | final spent | removed UTC | reason |
|---|---|---|---|
| mine-h49-1 | ~$80 | 2026-08-08T04:22Z | H49 REFUTE m=+0.01174 |
| mine-h45-1 | ~$55 | 2026-08-08T03:20Z | H45 REFUTE m=+0.00819 |
| mine-h46-1 | ~$52 | 2026-08-08T03:04Z | H46 REFUTE m=+0.00802 |
| mine-h48-1 | ~$45 | 2026-08-08T03:01Z | H48 REFUTE band×1.269 |
| mine-h47-1 | ~$46 | 2026-08-08T03:01Z | H47 REFUTE m=+0.00463 |

## Recent reconciles (last 3)

| UTC | lium ps mine-* | action |
|---|---|---|
| 2026-08-08T04:28Z | h50–h54 match | H51 prefreeze OK→n80; H54 train; H50~68 |
| 2026-08-08T04:23Z | h50–h54 match | H49 REFUTE rm; rent h54; H51 p241 recover |
| 2026-08-08T04:09Z | h49–h53 match | H51 Triton→freeze recover 28472; H49~57 |
