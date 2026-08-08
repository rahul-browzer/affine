# INVENTORY — mine-* pods only

**Cap: 40 lines.** Live table + last 3 reconciles. Never touch non-`mine-*`.
Pre-compaction: `archive/INVENTORY-full-2026-08-07.md`.

## Live

| name | huid | gpu | $/hr | remove_at | purpose | status |
|---|---|---|---|---|---|---|
| mine-h88-1 | zesty-hawk-be | 8×H200 | $31.92 | ~2026-08-09T03:32Z | H88 Tok-init r30 | n80+mid304 ~71/80 |
| mine-h90-1 | noble-shark-3c | 8×H200 | $28.00 | ~2026-08-09T04:23Z | H90 Tok-init r14 | n80+mid304 |
| mine-h91-1 | brave-shark-d2 | 8×H200 | $31.92 | ~2026-08-09T04:31Z | H91 Tok-init r12 | chall loading |
| mine-h92-1 | calm-lion-f6 | 8×H200 | $28.00 | ~2026-08-09T05:12Z | H92 Tok-init r13 | train live |
| mine-h93-1 | eager-raven-1e | 8×H200 | $31.92 | ~2026-08-09T05:21Z | H93 Tok-init r15 | bootstrap |

SSH: h88 .19:20100 · h90 .232:40310 · h91 .18:20099 ·
h92 .236:40300 · h93 .22:20099 ·
known_hosts `/tmp/mine-h{88,90,91,92,93}-1.known_hosts` ·
**Free: 0**. Cap 5. Burn ~$151.8/h mining.
Account also has non-mine `wan-lora-*` / `affine-*` — **never rm**.

## Dead

| name | final spent | removed UTC | reason |
|---|---|---|---|
| mine-h89-1 | ~$48 | 2026-08-08T17:20Z | H89 m=−0.007241 vs Tok (Tok-init r31) |
| mine-h87-1 | ~$52 | 2026-08-08T17:12Z | H87 m=+0.005075 vs Tok (Tok-init r29) |
| mine-h86-1 | ~$42 | 2026-08-08T16:30Z | H86 m=−0.000341 vs Tok (Tok-init r28) |
| mine-h85-1 | ~$50 | 2026-08-08T16:20Z | H85 m=−0.008170 vs Tok (Tok-init r27) |
| mine-h83-1 | ~$60 | 2026-08-08T15:37Z | H83 m=+0.001012 vs Tok (Tok-init r25) |

## Recent reconciles (last 3)

| UTC | lium ps mine-* | action |
|---|---|---|
| 2026-08-08T17:22Z | h88/90/91/92/93 | H89 REFUTE+rm; H90 mid304; rent H93 |
| 2026-08-08T17:16Z | h88/89/90/91/92 | H90 retry rearm 120; H91 king340 DONE |
| 2026-08-08T17:13Z | h88/89/90/91/92 | H87 rm+REFUTE; H90/91 king340; rent H92 |
