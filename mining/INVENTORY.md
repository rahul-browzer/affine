# INVENTORY — mine-* pods only

**Cap: 40 lines.** Live table + last 3 reconciles. Never touch non-`mine-*`.
Pre-compaction: `archive/INVENTORY-full-2026-08-07.md`.
**Pod cap: 20** (operator 2026-08-08). Burn cap $833/h.

## Live

| name | huid | gpu | $/hr | remove_at | purpose | status |
|---|---|---|---|---|---|---|
| mine-f10-1 | eager-wolf-42 | 8×H200 | $28.00 | 2026-08-09T11:54Z | H105 F10 TalentPigs LoRA | **n80 ~29/80** |
| mine-f11-1 | swift-eagle-51 | 8×H200 | $28.00 | 2026-08-09T12:02Z | H106 F11 pandora LoRA | **n80 ~35/80** |
| mine-f13-1 | zesty-hawk-1f | 8×H200 | $31.92 | 2026-08-09T12:17Z | H108 F13 diane613 | **n80 ~47/80** |
| mine-f14-1 | eager-comet-be | 8×H200 | $28.00 | 2026-08-09T12:34Z | H109 F14 Bittob | **n80 ~3/80** |
| mine-f15-1 | calm-wolf-f7 | 8×H200 | $31.92 | 2026-08-09T12:37Z | H110 F15 everest12 | **n80 ~38/80** |
| mine-f16-1 | calm-wolf-2f | 8×H200 | $28.00 | 2026-08-09T13:57Z | H111 F16 af-k1 | **train** |
| mine-f17-1 | eager-eagle-f3 | 8×H200 | $31.92 | 2026-08-09T14:02Z | H112 F17 raw-genesis | **bootstrap** |
| mine-f18-1 | cosmic-matrix-19 | 8×H200 | $33.81 | 2026-08-09T14:06Z | H113 F18 raw-TalentPigs | **bootstrap** |
| mine-f19-1 | eager-comet-12 | 8×H200 | $24.40 | 2026-08-09T14:12Z | H114 F19 raw-kevin | **bootstrap** |
| mine-f20-1 | lunar-raven-37 | 8×H200 | $23.20 | 2026-08-09T14:15Z | H115 F20 raw-pandora | **bootstrap** |

SSH: f13/f15/f17:20099 f19:20127 f10–11:40300 f14:40309 f16:40311 f18:40300 f20:40301 · kh `/tmp/mine-*-1.known_hosts`.
**Free: 10**. Burn ~$289.2/h. Non-mine — **never rm**.

## Dead

| name | final spent | removed UTC | reason |
|---|---|---|---|
| mine-f20-1 (liar) | ~$0.05 | 2026-08-09T02:15Z | COUNT=2 calm-hawk-e4 (zesty-hawk-ae $22→$5.50) |
| mine-f19-1 (liars) | ~$1 | 2026-08-09T02:11Z | COUNT=4 zesty-fox-fc×2; parse-bug tear then re-rent |
| mine-f12-1 | ~$47.64 | 2026-08-09T01:53Z | H107/F12 REFUTE m=−0.05941 vs Tok |
| mine-f4-1 / f9-1 | ~$460 | 2026-08-09T00:45Z | F4/F9 REFUTE (see archive) |

## Recent reconciles (last 3)

| UTC | lium ps mine-* | action |
|---|---|---|
| 2026-08-09T02:16Z | 10 live | rented mine-f20-1 F20 raw-pandora COUNT=8 @$23.20; tore COUNT=2 liar; burn ~$289/h |
| 2026-08-09T02:12Z | 9 live | rented mine-f19-1 F19 raw-kevin COUNT=8 @$24.40; burn ~$266/h |
| 2026-08-09T02:07Z | 8 live | rented mine-f18-1 F18 raw-TalentPigs; burn ~$241.6/h |
