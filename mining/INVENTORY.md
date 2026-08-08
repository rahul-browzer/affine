# INVENTORY — mine-* pods only

**Cap: 40 lines.** Live table + last 3 reconciles. Never touch non-`mine-*`.
Pre-compaction: `archive/INVENTORY-full-2026-08-07.md`.

## Live

| name | huid | gpu | $/hr | remove_at | purpose | status |
|---|---|---|---|---|---|---|
| mine-h45-1 | lunar-fox-40 | 8×H200 | $28.00 | ~2026-08-08T13:13Z | H45 m7×wZA r8 | n80 ~48/80 |
| mine-h49-1 | zesty-shark-45 | 8×H200 | $33.81 | ~2026-08-08T13:59Z | H49 m7×wZA α4 | n80 a203 |
| mine-h50-1 | eager-hawk-5b | 8×H200 | $28.00 | ~2026-08-08T15:03Z | H50 m7×wZA lr7.5e-6 | bootstrap |
| mine-h51-1 | brave-lion-47 | 8×H200 | $28.00 | ~2026-08-08T15:03Z | H51 m7×wZA α16 | bootstrap |
| mine-h52-1 | noble-wolf-4b | 8×H200 | $31.92 | ~2026-08-08T15:05Z | H52 m7×wZA lr6e-6 | bootstrap |

SSH: h45 .236:40299 · h49 .54:40300 · h50 .237:40499 · h51 .232:40300 ·
h52 .18:20099 · known_hosts `/tmp/mine-h{45,49,50,51,52}-1.known_hosts` ·
**Free: 0**. Cap 5. Burn ~$149.7/h mining.

## Dead

| name | final spent | removed UTC | reason |
|---|---|---|---|
| mine-h46-1 | ~$52 | 2026-08-08T03:04Z | H46 REFUTE m=+0.00802 |
| mine-h48-1 | ~$45 | 2026-08-08T03:01Z | H48 REFUTE band base×1.269 |
| mine-h47-1 | ~$46 | 2026-08-08T03:01Z | H47 REFUTE m=+0.00463 |
| mine-h44-1 | ~$34 | 2026-08-08T01:58Z | H44 REFUTE m=−0.00017 |
| mine-h43-1 | ~$46 | 2026-08-08T01:32Z | H43 REFUTE m=+0.01123 |

## Recent reconciles (last 3)

| UTC | lium ps mine-* | action |
|---|---|---|
| 2026-08-08T03:05Z | h45,h49–h52 match | rm h46–h48 REFUTE; rent h50–h52 |
| 2026-08-08T02:53Z | h45–h49 match | H49 p230 recover |
| 2026-08-08T02:44Z | h45–h49 match | H49 FALSE_PROBE→chall recover |
