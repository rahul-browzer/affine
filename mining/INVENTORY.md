# INVENTORY — mine-* pods only

**Cap: 40 lines.** Live table + last 3 reconciles. Never touch non-`mine-*`.
Pre-compaction: `archive/INVENTORY-full-2026-08-07.md`.
**Pod cap: 20** (operator 2026-08-08). Burn cap $833/h.

## Live

| name | huid | gpu | $/hr | remove_at | purpose | status |
|---|---|---|---|---|---|---|
| mine-f10-1 | eager-wolf-42 | 8×H200 | $28.00 | 2026-08-09T11:54Z | H105 F10 TalentPigs LoRA | **n80 ~57/80** |
| mine-f11-1 | swift-eagle-51 | 8×H200 | $28.00 | 2026-08-09T12:02Z | H106 F11 pandora LoRA | **n80 ~62/80** |
| mine-f13-1 | zesty-hawk-1f | 8×H200 | $31.92 | 2026-08-09T12:17Z | H108 F13 diane613 | **n80 ~17/80** |
| mine-f14-1 | eager-comet-be | 8×H200 | $28.00 | 2026-08-09T12:34Z | H109 F14 Bittob | **n80 ~29/80** |
| mine-f15-1 | calm-wolf-f7 | 8×H200 | $31.92 | 2026-08-09T12:37Z | H110 F15 everest12 | **n80 ~23/80** |
| mine-f16-1 | calm-wolf-2f | 8×H200 | $28.00 | 2026-08-09T13:57Z | H111 F16 af-k1 | **merge** |
| mine-f17-1 | eager-eagle-f3 | 8×H200 | $31.92 | 2026-08-09T14:02Z | H112 F17 raw-genesis | **serve T+K** |
| mine-f18-1 | cosmic-matrix-19 | 8×H200 | $33.81 | 2026-08-09T14:06Z | H113 F18 raw-TalentPigs | **bootstrap** |
| mine-f19-1 | eager-comet-12 | 8×H200 | $24.40 | 2026-08-09T14:12Z | H114 F19 raw-kevin | **n80** |
| mine-f20-1 | lunar-raven-37 | 8×H200 | $23.20 | 2026-08-09T14:15Z | H115 F20 raw-pandora | **serve T+K** |
| mine-f21-1 | lunar-comet-f7 | 8×B200 | $40.00 | 2026-08-09T14:19Z | H116 F21 raw-diane | **bootstrap** |
| mine-f22-1 | calm-hawk-98 | 8×B300 | $63.60 | 2026-08-09T14:27Z | H117 F22 raw-everest12 | **bootstrap** |
| mine-f23-1 | lunar-matrix-eb | 8×B300 | $63.60 | 2026-08-09T14:31Z | H118 F23 raw-Bittob | **bootstrap** |

SSH: f13/f15/f17:20099 f19:20127 f10–11/f22:40300 f14:40309 f16:40311 f18:40300 f20/f23:40301 f21:20300 · kh `/tmp/mine-*-1.known_hosts`.
**Free: 7**. Burn ~$456.4/h. Non-mine — **never rm**.

## Dead (recent)
mine-f12-1 REFUTE −0.059; liar tears f19/f20 p441–442 — detail `archive/`.

## Recent reconciles (last 3)

| UTC | lium ps mine-* | action |
|---|---|---|
| 2026-08-09T02:32Z | 13 live | rented mine-f23-1 F23 raw-Bittob B300 COUNT=8 @$63.60; burn ~$456/h |
| 2026-08-09T02:28Z | 12 live | rented mine-f22-1 F22 raw-everest B300 COUNT=8 @$63.60; burn ~$393/h |
| 2026-08-09T02:19Z | 11 live | rented mine-f21-1 F21 raw-diane B200 COUNT=8 @$40; burn ~$329/h |
