# INVENTORY — mine-* pods only

**Cap: 40 lines.** Live table + last 3 reconciles. Never touch non-`mine-*`.
Pre-compaction: `archive/INVENTORY-full-2026-08-07.md`.
**Pod cap: 20** (operator 2026-08-08). Burn cap $833/h.

## Live

| name | huid | gpu | $/hr | remove_at | purpose | status |
|---|---|---|---|---|---|---|
| mine-f17-1 | eager-eagle-f3 | 8×H200 | $31.92 | 2026-08-09T14:02Z | H112 F17 raw-genesis | **n80 ~57** |
| mine-f22-1 | calm-hawk-98 | 8×B300 | $63.60 | 2026-08-09T14:27Z | H117 F22 raw-everest12 | everest ~54G |
| mine-f23-1 | lunar-matrix-eb | 8×B300 | $63.60 | 2026-08-09T14:31Z | H118 F23 raw-Bittob | **n80 started** |
| mine-f25-1 | eager-orbit-09 | 8×H200 | $24.40 | 2026-08-09T15:20Z | H120 F25 raw-golden | **n80 ~44** |
| mine-f26-1 | gentle-fox-2c | 8×H200 | $23.20 | 2026-08-09T16:12Z | H121 F26 full-FT | **train ~12/60** |
| mine-f27-1 | eager-orbit-15 | 8×H200 | $28.00 | 2026-08-09T16:16Z | H122 F27 gen-FT | **train ~5/60** |
| mine-f28-1 | eager-eagle-b1 | 8×H200 | $28.00 | 2026-08-09T16:20Z | H123 F28 trefs-FT | Tok DL |
| mine-f29-1 | gentle-shark-9c | 8×H200 | $28.00 | 2026-08-09T16:26Z | H124 F29 gold-FT | **boot** |

SSH: f17:20099 f22:40300 f23:40301 f25:20126 f26:40300 f27:40299 f28:40300 f29:40300 · kh `/tmp/mine-*-1.known_hosts`.
**Free: 12**. Burn ~$290.7/h. Non-mine — **never rm**.

## Dead (recent)
mine-f18-1 REFUTE m=−0.03010 (p460); mine-f16-1 −0.07623; mine-f24-1 −0.08673;
mine-f21-1 −0.07226; mine-f20-1 −0.02975; mine-f19-1 −0.00611.

## Recent reconciles (last 3)

| UTC | lium ps mine-* | action |
|---|---|---|
| 2026-08-09T04:26Z | 8 live | rent mine-f29-1 H200@$28 COUNT=8; F29 golden-FT; burn→~$290.7/h |
| 2026-08-09T04:21Z | 7 live | rent mine-f28-1 H200@$28 COUNT=8; F28 teacher-refs FT; burn→~$262.7/h |
| 2026-08-09T04:17Z | 6 live | rent mine-f27-1 H200@$28 COUNT=8; F27 Genesis-FT; burn→~$234.7/h |
