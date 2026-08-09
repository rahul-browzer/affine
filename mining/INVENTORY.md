# INVENTORY — mine-* pods only

**Cap: 40 lines.** Live table + last 3 reconciles. Never touch non-`mine-*`.
Pre-compaction: `archive/INVENTORY-full-2026-08-07.md`.
**Pod cap: 20** (operator 2026-08-08). Burn cap $833/h.

## Live

| name | huid | gpu | $/hr | remove_at | purpose | status |
|---|---|---|---|---|---|---|
| mine-f22-1 | calm-hawk-98 | 8×B300 | $63.60 | 2026-08-09T14:27Z | H117 F22 raw-everest12 | n80 ~14/80 |
| mine-f29-1 | gentle-shark-9c | 8×H200 | $28.00 | 2026-08-09T16:26Z | H124 F29 gold-FT | n80 ~69/80 |
| mine-f32-1 | noble-wolf-e8 | 8×H200 | $31.92 | 2026-08-09T16:49Z | H127 F32 talent-FT | n80 ~15/80 |
| mine-f33-1 | golden-matrix-f1 | 8×H200 | $24.40 | 2026-08-09T17:07Z | H128 F33 pandora-FT | n80 ~21/80 |
| mine-f34-1 | brave-eagle-b1 | 8×H200 | $31.92 | 2026-08-09T17:10Z | H129 F34 diane-FT | n80 ~8/80 |
| mine-f35-1 | zesty-matrix-04 | 8×B200 | $40.00 | 2026-08-09T17:19Z | H130 F35 everest-FT | king478 loading |
| mine-f36-1 | zesty-orbit-ff | 8×H200 | $33.81 | 2026-08-09T18:25Z | H131 F36 af-k1-FT | train/post_train |

SSH: f22/f29/f36:40300 f32/f34:20099 f33:20127 f35:20294 · kh `/tmp/mine-*-1.known_hosts`.
**Free: 13**. Burn ~$253.6/h. Non-mine — **never rm**.

## Dead (recent)
mine-f26-1 REFUTE m=−0.00031 (p490); mine-f27-1 m=−0.07068; mine-f31-1 m=−0.07651;
mine-f28-1 m=−0.00982; mine-f30-1 m=−0.01918 (p489); mine-f23-1/−0.084; mine-f25-1/−0.063.

## Recent reconciles (last 3)

| UTC | lium ps mine-* | action |
|---|---|---|
| 2026-08-09T06:57Z | 7 live | F26/F27/F31 REFUTE rm; F35 king478 loading; no rent |
| 2026-08-09T06:54Z | 10 live | F35 king478+watcher; F28/F30 REFUTE rm; F34 watcher fix |
| 2026-08-09T06:50Z | 12 live | F22+F32 king478→n80 e203; F35 still kingDEAD |
