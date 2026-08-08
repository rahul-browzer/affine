# INVENTORY — mine-* pods only

**Cap: 40 lines.** Live table + last 3 reconciles. Never touch non-`mine-*`.
Pre-compaction: `archive/INVENTORY-full-2026-08-07.md`.

## Live

| name | huid | gpu | $/hr | remove_at | purpose | status |
|---|---|---|---|---|---|---|
| mine-h70-1 | cosmic-raven-9e | 8×H200 | $31.92 | ~2026-08-08T21:42Z | H70 m7×wZA lr5.01e-6 | n80 vs Tok ~34/80 |
| mine-h71-1 | eager-fox-be | 8×H200 | $28.00 | ~2026-08-08T22:05Z | H71 m7×wZA r=16 vs Tok | recover264 warm |
| mine-h72-1 | golden-comet-7a | 8×H200 | $28.00 | ~2026-08-08T22:20Z | H72 r18-rep vs Tok | merge |
| mine-h73-1 | eager-matrix-9a | 8×H200 | $31.92 | ~2026-08-08T22:21Z | H73 r19-rep vs Tok | merge |
| mine-h74-1 | brave-orbit-28 | 8×H200 | $28.00 | ~2026-08-08T22:42Z | H74 r18-rep#2 vs Tok | bootstrap |

SSH: h70 .18:20100 · h71 .237:40311 · h72 .232:40299 ·
h73 .19:20100 · h74 .236:40300 ·
known_hosts `/tmp/mine-h{70,71,72,73,74}-1.known_hosts` ·
**Free: 0**. Cap 5. Burn ~$147.8/h mining.
Account also has non-mine `wan-lora-train` — **never rm**.

## Dead

| name | final spent | removed UTC | reason |
|---|---|---|---|
| mine-h69-1 | ~$50 | 2026-08-08T10:42Z | H69 m=+0.01641 vs TalentPigs |
| mine-h68-1 | ~$45 | 2026-08-08T10:19Z | H68 REFUTE band×1.257 |
| mine-h67-1 | $41.66 | 2026-08-08T10:20Z | H67 m=+0.01835 shortlist→H73 |
| mine-h66-1 | ~$46 | 2026-08-08T10:05Z | H66 REFUTE m=+0.00976 |
| mine-h65-1 | ~$43 | 2026-08-08T09:42Z | H65 REFUTE m=+0.01829 |

## Recent reconciles (last 3)

| UTC | lium ps mine-* | action |
|---|---|---|
| 2026-08-08T10:43Z | h70–74 match | rm h69; rent h74 r18-rep#2 |
| 2026-08-08T10:36Z | h69–73 match | H71 recover264 fired; no rent/rm |
| 2026-08-08T10:28Z | h69–73 match | H71 p283 preempt rearm; no rent/rm |
