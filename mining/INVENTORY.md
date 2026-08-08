# INVENTORY — mine-* pods only

**Cap: 40 lines.** Live table + last 3 reconciles. Never touch non-`mine-*`.
Pre-compaction: `archive/INVENTORY-full-2026-08-07.md`.

## Live

| name | huid | gpu | $/hr | remove_at | purpose | status |
|---|---|---|---|---|---|---|
| mine-h40-1 | gentle-eagle-c9 | 8×B200 | $40.00 | ~2026-08-08T11:12Z | H40 m7×wZA ep3 | chall recover |
| mine-h43-1 | noble-eagle-18 | 8×H200 | $31.92 | ~2026-08-08T12:05Z | H43 m7×wZA α64 | n80 ~75/80 |
| mine-h44-1 | zesty-lion-e0 | 8×H200 | $28.00 | ~2026-08-08T12:45Z | H44 clipL1≥0.08 | n80 ~19/80 |
| mine-h45-1 | lunar-fox-40 | 8×H200 | $28.00 | ~2026-08-08T13:13Z | H45 m7×wZA r8 | train |
| mine-h46-1 | cosmic-fox-ea | 8×H200 | $31.92 | ~2026-08-08T13:28Z | H46 m7×wZA lr2.5e-6 | bootstrap |

SSH: h40 .147:20300 · h43 .22:20099 · h44 .232:40298 · h45 .236:40299 ·
h46 .19:20100 · known_hosts `/tmp/mine-h{40,43,44,45,46}-1.known_hosts` ·
**Free: 0**. Cap 5. Burn ~$159.8/h mining.

## Dead

| name | final spent | removed UTC | reason |
|---|---|---|---|
| mine-h42-1 | ~$44 | 2026-08-08T01:28Z | H42 REFUTE m=+0.01613 |
| mine-h41-1 | ~$64 | 2026-08-08T01:13Z | H41 REFUTE m=+0.00533 |
| mine-h39-1 | ~$52 | 2026-08-08T00:43Z | H39 REFUTE m=+0.00544 |
| mine-h44-1 (brave-fox-27) | ~$0.1 | 2026-08-08T00:44Z | REJECT 4 GPU @$11.60 |
| mine-h38-1 | ~$61 | 2026-08-08T00:03Z | H38 REFUTE m=−0.00037 |
| mine-h37-1 | ~$61 | 2026-08-08T00:03Z | H37 REFUTE m=−0.00088 |

## Recent reconciles (last 3)

| UTC | lium ps mine-* | action |
|---|---|---|
| 2026-08-08T01:28Z | h40,h43–h46 match | H42 rm+H46 rent; H43~75/80 |
| 2026-08-08T01:14Z | h40,h42–h45 match | H41 rm+H45 rent; H40 p219 |
| 2026-08-08T00:49Z | h40–h44 match | dual-sim kill h42/h43; H40 p218 |
