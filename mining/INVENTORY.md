# INVENTORY — mine-* pods only

**Cap: 40 lines.** Live table + last 3 reconciles. Never touch non-`mine-*`.
Pre-compaction: `archive/INVENTORY-full-2026-08-07.md`.
**Pod cap: 20** (operator 2026-08-08). Burn cap $833/h.

## Live

| name | huid | gpu | $/hr | remove_at | purpose | status |
|---|---|---|---|---|---|---|
| mine-f22-1 | calm-hawk-98 | 8×B300 | $63.60 | 2026-08-09T14:27Z | H117 F22 raw-everest12 | everest ~43G incomplete |
| mine-f23-1 | lunar-matrix-eb | 8×B300 | $63.60 | 2026-08-09T14:31Z | H118 F23 raw-Bittob | **n80 ~69** |
| mine-f26-1 | gentle-fox-2c | 8×H200 | $23.20 | 2026-08-09T16:12Z | H121 F26 full-FT | **train** |
| mine-f27-1 | eager-orbit-15 | 8×H200 | $28.00 | 2026-08-09T16:16Z | H122 F27 gen-FT | **train** |
| mine-f28-1 | eager-eagle-b1 | 8×H200 | $28.00 | 2026-08-09T16:20Z | H123 F28 trefs-FT | **train** |
| mine-f29-1 | gentle-shark-9c | 8×H200 | $28.00 | 2026-08-09T16:26Z | H124 F29 gold-FT | **train** |
| mine-f30-1 | lunar-wolf-aa | 8×H200 | $28.00 | 2026-08-09T16:31Z | H125 F30 kevin-FT | **train** |
| mine-f31-1 | golden-hawk-bb | 8×H200 | $31.92 | 2026-08-09T16:39Z | H126 F31 bittob-FT | **train** |
| mine-f32-1 | noble-wolf-e8 | 8×H200 | $31.92 | 2026-08-09T16:49Z | H127 F32 talent-FT | **pip/boot** |

SSH: f22:40300 f23:40301 f26–f30:40300 (f27:40299) f31/f32:20099 · kh `/tmp/mine-*-1.known_hosts`.
**Free: 11**. Burn ~$326.2/h. Non-mine — **never rm**.

## Dead (recent)
mine-f25-1 REFUTE m=−0.06343 (p467); mine-f17-1 −0.05489; mine-f18-1 −0.03010;
mine-f16-1 −0.07623; mine-f24-1 −0.08673; mine-f21-1 −0.07226; mine-f20-1 −0.02975.

## Recent reconciles (last 3)

| UTC | lium ps mine-* | action |
|---|---|---|
| 2026-08-09T04:50Z | 9 live | tear mine-f25-1 REFUTE; rent mine-f32-1 H200@$31.92 COUNT=8; F32 TalentPigs-FT |
| 2026-08-09T04:39Z | 9 live | tear mine-f17-1 REFUTE; rent mine-f31-1 H200@$31.92 COUNT=8; F31 Bittob-FT |
| 2026-08-09T04:31Z | 9 live | rent mine-f30-1 H200@$28 COUNT=8; F30 kevin-FT; burn→~$318.7/h |
