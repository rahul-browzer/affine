# H102 / F7 — REFUTED (pass 419)

## Screen (n80, k=1, block_hash=e203…)

| metric | value |
|---|---|
| margin | **−0.051935** |
| z | −5.723 |
| SE | 0.009075 |
| S_c / S_k | −0.02438 / +0.02675 |
| mean_λ2_c / mean_λ2_k | **−0.01977** / −0.00416 |
| r_c | 1.100 |
| base_x | 0.882 |
| gates | both valid (pass 0.68/0.83, bank 0.39/0.43) |
| n_paired | 80 |
| elapsed | (e203 live; decision 2026-08-09T00:30:59Z) |

Decision: `REFUTE_H102` (write_merge_decision nested_verdict). Pod `mine-f7-1` removed (~$105 @ $28/h).

## Verdict

Genesis-init × teacher `z_C` SFT (791 shortz) does **not** beat Tok — margin
−0.052, mean_λ2_c −0.020 ≪ king −0.004. Teacher-thought distill on Genesis
worsens Λ2 vs the live king the same way Genesis-RL (F8) did. Family **closed**.
Do not CONFIRM / SWEEP teacher-zC cells.
