# INVENTORY — mine-* pods only

**Cap: 40 lines.** Live table + last 3 reconciles. Never touch non-`mine-*`.
Pre-compaction: `archive/INVENTORY-full-2026-08-07.md`.
**Pod cap: 20** (operator 2026-08-08). Burn cap $833/h.

## Live

| name | huid | gpu | $/hr | remove_at | purpose | status |
|---|---|---|---|---|---|---|
| mine-h91-1 | brave-shark-d2 | 8×H200 | $31.92 | ~2026-08-09T04:31Z | H91 Tok r12 | n80 ~45/80+mid304 |
| mine-h93-1 | eager-raven-1e | 8×H200 | $31.92 | ~2026-08-09T05:21Z | H93 Tok r15 | n80 ~57/80+mid304 |
| mine-h94-1 | cosmic-fox-43 | 8×H200 | $28.00 | ~2026-08-09T05:27Z | H94 Tok r11 | n80 ~42/80+mid304 |
| mine-h95-1 | calm-raven-0f | 8×H200 | $31.92 | ~2026-08-09T06:05Z | H95 Tok r10 | CPU merge |
| mine-h96-1 | golden-matrix-af | 8×H200 | $28.00 | ~2026-08-09T06:52Z | H96 Tok r9 | train |
| mine-f3-1 | noble-raven-ff | 8×H200 | $28.00 | ~2026-08-09T07:01Z | H97 F3 r256 | BOOTSTRAP |

SSH: h91 .18:20099 · h93 .22:20099 · h94 .237:40311 ·
h95 .19:20100 · h96 .232:40299 · f3 .236:40311 ·
known_hosts `/tmp/mine-h{91,93,94,95,96}-1.known_hosts` + `/tmp/mine-f3-1.known_hosts`.
**Free: 14**. Burn ~$179.8/h mining.
Account also has non-mine `wan-lora-*` / `affine-*` / `glm52-*` — **never rm**.

## Dead

| name | final spent | removed UTC | reason |
|---|---|---|---|
| mine-h92-1 | ~$47 | 2026-08-08T18:52Z | H92 m=+0.000618 vs Tok |
| mine-h90-1 | ~$47 | 2026-08-08T18:05Z | H90 m=−0.008472 vs Tok |
| mine-h88-1 | ~$60 | 2026-08-08T17:27Z | H88 m=+0.001358 vs Tok |
| mine-h89-1 | ~$48 | 2026-08-08T17:20Z | H89 m=−0.007241 vs Tok |
| mine-h87-1 | ~$52 | 2026-08-08T17:12Z | H87 m=+0.005075 vs Tok |

## Recent reconciles (last 3)

| UTC | lium ps mine-* | action |
|---|---|---|
| 2026-08-08T19:02Z | h91/93/94/95/96 + f3 | rent mine-f3-1 F3 r256; no touch non-mine |
| 2026-08-08T18:53Z | h91/93/94/95/96 | H92 REFUTE→rm; rent h96 r9 |
| 2026-08-08T18:36Z | h91/92/93/94/95 | H94 king re-fire+n80; H93 mid304 |
