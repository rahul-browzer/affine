# R3b — GRPO alt-LR/rank vs ckp333

**Decision: REFUTE** (p2190) — `SIGNAL_POS_BELOW_KSIGMA`

| metric | value |
|---|---|
| margin | **+0.00232** |
| SE | 0.00945 |
| z | 0.245 |
| live 2σ thr | 0.01889 |
| headroom vs 2σ | **0.123×** (need ≥1.5×) |
| reason_c / reason_k | −0.0163 / −0.0182 |
| n_paired | 79 |

Artifacts: `artifacts/r3b_decision_p2190.json`, `artifacts/r3b_sim_result_p2190.json`.
Stage-5 SKIP. Alt knobs (lr=2e-5 r=64 G=8) do not clear live crown bar.
