# INVENTORY — mine-* pods only

**Cap: 40 lines.** Live table + last 3 reconciles. Never touch non-`mine-*`.
Pre-compaction: `archive/INVENTORY-full-2026-08-07.md`.

## Live

| name | huid | gpu | $/hr | remove_at | purpose | status |
|---|---|---|---|---|---|---|
| mine-h86-1 | calm-wolf-21 | 8×H200 | $28.00 | ~2026-08-09T02:59Z | H86 Tok-init r28 | **n80** ~60/80 |
| mine-h87-1 | swift-shark-4f | 8×H200 | $31.92 | ~2026-08-09T03:31Z | H87 Tok-init r29 | chall bare+preempt |
| mine-h88-1 | zesty-hawk-be | 8×H200 | $31.92 | ~2026-08-09T03:32Z | H88 Tok-init r30 | **merge** |
| mine-h89-1 | gentle-fox-06 | 8×H200 | $28.00 | ~2026-08-09T03:38Z | H89 Tok-init r31 | tchr+king p332 |

SSH: h86 .236:40300 · h87 .22:20100 · h88 .19:20100 ·
h89 .237:40309 ·
known_hosts `/tmp/mine-h{86,87,88,89}-1.known_hosts` ·
**Free: 1**. Cap 5. Burn ~$119.8/h mining.
Account also has non-mine `wan-lora-*` / `affine-*` — **never rm**.

## Dead

| name | final spent | removed UTC | reason |
|---|---|---|---|
| mine-h85-1 | ~$50 | 2026-08-08T16:20Z | H85 m=−0.008170 vs Tok (Tok-init r27) |
| mine-h83-1 | ~$60 | 2026-08-08T15:37Z | H83 m=+0.001012 vs Tok (Tok-init r25) |
| mine-h84-1 | ~$36 | 2026-08-08T15:32Z | H84 m=−0.002423 vs Tok (Tok-init r26) |
| mine-h82-1 | ~$64 | 2026-08-08T15:30Z | H82 m=−0.004388 vs Tok (Tok-init r23) |
| mine-h81-1 | ~$53 | 2026-08-08T14:59Z | H81 m=+0.008811 vs Tok (Tok-init r22) |

## Recent reconciles (last 3)

| UTC | lium ps mine-* | action |
|---|---|---|
| 2026-08-08T16:21Z | h86/87/88/89 | rm h85 REFUTE; H89 tchr+king recover332; no rent |
| 2026-08-08T16:09Z | h85/86/87/88/89 | H87 teacher recover331; H89 recover264; no rent/rm |
| 2026-08-08T16:05Z | h85/86/87/88/89 | H89 train→merge→chall; H88 DL→train; no rent/rm |
