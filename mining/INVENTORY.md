# INVENTORY — mine-* pods only

**Cap: 40 lines.** Live table + last 3 reconciles. Never touch non-`mine-*`.
Pre-compaction: `archive/INVENTORY-full-2026-08-07.md`.
**Pod cap: 20** (operator 2026-08-08). Burn cap $833/h.

## Live

| name | huid | gpu | $/hr | remove_at | purpose | status |
|---|---|---|---|---|---|---|
| mine-f4-1 | calm-wolf-30 | 8×B300 | $63.60 | 2026-08-09T07:18Z | H100 F4 Genesis | n80 b203 ~50/80 |
| mine-f7-1 | lunar-shark-87 | 8×H200 | $28.00 | 2026-08-09T08:52Z | H102 F7 teacher-zC | n80 e203 ~37/80 |
| mine-f9-1 | lunar-fox-0a | 8×H200 | $31.92 | 2026-08-09T09:12Z | H104 F9 kevin-base | n80 d203 ~16/80 |
| mine-f10-1 | eager-wolf-42 | 8×H200 | $28.00 | 2026-08-09T11:54Z | H105 F10 TalentPigs | train ~20/60 |
| mine-f11-1 | swift-eagle-51 | 8×H200 | $28.00 | 2026-08-09T12:02Z | H106 F11 pandora | train+af10 kingDL |

SSH: f4 204.9.206.243:40099 · f7 .232:40311 ·
f9 38.255.28.18:20099 · f10 .234:40300 · f11 .237:40300 ·
kh `~/.ssh/id_ed25519` + `/tmp/mine-*-1.known_hosts`.
**Free: 15**. Burn ~$179.5/h. Non-mine — **never rm**.

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
| 2026-08-09T00:08Z | 5 live | F11 af11→af10 fix; no rm/rent; burn ~$179.5/h |
| 2026-08-09T00:03Z | 5 live | rent mine-f11-1 (H106/F11); burn ~$179.5/h |
| 2026-08-08T23:59Z | 4 live | F10 train confirmed (p413); no rm/rent |
