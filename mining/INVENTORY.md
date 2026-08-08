# INVENTORY — mine-* pods only

**Cap: 40 lines.** Live table + last 3 reconciles. Never touch non-`mine-*`.
Pre-compaction: `archive/INVENTORY-full-2026-08-07.md`.

## Live

| name | huid | gpu | $/hr | remove_at | purpose | status |
|---|---|---|---|---|---|---|
| mine-h83-1 | cosmic-matrix-be | 8×H200 | $31.92 | ~2026-08-09T01:44Z | H83 Tok-init r25 | **n80** ~70/80 |
| mine-h85-1 | eager-fox-a3 | 8×H200 | $28.00 | ~2026-08-09T02:34Z | H85 Tok-init r27 | **n80+mid304** |
| mine-h86-1 | calm-wolf-21 | 8×H200 | $28.00 | ~2026-08-09T02:59Z | H86 Tok-init r28 | **train** |
| mine-h87-1 | swift-shark-4f | 8×H200 | $31.92 | ~2026-08-09T03:31Z | H87 Tok-init r29 | **bootstrap** |
| mine-h88-1 | zesty-hawk-be | 8×H200 | $31.92 | ~2026-08-09T03:32Z | H88 Tok-init r30 | **bootstrap** |

SSH: h83 .18:20098 · h85 .232:40300 · h86 .236:40300 ·
h87 .22:20100 · h88 .19:20100 ·
known_hosts `/tmp/mine-h{83,85,86,87,88}-1.known_hosts` ·
**Free: 0**. Cap 5. Burn ~$151.8/h mining.
Account also has non-mine `wan-lora-*` / `affine-*` — **never rm**.

## Dead

| name | final spent | removed UTC | reason |
|---|---|---|---|
| mine-h84-1 | ~$36 | 2026-08-08T15:32Z | H84 m=−0.002423 vs Tok (Tok-init r26) |
| mine-h82-1 | ~$64 | 2026-08-08T15:30Z | H82 m=−0.004388 vs Tok (Tok-init r23) |
| mine-h81-1 | ~$53 | 2026-08-08T14:59Z | H81 m=+0.008811 vs Tok (Tok-init r22) |
| mine-h80-1 | ~$59 | 2026-08-08T14:33Z | H80 m=−0.000821 vs Tok (Tok-init r17) |
| mine-h79-1 | ~$48 | 2026-08-08T13:56Z | H79 m=−0.007836 vs Tok (Tok-init r18) |

## Recent reconciles (last 3)

| UTC | lium ps mine-* | action |
|---|---|---|
| 2026-08-08T15:32Z | h83/85/86/87/88 | H82+H84 REFUTE→rm; rent h87+h88; H85 n80 |
| 2026-08-08T15:05Z | h82/83/84/85/86 | H85 n80+mid304+recover; no rent/rm |
| 2026-08-08T15:00Z | h82/83/84/85/86 | H81 REFUTE→rm; rent h86 r28; no other rm |
