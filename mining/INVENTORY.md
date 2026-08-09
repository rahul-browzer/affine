# INVENTORY — mine-* pods only

**Cap: 40 lines.** Live table + last 3 reconciles. Never touch non-`mine-*`.
Pre-compaction: `archive/INVENTORY-full-2026-08-07.md`.
**Pod cap: 20** (operator 2026-08-08). Burn cap $833/h.

## Live

| name | huid | gpu | $/hr | remove_at | purpose | status |
|---|---|---|---|---|---|---|
| mine-f44-1 | swift-matrix-65 | 8×H200 | $28.00 | 2026-08-09T21:28Z | H139 F44 tok-odpo-Λ2 | n80 d203 @34/80 |
| mine-f45-1 | lunar-matrix-d4 | 8×H200 | $31.92 | 2026-08-09T21:35Z | H140 F45 tok-lastn-rl | n80 **d203 p529** @0/80 |
| mine-f46-1 | swift-comet-18 | 8×H200 | $23.20 | 2026-08-09T22:02Z | H141 F46 gen-lastn-rl | n80 d203 @39/80 |

SSH: f44:40300 f45:20099 f46:40061 · kh `/tmp/mine-fNN.kh`.
**Free: 17**. Burn ~$83/h. Non-mine — **never rm**.

## Dead (recent)
mine-f42-1/+0.00508 REFUTE (p534); mine-f40-1/−0.02343; mine-f41-1/−0.01159;
mine-f47-1/band 2.24×; mine-f39-1/+0.00267; mine-f38-1/−0.05342;
mine-f43-1/−0.00966; mine-f48-1/orphan; mine-f37-1/−0.00047; mine-f36-1/−0.06667.

## Recent reconciles (last 3)

| UTC | lium ps mine-* | action |
|---|---|---|
| 2026-08-09T11:52Z | 3 | F45 kill a203-retry→p529 d203; burn ~$83/h |
| 2026-08-09T11:49Z | 3 | F45 watcher→p529 + relaunch patch; burn ~$83/h |
| 2026-08-09T11:46Z | 4→3 | F42 REFUTE m=+0.00508 + rm; burn ~$83/h |
