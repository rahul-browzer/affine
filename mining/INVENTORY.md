# INVENTORY — mine-* pods only

**Cap: 40 lines.** Live table + last 3 reconciles. Never touch non-`mine-*`.
Pre-compaction: `archive/INVENTORY-full-2026-08-07.md`.
**Pod cap: 20** (operator 2026-08-08). Burn cap $833/h.

## Live

| name | huid | gpu | $/hr | remove_at | purpose | status |
|---|---|---|---|---|---|---|
| mine-f16-1 | calm-wolf-2f | 8×H200 | $28.00 | 2026-08-09T13:57Z | H111 F16 af-k1 | **n80 ~70** |
| mine-f17-1 | eager-eagle-f3 | 8×H200 | $31.92 | 2026-08-09T14:02Z | H112 F17 raw-genesis | **n80 ~6** retry4 |
| mine-f18-1 | cosmic-matrix-19 | 8×H200 | $33.81 | 2026-08-09T14:06Z | H113 F18 raw-TalentPigs | **n80 ~64** |
| mine-f22-1 | calm-hawk-98 | 8×B300 | $63.60 | 2026-08-09T14:27Z | H117 F22 raw-everest12 | everest DL 92% |
| mine-f23-1 | lunar-matrix-eb | 8×B300 | $63.60 | 2026-08-09T14:31Z | H118 F23 raw-Bittob | king DL ~27G inc |
| mine-f25-1 | eager-orbit-09 | 8×H200 | $24.40 | 2026-08-09T15:20Z | H120 F25 raw-golden | **n80 ~32** |

SSH: f17:20099 f16:40311 f18/f22:40300 f23:40301 f25:20126 · kh `/tmp/mine-*-1.known_hosts`.
**Free: 14**. Burn ~$245.3/h. Non-mine — **never rm**.

## Dead (recent)
mine-f24-1 REFUTE m=−0.08673 (p458); mine-f21-1 −0.07226 (p458); mine-f20-1 −0.02975; mine-f19-1 −0.00611; mine-f13-1 −0.07293.

## Recent reconciles (last 3)

| UTC | lium ps mine-* | action |
|---|---|---|
| 2026-08-09T03:55Z | 6 live | F21+F24 REFUTE tear lunar-comet-f7+calm-raven-15; burn →~$245.3/h |
| 2026-08-09T03:28Z | 8 live | F20 REFUTE tear lunar-raven-37; burn →~$313.3/h |
| 2026-08-09T03:21Z | 9 live | rent mine-f25-1 H200@$24.40 TTL12h COUNT=8; burn ~$336.5/h |
