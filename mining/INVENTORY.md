# INVENTORY — mine-* pods only

**Cap: 40 lines.** Live table + last 3 reconciles. Never touch non-`mine-*`.
Pre-compaction: `archive/INVENTORY-full-2026-08-07.md`.
**Pod cap: 20** (operator 2026-08-08). Burn cap $833/h.

## Live

| name | huid | gpu | $/hr | remove_at | purpose | status |
|---|---|---|---|---|---|---|
| mine-f36-1 | zesty-orbit-ff | 8×H200 | $33.81 | 2026-08-09T18:25Z | H131 F36 af-k1-FT | n80 ~67/80 |
| mine-f37-1 | calm-eagle-91 | 8×H200 | $23.20 | 2026-08-09T19:06Z | H132 F37 tok-rl-Λ2 | RL step≥115 |
| mine-f38-1 | golden-eagle-8b | 8×H200 | $23.20 | 2026-08-09T19:51Z | H133 F38 gen-rl-Λ2 | teacher DL |
| mine-f39-1 | cosmic-matrix-95 | 8×H200 | $24.40 | 2026-08-09T20:06Z | H134 F39 tok-rl-S* | Tok DL |
| mine-f40-1 | zesty-wolf-91 | 8×H200 | $28.00 | 2026-08-09T20:12Z | H135 F40 kevin-rl-Λ2 | bootstrap |

SSH: f36:40300 f37:40049 f38:40300 f39:20127 f40:40300 · kh `/tmp/mine-*-1.known_hosts`.
**Free: 15**. Burn ~$132.6/h. Non-mine — **never rm**.

## Dead (recent)
mine-f32-1 REFUTE m=−0.02626 (p502); mine-f34-1/−0.06281; mine-f22-1/−0.06273;
mine-f29-1/−0.09256; mine-f35-1/−0.08429; mine-f33-1/−0.02161; mine-f26-1/−0.00031;
mine-f27-1/−0.07068; mine-f31-1/−0.07651; mine-f28-1/−0.00982; mine-f30-1/−0.01918.

## Recent reconciles (last 3)

| UTC | lium ps mine-* | action |
|---|---|---|
| 2026-08-09T08:12Z | 5 live | rent mine-f40-1 H135/F40 @$28/h TTL12h; burn~$132.6/h |
| 2026-08-09T08:08Z | 4 live | F32 REFUTE+rm; rent mine-f39-1 H134/F39 @$24.40; burn~$104.6/h |
| 2026-08-09T07:53Z | 4 live | rent mine-f38-1 H133/F38 @$23.20/h TTL12h; burn~$112.1/h |
