# INVENTORY — mine-* pods only

**Cap: 40 lines.** Live table + last 3 reconciles. Never touch non-`mine-*`.
Pre-compaction: `archive/INVENTORY-full-2026-08-07.md`.
**Pod cap: 20** (operator 2026-08-08). Burn cap $833/h.

## Live

| name | huid | gpu | $/hr | remove_at | purpose | status |
|---|---|---|---|---|---|---|
| mine-f13-1 | zesty-hawk-1f | 8×H200 | $31.92 | 2026-08-09T12:17Z | H108 F13 diane613 | **n80 ~68** |
| mine-f16-1 | calm-wolf-2f | 8×H200 | $28.00 | 2026-08-09T13:57Z | H111 F16 af-k1 | post_train |
| mine-f17-1 | eager-eagle-f3 | 8×H200 | $31.92 | 2026-08-09T14:02Z | H112 F17 raw-genesis | **n80 ~22** |
| mine-f18-1 | cosmic-matrix-19 | 8×H200 | $33.81 | 2026-08-09T14:06Z | H113 F18 raw-TalentPigs | king only |
| mine-f19-1 | eager-comet-12 | 8×H200 | $24.40 | 2026-08-09T14:12Z | H114 F19 raw-kevin | **n80 ~53** |
| mine-f20-1 | lunar-raven-37 | 8×H200 | $23.20 | 2026-08-09T14:15Z | H115 F20 raw-pandora | **n80 ~40** |
| mine-f21-1 | lunar-comet-f7 | 8×B200 | $40.00 | 2026-08-09T14:19Z | H116 F21 raw-diane | **recover452** |
| mine-f22-1 | calm-hawk-98 | 8×B300 | $63.60 | 2026-08-09T14:27Z | H117 F22 raw-everest12 | bootstrap |
| mine-f23-1 | lunar-matrix-eb | 8×B300 | $63.60 | 2026-08-09T14:31Z | H118 F23 raw-Bittob | bootstrap |
| mine-f24-1 | calm-raven-15 | 8×H200 | $28.00 | 2026-08-09T14:54Z | H119 F24 raw-af-k1 | boot |

SSH: f13/f17:20099 f19:20127 f16:40311 f18/f22:40300 f20/f23:40301 f21:20300 f24:40299 · kh `/tmp/mine-*-1.known_hosts`.
**Free: 10**. Burn ~$368.5/h. Non-mine — **never rm**.

## Dead (recent)
mine-f14-1 REFUTE m=−0.05784 (p452); mine-f15-1 −0.08285 (p452); mine-f10-1 −0.031.

## Recent reconciles (last 3)

| UTC | lium ps mine-* | action |
|---|---|---|
| 2026-08-09T03:01Z | 10 live | F14/F15 REFUTE tear; F21 recover452 armed |
| 2026-08-09T02:54Z | 12 live | rent mine-f24-1 H200@$28 COUNT=8; boot H119 |
| 2026-08-09T02:51Z | 11 live | F10 REFUTE−0.03095 tear mine-f10-1; no rent |
