# INVENTORY — mine-* pods only

**Cap: 40 lines.** Live table + last 3 reconciles. Never touch non-`mine-*`.
Pre-compaction: `archive/INVENTORY-full-2026-08-07.md`.

## Live

| name | huid | gpu | $/hr | remove_at | purpose | status |
|---|---|---|---|---|---|---|
| mine-h88-1 | zesty-hawk-be | 8×H200 | $31.92 | ~2026-08-09T03:32Z | H88 Tok-init r30 | n80+mid304 ~66/80 |
| mine-h89-1 | gentle-fox-06 | 8×H200 | $28.00 | ~2026-08-09T03:38Z | H89 Tok-init r31 | n80+mid304 ~71/80 |
| mine-h90-1 | noble-shark-3c | 8×H200 | $28.00 | ~2026-08-09T04:23Z | H90 Tok-init r14 | king340+retry120 |
| mine-h91-1 | brave-shark-d2 | 8×H200 | $31.92 | ~2026-08-09T04:31Z | H91 Tok-init r12 | king DONE+merge |
| mine-h92-1 | calm-lion-f6 | 8×H200 | $28.00 | ~2026-08-09T05:12Z | H92 Tok-init r13 | bootstrap DL |

SSH: h88 .19:20100 · h89 .237:40309 · h90 .232:40310 ·
h91 .18:20099 · h92 .236:40300 ·
known_hosts `/tmp/mine-h{88,89,90,91,92}-1.known_hosts` ·
**Free: 0**. Cap 5. Burn ~$147.8/h mining.
Account also has non-mine `wan-lora-*` / `affine-*` — **never rm**.

## Dead

| name | final spent | removed UTC | reason |
|---|---|---|---|
| mine-h87-1 | ~$52 | 2026-08-08T17:12Z | H87 m=+0.005075 vs Tok (Tok-init r29) |
| mine-h86-1 | ~$42 | 2026-08-08T16:30Z | H86 m=−0.000341 vs Tok (Tok-init r28) |
| mine-h85-1 | ~$50 | 2026-08-08T16:20Z | H85 m=−0.008170 vs Tok (Tok-init r27) |
| mine-h83-1 | ~$60 | 2026-08-08T15:37Z | H83 m=+0.001012 vs Tok (Tok-init r25) |
| mine-h84-1 | ~$36 | 2026-08-08T15:32Z | H84 m=−0.002423 vs Tok (Tok-init r26) |

## Recent reconciles (last 3)

| UTC | lium ps mine-* | action |
|---|---|---|
| 2026-08-08T17:16Z | h88/89/90/91/92 | H90 retry rearm 120; H91 king340 DONE |
| 2026-08-08T17:13Z | h88/89/90/91/92 | H87 rm+REFUTE; H90/91 king340; rent H92 |
| 2026-08-08T17:06Z | h87/88/89/90/91 | H91 king339 recover + preempt rearm |
