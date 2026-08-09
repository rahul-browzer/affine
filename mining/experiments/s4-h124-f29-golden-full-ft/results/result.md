# H124 / F29 — result (pass 498)

## Verdict
**REFUTE.** Screen n80 e203 margin **m=−0.09256** (z=−8.50) vs Tok331102.

## Numbers
| side | valid | S | mean_λ2 | r | gate_pass | bank |
|---|---|---|---|---|---|---|
| king | true | 0.04480 | +0.00103 | 0.605 | 0.844 | 0.503 |
| chall | true | −0.04850 | **−0.02914** | 1.386 | 0.806 | 0.472 |

- se=0.01089 · n_paired=80 · base_x=0.911 · block_hash=e203…0005
- Gates cleared; loss is ranking (Λ2 collapse), not validity.
- Artifact: `h124_n80_e203_result.json`, `h124_decision.json` (`REFUTE_H124`).

## Decision
Family F29 closed. Teardown `mine-f29-1` (gentle-shark-9c). Same failure mode as other past-king full-FT×high-Λ2 screens (λ2_c ≪ 0). Do not CONFIRM/SWEEP; do not rent more of this class.
