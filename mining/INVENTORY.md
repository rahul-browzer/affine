# INVENTORY — mine-* pods only

**Cap: 40 lines.** Live table + last 3 reconciles. Never touch non-`mine-*`.
Pre-compaction: `archive/INVENTORY-full-2026-08-07.md`.
**Pod cap: 20** (operator 2026-08-08). Burn cap $833/h.

## Live

| name | huid | gpu | $/hr | remove_at | purpose | status |
|---|---|---|---|---|---|---|
| mine-f4-1 | calm-wolf-30 | 8×B300 | $63.60 | 2026-08-09T07:18Z | H100 F4 Genesis | n80 d203 ~14/80 |
| mine-f7-1 | lunar-shark-87 | 8×H200 | $28.00 | 2026-08-09T08:52Z | H102 F7 teacher-zC | n80 e203 ~59/80 |
| mine-f9-1 | lunar-fox-0a | 8×H200 | $31.92 | 2026-08-09T09:12Z | H104 F9 kevin-base | n80 d203 ~32/80 |
| mine-f10-1 | eager-wolf-42 | 8×H200 | $28.00 | 2026-08-09T11:54Z | H105 F10 TalentPigs | train ~52/60 |
| mine-f11-1 | swift-eagle-51 | 8×H200 | $28.00 | 2026-08-09T12:02Z | H106 F11 pandora | train live |
| mine-f12-1 | lunar-wolf-a5 | 8×H200 | $28.00 | 2026-08-09T12:10Z | H107 F12 golden-crown | train live |
| mine-f13-1 | zesty-hawk-1f | 8×H200 | $31.92 | 2026-08-09T12:17Z | H108 F13 diane613 | bootstrap |

SSH: f4 204.9.206.243:40099 · f7 .232:40311 ·
f9 38.255.28.18:20099 · f10 .234:40300 · f11 .237:40300 ·
f12 .236:40300 · f13 38.255.28.21:20099 ·
kh `~/.ssh/id_ed25519` + `/tmp/mine-*-1.known_hosts`.
**Free: 13**. Burn ~$239.4/h. Non-mine — **never rm**.

## Dead

| name | final spent | removed UTC | reason |
|---|---|---|---|
| mine-f8-1 | ~$77 | 2026-08-08T23:49Z | H103/F8 REFUTE m=−0.04829 vs Tok |
| mine-f6-1 | ~$56 | 2026-08-08T22:42Z | H101/F6 REFUTE m=−0.00453 vs Tok |
| mine-f1-1 | ~$106 | 2026-08-08T22:14Z | H98/F1 REFUTE m=+0.00229 vs Tok |
| mine-f3-1 | ~$50 | 2026-08-08T20:50Z | H97/F3 REFUTE m=−0.01506 vs Tok |
| mine-h96-1 | ~$53 | 2026-08-08T20:47Z | H96 REFUTE m=+0.00913 vs Tok |

## Recent reconciles (last 3)

| UTC | lium ps mine-* | action |
|---|---|---|
| 2026-08-09T00:18Z | 7 live | rent mine-f13-1 (H108/F13); burn ~$239.4/h |
| 2026-08-09T00:14Z | 6 live | F4 kill stale longwait c203→d203; no rm/rent |
| 2026-08-09T00:11Z | 6 live | rent mine-f12-1 (H107/F12); burn ~$207.5/h |
