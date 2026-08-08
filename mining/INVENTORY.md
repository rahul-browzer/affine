# INVENTORY — mine-* pods only

**Cap: 40 lines.** Live table + last 3 reconciles. Never touch non-`mine-*`.
Pre-compaction: `archive/INVENTORY-full-2026-08-07.md`.

## Live

| name | huid | gpu | $/hr | remove_at | purpose | status |
|---|---|---|---|---|---|---|
| mine-h76-1 | gentle-raven-df | 8×H200 | $31.92 | ~2026-08-08T23:38Z | H76 r18-rep#4 vs Tok | **n80 a203** + mid304 |
| mine-h77-1 | eager-shark-64 | 8×H200 | $28.00 | ~2026-08-08T23:44Z | H77 r17 vs Tok | **king308** → n80 |
| mine-h78-1 | eager-comet-a4 | 8×H200 | $31.92 | ~2026-08-08T23:44Z | H78 r21 vs Tok | **n80 a203** + mid304 |
| mine-h79-1 | lunar-shark-be | 8×H200 | $28.00 | ~2026-08-09T00:18Z | H79 Tok-init r18 | recover264 chall |
| mine-h80-1 | eager-shark-18 | 8×H200 | $28.00 | ~2026-08-09T00:26Z | H80 Tok-init r17 | king→chall→n80 |

SSH: h76 .18:20100 · h77 .237:40306 · h78 .22:20100 ·
h79 .232:40100 · h80 .236:40311 ·
known_hosts `/tmp/mine-h{76,77,78,79,80}-1.known_hosts` ·
**Free: 0**. Cap 5. Burn ~$147.8/h mining.
Account also has non-mine `wan-lora-train` / `affine-*` — **never rm**.

## Dead

| name | final spent | removed UTC | reason |
|---|---|---|---|
| mine-h75-1 | ~$42 | 2026-08-08T12:25Z | H75 m=+0.000550 vs Tok |
| mine-h74-1 | ~$44 | 2026-08-08T12:17Z | H74 m=−0.011003 vs Tok |
| mine-h73-1 | ~$43 | 2026-08-08T11:43Z | H73 m=−0.005810 vs Tok |
| mine-h72-1 | ~$38 | 2026-08-08T11:43Z | H72 m=−0.009356 vs Tok |
| mine-h71-1 | ~$40 | 2026-08-08T11:37Z | H71 m=−0.013655 vs Tok |

## Recent reconciles (last 3)

| UTC | lium ps mine-* | action |
|---|---|---|
| 2026-08-08T12:56Z | h76–80 match | H77 king308 recover; no rent/rm |
| 2026-08-08T12:53Z | h76–80 match | H79 Tok-proc fix + recover264; H80 patched; no rent/rm |
| 2026-08-08T12:47Z | h76–80 match | H77 king306 recover; no rent/rm |
