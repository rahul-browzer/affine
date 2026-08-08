# INVENTORY — mine-* pods only

**Cap: 40 lines.** Live table + last 3 reconciles. Never touch non-`mine-*`.
Pre-compaction: `archive/INVENTORY-full-2026-08-07.md`.

## Live

| name | huid | gpu | $/hr | remove_at | purpose | status |
|---|---|---|---|---|---|---|
| mine-h72-1 | golden-comet-7a | 8×H200 | $28.00 | ~2026-08-08T22:20Z | H72 r18-rep vs Tok | n80 ~68/80 |
| mine-h73-1 | eager-matrix-9a | 8×H200 | $31.92 | ~2026-08-08T22:21Z | H73 r19-rep vs Tok | n80 ~72/80 |
| mine-h74-1 | brave-orbit-28 | 8×H200 | $28.00 | ~2026-08-08T22:42Z | H74 r18-rep#2 vs Tok | n80 ~15/80 |
| mine-h75-1 | cosmic-hawk-20 | 8×H200 | $31.92 | ~2026-08-08T23:07Z | H75 r18-rep#3 vs Tok | chall loading |
| mine-h76-1 | gentle-raven-df | 8×H200 | $31.92 | ~2026-08-08T23:38Z | H76 r18-rep#4 vs Tok | bootstrap |

SSH: h72 .232:40299 · h73 .19:20100 · h74 .236:40300 ·
h75 .21:20100 · h76 .18:20100 ·
known_hosts `/tmp/mine-h{72,73,74,75,76}-1.known_hosts` ·
**Free: 0**. Cap 5. Burn ~$151.8/h mining.
Account also has non-mine `wan-lora-train` / `affine-*` — **never rm**.

## Dead

| name | final spent | removed UTC | reason |
|---|---|---|---|
| mine-h71-1 | ~$40 | 2026-08-08T11:37Z | H71 m=−0.013655 vs Tok |
| mine-h70-1 | ~$40 | 2026-08-08T11:06Z | H70 m=−0.000525 vs Tok |
| mine-h69-1 | ~$50 | 2026-08-08T10:42Z | H69 m=+0.01641 vs TalentPigs |
| mine-h68-1 | ~$45 | 2026-08-08T10:19Z | H68 REFUTE band×1.257 |
| mine-h67-1 | $41.66 | 2026-08-08T10:20Z | H67 m=+0.01835 shortlist→H73 |

## Recent reconciles (last 3)

| UTC | lium ps mine-* | action |
|---|---|---|
| 2026-08-08T11:37Z | h72–75 +h76; −h71 | H71 REFUTE tear; rent h76 r18-rep#4 |
| 2026-08-08T11:30Z | h71–75 match | H74 salvage264→n80 live; no rent/rm |
| 2026-08-08T11:13Z | h71–75 match | H74 bare→recover264 isolated; no rent/rm |
