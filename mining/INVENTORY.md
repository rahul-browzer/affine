# INVENTORY — mine-* pods only

**Cap: 40 lines.** Live table + last 3 reconciles. Never touch non-`mine-*`.
Pre-compaction: `archive/INVENTORY-full-2026-08-07.md`.
**Pod cap: 20** (operator 2026-08-08). Burn cap $833/h.

## Live

| name | huid | gpu | $/hr | remove_at | purpose | status |
|---|---|---|---|---|---|---|
| mine-f4-1 | calm-wolf-30 | 8×B300 | $63.60 | 2026-08-09T07:18Z | H100 F4 Genesis | n80 d203 ~48/80 |
| mine-f9-1 | lunar-fox-0a | 8×H200 | $31.92 | 2026-08-09T09:12Z | H104 F9 kevin | n80 d203 ~59/80 |
| mine-f10-1 | eager-wolf-42 | 8×H200 | $28.00 | 2026-08-09T11:54Z | H105 F10 TalentPigs | chall→n80 |
| mine-f11-1 | swift-eagle-51 | 8×H200 | $28.00 | 2026-08-09T12:02Z | H106 F11 pandora | merge live |
| mine-f12-1 | lunar-wolf-a5 | 8×H200 | $28.00 | 2026-08-09T12:10Z | H107 F12 golden | train live |
| mine-f13-1 | zesty-hawk-1f | 8×H200 | $31.92 | 2026-08-09T12:17Z | H108 F13 diane613 | train live |
| mine-f14-1 | eager-comet-be | 8×H200 | $28.00 | 2026-08-09T12:34Z | H109 F14 Bittob | bootstrap |

SSH: f4 …243:40099 · f9 …18:20099 · f10 .234:40300 · f11 .237:40300 ·
f12 .236:40300 · f13 …21:20099 · f14 .232:40309 · kh `/tmp/mine-*-1.known_hosts`.
**Free: 13**. Burn ~$239.4/h. Non-mine — **never rm**.

## Dead

| name | final spent | removed UTC | reason |
|---|---|---|---|
| mine-f7-1 | ~$105 | 2026-08-09T00:31Z | H102/F7 REFUTE m=−0.05194 vs Tok |
| mine-f8-1 | ~$77 | 2026-08-08T23:49Z | H103/F8 REFUTE m=−0.04829 vs Tok |
| mine-f6-1 | ~$56 | 2026-08-08T22:42Z | H101/F6 REFUTE m=−0.00453 vs Tok |
| mine-f1-1 | ~$106 | 2026-08-08T22:14Z | H98/F1 REFUTE m=+0.00229 vs Tok |
| mine-f3-1 | ~$50 | 2026-08-08T20:50Z | H97/F3 REFUTE m=−0.01506 vs Tok |

## Recent reconciles (last 3)

| UTC | lium ps mine-* | action |
|---|---|---|
| 2026-08-09T00:35Z | 7 live | rent mine-f14-1 (H109/F14); burn ~$239.4/h |
| 2026-08-09T00:31Z | 6 live | rm mine-f7-1 (H102 REFUTE); burn ~$211.4/h |
| 2026-08-09T00:18Z | 7 live | rent mine-f13-1 (H108/F13); burn ~$239.4/h |
