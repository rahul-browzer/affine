# INVENTORY — mine-* pods only

**Cap: 40 lines.** Live table + last 3 reconciles. Never touch non-`mine-*`.
Pre-compaction: `archive/INVENTORY-full-2026-08-07.md`.
**Pod cap: 20** (operator 2026-08-08). Burn cap $833/h.

## Live

| name | huid | gpu | $/hr | remove_at | purpose | status |
|---|---|---|---|---|---|---|
| mine-f22-1 | calm-hawk-98 | 8×B300 | $63.60 | 2026-08-09T14:27Z | H117 F22 raw-everest12 | n80 e203 |
| mine-f26-1 | gentle-fox-2c | 8×H200 | $23.20 | 2026-08-09T16:12Z | H121 F26 full-FT | n80 ~77/80 |
| mine-f27-1 | eager-orbit-15 | 8×H200 | $28.00 | 2026-08-09T16:16Z | H122 F27 gen-FT | n80 ~75/80 |
| mine-f29-1 | gentle-shark-9c | 8×H200 | $28.00 | 2026-08-09T16:26Z | H124 F29 gold-FT | n80 ~66/80 |
| mine-f31-1 | golden-hawk-bb | 8×H200 | $31.92 | 2026-08-09T16:39Z | H126 F31 bittob-FT | n80 ~76/80 |
| mine-f32-1 | noble-wolf-e8 | 8×H200 | $31.92 | 2026-08-09T16:49Z | H127 F32 talent-FT | n80 e203 |
| mine-f33-1 | golden-matrix-f1 | 8×H200 | $24.40 | 2026-08-09T17:07Z | H128 F33 pandora-FT | n80 early |
| mine-f34-1 | brave-eagle-b1 | 8×H200 | $31.92 | 2026-08-09T17:10Z | H129 F34 diane-FT | n80 d203 |
| mine-f35-1 | zesty-matrix-04 | 8×B200 | $40.00 | 2026-08-09T17:19Z | H130 F35 everest-FT | king478→n80 |
| mine-f36-1 | zesty-orbit-ff | 8×H200 | $33.81 | 2026-08-09T18:25Z | H131 F36 af-k1-FT | train/post_train |

SSH: f22/f26/f29/f36:40300 (f27:40299) f31/f32/f34:20099 f33:20127 f35:20294 · kh `/tmp/mine-*-1.known_hosts`.
**Free: 10**. Burn ~$336.8/h. Non-mine — **never rm**.

## Dead (recent)
mine-f28-1 REFUTE m=−0.00982 (p489); mine-f30-1 REFUTE m=−0.01918 (p489);
mine-f35-1 lunar-lion-a0 COUNT=4 tear (p471); mine-f23-1 REFUTE m=−0.08436;
mine-f25-1 −0.06343; mine-f17-1 −0.05489; mine-f18-1 −0.03010.

## Recent reconciles (last 3)

| UTC | lium ps mine-* | action |
|---|---|---|
| 2026-08-09T06:54Z | 10 live | F35 king478+watcher; F28/F30 REFUTE rm; F34 watcher fix; no rent |
| 2026-08-09T06:50Z | 12 live | F22+F32 king478→n80 e203; F35 still kingDEAD; no rent/rm |
| 2026-08-09T06:40Z | 12 live | F36 tf36→tf32 + train relaunch; no rent/rm |
