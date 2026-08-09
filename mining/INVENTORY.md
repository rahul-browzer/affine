# INVENTORY — mine-* pods only

**Cap: 40 lines.** Live table + last 3 reconciles. Never touch non-`mine-*`.
Pre-compaction: `archive/INVENTORY-full-2026-08-07.md`.
**Pod cap: 20** (operator 2026-08-08). Burn cap $833/h.

## Live

| name | huid | gpu | $/hr | remove_at | purpose | status |
|---|---|---|---|---|---|---|
| mine-f16-1 | calm-wolf-2f | 8×H200 | $28.00 | 2026-08-09T13:57Z | H111 F16 af-k1 | **n80 ~26** |
| mine-f17-1 | eager-eagle-f3 | 8×H200 | $31.92 | 2026-08-09T14:02Z | H112 F17 raw-genesis | **n80 ~9** retry |
| mine-f18-1 | cosmic-matrix-19 | 8×H200 | $33.81 | 2026-08-09T14:06Z | H113 F18 raw-TalentPigs | **n80 ~20** |
| mine-f21-1 | lunar-comet-f7 | 8×B200 | $40.00 | 2026-08-09T14:19Z | H116 F21 raw-diane | **n80 ~16** restart |
| mine-f22-1 | calm-hawk-98 | 8×B300 | $63.60 | 2026-08-09T14:27Z | H117 F22 raw-everest12 | everest DL ~38G |
| mine-f23-1 | lunar-matrix-eb | 8×B300 | $63.60 | 2026-08-09T14:31Z | H118 F23 raw-Bittob | king DL 91% |
| mine-f24-1 | calm-raven-15 | 8×H200 | $28.00 | 2026-08-09T14:54Z | H119 F24 raw-af-k1 | **n80 ~34** |
| mine-f25-1 | eager-orbit-09 | 8×H200 | $24.40 | 2026-08-09T15:20Z | H120 F25 raw-golden | serve launched |

SSH: f17:20099 f16:40311 f18/f22:40300 f23:40301 f21:20300 f24:40299 f25:20126 · kh `/tmp/mine-*-1.known_hosts`.
**Free: 12**. Burn ~$313.3/h. Non-mine — **never rm**.

## Dead (recent)
mine-f20-1 REFUTE m=−0.02975 (p457); mine-f19-1 −0.00611; mine-f13-1 −0.07293; mine-f14-1 −0.05784; mine-f15-1 −0.08285.

## Recent reconciles (last 3)

| UTC | lium ps mine-* | action |
|---|---|---|
| 2026-08-09T03:28Z | 8 live | F20 REFUTE tear lunar-raven-37; burn →~$313.3/h |
| 2026-08-09T03:21Z | 9 live | rent mine-f25-1 H200@$24.40 TTL12h COUNT=8; F20~69; burn ~$336.5/h |
| 2026-08-09T03:15Z | 8 live | F19 REFUTE tear eager-comet-12; F18 n80 up; burn ~$312/h |
