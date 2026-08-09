# INVENTORY — mine-* pods only

**Cap: 40 lines.** Live table + last 3 reconciles. Never touch non-`mine-*`.
Pre-compaction: `archive/INVENTORY-full-2026-08-07.md`.
**Pod cap: 20** (operator 2026-08-08). Burn cap $833/h.

## Live

| name | huid | gpu | $/hr | remove_at | purpose | status |
|---|---|---|---|---|---|---|
| mine-f22-1 | calm-hawk-98 | 8×B300 | $63.60 | 2026-08-09T14:27Z | H117 F22 raw-everest12 | n80 ~76/80 |
| mine-f32-1 | noble-wolf-e8 | 8×H200 | $31.92 | 2026-08-09T16:49Z | H127 F32 talent-FT | n80 ~40/80 |
| mine-f34-1 | brave-eagle-b1 | 8×H200 | $31.92 | 2026-08-09T17:10Z | H129 F34 diane-FT | n80 ~70/80 |
| mine-f36-1 | zesty-orbit-ff | 8×H200 | $33.81 | 2026-08-09T18:25Z | H131 F36 af-k1-FT | n80 ~16/80 |
| mine-f37-1 | calm-eagle-91 | 8×H200 | $23.20 | 2026-08-09T19:06Z | H132 F37 tok-rl-Λ2 | RL step≥45 |

SSH: f22/f36:40300 f32/f34:20099 f37:40049 · kh `/tmp/mine-*-1.known_hosts`.
**Free: 15**. Burn ~$184.5/h. Non-mine — **never rm**.

## Dead (recent)
mine-f29-1 REFUTE m=−0.09256 (p498); mine-f35-1/−0.08429; mine-f33-1/−0.02161;
mine-f26-1/−0.00031; mine-f27-1/−0.07068; mine-f31-1/−0.07651; mine-f28-1/−0.00982;
mine-f30-1/−0.01918.

## Recent reconciles (last 3)

| UTC | lium ps mine-* | action |
|---|---|---|
| 2026-08-09T07:40Z | 5 live | F29 REFUTE m=−0.09256 +rm; burn~$184.5/h; no rent |
| 2026-08-09T07:37Z | 6 live | F35 REFUTE m=−0.0843 +rm; burn~$212.4/h; no rent |
| 2026-08-09T07:34Z | 7 live | F33 REFUTE+rm; F37 soft=18:06Z rearm; no rent |
