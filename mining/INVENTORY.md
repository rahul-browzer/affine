# INVENTORY — mine-* pods only

**Cap: 40 lines.** Live table + last 3 reconciles. Never touch non-`mine-*`.
Pre-compaction: `archive/INVENTORY-full-2026-08-07.md`.
**Pod cap: 20** (operator 2026-08-08). Burn cap $833/h.

## Live

| name | huid | gpu | $/hr | remove_at | purpose | status |
|---|---|---|---|---|---|---|
| mine-f10-1 | eager-wolf-42 | 8×H200 | $28.00 | 2026-08-09T11:54Z | H105 F10 TalentPigs LoRA | **n80 ~70/80** |
| mine-f13-1 | zesty-hawk-1f | 8×H200 | $31.92 | 2026-08-09T12:17Z | H108 F13 diane613 | **n80 ~40** |
| mine-f14-1 | eager-comet-be | 8×H200 | $28.00 | 2026-08-09T12:34Z | H109 F14 Bittob | **n80 ~45** |
| mine-f15-1 | calm-wolf-f7 | 8×H200 | $31.92 | 2026-08-09T12:37Z | H110 F15 everest12 | **n80 ~45** |
| mine-f16-1 | calm-wolf-2f | 8×H200 | $28.00 | 2026-08-09T13:57Z | H111 F16 af-k1 | post_train→chall |
| mine-f17-1 | eager-eagle-f3 | 8×H200 | $31.92 | 2026-08-09T14:02Z | H112 F17 raw-genesis | **king449 recover** |
| mine-f18-1 | cosmic-matrix-19 | 8×H200 | $33.81 | 2026-08-09T14:06Z | H113 F18 raw-TalentPigs | chall load |
| mine-f19-1 | eager-comet-12 | 8×H200 | $24.40 | 2026-08-09T14:12Z | H114 F19 raw-kevin | **n80 ~20** |
| mine-f20-1 | lunar-raven-37 | 8×H200 | $23.20 | 2026-08-09T14:15Z | H115 F20 raw-pandora | **n80 ~5** |
| mine-f21-1 | lunar-comet-f7 | 8×B200 | $40.00 | 2026-08-09T14:19Z | H116 F21 raw-diane | health200 ≠probe |
| mine-f22-1 | calm-hawk-98 | 8×B300 | $63.60 | 2026-08-09T14:27Z | H117 F22 raw-everest12 | bootstrap |
| mine-f23-1 | lunar-matrix-eb | 8×B300 | $63.60 | 2026-08-09T14:31Z | H118 F23 raw-Bittob | bootstrap |

SSH: f13/f15/f17:20099 f19:20127 f10/f22:40300 f14:40309 f16:40311 f18:40300 f20/f23:40301 f21:20300 · kh `/tmp/mine-*-1.known_hosts`.
**Free: 8**. Burn ~$428.4/h. Non-mine — **never rm**.

## Dead (recent)
mine-f11-1 REFUTE m=−0.03414; mine-f12-1 REFUTE −0.059; liar tears f19/f20 p441–442.

## Recent reconciles (last 3)

| UTC | lium ps mine-* | action |
|---|---|---|
| 2026-08-09T02:49Z | 12 live | F17 king449 recover (mid-n80 EngineDead); F21 :800*=200 wait probe; no rent |
| 2026-08-09T02:42Z | 12 live | F21 chall recover448; F11 REFUTE−0.034 tear; no rent |
| 2026-08-09T02:38Z | 13 live | F21 teacher ENOENT→recover447; F17 n80 started; no rm/rent |
