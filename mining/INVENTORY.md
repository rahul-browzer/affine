# INVENTORY — mine-* pods only

**Cap: 40 lines.** Live table + last 3 reconciles. Never touch non-`mine-*`.
Pre-compaction: `archive/INVENTORY-full-2026-08-07.md`.

## Live

| name | huid | gpu | $/hr | remove_at | purpose | status |
|---|---|---|---|---|---|---|
| mine-h91-1 | brave-shark-d2 | 8×H200 | $31.92 | ~2026-08-09T04:31Z | H91 Tok-init r12 | n80 ~31/80+mid304 |
| mine-h93-1 | eager-raven-1e | 8×H200 | $31.92 | ~2026-08-09T05:21Z | H93 Tok-init r15 | n80 ~46/80+mid304 |
| mine-h94-1 | cosmic-fox-43 | 8×H200 | $28.00 | ~2026-08-09T05:27Z | H94 Tok-init r11 | n80 ~28/80+mid304 |
| mine-h95-1 | calm-raven-0f | 8×H200 | $31.92 | ~2026-08-09T06:05Z | H95 Tok-init r10 | post_train/train |
| mine-h96-1 | golden-matrix-af | 8×H200 | $28.00 | ~2026-08-09T06:52Z | H96 Tok-init r9 | BOOTSTRAP |

SSH: h91 .18:20099 · h93 .22:20099 · h94 .237:40311 ·
h95 .19:20100 · h96 .232:40299 ·
known_hosts `/tmp/mine-h{91,93,94,95,96}-1.known_hosts` ·
**Free: 0**. Cap 5. Burn ~$151.8/h mining.
Account also has non-mine `wan-lora-*` / `affine-*` — **never rm**.

## Dead

| name | final spent | removed UTC | reason |
|---|---|---|---|
| mine-h92-1 | ~$47 | 2026-08-08T18:52Z | H92 m=+0.000618 vs Tok (Tok-init r13) |
| mine-h90-1 | ~$47 | 2026-08-08T18:05Z | H90 m=−0.008472 vs Tok (Tok-init r14) |
| mine-h88-1 | ~$60 | 2026-08-08T17:27Z | H88 m=+0.001358 vs Tok (Tok-init r30) |
| mine-h89-1 | ~$48 | 2026-08-08T17:20Z | H89 m=−0.007241 vs Tok (Tok-init r31) |
| mine-h87-1 | ~$52 | 2026-08-08T17:12Z | H87 m=+0.005075 vs Tok (Tok-init r29) |

## Recent reconciles (last 3)

| UTC | lium ps mine-* | action |
|---|---|---|
| 2026-08-08T18:53Z | h91/93/94/95/96 | H92 REFUTE→rm; rent h96 r9; no touch non-mine |
| 2026-08-08T18:36Z | h91/92/93/94/95 | H94 king ENOENT→re-fire→n80+mid304; H93 mid304 |
| 2026-08-08T18:21Z | h91/92/93/94/95 | H94 king OOM→recover332; H93 mid304→recover264 |
