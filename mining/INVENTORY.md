# INVENTORY — mine-* pods only

**Cap: 40 lines.** Live table + last 3 reconciles. Never touch non-`mine-*`.
Pre-compaction: `archive/INVENTORY-full-2026-08-07.md`.
**Pod cap: 20** (operator 2026-08-08). Burn cap $833/h.

## Live

| name | huid | gpu | $/hr | remove_at | purpose | status |
|---|---|---|---|---|---|---|
| mine-f10-1 | eager-wolf-42 | 8×H200 | $28.00 | 2026-08-09T11:54Z | H105 F10 TalentPigs | **n80 e203 ~34/80** |
| mine-f11-1 | swift-eagle-51 | 8×H200 | $28.00 | 2026-08-09T12:02Z | H106 F11 pandora | **n80 d203** early |
| mine-f13-1 | zesty-hawk-1f | 8×H200 | $31.92 | 2026-08-09T12:17Z | H108 F13 diane613 | **n80 e203 ~7/80** |
| mine-f14-1 | eager-comet-be | 8×H200 | $28.00 | 2026-08-09T12:34Z | H109 F14 Bittob | **n80 d203** early |
| mine-f15-1 | calm-wolf-f7 | 8×H200 | $31.92 | 2026-08-09T12:37Z | H110 F15 everest12 | **n80 f203 ~4/80** |
| mine-f16-1 | calm-wolf-2f | 8×H200 | $28.00 | 2026-08-09T13:57Z | H111 F16 af-k1 | **bootstrap** |

SSH: f13/f15:20099 f10–11:40300 f14:40309 f16:40311 · kh `/tmp/mine-*-1.known_hosts`.
**Free: 14**. Burn ~$175.8/h. Non-mine — **never rm**.

## Dead

| name | final spent | removed UTC | reason |
|---|---|---|---|
| mine-f12-1 | ~$47.64 | 2026-08-09T01:53Z | H107/F12 REFUTE m=−0.05941 vs Tok |
| mine-f4-1 | ~$347 | 2026-08-09T00:45Z | H100/F4 REFUTE m=−0.05488 vs Tok |
| mine-f9-1 | ~$113 | 2026-08-09T00:45Z | H104/F9 REFUTE m=−0.01417 vs Tok |
| mine-f7-1 | ~$105 | 2026-08-09T00:31Z | H102/F7 REFUTE m=−0.05194 vs Tok |
| mine-f8-1 | ~$77 | 2026-08-08T23:49Z | H103/F8 REFUTE m=−0.04829 vs Tok |

## Recent reconciles (last 3)

| UTC | lium ps mine-* | action |
|---|---|---|
| 2026-08-09T01:58Z | 6 live | rented mine-f16-1 F16; burn ~$175.8/h |
| 2026-08-09T01:53Z | 5 live | F12 REFUTE+rm; F11 a203→d203; burn ~$147.8/h |
| 2026-08-09T01:48Z | 6 live | F15→d203first; F11→longwait; burn ~$175.8/h |
