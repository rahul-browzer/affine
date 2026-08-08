# INVENTORY — mine-* pods only

**Cap: 40 lines.** Live table + last 3 reconciles. Never touch non-`mine-*`.
Pre-compaction: `archive/INVENTORY-full-2026-08-07.md`.
**Pod cap: 20** (operator 2026-08-08). Burn cap $833/h.

## Live

| name | huid | gpu | $/hr | remove_at | purpose | status |
|---|---|---|---|---|---|---|
| mine-h91-1 | brave-shark-d2 | 8×H200 | $31.92 | ~2026-08-09T04:31Z | H91 Tok r12 | n80 ~54/80+mid304 |
| mine-h93-1 | eager-raven-1e | 8×H200 | $31.92 | ~2026-08-09T05:21Z | H93 Tok r15 | n80 ~65/80+mid304 |
| mine-h94-1 | cosmic-fox-43 | 8×H200 | $28.00 | ~2026-08-09T05:27Z | H94 Tok r11 | n80 ~46/80+mid304 |
| mine-h95-1 | calm-raven-0f | 8×H200 | $31.92 | ~2026-08-09T06:05Z | H95 Tok r10 | chall re-serve |
| mine-h96-1 | golden-matrix-af | 8×H200 | $28.00 | ~2026-08-09T06:52Z | H96 Tok r9 | train |
| mine-f3-1 | noble-raven-ff | 8×H200 | $28.00 | ~2026-08-09T07:01Z | H97 F3 r256 | BOOTSTRAP |
| mine-f1-1 | brave-hawk-5a | 8×H200 | $33.81 | ~2026-08-09T07:06Z | H98 F1 RL | BOOTSTRAP |

SSH: h91 .18:20099 · h93 .22:20099 · h94 .237:40311 · h95 .19:20100 ·
h96 .232:40299 · f3 .236:40311 · f1 .54:40099 · kh `/tmp/mine-h{91,93,94,95,96}-1` + `mine-f{3,1}-1`.
**Free: 13**. Burn ~$213.6/h. Non-mine `wan-lora-*`/`affine-*`/`glm52-*` — **never rm**.

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
| 2026-08-08T19:07Z | h91/93/94/95/96 + f3 + f1 | rent mine-f1-1 F1 RL; COUNT=8; bootstrap |
| 2026-08-08T19:02Z | h91/93/94/95/96 + f3 | rent mine-f3-1 F3 r256; no touch non-mine |
| 2026-08-08T18:53Z | h91/93/94/95/96 | H92 REFUTE→rm; rent h96 r9 |
