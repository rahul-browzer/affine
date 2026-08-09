# INVENTORY — mine-* pods only

**Cap: 40 lines.** Live table + last 3 reconciles. Never touch non-`mine-*`.
Pre-compaction: `archive/INVENTORY-full-2026-08-07.md`.
**Pod cap: 20** (operator 2026-08-08). Burn cap $833/h.

## Live

| name | huid | gpu | $/hr | remove_at | purpose | status |
|---|---|---|---|---|---|---|
| mine-f40-1 | zesty-wolf-91 | 8×H200 | $28.00 | 2026-08-09T20:12Z | H135 F40 kevin-rl-Λ2 | n80 c203 @34/80 |
| mine-f41-1 | cosmic-fox-2d | 8×H200 | $28.00 | 2026-08-09T20:19Z | H136 F41 tpigs-rl-Λ2 | n80 e203 @45/80 |
| mine-f42-1 | noble-raven-de | 8×H200 | $28.00 | 2026-08-09T20:25Z | H137 F42 tok-bon-Λ2 | n80 d203 @20/80 |
| mine-f44-1 | swift-matrix-65 | 8×H200 | $28.00 | 2026-08-09T21:28Z | H139 F44 tok-odpo-Λ2 | n80 starting |
| mine-f45-1 | lunar-matrix-d4 | 8×H200 | $31.92 | 2026-08-09T21:35Z | H140 F45 tok-lastn-rl | n80 a203 @6/80 |
| mine-f46-1 | swift-comet-18 | 8×H200 | $23.20 | 2026-08-09T22:02Z | H141 F46 gen-lastn-rl | recover264 |
| mine-f47-1 | golden-matrix-bb | 8×H200 | $31.92 | 2026-08-09T22:07Z | H142 F47 raw-coder | n80 @53/80 |

SSH: f40–42/f44:40300 f45/f47:20099 f46:40061 · kh `/tmp/mine-fNN.kh`.
**Free: 13**. Burn ~$199/h. Non-mine — **never rm**.

## Dead (recent)
mine-f39-1/+0.00267 REFUTE (p528); mine-f38-1/−0.05342 (p526); mine-f43-1/−0.00966;
mine-f48-1/orphan (p524); mine-f37-1/−0.00047; mine-f36-1/−0.06667;
mine-f32-1/−0.02626; mine-f34-1/−0.06281; mine-f22-1/−0.06273.

## Recent reconciles (last 3)

| UTC | lium ps mine-* | action |
|---|---|---|
| 2026-08-09T11:15Z | 8→7 | F39 REFUTE+rm; F45/F46 visual restore; burn ~$199/h |
| 2026-08-09T11:01Z | 8 live | match inv; F42 merge→n80 d203 p527; burn ~$223.4/h |
| 2026-08-09T10:42Z | 9→8 | F38 REFUTE m=−0.05342; rm mine-f38-1; burn ~$223.4/h |
