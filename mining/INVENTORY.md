# INVENTORY — mine-* pods only

**Cap: 40 lines.** Live table + last 3 reconciles. Never touch non-`mine-*`.
Pre-compaction: `archive/INVENTORY-full-2026-08-07.md`.
**Pod cap: 20** (operator 2026-08-08). Burn cap $833/h.

## Live

| name | huid | gpu | $/hr | remove_at | purpose | status |
|---|---|---|---|---|---|---|
| mine-f42-1 | noble-raven-de | 8×H200 | $28.00 | 2026-08-09T20:25Z | H137 F42 tok-bon-Λ2 | n80 d203 @60/80 |
| mine-f44-1 | swift-matrix-65 | 8×H200 | $28.00 | 2026-08-09T21:28Z | H139 F44 tok-odpo-Λ2 | n80 d203 @10/80 |
| mine-f45-1 | lunar-matrix-d4 | 8×H200 | $31.92 | 2026-08-09T21:35Z | H140 F45 tok-lastn-rl | n80 a203 @40/80 |
| mine-f46-1 | swift-comet-18 | 8×H200 | $23.20 | 2026-08-09T22:02Z | H141 F46 gen-lastn-rl | n80 d203 @15/80 |

SSH: f42/f44:40300 f45:20099 f46:40061 · kh `/tmp/mine-fNN.kh`.
**Free: 16**. Burn ~$111/h. Non-mine — **never rm**.

## Dead (recent)
mine-f40-1/−0.02343 REFUTE (p533); mine-f41-1/−0.01159; mine-f47-1/band 2.24×;
mine-f39-1/+0.00267; mine-f38-1/−0.05342; mine-f43-1/−0.00966; mine-f48-1/orphan;
mine-f37-1/−0.00047; mine-f36-1/−0.06667; mine-f32-1/−0.02626; mine-f34-1/−0.06281.

## Recent reconciles (last 3)

| UTC | lium ps mine-* | action |
|---|---|---|
| 2026-08-09T11:38Z | 5→4 | F40 REFUTE m=−0.02343 + rm; burn ~$111/h |
| 2026-08-09T11:33Z | 6→5 | F41 REFUTE m=−0.01159 + rm; burn ~$139/h |
| 2026-08-09T11:29Z | 6 live | match; F44 recover DONE+p529 watcher; F46 watcher→p529 |
