# INVENTORY — mine-* pods only

**Cap: 40 lines.** Live table + last 3 reconciles. Never touch non-`mine-*`.
Pre-compaction: `archive/INVENTORY-full-2026-08-07.md`.
**Pod cap: 20** (operator 2026-08-08). Burn cap $833/h.

## Live

| name | huid | gpu | $/hr | remove_at | purpose | status |
|---|---|---|---|---|---|---|
| mine-f37-1 | calm-eagle-91 | 8×H200 | $23.20 | 2026-08-09T19:06Z | H132 F37 tok-rl-Λ2 | **n80 ~50/80** |
| mine-f38-1 | golden-eagle-8b | 8×H200 | $23.20 | 2026-08-09T19:51Z | H133 F38 gen-rl-Λ2 | **merge live** |
| mine-f39-1 | cosmic-matrix-95 | 8×H200 | $24.40 | 2026-08-09T20:06Z | H134 F39 tok-rl-S* | RL train |
| mine-f40-1 | zesty-wolf-91 | 8×H200 | $28.00 | 2026-08-09T20:12Z | H135 F40 kevin-rl-Λ2 | RL~110; **king p512** |
| mine-f41-1 | cosmic-fox-2d | 8×H200 | $28.00 | 2026-08-09T20:19Z | H136 F41 tpigs-rl-Λ2 | RL retrain |
| mine-f42-1 | noble-raven-de | 8×H200 | $28.00 | 2026-08-09T20:25Z | H137 F42 tok-bon-Λ2 | BoN train |
| mine-f43-1 | zesty-matrix-8e | 8×H200 | $31.92 | 2026-08-09T20:34Z | H138 F43 tok-dpo-Λ2 | **merge live** |

SSH: f37:40049 f38:40300 f39:20127 f40:40300 f41:40300 f42:40300 f43:20099 · kh `/tmp/mine-fNN.kh`.
**Free: 13**. Burn ~$186.7/h. Non-mine — **never rm**.

## Dead (recent)
mine-f43-1/golden-lion-4a COUNT=3 (p506 rm); mine-f36-1/−0.06667; mine-f32-1/−0.02626;
mine-f34-1/−0.06281; mine-f22-1/−0.06273; mine-f29-1/−0.09256; mine-f35-1/−0.08429;
mine-f33-1/−0.02161; mine-f26-1/−0.00031; mine-f27-1/−0.07068; mine-f31-1/−0.07651.

## Recent reconciles (last 3)

| UTC | lium ps mine-* | action |
|---|---|---|
| 2026-08-09T09:24Z | 7 live | F40 king shm-hang→king332 p512; F37 n80@50/80; F38/F43 merge |
| 2026-08-09T09:20Z | 7 live | F41 teacher:200+retrain mean_r≠0; F37 n80@43/80; F43 merge |
| 2026-08-09T09:12Z | 7 live | F41 teacher ENOENT@step0→kill train+recover332+retrain; F37 n80@28/80 |
