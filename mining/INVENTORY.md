# INVENTORY — mine-* pods only

**Cap: 40 lines.** Live table + last 3 reconciles. Never touch non-`mine-*`.
Pre-compaction: `archive/INVENTORY-full-2026-08-07.md`.
**Pod cap: 20** (operator 2026-08-08). Burn cap $833/h.

## Live

| name | huid | gpu | $/hr | remove_at | purpose | status |
|---|---|---|---|---|---|---|
| mine-f4-1 | calm-wolf-30 | 8×B300 | $63.60 | 2026-08-09T07:18Z | H100 F4 Genesis | teacher recover332→n80 |
| mine-f7-1 | lunar-shark-87 | 8×H200 | $28.00 | 2026-08-09T08:52Z | H102 F7 teacher-zC | n80 b203 ~5/8 |
| mine-f8-1 | brave-matrix-d8 | 8×H200 | $28.00 | 2026-08-09T09:04Z | H103 F8 Genesis-RL | n80 a203 ~31/31 |
| mine-f9-1 | lunar-fox-0a | 8×H200 | $31.92 | 2026-08-09T09:12Z | H104 F9 kevin-base | n80 b203 ~39/40 |

SSH: f4 204.9.206.243:40099 · f7 .232:40311 · f8 .236:40309 ·
f9 38.255.28.18:20099 · kh `~/.ssh/id_ed25519` + `/tmp/mine-*-1.known_hosts`.
**Free: 16**. Burn ~$151.5/h. Non-mine — **never rm**.

## Dead

| name | final spent | removed UTC | reason |
|---|---|---|---|
| mine-f6-1 | ~$56 | 2026-08-08T22:42Z | H101/F6 REFUTE m=−0.00453 vs Tok |
| mine-f1-1 | ~$106 | 2026-08-08T22:14Z | H98/F1 REFUTE m=+0.00229 vs Tok |
| mine-f3-1 | ~$50 | 2026-08-08T20:50Z | H97/F3 REFUTE m=−0.01506 vs Tok |
| mine-h96-1 | ~$53 | 2026-08-08T20:47Z | H96 REFUTE m=+0.00913 vs Tok |
| mine-f2-1 | ~$57 | 2026-08-08T20:38Z | H99/F2 REFUTE m=−0.001994 vs Tok |

## Recent reconciles (last 3)

| UTC | lium ps mine-* | action |
|---|---|---|
| 2026-08-08T23:17Z | 4 live | F4 teacher ENOENT→recover332; no rm/rent |
| 2026-08-08T23:14Z | 4 live | F4 cuda404→n80; kill stale p401/p403; no rm/rent |
| 2026-08-08T23:07Z | 4 live | F4 cuda404 cudart symlink relaunch; no rm/rent |
