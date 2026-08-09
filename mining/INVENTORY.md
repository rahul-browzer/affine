# INVENTORY — mine-* pods only

**Cap: 40 lines.** Live table + last 3 reconciles. Never touch non-`mine-*`.
Pre-compaction: `archive/INVENTORY-full-2026-08-07.md`.
**Pod cap: 20** (operator 2026-08-08). Burn cap $833/h.

## Live

| name | huid | gpu | $/hr | remove_at | purpose | status |
|---|---|---|---|---|---|---|
| mine-f17-1 | eager-eagle-f3 | 8×H200 | $31.92 | 2026-08-09T14:02Z | H112 F17 raw-genesis | **n80 ~30** |
| mine-f22-1 | calm-hawk-98 | 8×B300 | $63.60 | 2026-08-09T14:27Z | H117 F22 raw-everest12 | everest DL ~50G |
| mine-f23-1 | lunar-matrix-eb | 8×B300 | $63.60 | 2026-08-09T14:31Z | H118 F23 raw-Bittob | Tok DL ~63G |
| mine-f25-1 | eager-orbit-09 | 8×H200 | $24.40 | 2026-08-09T15:20Z | H120 F25 raw-golden | **n80 ~20** |
| mine-f26-1 | gentle-fox-2c | 8×H200 | $23.20 | 2026-08-09T16:12Z | H121 F26 full-FT | bootstrap/pip |

SSH: f17:20099 f22:40300 f23:40301 f25:20126 f26:40300 · kh `/tmp/mine-*-1.known_hosts`.
**Free: 15**. Burn ~$206.7/h. Non-mine — **never rm**.

## Dead (recent)
mine-f18-1 REFUTE m=−0.03010 (p460); mine-f16-1 −0.07623; mine-f24-1 −0.08673;
mine-f21-1 −0.07226; mine-f20-1 −0.02975; mine-f19-1 −0.00611.

## Recent reconciles (last 3)

| UTC | lium ps mine-* | action |
|---|---|---|
| 2026-08-09T04:12Z | 5 live | rent mine-f26-1 H200@$23.20 COUNT=8; F26 bootstrap; burn→~$206.7/h |
| 2026-08-09T04:08Z | 4 live | F18 REFUTE tear cosmic-matrix-19; burn →~$183.5/h |
| 2026-08-09T04:01Z | 5 live | F16 REFUTE tear calm-wolf-2f; burn →~$217.3/h |
