# INVENTORY — mine-* pods only

**Cap: 40 lines.** Live table + last 3 reconciles. Never touch non-`mine-*`.
Pre-compaction: `archive/INVENTORY-full-2026-08-07.md`.
**Pod cap: 20** (operator 2026-08-08). Burn cap $833/h.

## Live

| name | huid | gpu | $/hr | remove_at | purpose | status |
|---|---|---|---|---|---|---|
| mine-f38-1 | golden-eagle-8b | 8×H200 | $23.20 | 2026-08-09T19:51Z | H133 F38 gen-rl-Λ2 | chall recover264 |
| mine-f39-1 | cosmic-matrix-95 | 8×H200 | $24.40 | 2026-08-09T20:06Z | H134 F39 tok-rl-S* | RL train |
| mine-f40-1 | zesty-wolf-91 | 8×H200 | $28.00 | 2026-08-09T20:12Z | H135 F40 kevin-rl-Λ2 | merge_lora |
| mine-f41-1 | cosmic-fox-2d | 8×H200 | $28.00 | 2026-08-09T20:19Z | H136 F41 tpigs-rl-Λ2 | RL train |
| mine-f42-1 | noble-raven-de | 8×H200 | $28.00 | 2026-08-09T20:25Z | H137 F42 tok-bon-Λ2 | BoN train |
| mine-f43-1 | zesty-matrix-8e | 8×H200 | $31.92 | 2026-08-09T20:34Z | H138 F43 tok-dpo-Λ2 | **n80 @1/80** |
| mine-f44-1 | swift-matrix-65 | 8×H200 | $28.00 | 2026-08-09T21:28Z | H139 F44 tok-odpo-Λ2 | **teacher recover332** |
| mine-f45-1 | lunar-matrix-d4 | 8×H200 | $31.92 | 2026-08-09T21:35Z | H140 F45 tok-lastn-rl | tok DL |

SSH: f38:40300 f39:20127 f40–42/f44:40300 f43:20099 f45:20099 · kh `/tmp/mine-fNN.kh` (f44-1/f45-1).
**Free: 12**. Burn ~$223.4/h. Non-mine — **never rm**.

## Dead (recent)
mine-f37-1/−0.00047; mine-f43-1/golden-lion-4a COUNT=3 (p506);
mine-f36-1/−0.06667; mine-f32-1/−0.02626; mine-f34-1/−0.06281;
mine-f22-1/−0.06273; mine-f29-1/−0.09256; mine-f35-1/−0.08429;
mine-f33-1/−0.02161; mine-f26-1/−0.00031; mine-f27-1/−0.07068.

## Recent reconciles (last 3)

| UTC | lium ps mine-* | action |
|---|---|---|
| 2026-08-09T09:47Z | 8 live | F44 teacher recover332 (ENOENT); F43 n80@1/80 |
| 2026-08-09T09:45Z | 8 live | F37 REFUTE m=−0.00047 → rm mine-f37-1; F38 chall recover264 |
| 2026-08-09T09:36Z | 9 live | rent mine-f45-1 COUNT=8; F38 n80 launched; F37@69/80 |
