# INVENTORY — mine-* pods only

**Cap: 40 lines.** Live table + last 3 reconciles. Never touch non-`mine-*`.
Pre-compaction: `archive/INVENTORY-full-2026-08-07.md`.

## Live

| name | huid | gpu | $/hr | remove_at | purpose | status |
|---|---|---|---|---|---|---|
| mine-h74-1 | brave-orbit-28 | 8×H200 | $28.00 | ~2026-08-08T22:42Z | H74 r18-rep#2 vs Tok | n80 ~57/80 |
| mine-h75-1 | cosmic-hawk-20 | 8×H200 | $31.92 | ~2026-08-08T23:07Z | H75 r18-rep#3 vs Tok | n80 ~45/80 |
| mine-h76-1 | gentle-raven-df | 8×H200 | $31.92 | ~2026-08-08T23:38Z | H76 r18-rep#4 vs Tok | merge→chall serve |
| mine-h77-1 | eager-shark-64 | 8×H200 | $28.00 | ~2026-08-08T23:45Z | H77 r17 vs Tok | merging |
| mine-h78-1 | eager-comet-a4 | 8×H200 | $31.92 | ~2026-08-08T23:45Z | H78 r21 vs Tok | merging |

SSH: h74 .236:40300 · h75 .21:20100 · h76 .18:20100 ·
h77 .237:40306 · h78 .22:20100 ·
known_hosts `/tmp/mine-h{74,75,76,77,78}-1.known_hosts` ·
**Free: 0**. Cap 5. Burn ~$151.8/h mining.
Account also has non-mine `wan-lora-train` / `affine-*` — **never rm**.

## Dead

| name | final spent | removed UTC | reason |
|---|---|---|---|
| mine-h73-1 | ~$43 | 2026-08-08T11:43Z | H73 m=−0.005810 vs Tok |
| mine-h72-1 | ~$38 | 2026-08-08T11:43Z | H72 m=−0.009356 vs Tok |
| mine-h71-1 | ~$40 | 2026-08-08T11:37Z | H71 m=−0.013655 vs Tok |
| mine-h70-1 | ~$40 | 2026-08-08T11:06Z | H70 m=−0.000525 vs Tok |
| mine-h69-1 | ~$50 | 2026-08-08T10:42Z | H69 m=+0.01641 vs TalentPigs |

## Recent reconciles (last 3)

| UTC | lium ps mine-* | action |
|---|---|---|
| 2026-08-08T12:03Z | h74–78 match | H76 train→merge→chall; H77/H78 train.done→merge |
| 2026-08-08T11:45Z | h74–76 +h77 +h78; −h72 −h73 | H72/H73 REFUTE tear; rent h77 r17 + h78 r21 |
| 2026-08-08T11:37Z | h72–75 +h76; −h71 | H71 REFUTE tear; rent h76 r18-rep#4 |
