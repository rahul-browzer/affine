# INVENTORY — mine-* pods only

**Cap: 40 lines.** Live table + last 3 reconciles. Never touch non-`mine-*`.
Pre-compaction: `archive/INVENTORY-full-2026-08-07.md`.
**Pod cap: 20** (operator 2026-08-08). Burn cap $833/h.

## Live

| name | huid | gpu | $/hr | remove_at | purpose | status |
|---|---|---|---|---|---|---|
| mine-f16-1 | calm-wolf-2f | 8×H200 | $28.00 | 2026-08-09T13:57Z | H111 F16 af-k1 | **n80 ~11** |
| mine-f17-1 | eager-eagle-f3 | 8×H200 | $31.92 | 2026-08-09T14:02Z | H112 F17 raw-genesis | **n80 ~48** |
| mine-f18-1 | cosmic-matrix-19 | 8×H200 | $33.81 | 2026-08-09T14:06Z | H113 F18 raw-TalentPigs | **n80 up** |
| mine-f20-1 | lunar-raven-37 | 8×H200 | $23.20 | 2026-08-09T14:15Z | H115 F20 raw-pandora | **n80 ~60** |
| mine-f21-1 | lunar-comet-f7 | 8×B200 | $40.00 | 2026-08-09T14:19Z | H116 F21 raw-diane | **n80 ~47** |
| mine-f22-1 | calm-hawk-98 | 8×B300 | $63.60 | 2026-08-09T14:27Z | H117 F22 raw-everest12 | everest DL |
| mine-f23-1 | lunar-matrix-eb | 8×B300 | $63.60 | 2026-08-09T14:31Z | H118 F23 raw-Bittob | king DL |
| mine-f24-1 | calm-raven-15 | 8×H200 | $28.00 | 2026-08-09T14:54Z | H119 F24 raw-af-k1 | **n80 ~15** |

SSH: f17:20099 f16:40311 f18/f22:40300 f20/f23:40301 f21:20300 f24:40299 · kh `/tmp/mine-*-1.known_hosts`.
**Free: 12**. Burn ~$312.1/h. Non-mine — **never rm**.

## Dead (recent)
mine-f19-1 REFUTE m=−0.00611 (p455); mine-f13-1 −0.07293; mine-f14-1 −0.05784; mine-f15-1 −0.08285.

## Recent reconciles (last 3)

| UTC | lium ps mine-* | action |
|---|---|---|
| 2026-08-09T03:15Z | 8 live | F19 REFUTE tear eager-comet-12; F18 n80 up; burn ~$312/h |
| 2026-08-09T03:10Z | 9 live | F13 REFUTE tear; F18 recover454 armed; burn ~$336.5/h |
| 2026-08-09T03:04Z | 10 live | F21 n80 up; F16 teacher Triton ENOENT → recover453 |
