# INVENTORY — mine-* pods only

**Cap: 40 lines.** Live table + last 3 reconciles. Never touch non-`mine-*`.
Pre-compaction: `archive/INVENTORY-full-2026-08-07.md`.

## Live

| name | huid | gpu | $/hr | remove_at | purpose | status |
|---|---|---|---|---|---|---|
| mine-h80-1 | eager-shark-18 | 8×H200 | $28.00 | ~2026-08-09T00:26Z | H80 Tok-init r17 | **n80** ~60/80 |
| mine-h81-1 | golden-orbit-da | 8×H200 | $31.92 | ~2026-08-09T01:19Z | H81 Tok-init r22 | **n80** a203 + mid304 |
| mine-h82-1 | golden-comet-74 | 8×H200 | $31.92 | ~2026-08-09T01:29Z | H82 Tok-init r23 | **merge** ~63G |
| mine-h83-1 | cosmic-matrix-be | 8×H200 | $31.92 | ~2026-08-09T01:44Z | H83 Tok-init r25 | **merge** ~12G + preempt rearm |
| mine-h84-1 | gentle-lion-26 | 8×H200 | $28.00 | ~2026-08-09T01:56Z | H84 Tok-init r26 | **serve** teacher/king |

SSH: h80 .236:40311 · h81 .19:20100 · h82 .21:20100 ·
h83 .18:20098 · h84 .237:40311 ·
known_hosts `/tmp/mine-h{80,81,82,83,84}-1.known_hosts` ·
**Free: 0**. Cap 5. Burn ~$151.8/h mining.
Account also has non-mine `wan-lora-*` / `affine-*` — **never rm**.

## Dead

| name | final spent | removed UTC | reason |
|---|---|---|---|
| mine-h79-1 | ~$48 | 2026-08-08T13:56Z | H79 m=−0.007836 vs Tok (Tok-init r18) |
| mine-h77-1 | ~$52 | 2026-08-08T13:43Z | H77 m=−0.021756 vs Tok (r17 closed) |
| mine-h76-1 | ~$56 | 2026-08-08T13:29Z | H76 m=−0.019735 vs Tok (r18 closed) |
| mine-h78-1 | ~$50 | 2026-08-08T13:18Z | H78 m=−0.007412 vs Tok (r=21) |
| mine-h75-1 | ~$42 | 2026-08-08T12:25Z | H75 m=+0.000550 vs Tok |

## Recent reconciles (last 3)

| UTC | lium ps mine-* | action |
|---|---|---|
| 2026-08-08T14:21Z | h80/81/82/83/84 | H81 n80+mid304; rearm h83 preempt; no rent/rm |
| 2026-08-08T14:08Z | h80/81/82/83/84 | H83 train; rearm h81/h82 preempt; no rent/rm |
| 2026-08-08T14:03Z | h80/81/82/83/84 | H82 train→merge; H84 train; no rent/rm |
