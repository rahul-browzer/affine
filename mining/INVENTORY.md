# INVENTORY — mine-* pods only

**Cap: 40 lines.** Live table + last 3 reconciles. Never touch non-`mine-*`.
Pre-compaction: `archive/INVENTORY-full-2026-08-07.md`.
**Pod cap: 20** (operator 2026-08-08). Burn cap $833/h.

## Live

| name | huid | gpu | $/hr | remove_at | purpose | status |
|---|---|---|---|---|---|---|
| mine-h96-1 | golden-matrix-af | 8×H200 | $28.00 | ~2026-08-09T06:52Z | H96 Tok r9 | **n80~79/80** |
| mine-f3-1 | noble-raven-ff | 8×H200 | $28.00 | ~2026-08-09T07:01Z | H97 F3 r256 | **n80~69/80+mid304** |
| mine-f1-1 | brave-hawk-5a | 8×H200 | $33.81 | ~2026-08-09T07:06Z | H98 F1 RL | train~150/200+T/K200 |
| mine-f4-1 | calm-wolf-30 | 8×B300 | $63.60 | ~2026-08-09T07:18Z | H100 F4 Genesis | merge+Tok DL |
| mine-f6-1 | noble-shark-14 | 8×H200 | $28.00 | ~2026-08-09T08:42Z | H101 F6 shortfmt | **bootstrap** |

SSH: h96 .232:40299 · f3 .236:40311 · f1 .54:40099 ·
f4 204.9.206.243:40099 · f6 .237:40300 ·
kh `~/.ssh/id_ed25519` + `/tmp/mine-*-1.known_hosts`.
**Free: 15**. Burn ~$181.4/h. Non-mine — **never rm**.

## Dead

| name | final spent | removed UTC | reason |
|---|---|---|---|
| mine-f2-1 | ~$57 | 2026-08-08T20:38Z | H99/F2 REFUTE m=−0.001994 vs Tok |
| mine-h95-1 | ~$70 | 2026-08-08T20:15Z | H95 REFUTE m=+0.001489 vs Tok |
| mine-h94-1 | ~$53 | 2026-08-08T19:22Z | H94 m=−0.013746 vs Tok |
| mine-h91-1 | ~$91 | 2026-08-08T19:21Z | H91 m=−0.005604 vs Tok |

## Recent reconciles (last 3)

| UTC | lium ps mine-* | action |
|---|---|---|
| 2026-08-08T20:43Z | 5 live (+f6) | rent mine-f6-1 H200@$28; H101/F6 bootstrap |
| 2026-08-08T20:38Z | 4 live after rm f2 | H99 REFUTE m=−0.002; rm mine-f2-1 |
| 2026-08-08T20:36Z | 5 live match inv | F4 train→merge; Tok DL resume; no rm/rent |
