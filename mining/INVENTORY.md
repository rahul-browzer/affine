# INVENTORY — mine-* pods only

**Cap: 40 lines.** Live table + last 3 reconciles. Never touch non-`mine-*`.
Pre-compaction: `archive/INVENTORY-full-2026-08-07.md`.

## Live

| name | huid | gpu | $/hr | remove_at | purpose | status |
|---|---|---|---|---|---|---|
| mine-h75-1 | cosmic-hawk-20 | 8×H200 | $31.92 | ~2026-08-08T23:07Z | H75 r18-rep#3 vs Tok | n80 ~75/80 |
| mine-h76-1 | gentle-raven-df | 8×H200 | $31.92 | ~2026-08-08T23:38Z | H76 r18-rep#4 vs Tok | king300 recover |
| mine-h77-1 | eager-shark-64 | 8×H200 | $28.00 | ~2026-08-08T23:44Z | H77 r17 vs Tok | recover264 warm |
| mine-h78-1 | eager-comet-a4 | 8×H200 | $31.92 | ~2026-08-08T23:44Z | H78 r21 vs Tok | chall loading |
| mine-h79-1 | lunar-shark-be | 8×H200 | $28.00 | ~2026-08-09T00:18Z | H79 Tok-init r18 | bootstrap dl |

SSH: h75 .21:20100 · h76 .18:20100 · h77 .237:40306 ·
h78 .22:20100 · h79 .232:40100 ·
known_hosts `/tmp/mine-h{75,76,77,78,79}-1.known_hosts` ·
**Free: 0**. Cap 5. Burn ~$151.8/h mining.
Account also has non-mine `wan-lora-train` / `affine-*` — **never rm**.

## Dead

| name | final spent | removed UTC | reason |
|---|---|---|---|
| mine-h74-1 | ~$44 | 2026-08-08T12:17Z | H74 m=−0.011003 vs Tok |
| mine-h73-1 | ~$43 | 2026-08-08T11:43Z | H73 m=−0.005810 vs Tok |
| mine-h72-1 | ~$38 | 2026-08-08T11:43Z | H72 m=−0.009356 vs Tok |
| mine-h71-1 | ~$40 | 2026-08-08T11:37Z | H71 m=−0.013655 vs Tok |
| mine-h70-1 | ~$40 | 2026-08-08T11:06Z | H70 m=−0.000525 vs Tok |

## Recent reconciles (last 3)

| UTC | lium ps mine-* | action |
|---|---|---|
| 2026-08-08T12:23Z | h75–79 match | H76 king300 recover after EngineDead; H75~75/80 |
| 2026-08-08T12:19Z | h75–79; −h74 | H74 REFUTE tear; H77 recover264; rent h79 Tok-init |
| 2026-08-08T12:12Z | h74–78 match | H76 stale-retry refresh→recover264→n80 |
