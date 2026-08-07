# H35 result — REFUTED

## Verdict

**REFUTED.** n80 a203 paired margin **+0.01602** (z=2.45) ≪ 0.04 submit bar.
Fails 3σ (need z>3) and δ=0.02 (margin < 0.02). Gates OK; base×**1.238**
(near band edge 1.25); r_c=0.567 ∈ [0.3,4].

## Numbers (a203 slice)

| | S | baseline_abs | notes |
|---|---|---|---|
| king | 0.03070 | 0.111 | valid |
| chall | 0.04722 | 0.137 | valid, bank 0.60 |
| margin | **+0.01602** | se=0.00653 | n_paired≈80 |

## Decision

lr=1e-4 on m7×king-self is the best of that family (H30 −0.003 / H31
+0.000 / H34 +0.006 / **H35 +0.016**) but still short of bar; base× near
1.25 warns against pushing LR further on king-self. Tear down `mine-h35-1`.
Do not requeue H30/H31/H34/H35 axes.
