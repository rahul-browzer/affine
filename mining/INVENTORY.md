# INVENTORY — mine-* pods only

**Cap: 40 lines.** Live table + last 3 reconciles. Never touch non-`mine-*`.
Pre-compaction: `archive/INVENTORY-full-2026-08-07.md`.

## Live

| name | huid | gpu | $/hr | remove_at | purpose | status |
|---|---|---|---|---|---|---|
| mine-h87-1 | swift-shark-4f | 8×H200 | $31.92 | ~2026-08-09T03:31Z | H87 Tok-init r29 | chall frozen |
| mine-h88-1 | zesty-hawk-be | 8×H200 | $31.92 | ~2026-08-09T03:32Z | H88 Tok-init r30 | chall :8002=200 |
| mine-h89-1 | gentle-fox-06 | 8×H200 | $28.00 | ~2026-08-09T03:38Z | H89 Tok-init r31 | tchr+chall recover |
| mine-h90-1 | noble-shark-3c | 8×H200 | $28.00 | ~2026-08-09T04:23Z | H90 Tok-init r14 | bootstrap |
| mine-h91-1 | brave-shark-d2 | 8×H200 | $31.92 | ~2026-08-09T04:31Z | H91 Tok-init r12 | **bootstrap** |

SSH: h87 .22:20100 · h88 .19:20100 · h89 .237:40309 ·
h90 .232:40310 · h91 .18:20099 ·
known_hosts `/tmp/mine-h{87,88,89,90,91}-1.known_hosts` ·
**Free: 0**. Cap 5. Burn ~$151.8/h mining.
Account also has non-mine `wan-lora-*` / `affine-*` — **never rm**.

## Dead

| name | final spent | removed UTC | reason |
|---|---|---|---|
| mine-h86-1 | ~$42 | 2026-08-08T16:30Z | H86 m=−0.000341 vs Tok (Tok-init r28) |
| mine-h85-1 | ~$50 | 2026-08-08T16:20Z | H85 m=−0.008170 vs Tok (Tok-init r27) |
| mine-h83-1 | ~$60 | 2026-08-08T15:37Z | H83 m=+0.001012 vs Tok (Tok-init r25) |
| mine-h84-1 | ~$36 | 2026-08-08T15:32Z | H84 m=−0.002423 vs Tok (Tok-init r26) |
| mine-h82-1 | ~$64 | 2026-08-08T15:30Z | H82 m=−0.004388 vs Tok (Tok-init r23) |

## Recent reconciles (last 3)

| UTC | lium ps mine-* | action |
|---|---|---|
| 2026-08-08T16:31Z | h87/88/89/90/91 | rm h86 REFUTE; rent h91 @$31.92 ttl12h |
| 2026-08-08T16:24Z | h86/87/88/89/90 | rent h90 @$28/h ttl12h COUNT=8; H90 bootstrap |
| 2026-08-08T16:21Z | h86/87/88/89 | rm h85 REFUTE; H89 tchr+king recover332 |
