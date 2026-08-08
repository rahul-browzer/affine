# INVENTORY — mine-* pods only

**Cap: 40 lines.** Live table + last 3 reconciles. Never touch non-`mine-*`.
Pre-compaction: `archive/INVENTORY-full-2026-08-07.md`.

## Live

| name | huid | gpu | $/hr | remove_at | purpose | status |
|---|---|---|---|---|---|---|
| mine-h76-1 | gentle-raven-df | 8×H200 | $31.92 | ~2026-08-08T23:38Z | H76 r18-rep#4 vs Tok | **n80 a203** ~65/80 |
| mine-h77-1 | eager-shark-64 | 8×H200 | $28.00 | ~2026-08-08T23:44Z | H77 r17 vs Tok | **n80 a203** ~32/80 |
| mine-h79-1 | lunar-shark-be | 8×H200 | $28.00 | ~2026-08-09T00:18Z | H79 Tok-init r18 | **n80 a203** ~12/80 |
| mine-h80-1 | eager-shark-18 | 8×H200 | $28.00 | ~2026-08-09T00:26Z | H80 Tok-init r17 | **king311** re-fire |
| mine-h81-1 | golden-orbit-da | 8×H200 | $31.92 | ~2026-08-09T01:19Z | H81 Tok-init r22 | **bootstrap** |

SSH: h76 .18:20100 · h77 .237:40306 · h79 .232:40100 ·
h80 .236:40311 · h81 .19:20100 ·
known_hosts `/tmp/mine-h{76,77,79,80,81}-1.known_hosts` ·
**Free: 0**. Cap 5. Burn ~$147.8/h mining.
Account also has non-mine `wan-lora-train` / `affine-*` — **never rm**.

## Dead

| name | final spent | removed UTC | reason |
|---|---|---|---|
| mine-h78-1 | ~$50 | 2026-08-08T13:18Z | H78 m=−0.007412 vs Tok (r=21) |
| mine-h75-1 | ~$42 | 2026-08-08T12:25Z | H75 m=+0.000550 vs Tok |
| mine-h74-1 | ~$44 | 2026-08-08T12:17Z | H74 m=−0.011003 vs Tok |
| mine-h73-1 | ~$43 | 2026-08-08T11:43Z | H73 m=−0.005810 vs Tok |
| mine-h72-1 | ~$38 | 2026-08-08T11:43Z | H72 m=−0.009356 vs Tok |

## Recent reconciles (last 3)

| UTC | lium ps mine-* | action |
|---|---|---|
| 2026-08-08T13:20Z | h76/77/79/80/81 | rm h78; rent h81; H80 king re-fire |
| 2026-08-08T13:14Z | h76–80 match | H80 king311 after ENOENT; no rent/rm |
| 2026-08-08T13:07Z | h76–80 match | H79/H80 visual phantom fix + recover |
