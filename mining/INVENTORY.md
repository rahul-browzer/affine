# INVENTORY — mine-* pods only

**Cap: 40 lines.** Live table + last 3 reconciles. Never touch non-`mine-*`.
Pre-compaction: `archive/INVENTORY-full-2026-08-07.md`.
**Pod cap: 20** (operator 2026-08-08). Burn cap $833/h.

## Live

| name | huid | gpu | $/hr | remove_at | purpose | status |
|---|---|---|---|---|---|---|
| mine-f37-1 | calm-eagle-91 | 8×H200 | $23.20 | 2026-08-09T19:06Z | H132 F37 tok-rl-Λ2 | RL ~155/200 |
| mine-f38-1 | golden-eagle-8b | 8×H200 | $23.20 | 2026-08-09T19:51Z | H133 F38 gen-rl-Λ2 | RL train |
| mine-f39-1 | cosmic-matrix-95 | 8×H200 | $24.40 | 2026-08-09T20:06Z | H134 F39 tok-rl-S* | RL train |
| mine-f40-1 | zesty-wolf-91 | 8×H200 | $28.00 | 2026-08-09T20:12Z | H135 F40 kevin-rl-Λ2 | teacher serve |
| mine-f41-1 | cosmic-fox-2d | 8×H200 | $28.00 | 2026-08-09T20:19Z | H136 F41 tpigs-rl-Λ2 | base DL |
| mine-f42-1 | noble-raven-de | 8×H200 | $28.00 | 2026-08-09T20:25Z | H137 F42 tok-bon-Λ2 | bootstrap |

SSH: f37:40049 f38:40300 f39:20127 f40:40300 f41:40300 f42:40300 · kh `/tmp/mine-*-1.known_hosts`.
**Free: 14**. Burn ~$154.8/h. Non-mine — **never rm**.

## Dead (recent)
mine-f36-1 REFUTE m=−0.06667 (p504); mine-f32-1/−0.02626; mine-f34-1/−0.06281;
mine-f22-1/−0.06273; mine-f29-1/−0.09256; mine-f35-1/−0.08429; mine-f33-1/−0.02161;
mine-f26-1/−0.00031; mine-f27-1/−0.07068; mine-f31-1/−0.07651; mine-f28-1/−0.00982;
mine-f30-1/−0.01918.

## Recent reconciles (last 3)

| UTC | lium ps mine-* | action |
|---|---|---|
| 2026-08-09T08:26Z | 6 live | rent mine-f42-1 H137/F42 BoN @$28/h TTL12h; burn~$154.8/h |
| 2026-08-09T08:21Z | 5 live | F36 REFUTE+rm; rent mine-f41-1 H136/F41 @$28/h TTL12h; burn~$126.8/h |
| 2026-08-09T08:12Z | 5 live | rent mine-f40-1 H135/F40 @$28/h TTL12h; burn~$132.6/h |
