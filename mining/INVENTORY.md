# INVENTORY — mine-* pods only

**Cap: 40 lines.** Live table + last 3 reconciles. Never touch non-`mine-*`.
Pre-compaction: `archive/INVENTORY-full-2026-08-07.md`.
**Pod cap: 20** (operator 2026-08-08). Burn cap $833/h.

## Live

| name | huid | gpu | $/hr | remove_at | purpose | status |
|---|---|---|---|---|---|---|
| mine-f1-1 | brave-hawk-5a | 8×H200 | $33.81 | ~2026-08-09T07:06Z | H98 F1 RL | train~150/200+T/K200 |
| mine-f4-1 | calm-wolf-30 | 8×B300 | $63.60 | ~2026-08-09T07:18Z | H100 F4 Genesis | merge+Tok DL |
| mine-f6-1 | noble-shark-14 | 8×H200 | $28.00 | ~2026-08-09T08:42Z | H101 F6 shortfmt | train 0/60 |

SSH: f1 .54:40099 · f4 204.9.206.243:40099 · f6 .237:40300 ·
kh `~/.ssh/id_ed25519` + `/tmp/mine-*-1.known_hosts`.
**Free: 17**. Burn ~$125.4/h. Non-mine — **never rm**.

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
| 2026-08-08T20:50Z | 3 live after rm f3 | H97 REFUTE m=−0.015; rm mine-f3-1 |
| 2026-08-08T20:47Z | 4 live after rm h96 | H96 REFUTE m=+0.009; rm mine-h96-1 |
| 2026-08-08T20:43Z | 5 live (+f6) | rent mine-f6-1 H200@$28; H101/F6 bootstrap |
