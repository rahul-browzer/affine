# INVENTORY — mine-* pods only

**Cap: 40 lines.** Live table + last 3 reconciles. Never touch non-`mine-*`.
Pre-compaction: `archive/INVENTORY-full-2026-08-07.md`.
**Pod cap: 20** (operator 2026-08-08). Burn cap $833/h.

## Live

| name | huid | gpu | $/hr | remove_at | purpose | status |
|---|---|---|---|---|---|---|
| mine-f1-1 | brave-hawk-5a | 8×H200 | $33.81 | 2026-08-09T07:05Z | H98 F1 RL | n80 ~12/80 vs Tok |
| mine-f4-1 | calm-wolf-30 | 8×B300 | $63.60 | 2026-08-09T07:18Z | H100 F4 Genesis | Tok Range ~79% |
| mine-f6-1 | noble-shark-14 | 8×H200 | $28.00 | 2026-08-09T08:42Z | H101 F6 shortfmt | a2 compile post-load |
| mine-f7-1 | lunar-shark-87 | 8×H200 | $28.00 | 2026-08-09T08:52Z | H102 F7 teacher-zC | salvage unfrozen p386 |
| mine-f8-1 | brave-matrix-d8 | 8×H200 | $28.00 | 2026-08-09T09:04Z | H103 F8 Genesis-RL | RL train live |
| mine-f9-1 | lunar-fox-0a | 8×H200 | $31.92 | 2026-08-09T09:12Z | H104 F9 kevin-base | kevin LoRA train |

SSH: f1 .54:40099 · f4 204.9.206.243:40099 · f6 .237:40300 · f7 .232:40311 ·
f8 .236:40309 · f9 38.255.28.18:20099 · kh `~/.ssh/id_ed25519` + `/tmp/mine-*-1.known_hosts`.
**Free: 14**. Burn ~$213.3/h. Non-mine — **never rm**.

## Dead

| name | final spent | removed UTC | reason |
|---|---|---|---|
| mine-f3-1 | ~$50 | 2026-08-08T20:50Z | H97/F3 REFUTE m=−0.01506 vs Tok |
| mine-h96-1 | ~$53 | 2026-08-08T20:47Z | H96 REFUTE m=+0.00913 vs Tok |
| mine-f2-1 | ~$57 | 2026-08-08T20:38Z | H99/F2 REFUTE m=−0.001994 vs Tok |
| mine-h95-1 | ~$70 | 2026-08-08T20:15Z | H95 REFUTE m=+0.001489 vs Tok |

## Recent reconciles (last 3)

| UTC | lium ps mine-* | action |
|---|---|---|
| 2026-08-08T21:41Z | 6 live | F7 unfreeze salvage 555 hang; no rm/rent |
| 2026-08-08T21:38Z | 6 live | F6 peer-seed from F7; F7 n80 live; no rm/rent |
| 2026-08-08T21:33Z | 6 live | F7 midload seed; F1 n80; no rm/rent |
