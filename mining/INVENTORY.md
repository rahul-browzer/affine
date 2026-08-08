# INVENTORY — mine-* pods only

**Cap: 40 lines.** Live table + last 3 reconciles. Never touch non-`mine-*`.
Pre-compaction: `archive/INVENTORY-full-2026-08-07.md`.

## Live

| name | huid | gpu | $/hr | remove_at | purpose | status |
|---|---|---|---|---|---|---|
| mine-h69-1 | noble-eagle-06 | 8×H200 | $31.92 | ~2026-08-08T21:08Z | H69 m7×wZA r=17 | n80 ~58/80 (old king) |
| mine-h70-1 | cosmic-raven-9e | 8×H200 | $31.92 | ~2026-08-08T21:42Z | H70 m7×wZA lr5.01e-6 | **n80 vs Tok** |
| mine-h71-1 | eager-fox-be | 8×H200 | $28.00 | ~2026-08-08T22:05Z | H71 m7×wZA r=16 vs Tok | chall serve→n80 |
| mine-h72-1 | golden-comet-7a | 8×H200 | $28.00 | ~2026-08-08T22:20Z | H72 r18-rep vs Tok | train |
| mine-h73-1 | eager-matrix-9a | 8×H200 | $31.92 | ~2026-08-08T22:21Z | H73 r19-rep vs Tok | train |

SSH: h69 .22:20100 · h70 .18:20100 · h71 .237:40311 ·
h72 .232:40299 · h73 .19:20100 ·
known_hosts `/tmp/mine-h{69,70,71,72,73}-1.known_hosts` ·
**Free: 0**. Cap 5. Burn ~$151.8/h mining.

## Dead

| name | final spent | removed UTC | reason |
|---|---|---|---|
| mine-h68-1 | ~$45 | 2026-08-08T10:19Z | H68 REFUTE band×1.257 |
| mine-h67-1 | $41.66 | 2026-08-08T10:20Z | H67 m=+0.01835 shortlist→H73 |
| mine-h66-1 | ~$46 | 2026-08-08T10:05Z | H66 REFUTE m=+0.00976 |
| mine-h65-1 | ~$43 | 2026-08-08T09:42Z | H65 REFUTE m=+0.01829 |
| mine-h61-1 | ~$75 | 2026-08-08T09:07Z | H61 REFUTE band×1.262 |

## Recent reconciles (last 3)

| UTC | lium ps mine-* | action |
|---|---|---|
| 2026-08-08T10:28Z | h69–73 match | H71 p283 preempt rearm; no rent/rm |
| 2026-08-08T10:26Z | h69–73 match | H70 Tok promptable→n80; no rent/rm |
| 2026-08-08T10:22Z | h69–73 match | rm h67/h68; rent h72+h73 |
