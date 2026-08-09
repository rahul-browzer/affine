# INVENTORY — mine-* pods only

**Cap: 40 lines.** Live table + last 3 reconciles. Never touch non-`mine-*`.
Pre-compaction: `archive/INVENTORY-full-2026-08-07.md`.
**Pod cap: 20** (operator 2026-08-08). Burn cap $833/h.

## Live

| name | huid | gpu | $/hr | remove_at | purpose | status |
|---|---|---|---|---|---|---|
| mine-f10-1 | eager-wolf-42 | 8×H200 | $28.00 | 2026-08-09T11:54Z | H105 F10 TalentPigs | **n80 d203 live** |
| mine-f11-1 | swift-eagle-51 | 8×H200 | $28.00 | 2026-08-09T12:02Z | H106 F11 pandora | recover264 a1 load |
| mine-f12-1 | lunar-wolf-a5 | 8×H200 | $28.00 | 2026-08-09T12:10Z | H107 F12 golden | recover264 a1 (p425) |
| mine-f13-1 | zesty-hawk-1f | 8×H200 | $31.92 | 2026-08-09T12:17Z | H108 F13 diane613 | merge_lora |
| mine-f14-1 | eager-comet-be | 8×H200 | $28.00 | 2026-08-09T12:34Z | H109 F14 Bittob | train live |
| mine-f15-1 | calm-wolf-f7 | 8×H200 | $31.92 | 2026-08-09T12:37Z | H110 F15 everest12 | bootstrap HF DL |

SSH: f13/f15:20099 f10–12:40300 f14:40309 · kh `/tmp/mine-*-1.known_hosts`.
**Free: 14**. Burn ~$175.8/h. Non-mine — **never rm**.

## Dead

| name | final spent | removed UTC | reason |
|---|---|---|---|
| mine-f4-1 | ~$347 | 2026-08-09T00:45Z | H100/F4 REFUTE m=−0.05488 vs Tok |
| mine-f9-1 | ~$113 | 2026-08-09T00:45Z | H104/F9 REFUTE m=−0.01417 vs Tok |
| mine-f7-1 | ~$105 | 2026-08-09T00:31Z | H102/F7 REFUTE m=−0.05194 vs Tok |
| mine-f8-1 | ~$77 | 2026-08-08T23:49Z | H103/F8 REFUTE m=−0.04829 vs Tok |
| mine-f6-1 | ~$56 | 2026-08-08T22:42Z | H101/F6 REFUTE m=−0.00453 vs Tok |

## Recent reconciles (last 3)

| UTC | lium ps mine-* | action |
|---|---|---|
| 2026-08-09T00:56Z | 6 live | F10 n80 d203; F12 recover264 armed; burn ~$175.8/h |
| 2026-08-09T00:50Z | 6 live | F11 recover264 after EngineDead; F10 a2 load |
| 2026-08-09T00:45Z | 6 live | F9+F4 REFUTE tear; burn ~$175.8/h |
