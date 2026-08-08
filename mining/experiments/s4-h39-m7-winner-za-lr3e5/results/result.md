# H39 result — REFUTED

**Verdict:** `REFUTE_H39` @ 2026-08-08T00:33:11Z (n80 a203)

| metric | value |
|---|---|
| margin | **+0.00544** |
| z | 0.85 |
| S_c / S_k | 0.0505 / 0.0449 |
| SE | 0.00643 |
| r_c | 0.584 |
| base× | 1.105 |
| valid_c | true |
| submit | false |

**Decision rule:** need m>0.04. Observed ≪ bar (and below H28's +0.01095).

**Interpretation:** mid-LR 3e-5 between H28@1e-5 (+0.011) and H37@1e-4 (−0.0009)
does not recover signal — if anything weaker than H28. Do not requeue lr≥3e-5 on
m7×winner-zA. Prefer gentler LR (H42@5e-6) / rank-α / data axes.
