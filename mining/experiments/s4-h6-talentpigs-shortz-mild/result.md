# H6 result — REFUTED

TalentPigs-init shortz-nolist thought LoRA (lr=5e-6) n80 vs live TalentPigs.

| metric | challenger | king |
|---|---|---|
| S | 0.03206 | 0.02928 |
| Λ2 | +0.00253 | +0.00163 |
| implied clip-L1 (S−Λ2) | ≈0.0295 | ≈0.0277 |
| r | 0.730 | 0.740 |
| baseline_abs | 0.119 | 0.124 |
| base× | **0.957** | — |

- **margin +0.00330**, z=0.54, SE=0.00612 — gate-valid, fails crowning (need >0.02 and >3·SE≈0.018)
- mid50 was SIGNAL_NEG; final confirms same near-zero positive as H5b (+0.00322)
- clip-L1 ≈ king, not ≥0.042 as predicted — mild shortz LoRA does not raise L1 enough
- `mine-h5c-1` torn down after decision (~$116 spent on pod lifetime incl. prior H5c)

Artifacts: `results/h6_decision.json`, `results/h6_sim_result.json`.
Do not submit. Do not retry same recipe.
