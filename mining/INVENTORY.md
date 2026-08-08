# INVENTORY — mine-* pods only

**Cap: 40 lines.** Live table + last 3 reconciles. Never touch non-`mine-*`.
Pre-compaction: `archive/INVENTORY-full-2026-08-07.md`.

## Live

| name | huid | gpu | $/hr | remove_at | purpose | status |
|---|---|---|---|---|---|---|
| mine-h71-1 | eager-fox-be | 8×H200 | $28.00 | ~2026-08-08T22:05Z | H71 m7×wZA r=16 vs Tok | n80 ~67/80 |
| mine-h72-1 | golden-comet-7a | 8×H200 | $28.00 | ~2026-08-08T22:20Z | H72 r18-rep vs Tok | n80 ~53/80 |
| mine-h73-1 | eager-matrix-9a | 8×H200 | $31.92 | ~2026-08-08T22:21Z | H73 r19-rep vs Tok | n80 ~56/80 |
| mine-h74-1 | brave-orbit-28 | 8×H200 | $28.00 | ~2026-08-08T22:42Z | H74 r18-rep#2 vs Tok | n80 LIVE |
| mine-h75-1 | cosmic-hawk-20 | 8×H200 | $31.92 | ~2026-08-08T23:07Z | H75 r18-rep#3 vs Tok | train @26 |

SSH: h71 .237:40311 · h72 .232:40299 · h73 .19:20100 ·
h74 .236:40300 · h75 .21:20100 ·
known_hosts `/tmp/mine-h{71,72,73,74,75}-1.known_hosts` ·
**Free: 0**. Cap 5. Burn ~$147.8/h mining.
Account also has non-mine `wan-lora-train` / `affine-*` — **never rm**.

## Dead

| name | final spent | removed UTC | reason |
|---|---|---|---|
| mine-h70-1 | ~$40 | 2026-08-08T11:06Z | H70 m=−0.000525 vs Tok |
| mine-h69-1 | ~$50 | 2026-08-08T10:42Z | H69 m=+0.01641 vs TalentPigs |
| mine-h68-1 | ~$45 | 2026-08-08T10:19Z | H68 REFUTE band×1.257 |
| mine-h67-1 | $41.66 | 2026-08-08T10:20Z | H67 m=+0.01835 shortlist→H73 |
| mine-h66-1 | ~$46 | 2026-08-08T10:05Z | H66 REFUTE m=+0.00976 |

## Recent reconciles (last 3)

| UTC | lium ps mine-* | action |
|---|---|---|
| 2026-08-08T11:30Z | h71–75 match | H74 salvage264→n80 live; no rent/rm |
| 2026-08-08T11:13Z | h71–75 match | H74 bare→recover264 isolated; no rent/rm |
| 2026-08-08T11:11Z | h71–75 match | H74 kill retry@104→relaunch@0; no rent/rm |
