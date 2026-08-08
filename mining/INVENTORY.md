# INVENTORY — mine-* pods only

**Cap: 40 lines.** Live table + last 3 reconciles. Never touch non-`mine-*`.
Pre-compaction: `archive/INVENTORY-full-2026-08-07.md`.

## Live

| name | huid | gpu | $/hr | remove_at | purpose | status |
|---|---|---|---|---|---|---|
| mine-h67-1 | eager-hawk-f5 | 8×H200 | $28.00 | ~2026-08-08T20:51Z | H67 m7×wZA r=19 | n80 ~65/80 (old king) |
| mine-h68-1 | cosmic-shark-68 | 8×H200 | $31.92 | ~2026-08-08T20:58Z | H68 m7×wZA lr4.95e-6 | n80 ~66/80 (old king) |
| mine-h69-1 | noble-eagle-06 | 8×H200 | $31.92 | ~2026-08-08T21:08Z | H69 m7×wZA r=17 | n80 ~25/80 (old king) |
| mine-h70-1 | cosmic-raven-9e | 8×H200 | $31.92 | ~2026-08-08T21:42Z | H70 m7×wZA lr5.01e-6 | chall recover; Tok wait |
| mine-h71-1 | eager-fox-be | 8×H200 | $28.00 | ~2026-08-08T22:05Z | H71 m7×wZA r=16 vs Tok | train |

SSH: h67 .236:40300 · h68 .21:20100 · h69 .22:20100 ·
h70 .18:20100 · h71 .237:40311 ·
known_hosts `/tmp/mine-h{67,68,69,70,71}-1.known_hosts` ·
**Free: 0**. Cap 5. Burn ~$151.8/h mining.

## Dead

| name | final spent | removed UTC | reason |
|---|---|---|---|
| mine-h66-1 | ~$46 | 2026-08-08T10:05Z | H66 REFUTE m=+0.00976 |
| mine-h65-1 | ~$43 | 2026-08-08T09:42Z | H65 REFUTE m=+0.01829 |
| mine-h61-1 | ~$75 | 2026-08-08T09:07Z | H61 REFUTE band×1.262 |
| mine-h63-1 | ~$48 | 2026-08-08T08:58Z | H63 REFUTE m=+0.00424 |
| mine-h64-1 | ~$44 | 2026-08-08T08:51Z | H64 REFUTE m=+0.02509 (best; z=2.993) |

## Recent reconciles (last 3)

| UTC | lium ps mine-* | action |
|---|---|---|
| 2026-08-08T10:11Z | h67–71 match | H70 merge salvage+chall recover282 |
| 2026-08-08T10:08Z | h67–71 match | H70 preempt rearm pid13587; counts |
| 2026-08-08T10:06Z | h67–71 match | H66 REFUTE+rm; rent h71 r16 vs Tok |
