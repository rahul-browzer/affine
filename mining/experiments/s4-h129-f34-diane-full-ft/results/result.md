# H129 / F34 — result (pass 500)

## Verdict
**REFUTE.** Screen n80 e203 margin **m=−0.06281** (z=−6.99) vs Tok331102.

## Numbers
| side | valid | S | mean_λ2 | r | gate_pass | bank |
|---|---|---|---|---|---|---|
| king | true | 0.02129 | −0.00978 | 0.699 | 0.833 | 0.442 |
| chall | true | −0.04256 | **−0.02444** | 1.298 | 0.714 | 0.390 |

- se=0.00898 · n_paired=80 · base_x=0.887 · block_hash=e203…0005
- Gates cleared; loss is ranking (Λ2 collapse), not validity.
- Artifact: `h129_sim_result.json`, `h129_decision.json` (`REFUTE_H129`).

## Decision
Family F34 closed. Teardown `mine-f34-1` (brave-eagle-b1). Same failure mode as other past-king full-FT×Λ2 screens (λ2_c ≪ king). Do not CONFIRM/SWEEP; do not rent more of this class. Screens left in class: F32 TalentPigs, F36 af-k1 only.
