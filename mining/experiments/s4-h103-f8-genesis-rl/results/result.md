# H103 / F8 — REFUTED (pass 409)

## Screen (n80, k=1, block_hash=a203…)

| metric | value |
|---|---|
| margin | **−0.048287** |
| z | −4.997 |
| SE | 0.00966 |
| S_c / S_k | −0.02321 / +0.02459 |
| mean_λ2_c / mean_λ2_k | **−0.02090** / −0.00546 |
| r_c | 1.014 |
| base_x | 0.965 |
| gates | both valid (pass 0.57/0.84, bank 0.34/0.43) |
| n_paired | 79 |
| elapsed | 2889 s |

Decision: `REFUTE_H103` (write_merge_decision nested_verdict). Pod `mine-f8-1` removed.

## Verdict

Genesis-init × REINFORCE-L1lift does **not** move Λ2 toward the teacher — it
moved Λ2 *worse* (−0.021 vs king −0.005). Same structural failure as F1
(Tok-RL) but larger negative. Family **closed**. Do not CONFIRM / SWEEP.
