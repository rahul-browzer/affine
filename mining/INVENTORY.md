# INVENTORY — mine-* pods only

**Cap: 40 lines.** Live table + last 3 reconciles. Never touch non-`mine-*`.
Pre-compaction: `archive/INVENTORY-full-2026-08-07.md`.

## Live

| name | huid | gpu | $/hr | remove_at | purpose | status |
|---|---|---|---|---|---|---|
| mine-h44-1 | zesty-lion-e0 | 8×H200 | $28.00 | ~2026-08-08T12:45Z | H44 clipL1≥0.08 | n80 ~38/80 |
| mine-h45-1 | lunar-fox-40 | 8×H200 | $28.00 | ~2026-08-08T13:13Z | H45 m7×wZA r8 | merge |
| mine-h46-1 | cosmic-fox-ea | 8×H200 | $31.92 | ~2026-08-08T13:28Z | H46 m7×wZA lr2.5e-6 | train |
| mine-h47-1 | golden-comet-01 | 8×H200 | $31.92 | ~2026-08-08T13:33Z | H47 m7×wZA α8 | bootstrap |
| mine-h48-1 | zesty-raven-35 | 8×H200 | $31.92 | ~2026-08-08T13:33Z | H48 m7×wZA lr1e-6 | bootstrap |

SSH: h44 .232:40298 · h45 .236:40299 · h46 .19:20100 · h47 .21:20099 ·
h48 .22:20100 · known_hosts `/tmp/mine-h{44,45,46,47,48}-1.known_hosts` ·
**Free: 0**. Cap 5. Burn ~$151.8/h mining.

## Dead

| name | final spent | removed UTC | reason |
|---|---|---|---|
| mine-h43-1 | ~$46 | 2026-08-08T01:32Z | H43 REFUTE m=+0.01123 |
| mine-h40-1 | ~$93 | 2026-08-08T01:32Z | H40 REFUTE-by-ops (ep3) |
| mine-h42-1 | ~$44 | 2026-08-08T01:28Z | H42 REFUTE m=+0.01613 |
| mine-h41-1 | ~$64 | 2026-08-08T01:13Z | H41 REFUTE m=+0.00533 |
| mine-h44-1 (brave-fox-27) | ~$0.1 | 2026-08-08T00:44Z | REJECT 4 GPU @$11.60 |
| mine-h39-1 | ~$52 | 2026-08-08T00:43Z | H39 REFUTE m=+0.00544 |

## Recent reconciles (last 3)

| UTC | lium ps mine-* | action |
|---|---|---|
| 2026-08-08T01:34Z | h44–h48 match | H43/H40 rm; H47/H48 rent+launch |
| 2026-08-08T01:28Z | h40,h43–h46 match | H42 rm+H46 rent; H43~75/80 |
| 2026-08-08T01:14Z | h40,h42–h45 match | H41 rm+H45 rent; H40 p219 |
