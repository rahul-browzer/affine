# H34 result — REFUTED

## Verdict

**REFUTED.** n80 a203 paired margin **+0.00593** (z=0.76) ≪ 0.04 submit bar.
Gates OK; base×1.114 ≤ 1.25; r_c=0.719 ∈ [0.3,4].

## Numbers (a203 slice)

| | S | Λ2 mean | gates |
|---|---|---|---|
| king | 0.00935 | −0.0115 | valid, bank 0.47, r 0.800 |
| chall | 0.01524 | −0.0133 | valid, bank 0.46, r 0.719 |
| margin | **+0.00593** | se=0.00778 | n_paired=79 |

`challenger_wins=false` (need > max(3·SE, 0.02) ≈ 0.023).

## Decision

epochs=2 on m7×king-self@lr1e-5 does not clear the bar (H30@1ep was −0.003).
Do not requeue H30/H34 epoch axis. H35 (lr=1e-4) still open on this family.
Tear down `mine-h34-1`.
