# INVENTORY — mine-* pods only

**Cap: 40 lines.** Live table + last 3 reconciles. Never touch non-`mine-*`.
Pre-compaction: `archive/INVENTORY-full-2026-08-07.md`.
**Pod cap: 20** (operator 2026-08-08). Burn cap $833/h.

## Live

| name | huid | gpu | $/hr | remove_at | purpose | status |
|---|---|---|---|---|---|---|
| mine-f10-1 | eager-wolf-42 | 8×H200 | $28.00 | 2026-08-09T11:54Z | H105 F10 TalentPigs | **n80 e203 ~3/80** |
| mine-f11-1 | swift-eagle-51 | 8×H200 | $28.00 | 2026-08-09T12:02Z | H106 F11 pandora | **king:8001=000** mid-n80 |
| mine-f12-1 | lunar-wolf-a5 | 8×H200 | $28.00 | 2026-08-09T12:10Z | H107 F12 golden | **n80 d203 ~53/80** |
| mine-f13-1 | zesty-hawk-1f | 8×H200 | $31.92 | 2026-08-09T12:17Z | H108 F13 diane613 | **n80 d203 ~28/80** |
| mine-f14-1 | eager-comet-be | 8×H200 | $28.00 | 2026-08-09T12:34Z | H109 F14 Bittob | **n80 e203 ~1/80** |
| mine-f15-1 | calm-wolf-f7 | 8×H200 | $31.92 | 2026-08-09T12:37Z | H110 F15 everest12 | **chall load** visual433 OK |

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
| 2026-08-09T01:35Z | 6 live | F15 visual433+SKIP_MERGE; F11 king dead; burn ~$175.8/h |
| 2026-08-09T01:32Z | 6 live | F15 gocryptfs hang→merge432; F14 n80 e203; burn ~$175.8/h |
| 2026-08-09T01:28Z | 6 live | F11 e203 nested-FP fix; F13 watcher→d203; burn ~$175.8/h |
