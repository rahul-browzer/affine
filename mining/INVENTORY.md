# INVENTORY — mine-* pods only

**Cap: 40 lines.** Live table + last 3 reconciles. Never touch non-`mine-*`.
Pre-compaction: `archive/INVENTORY-full-2026-08-07.md`.
**Pod cap: 20** (operator 2026-08-08). Burn cap $833/h.

## Live

| name | huid | gpu | $/hr | remove_at | purpose | status |
|---|---|---|---|---|---|---|
| mine-h95-1 | calm-raven-0f | 8×H200 | $31.92 | ~2026-08-09T06:05Z | H95 Tok r10 | **n80+mid304** |
| mine-h96-1 | golden-matrix-af | 8×H200 | $28.00 | ~2026-08-09T06:52Z | H96 Tok r9 | recover264 |
| mine-f3-1 | noble-raven-ff | 8×H200 | $28.00 | ~2026-08-09T07:01Z | H97 F3 r256 | chall load |
| mine-f1-1 | brave-hawk-5a | 8×H200 | $33.81 | ~2026-08-09T07:06Z | H98 F1 RL | train |
| mine-f2-1 | zesty-orbit-85 | 8×B200 | $40.00 | ~2026-08-09T07:13Z | H99 F2 Λ2 | train |
| mine-f4-1 | calm-wolf-30 | 8×B300 | $63.60 | ~2026-08-09T07:18Z | H100 F4 Genesis | bootstrap |

SSH: h95 .19:20100 · h96 .232:40299 · f3 .236:40311 ·
f1 .54:40099 · f2 150.136.71.147:20295 · f4 204.9.206.243:40099 ·
kh `~/.ssh/id_ed25519` + `/tmp/mine-*-1.known_hosts`.
**Free: 14**. Burn ~$225.3/h. Non-mine — **never rm**.

## Dead

| name | final spent | removed UTC | reason |
|---|---|---|---|
| mine-h94-1 | ~$53 | 2026-08-08T19:22Z | H94 m=−0.013746 vs Tok |
| mine-h91-1 | ~$91 | 2026-08-08T19:21Z | H91 m=−0.005604 vs Tok |
| mine-h93-1 | ~$62 | 2026-08-08T19:17Z | H93 m=−0.007210 vs Tok |
| mine-f2-1 (zesty-orbit-24) | ~$1 | 2026-08-08T19:12Z | COUNT=7≠8 (H200 catalog lie) |

## Recent reconciles (last 3)

| UTC | lium ps mine-* | action |
|---|---|---|
| 2026-08-08T19:31Z | 6 live match inv | H95 recover DONE→n80+mid304; H96 preempt→recover; no rm/rent |
| 2026-08-08T19:24Z | 6 live match inv | H95 mid304→bare→recover264; no rm/rent |
| 2026-08-08T19:22Z | −h91 −h94 | H91/H94 REFUTE; rm both; 6 live |
