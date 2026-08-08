# INVENTORY — mine-* pods only

**Cap: 40 lines.** Live table + last 3 reconciles. Never touch non-`mine-*`.
Pre-compaction: `archive/INVENTORY-full-2026-08-07.md`.

## Live

| name | huid | gpu | $/hr | remove_at | purpose | status |
|---|---|---|---|---|---|---|
| mine-h82-1 | golden-comet-74 | 8×H200 | $31.92 | ~2026-08-09T01:29Z | H82 Tok-init r23 | **n80** ~46/80 |
| mine-h83-1 | cosmic-matrix-be | 8×H200 | $31.92 | ~2026-08-09T01:44Z | H83 Tok-init r25 | **n80** ~15/80 |
| mine-h84-1 | gentle-lion-26 | 8×H200 | $28.00 | ~2026-08-09T01:56Z | H84 Tok-init r26 | **n80** b203 ~30/80 |
| mine-h85-1 | eager-fox-a3 | 8×H200 | $28.00 | ~2026-08-09T02:34Z | H85 Tok-init r27 | **n80+recover+mid304** |
| mine-h86-1 | calm-wolf-21 | 8×H200 | $28.00 | ~2026-08-09T02:59Z | H86 Tok-init r28 | **train** |

SSH: h82 .21:20100 · h83 .18:20098 · h84 .237:40311 ·
h85 .232:40300 · h86 .236:40300 ·
known_hosts `/tmp/mine-h{82,83,84,85,86}-1.known_hosts` ·
**Free: 0**. Cap 5. Burn ~$147.8/h mining.
Account also has non-mine `wan-lora-*` / `affine-*` — **never rm**.

## Dead

| name | final spent | removed UTC | reason |
|---|---|---|---|
| mine-h81-1 | ~$53 | 2026-08-08T14:59Z | H81 m=+0.008811 vs Tok (Tok-init r22) |
| mine-h80-1 | ~$59 | 2026-08-08T14:33Z | H80 m=−0.000821 vs Tok (Tok-init r17) |
| mine-h79-1 | ~$48 | 2026-08-08T13:56Z | H79 m=−0.007836 vs Tok (Tok-init r18) |
| mine-h77-1 | ~$52 | 2026-08-08T13:43Z | H77 m=−0.021756 vs Tok (r17 closed) |
| mine-h76-1 | ~$56 | 2026-08-08T13:29Z | H76 m=−0.019735 vs Tok (r18 closed) |

## Recent reconciles (last 3)

| UTC | lium ps mine-* | action |
|---|---|---|
| 2026-08-08T15:05Z | h82/83/84/85/86 | H85 n80+mid304+recover; no rent/rm |
| 2026-08-08T15:00Z | h82/83/84/85/86 | H81 REFUTE→rm; rent h86 r28; no other rm |
| 2026-08-08T14:54Z | h81/82/83/84/85 | H84 n80 b203; H83 n80/mid304; no rent/rm |
