# INVENTORY — mine-* pods only

**Cap: 40 lines.** Live table + last 3 reconciles. Never touch non-`mine-*`.
Pre-compaction: `archive/INVENTORY-full-2026-08-07.md`.
**Pod cap: 20** (operator 2026-08-08). Burn cap $833/h.

## Live

| name | huid | gpu | $/hr | remove_at | purpose | status |
|---|---|---|---|---|---|---|
| mine-f38-1 | golden-eagle-8b | 8×H200 | $23.20 | 2026-08-09T19:51Z | H133 F38 gen-rl-Λ2 | n80 @48/80 |
| mine-f39-1 | cosmic-matrix-95 | 8×H200 | $24.40 | 2026-08-09T20:06Z | H134 F39 tok-rl-S* | chall load |
| mine-f40-1 | zesty-wolf-91 | 8×H200 | $28.00 | 2026-08-09T20:12Z | H135 F40 kevin-rl-Λ2 | n80 @19/80 |
| mine-f41-1 | cosmic-fox-2d | 8×H200 | $28.00 | 2026-08-09T20:19Z | H136 F41 tpigs-rl-Λ2 | n80 d203 p523 |
| mine-f42-1 | noble-raven-de | 8×H200 | $28.00 | 2026-08-09T20:25Z | H137 F42 tok-bon-Λ2 | BoN/idle |
| mine-f43-1 | zesty-matrix-8e | 8×H200 | $31.92 | 2026-08-09T20:34Z | H138 F43 tok-dpo-Λ2 | n80 @73/80 |
| mine-f44-1 | swift-matrix-65 | 8×H200 | $28.00 | 2026-08-09T21:28Z | H139 F44 tok-odpo-Λ2 | online-DPO |
| mine-f45-1 | lunar-matrix-d4 | 8×H200 | $31.92 | 2026-08-09T21:35Z | H140 F45 tok-lastn-rl | lastN RL |
| mine-f46-1 | swift-comet-18 | 8×H200 | $23.20 | 2026-08-09T22:02Z | H141 F46 gen-lastn-rl | bootstrap |
| mine-f47-1 | golden-matrix-bb | 8×H200 | $31.92 | 2026-08-09T22:07Z | H142 F47 raw-coder | bootstrap |

SSH: f38:40300 f39:20127 f40–42/f44:40300 f43/f45/f47:20099 f46:40061 · kh `/tmp/mine-fNN.kh`.
**Free: 10**. Burn ~$278.6/h. Non-mine — **never rm**.

## Dead (recent)
mine-f37-1/−0.00047; mine-f43-1/golden-lion-4a COUNT=3 (p506);
mine-f36-1/−0.06667; mine-f32-1/−0.02626; mine-f34-1/−0.06281;
mine-f22-1/−0.06273; mine-f29-1/−0.09256; mine-f35-1/−0.08429;
mine-f33-1/−0.02161; mine-f26-1/−0.00031; mine-f27-1/−0.07068.

## Recent reconciles (last 3)

| UTC | lium ps mine-* | action |
|---|---|---|
| 2026-08-09T10:26Z | 10 live | F41 a203 FP→rearm d203 p523; F43@73 F38@48; no rent/rm |
| 2026-08-09T10:14Z | 10 live | F40 salvage→n80 b203; F43@53 F38@32; no rent/rm |
| 2026-08-09T10:07Z | 10 live | rent mine-f47-1 @$31.92; F43@38/80 F38@19/80 F40 n80 |
