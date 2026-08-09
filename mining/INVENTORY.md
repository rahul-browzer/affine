# INVENTORY — mine-* pods only

**Cap: 40 lines.** Live table + last 3 reconciles. Never touch non-`mine-*`.
Pre-compaction: `archive/INVENTORY-full-2026-08-07.md`.
**Pod cap: 20** (operator 2026-08-08). Burn cap $833/h.

## Live

| name | huid | gpu | $/hr | remove_at | purpose | status |
|---|---|---|---|---|---|---|
| mine-f22-1 | calm-hawk-98 | 8×B300 | $63.60 | 2026-08-09T14:27Z | H117 F22 raw-everest12 | n80 ~20/19 |
| mine-f29-1 | gentle-shark-9c | 8×H200 | $28.00 | 2026-08-09T16:26Z | H124 F29 gold-FT | n80 e203 ~41 |
| mine-f32-1 | noble-wolf-e8 | 8×H200 | $31.92 | 2026-08-09T16:49Z | H127 F32 talent-FT | n80 restart ~5 |
| mine-f33-1 | golden-matrix-f1 | 8×H200 | $24.40 | 2026-08-09T17:07Z | H128 F33 pandora-FT | n80 ~53/53 |
| mine-f34-1 | brave-eagle-b1 | 8×H200 | $31.92 | 2026-08-09T17:10Z | H129 F34 diane-FT | n80 ~33/33 |
| mine-f35-1 | zesty-matrix-04 | 8×B200 | $40.00 | 2026-08-09T17:19Z | H130 F35 everest-FT | n80 ~27/27 |
| mine-f36-1 | zesty-orbit-ff | 8×H200 | $33.81 | 2026-08-09T18:25Z | H131 F36 af-k1-FT | finalize |
| mine-f37-1 | calm-eagle-91 | 8×H200 | $23.20 | 2026-08-09T19:06Z | H132 F37 tok-rl-Λ2 | teacher→train |

SSH: f22/f29/f36:40300 f32/f34:20099 f33:20127 f35:20294 f37:40049 · kh `/tmp/mine-*-1.known_hosts`.
**Free: 12**. Burn ~$276.8/h. Non-mine — **never rm**.

## Dead (recent)
mine-f26-1 REFUTE m=−0.00031 (p490); mine-f27-1 m=−0.07068; mine-f31-1 m=−0.07651;
mine-f28-1 m=−0.00982; mine-f30-1 m=−0.01918 (p489); mine-f23-1/−0.084; mine-f25-1/−0.063.

## Recent reconciles (last 3)

| UTC | lium ps mine-* | action |
|---|---|---|
| 2026-08-09T07:19Z | 8 live | F36 salvage ckpt50→finalize; no rent/rm; COUNT=8 |
| 2026-08-09T07:08Z | 8 live | rent mine-f37-1 F37 teacher-Λ2 RL; COUNT=8; no rm |
| 2026-08-09T07:02Z | 7 live | F29/F33 watcher rearm; relaunch_chall f26→real EXP; no rent/rm |
