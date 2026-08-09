# H100 / F4 — REFUTED (pass 423)

## Screen (n80, k=1, block_hash=d203…)

| metric | value |
|---|---|
| margin | **−0.054885** |
| z | −5.928 |
| SE | 0.009259 |
| S_c / S_k | −0.02307 / +0.03016 |
| mean_λ2_c / mean_λ2_k | **−0.01886** / −0.00394 |
| r_c | 1.005 |
| base_x | 0.938 |
| gates | both valid (pass 0.59/…, bank 0.39) |
| n_paired | 80 |
| elapsed | 1836s · decision 2026-08-09T00:45:16Z |

Decision: `REFUTE_H100` (write_merge_decision nested_verdict). Pod `mine-f4-1` removed (~$347 @ $63.60/h).

## Verdict

Genesis-init × high-Λ2 z_A LoRA does **not** beat Tok — margin −0.055,
mean_λ2_c −0.019 ≪ king −0.004. Same Λ2-worsening as F7 teacher-zC / F8
Genesis-RL. Non-king Genesis base under this LoRA recipe is closed. Family
**closed**. Do not CONFIRM / SWEEP Genesis×high-Λ2 cells.
