# INVENTORY — mine-* pods only

**Cap: 40 lines.** Live table + last 3 reconciles. Never touch non-`mine-*`.
Pre-compaction: `archive/INVENTORY-full-2026-08-07.md`.

## Live

| name | huid | gpu | $/hr | remove_at | purpose | status |
|---|---|---|---|---|---|---|
| mine-h91-1 | brave-shark-d2 | 8×H200 | $31.92 | ~2026-08-09T04:31Z | H91 Tok-init r12 | n80+mid304 ~51/80 |
| mine-h92-1 | calm-lion-f6 | 8×H200 | $28.00 | ~2026-08-09T05:12Z | H92 Tok-init r13 | n80+mid304 ~33/80 |
| mine-h93-1 | eager-raven-1e | 8×H200 | $31.92 | ~2026-08-09T05:21Z | H93 Tok-init r15 | recover264 bare→isol |
| mine-h94-1 | cosmic-fox-43 | 8×H200 | $28.00 | ~2026-08-09T05:27Z | H94 Tok-init r11 | king recover util0.72 |
| mine-h95-1 | calm-raven-0f | 8×H200 | $31.92 | ~2026-08-09T06:05Z | H95 Tok-init r10 | bootstrap DL ~91% |

SSH: h91 .18:20099 · h92 .236:40300 · h93 .22:20099 ·
h94 .237:40311 · h95 .19:20100 ·
known_hosts `/tmp/mine-h{91,92,93,94,95}-1.known_hosts` ·
**Free: 0**. Cap 5. Burn ~$151.8/h mining.
Account also has non-mine `wan-lora-*` / `affine-*` — **never rm**.

## Dead

| name | final spent | removed UTC | reason |
|---|---|---|---|
| mine-h90-1 | ~$47 | 2026-08-08T18:05Z | H90 m=−0.008472 vs Tok (Tok-init r14) |
| mine-h88-1 | ~$60 | 2026-08-08T17:27Z | H88 m=+0.001358 vs Tok (Tok-init r30) |
| mine-h89-1 | ~$48 | 2026-08-08T17:20Z | H89 m=−0.007241 vs Tok (Tok-init r31) |
| mine-h87-1 | ~$52 | 2026-08-08T17:12Z | H87 m=+0.005075 vs Tok (Tok-init r29) |
| mine-h86-1 | ~$42 | 2026-08-08T16:30Z | H86 m=−0.000341 vs Tok (Tok-init r28) |

## Recent reconciles (last 3)

| UTC | lium ps mine-* | action |
|---|---|---|
| 2026-08-08T18:21Z | h91/92/93/94/95 | H94 king OOM→recover332; H93 mid304→recover264; no rent/rm |
| 2026-08-08T18:17Z | h91/92/93/94/95 | H94 freeze+n80+mid304; r12→r11 symlink; no rent/rm |
| 2026-08-08T18:08Z | h91/92/93/94/95 | H94 bare ENOENT → recover347; no rent/rm |
